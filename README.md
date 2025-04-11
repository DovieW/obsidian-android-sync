# Obsidian Android Sync
Easily sync your Obsidian vaults on Android using Git (SSH) + Termux, with automation and shortcuts using Tasker.
It works by syncing a vault when the Obsidian app is opened (or brought up from recents) and when it's closed (or if you just switch to another app).

To prevent conflicts, I recommend you add the following lines to your .gitignore file in all your vaults that you'll be syncing using Git. If you notice a plugin has a file which is often in conflict, you'll want to add that as well (remember to un-track these files first with `git rm --cached <file>`):
```gitignore
/.obsidian/workspace.json
/.obsidian/workspace-mobile.json
/.obsidian/plugins/obsidian-git/data.json
/conflict-files-obsidian-git.md
```
To stop conflicts from happening with your note files, you can create a `.gitattributes` file in the root of your vaults with the following content. It will basically always accept both changes for `.md` files.
```gitattributes
*.md merge=union
```
## Termux Setup
1. Install [F-Droid](https://f-droid.org/en/).
2. Install [Termux](https://f-droid.org/en/packages/com.termux/), [Termux:Tasker](https://f-droid.org/en/packages/com.termux.tasker/), and [Termux:API](https://f-droid.org/en/packages/com.termux.api/) apps from F-Droid (NOT from the Play Store).

   The next steps will mostly ask you to run commands in Termux.
3. Run `termux-setup-storage` and give access to files.
4. Run `pkg update && pkg upgrade -y && pkg install -y git openssh termux-api` to install packages. Press *Enter* any time it pauses with a question.
5. Run `mkdir -p /storage/emulated/0/repos/Obsidian` to create the directories used for repositories.
6. Run `git clone https://github.com/DovieW/obsidian-android-sync.git ~/storage/shared/repos/obsidian-android-sync` to clone this repo into the repos directory.

   Be aware that the next step will set [safe.directory](https://git-scm.com/docs/git-config/2.35.2#Documentation/git-config.txt-safedirectory) to '*'.
7. Run the setup script: `cp "/storage/emulated/0/repos/obsidian-android-sync/setup" ~/ && chmod +x "$HOME/setup" && source "$HOME/setup"`. Type `yes` and hit *Enter* if prompted.
8. The above command copied an SSH public key to your clipboard (or was displayed to the screen), paste this into your Git host's SSH key authentication setting (eg [Github](https://github.com/settings/keys)). If you want to copy the SSH key again, run the setup script again by simply running `setup`. The long verison of the setup command (above) is not needed anymore.
9. In Termux, you should now be in the Obsidian directory (verify with `pwd`) where you should now clone your Obsidian vaults. Try not to put any special characters (that are recognized by bash) in your vault name (eg an ampersand or exclamation point etc), if I remember correctly, it gave Tasker some issues, but you can probably get around that issue if you try. I don't know how spaces will behave.
10. Run the following command to apply a fix for [Git corruption issues](https://github.com/DovieW/obsidian-android-sync/issues/7): `"${HOME}/worktree-fix.sh"`

At this point, you can run `sync` to sync all the vaults in the `/storage/emulated/0/repos/Obsidian` folder. There will be no output if successful.
## Tasker Setup
1. Install [Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm&hl=en_US&gl=US) from the Play Store.
2. Enable the Termux permission in the settings for the Tasker app.
3. Open the Obsidian app and add your vaults from the `repos/Obsidian` folder.
4. If you're using the [Obsidian Git plugin](https://github.com/Vinzent03/obsidian-git), you should disable it for this device. You can do this in the plugin settings.
5. Import the "Tasker project" into Tasker. You can import the project in 2 ways. You can use this [TaskerNet link](https://taskernet.com/shares/?user=AS35m8n3cQwLQVpqM%2Fik6LZsANJ%2F8SkOXbatTM3JXxEQY4KYaxES06TbTgTRcO7ziHKZXfzQKT1B&id=Project%3AObsidian+Syncing), or you can import ([image](https://imgur.com/a/Fvyl8HF)) the .xml file from this repository. Once it's imported, there will be some prompts, I think one for giving Tasker "Usage Access" and one to enable all profiles. Accept all.
6. Give Termux the "Display over other apps" permission.
7. Add the Vault launch icons as Tasker widgets (use the widget type that allows you to add them to folders) to the home screen. Also, add the 3 helper tasks as widgets (as needed): 
   1. Sync Vaults   - syncs all vaults (now without output [see](https://github.com/DovieW/obsidian-android-sync/issues/2)
   2. Vaults Status - outputs the `git fetch && git status` of each vault
   3. Sync Log      - outputs the sync log

All vaults will sync at 4am every day using a Tasker profile.
## Notes
- You should get a notification if a sync fails. This requires AutoNotification from the PlayStore. To disable this, disable the Sync Error Notification profile. ([not working currently](https://github.com/DovieW/obsidian-android-sync/issues/3))
- If this repository has new commits that you want, running the `setup` command should pull them down. After which, you may be prompted to run a command to update the setup script itself, if it was updated.
