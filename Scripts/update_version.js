#!/usr/bin/env node
const fs = require("fs");
const { exit } = require("process");
const axios = require("axios");

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
    const name = cask.name;
    const caskName = cask.cask_name;

    if (!fs.existsSync(templatePath(caskName))) {
      console.error(`Error: ${templatePath(caskName)} is not exists`);
      continue;
    }

    const url = githubApi(name);

    axios
      .get(url)
      .then((res) => {
        const version = res.data.tag_name;
        const template = fs.readFileSync(templatePath(caskName)).toString();
        const code = template.replace("{{ version }}", `"${version}"`);
        fs.writeFileSync(caskPath(caskName), code);
      })
      .catch((err) => {
        console.error(`Error: ${err}`);
      });
  }
};

main();
