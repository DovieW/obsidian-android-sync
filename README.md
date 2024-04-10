# Obsidian Android Sync
Easily sync your Obsidian vaults on Android using Git (SSH) + Termux, with automation and shortcuts using Tasker.
It works by syncing a vault when it's opened and when it's closed.

[Here's an image](https://bit.ly/40hLIyt) of what it looks like, once complete with shortcuts to some optional utility functions. Each vault will have it's own icon. This allows syncing to be more efficient as without it, all vaults will sync each time in a specific order. Instead of just the vault that you open being synced immediately. If you only use one vault or don't mind the inefficiency of waiting for the vault that you just opened to be updated, then you can use the default Obsidian app icon. Also, all vaults are synced once a day (defaults to 4am).

To prevent conflicts, I recommend you add the following lines to your .gitignore file in all your vaults that you'll be syncing using Git. If you notice a plugin has a file which is often in conflict, you'll want to add that as well (remember to un-track it with `git rm --cached <file>`):
```gitignore
/.obsidian/workspace.json
/.obsidian/workspace-mobile.json
/.obsidian/plugins/obsidian-git/data.json
/conflict-files-obsidian-git.md
```
To stop conflicts from happening with your note files, you can create a .gitattributes file in the root of your vaults with the following content. It will basically always accept both changes for `.md` files.
```gitattributes
*.md merge=union
```
## Termux Setup
1. Install [Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm&hl=en_US&gl=US) from the Play Store.
2. Install [F-Droid](https://f-droid.org/en/).
3. Install [Termux](https://f-droid.org/en/packages/com.termux/), [Termux:Tasker](https://f-droid.org/en/packages/com.termux.tasker/), and [Termux:API](https://f-droid.org/en/packages/com.termux.api/) apps from F-Droid (NOT from the Play Store).

   The next steps will mostly ask you to run commands in Termux.
5. Run `termux-setup-storage` and give access to files.
6. Run `pkg update && pkg upgrade -y && pkg install -y git openssh termux-api` to install packages. Press *Enter* any time it pauses with a question.
7. Run `mkdir -p /storage/emulated/0/repos/Obsidian` to create the directories used for repositories.
8. Run `git clone https://github.com/DovieW/obsidian-android-sync.git ~/storage/shared/repos/obsidian-android-sync` to clone this repo into the repos directory.
9. Run the setup script: `cp "/storage/emulated/0/repos/obsidian-android-sync/setup" ~/ && chmod +x "$HOME/setup" && source "$HOME/setup"`. Type `yes` and hit *Enter* if prompted.
10. The above command copied an SSH public key to your clipboard (or was displayed to the screen), paste this into your Git host's SSH key authentication setting (eg [Github](https://github.com/settings/keys)). If want to copy the SSH key again, run the setup script again by simply running `setup`. The long verison of the setup command (above) is not needed anymore.
11. In Termux, you should now be in the Obsidian directory (verify with `pwd`) where you should now clone your Obsidian vaults. Try not to put any special characters (that are recognized by bash) in your vault name (eg an &, ! etc), if I remember correctly, it gave Tasker some issues, but you can probably get around that issue if you try. I don't know how spaces will behave.
12. Whenever you add a vault to the Obsidian folder, you should run the setup script again using the `setup` command. Do so now.

At this point, you can run `sync` to sync all the vaults in the `/storage/emulated/0/repos/Obsidian` folder.
## Tasker Setup
1. Enable the Termux permission in the settings for the Tasker app.
2. Open the Obsidian app and add your vaults from the `repos/Obsidian` folder.
3. If you're using the Obsidian Git plugin, you should disable it for this device. You can do this in the plugin settings.
4. Import the "Tasker project" into Tasker. Once you import it, I recommend you rearrange the tasks based on [this image](https://imgur.com/a/6Gj6aRj) for simplicity (to rearrange tasks, hold on a task, then drag). You can import the project in 2 ways. You can use this [TaskerNet link](https://taskernet.com/shares/?user=AS35m8n3cQwLQVpqM%2Fik6LZsANJ%2F8SkOXbatTM3JXxEQY4KYaxES06TbTgTRcO7ziHKZXfzQKT1B&id=Project%3AObsidian+Syncing), or you can import ([image](https://imgur.com/a/Fvyl8HF)) the .xml file from this repository. Once it's imported, there will be some prompts, I think one for giving Tasker "Usage Access" and one to enable all profiles. Accept all.
5. **Vault launch icons** - There are 2 example tasks (Vault1 and Vault2). Rename the task to the name of your vault (you can name it anything). Then in the task, you'll see a "Variable Set" action, change the value to the **name of the folder** which contains the repository for that vault.
6. Give Termux the "Display over other apps" permission.
7. Add the Vault launch icons as Tasker widgets (use the widget type that allows you to add them to folders) to the home screen. Also, add the 3 helper tasks as widgets (as needed): 
   1. Sync Vaults   - syncs all vaults
   2. Vaults Status - outputs the `git fetch && git status` of each vault
   3. Sync Log      - outputs the sync log.

All vaults will sync at 4am every day using a Tasker profile.
## Notes
- You should get a notification if a sync fails. This requires AutoNotification from the PlayStore. To disable this, disable the Sync Error Notification profile.
- The individual vault icons to open specific vaults can be a bit slow. I've tried different ways to open a vault. Faster ways had one of two problems. Either it would open the vault correctly, but then if you left the app, it would not appear in the recents list. Or, it would load the app, load the last vault used, then load the vault you wanted which ends up being slower then the current method. You can find almost all the methods I tried in the Open Vault task (they are disabled).
- If you prefer, you can have a popup menu (a scene or list dialog for example), to combine all the actions or vaults into one icon on your home screen.