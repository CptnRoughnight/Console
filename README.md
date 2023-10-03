# Console
 Console Addon for Godot

# Installation
Download this repo, copy the folders in "addon" and the Folder "Console" to you project. Start Godot.
Load your project, activate the RoughCon-Addon in the project settings (this activate an autoload)

# Usage
Add the "Console/Console.tscn" to your scene. In the _ready method you can now setup up the autoload
with your Vars and Consts.

![Screenshot_20231003_115249](https://github.com/CptnRoughnight/Console/assets/31368513/e8c976c6-6923-42f3-9217-5812bc40dcde)

In the inspector there are some options. 
Section Commands let's you setup a script file and the methods you want to enable for the console.


Section Settings:
[Activate Key]     - Input Action for activating/deactivating the console
[Save Log File]    - Save the log file to res://logs/log[timestamp].txt
[Log Save Time]    - Time for auto saving the log
[Paus On Activate] - Pauses the game on activation



