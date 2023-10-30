# Obsidian Android Sync

Sync using Git (SSH) + Termux, with automation and shortcuts using Tasker. [Here's an image](https://bit.ly/40hLIyt) of what it looks like, once complete.

You can follow along with [this video](https://bit.ly/45RFqXm).

Note: the [Obsidian Git plugin](https://github.com/denolehov/obsidian-git) should work on mobile when using HTTP to connect to the remote. See [here](https://github.com/denolehov/obsidian-git/blob/master/README.md#mobile).

Using [scrcpy](https://github.com/Genymobile/scrcpy) makes this setup easier. If pasting isn't working in scrcpy, use Alt + V to force send the copied text to your Android.

I recommend you add the following lines to your .gitignore file in all your vaults that you'll be syncing using Git:

```gitignore
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/plugins/obsidian-git/data.json
conflict-files-obsidian-git.md
```

---

### Setup

1. Install [Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm&hl=en_US&gl=US) ($10) from the Play Store.

2. Install [F-Droid](https://f-droid.org/en/).

3. Install [Termux](https://f-droid.org/en/packages/com.termux/), [Termux:Tasker](https://f-droid.org/en/packages/com.termux.tasker/), and [Termux:API](https://f-droid.org/en/packages/com.termux.api/) apps from F-Droid (NOT from the Play Store).

    The next steps will mostly ask you to run commands in Termux.

4. Run `termux-setup-storage` and give access to files.

5. Run `pkg upgrade && pkg install git openssh termux-api` to install packages.

6. Run `mkdir -p /storage/emulated/0/repos/Obsidian` to create the directories used for repositories.

7. Run `git clone https://github.com/DovieW/obsidian-android-sync.git ~/storage/shared/repos/obsidian-android-sync` to clone this repo into the repos directory.

8. Run the setup script: `setup="setup" && cp "/storage/emulated/0/repos/obsidian-android-sync/$setup" ~/ && chmod +x "$HOME/$setup" && source "$HOME/$setup"`.

9. The above command copied an SSH public key to your clipboard (or was displayed to the screen), paste this into your Git host's SSH key authentication setting (eg [Github](https://github.com/settings/keys)). If you add more vaults in the future or want to copy the SSH key again, you should run the setup script again by simply running `setup`. The long version above is not needed anymore.

10. You should now be in the Obsidian directory where you should now clone your Obsidian vaults. Try not to put any special characters (that are recognized by bash) in your vault name (eg an &, ! etc), if I remember correctly, it gave Tasker some issues, but you can probably get around that issue if you try. I don't know how spaces will behave.

11. Run `setup`.

At this point, you can run `sync` to sync all the Obsidian vaults in the `/storage/emulated/0/repos/Obsidian` folder.

---
### Tasker
1. Enable the Termux permission in the settings for the Tasker app.

2. Open the Obsidian app and add your vaults from the repos/Obsidian folder. If you're using the Obsidian Git plugin, you should disable it for your Android. You can do this in the plugin settings.

3. Import the "Tasker project" into Tasker. Once you import it, I recommend you rearrange the tasks based on [this image](https://raw.githubusercontent.com/DovieW/obsidian-android-sync/master/Tasks_Order.png) for simplicity (to rearrange tasks, hold on a task, then drag). You can import the project in 2 ways. You can use this [TaskerNet link](https://bit.ly/3Mn7M4S), or you can import the .xml file from this repository. You can do that by opening Tasker, and holding down on a project. A menu will appear, click "Import Project". Now you have to find the .xml file. Click "up" a couple times until you can find the "repos" folder. In that folder is the obsidian-android-sync folder. And the .xml file should be there.

4. There are ~~3~~ 2 types of tasks you have to edit in the project.
    1. Vault launch icons - Create widgets to these tasks so you can jump to a specific vault without having to open the app.
    2. Vault sync tasks - Each vault needs it's own sync task. This is to allow multiple vaults to sync in parralel.
    3. ~~Sync on app exit controller - When you leave the app, this will sync the vault you just left.~~

5. **Vault launch icons** - There are 2 example tasks (Example and Example2). Rename the task to the name of your vault (in this case, you can name it anything technically). Then in the task, you'll see a "Variable Set" action, change the value to the **name of the folder** which contains the repository for that vault.

6. **Vault sync tasks** - These tasks look like this: **Sync Vault - Example**. The name must be like that. Just replace "Example" with the **name of the folder which contains the repository of your vault (case sensitive)**. There is a "Variable Set" action in these tasks as well which has to be modified as well.

7. NOT NECESSARY ANYMORE - ~~**Sync on app exit controller** - This task is a little more complex. You'll have to modify the "Variable Set" actions, and the "If" actions (if you have more than 3 vaults). The CurrentVault variable represents the last vault you opened using a "open vault" task (see step 5). Each variable (vault1, vault2 etc.), should have the name (name of the folder - case sensitive) of a vault. And each part of the "If", should take care of one vault. If you have less than 3 vaults, all you have to do is modify the "Variable Set" actions. If you have more, you'll have to add "If" actions.~~

8. Give Termux the "Display over other apps" permission.

9. Add the Vault launch icons as widgets (use the one that allows you to add them to folders) to the home screen. Also, add the 3 helper tasks as widgets (as needed): 
   1. Sync Vaults - syncs all vaults
   2. Vaults Status - outputs the `git fetch && git status` of each vault
   3. Sync Log - outputs the sync log.

Instead of using "vault launch icons", you can replace that with a popup menu/scene (which runs the launch icon tasks), if you find that better.

If you prefer, you can have a popup menu (a scene or list dialog for example), to combine all the actions into one icon on your home screen.

There is a profile which syncs all vaults at 4am.

---

Any contributions are appreciated!
