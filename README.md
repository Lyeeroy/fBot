# AutoIt Minecraft Fishing Bot

[![AutoIt](https://img.shields.io/badge/language-AutoIt-blue.svg)](https://www.autoitscript.com/site/)
[![License](https://img.shields.io/github/license/yourusername/your-repo-name)](https://github.com/yourusername/your-repo-name/blob/main/LICENSE)

## Description
This AutoIt script automates fishing in Minecraft, complete with a user-friendly graphical interface. It constantly scans for a red color within a specified area on the screen and simulates fishing when the color is detected. The script provides real-time status updates, including fish caught and runtime. It also offers an easy-to-use close bind.

## Requirements
- [AutoIt](https://www.autoitscript.com/site/autoit/downloads/): Install AutoIt to run the script.
- Minecraft: Ensure Minecraft is installed and configured properly.

## Installation

1. **Install AutoIt:**
   - Download [AutoIt](https://www.autoitscript.com/site/autoit/downloads/) from the official website.
   - Follow the installation instructions provided on the website to install AutoIt.

2. **Configure Minecraft:**
   - Launch Minecraft and ensure it's set up according to your preferences.
   - Important: Configure Minecraft settings to display the red color used by the script within a square on the screen. The script relies on this for fishing detection.

## Usage

1. Run the AutoIt script after successfully installing AutoIt.

2. A graphical interface will appear, displaying the fishing bot's status.

3. Minecraft must be the active window for the script to function. If it's not, the script will wait for Minecraft to become active.

4. After a 4-second delay for Minecraft setup, the fishing bot will activate, and the script will begin monitoring for the red color within the specified area.

5. When the script detects the red color within the defined area, it will simulate a right-click (fishing action) in Minecraft.

6. The fishing bot will continue running until you press the "ESC" key.

7. The graphical interface will display the number of fish caught and the runtime.

**Note:** Ensure your Minecraft settings display the red color clearly within a square on the screen. Failure to do so may result in the script not detecting the fishing action.

Feel free to customize the script and graphical interface as needed. Enjoy automated fishing in Minecraft!
