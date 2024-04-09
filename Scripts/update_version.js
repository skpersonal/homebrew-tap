#!/usr/bin/env node
const fs = require("fs");
const { exit } = require("process");
const axios = require("axios");
const checksum = require("checksum");
const Downloader = require("nodejs-file-downloader");

const templatePath = (name) => `Templates/${name}.rb.tmp`;
const caskPath = (name) => `Casks/${name}.rb`;
const githubApi = (name) =>
  `https://api.github.com/repos/${name}/releases/latest`;

const main = () => {
  if (!fs.existsSync("Scripts/Casks.json")) {
    console.error(`Error: Casks.json is not exists`);
    exit(1);
  }

  const casks = JSON.parse(
    fs.readFileSync("Scripts/Casks.json", { encoding: "utf-8" })
  ).casks;

  for (const cask of casks) {
    const repo = cask.repo;
    const caskName = cask.cask_name;

    if (!fs.existsSync(templatePath(caskName))) {
      console.error(`Error: ${templatePath(caskName)} is not exists`);
      continue;
    }

    const url = githubApi(repo);

    axios
      .get(url)
      .then((res) => {
        const version = res.data.tag_name;
        const template = fs.readFileSync(templatePath(caskName)).toString();
        const versionUpdated = template.replace(
          "{{ version }}",
          `"${version}"`
        );
        const dlTmp = versionUpdated.replaceAll("#{version}", version);
        const downloadUrlRegexp = new RegExp(
          /https?:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#\u3000-\u30FE\u4E00-\u9FA0\uFF01-\uFFE3]+/g
        );
        const downloadUrl = dlTmp.match(downloadUrlRegexp)[0];
        (async () => {
          const dlFile = new Downloader({
            url: downloadUrl,
            directory: "./downloads",
            fileName: `${caskName}.${downloadUrl.split(".").pop()}`,
            cloneFiles: false,
          });
          try {
            const { filePath, downloadStatus } = await dlFile.download();
            checksum.file(filePath, { algorithm: "sha256" }, (err, sha256) => {
              if (err) {
                console.error(`Error: ${err}`);
                return;
              }
              const sha256Updated = versionUpdated.replace(
                "{{ sha256 }}",
                `"${sha256}"`
              );
              fs.writeFileSync(caskPath(caskName), sha256Updated);
            });
          } catch (error) {
            console.error("Download failed", error);
          }
        })();
      })
      .catch((err) => {
        console.error(`Error: ${err}`);
      });
  }
};

main();
