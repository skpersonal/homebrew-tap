const fs = require("fs");
const fsp = fs.promises;
const crypto = require("crypto");
const https = require("https");
const path = require("path");
const log4js = require("log4js");

const casks_dir = "Casks";

const logger = log4js.getLogger();
logger.level = "info";

function httpsGet(url) {
  return new Promise((resolve, reject) => {
    const options = {
      headers: {
        "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0",
      },
    };

    https
      .get(url, options, (res) => {
        let data = "";
        res.on("data", (chunk) => {
          data += chunk;
        });
        res.on("end", () => resolve(data));
      })
      .on("error", (err) => {
        reject(err);
      });
  });
}

async function extractDownloadUrl(filePath) {
  try {
    const fileContent = await fsp.readFile(filePath, "utf-8");
    const urlPattern = /url "(.*?)"/;

    const match = fileContent.match(urlPattern);

    if (match && match[1]) {
      return match[1];
    }

    throw new Error("URL not found in the specified file.");
  } catch (error) {
    logger.error("Failed to extract ZIP file URL:", error);
    throw error;
  }
}

function downloadFile(url, filePath, maxRedirects = 3) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(filePath);

    function get(url, redirectCount) {
      https
        .get(url, (response) => {
          if (
            response.statusCode >= 300 &&
            response.statusCode < 400 &&
            response.headers.location
          ) {
            if (redirectCount === 0) {
              reject(new Error("Too many redirects"));
            } else {
              logger.debug(`Redirecting to ${response.headers.location}`);
              get(response.headers.location, redirectCount - 1);
            }
          } else if (response.statusCode === 200) {
            response.pipe(file);
            file.on("finish", () => {
              file.close(resolve);
            });
          } else {
            reject(
              new Error(
                `Failed to download file: Status Code: ${response.statusCode}`
              )
            );
          }
        })
        .on("error", (err) => {
          fs.unlink(filePath, () => reject(err));
        });
    }

    get(url, maxRedirects);
  });
}

async function calculateSHA256(filePath) {
  const fileBuffer = await fsp.readFile(filePath);
  const hashSum = crypto.createHash("sha256");
  hashSum.update(fileBuffer);
  return hashSum.digest("hex");
}

async function updateCaskFile(caskFilePath, newVersion, newSha256) {
  let fileContent = await fsp.readFile(caskFilePath, "utf-8");
  fileContent = fileContent.replace(/version ".*"/, `version "${newVersion}"`);
  fileContent = fileContent.replace(/sha256 ".*"/, `sha256 "${newSha256}"`);
  await fsp.writeFile(caskFilePath, fileContent);
}

async function extractGithubRepo(filePath) {
  const fileContent = await fsp.readFile(filePath, "utf-8");
  const urlLineMatch = fileContent.match(
    /url "(https:\/\/github\.com\/[^\/]+\/[^\/]+)/
  );
  if (urlLineMatch && urlLineMatch[1]) {
    return urlLineMatch[1].replace("https://github.com/", "");
  }
  throw new Error(`GitHub repository not found in ${filePath}`);
}

async function extractCurrentVersion(caskFilePath) {
  const fileContent = await fsp.readFile(caskFilePath, "utf-8");
  const versionPattern = /version "(.*?)"/;
  const match = fileContent.match(versionPattern);
  if (match && match[1]) {
    return match[1];
  }
  return "";
}

async function updateCaskDefinition(caskFilePath, githubRepo) {
  try {
    const currentVersion = await extractCurrentVersion(caskFilePath);

    const latestReleaseInfo = await httpsGet(
      `https://api.github.com/repos/${githubRepo}/releases/latest`
    );
    const latestRelease = JSON.parse(latestReleaseInfo);
    const newVersion = latestRelease.tag_name;

    if (newVersion === currentVersion) {
      logger.info(
        `No update needed for ${caskFilePath}. Version is up-to-date.`
      );
      return;
    }

    const assetUrl = (await extractDownloadUrl(caskFilePath)).replaceAll(
      "#{version}",
      newVersion
    );

    logger.debug(assetUrl);

    const tempFilePath = `./${githubRepo.replace("/", "-")}.${path.extname(
      assetUrl
    )}`;
    await downloadFile(assetUrl, tempFilePath);

    const newSha256 = await calculateSHA256(tempFilePath);

    await updateCaskFile(caskFilePath, newVersion, newSha256);

    logger.info(
      `Cask definition updated to version ${newVersion} with SHA256 ${newSha256}`
    );

    await fsp.unlink(tempFilePath);
  } catch (error) {
    logger.error("Failed to update Cask definition:", error);
  }
}

function listRubyFiles(directory) {
  return fs.promises
    .readdir(directory, { withFileTypes: true })
    .then((entries) => {
      return entries
        .filter((entry) => entry.isFile() && path.extname(entry.name) === ".rb")
        .map((file) => path.join(directory, file.name));
    });
}

async function updateAllCaskDefinitions(directory) {
  try {
    const rubyFiles = await listRubyFiles(directory);

    for (const file of rubyFiles) {
      const githubRepo = await extractGithubRepo(file);
      await updateCaskDefinition(file, githubRepo);
      logger.info(`Updated: ${file}`);
    }
  } catch (error) {
    logger.error("Failed to update Cask definitions:", error);
  }
}

updateAllCaskDefinitions(casks_dir);
