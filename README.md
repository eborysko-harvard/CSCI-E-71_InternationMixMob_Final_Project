# Slack Services plugin for Apache Cordova
Final project for the group **International Mix Mob**
[![Build Status](https://travis-ci.org/eborysko-harvard/CSCI-E-71_InternationMixMob_Final_Project.svg)](https://travis-ci.org/eborysko-harvard/CSCI-E-71_InternationMixMob_Final_Project) [![ReviewNinja](https://app.review.ninja/45349867/badge)](https://app.review.ninja/eborysko-harvard/CSCI-E-71_InternationMixMob_Final_Project)

##Product Vision
Create Cordova plugins for iOS and Android to enable Slack services within development of any hybrid mobile application. The plugin includes:
* Authorization service
* Identity Information
* Selecting Channels
* Posting Messages
* Presence Awareness
* Advance Content sharing via Slash Commands
* An example Cordova application to demostrate the plugin's features.


## Team members
### Scrum Team
* Cornell Wright, _iOS Developer_
* Alpana Barua, _Scrum Master & part-time iOS Developer_
* Jeffry Pincus, _Android Developer_
* Frederick Jansen, _Android & Hybrid Developer_
* Manoj Shenoy, _iOS Developer_
* Shameek Nath, _Android Developer_
* Justin Sanford, _Android & Hybrid Developer_
* Evan Borysko, _Product Owner & part-time iOS Developer_

### Product owner
Evan Borysko

### Scrum Master
Alpana Barua

## Definition of Done
* Builds without errors.
* All public methods are documented.
* All classes are documented.
* Build and deployment steps are documented.
* Code is committed to Github.
* Code is reviewed by at least one other team member (pair/mobs need no other review) before committed to master.
* All existing unit tests pass, and new ones are written for new code.
* Additional unit tests code reviewed by 2 other team members (pair/mobs need one other review).
* Code coverage is > 85%.
* Code targets 4 platforms: iOS, Android, JS API and reference application.
* Ticket must be closed after a story is finished.
* Time is logged in Jira for all closed tickets.
* All commits must reference a ticket number.
* The product owner signs off on a closed ticket.
* Product has matched or exceeded the expectation of stake holders after product review.

## Stakeholders
* **Mobile App Developer** - needs a small lightweight plugin that allows easy integration into their app to authenticate in Slack, must have high levels of code readability and transparency and the documentation needs to be clear and logical.
* **Mobile Hybrid Web Developer**- needs a plugin that is platform agnostic, authentication should be fast and reliable with clear error descriptions.
* **Product Owner** - needs something that is fast to implement, needs to have few impediments to getting a product to market and enhances the productivity of the developer team.

## Resources
* [JIRA - Backlog and Sprint Boards](https://harvard-coursework.atlassian.net/secure/RapidBoard.jspa?rapidView=1&projectKey=SKCP&view=planning.nodetail&selectedIssue=SKCP-14&epics=visible)
* [Pointing Poker](https://www.pointingpoker.com/64137)
* [Travis-CI Dashboard](https://travis-ci.org/eborysko-harvard/CSCI-E-71_InternationMixMob_Final_Project)

## Git workflow
The idea is to follow a story branch pattern very similar to the one outlined [here](http://reinh.com/blog/2009/03/02/a-git-workflow-for-agile-teams.html), with the main difference being that no interactive rebase is required to squash commits. The steps are thus as follows:

Pull in latest content when on master.
```
git pull origin master
```
Create and checkout story branch. Use the ticket number as the start of the branch name
```
git checkout -b 80-git-workflow
```
Rebase from master often to keep up to date with changes. Fix any merge conflicts as they come along.
```
git fetch origin master
git rebase origin/master
```
When all work is done on this story, rebase with master once more. Then finally, merge the branch with master.
```
git checkout master
git merge 80-git-workflow
```
When followed correctly, no merge conflicts should ever appear on the master branch.

## Preparing Development Environment
### Android
#### Installing Cordova and running Cordova HelloWorld App
The source of this brief instruction list is the Cordova [Android Platform Guide](https://cordova.apache.org/docs/en/5.1.1/guide/platforms/android/index.html).

1. Install [Node.js](https://nodejs.org/) version 5.0.0.
2. Install [Java Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html).
3. Install [Android Studio](http://developer.android.com/sdk/installing/index.html?pkg=studio).
4. Open the Android SDK Manager (type `android` on console) and install:
  * Android SDK platform (Cordova [Android Platform Guide](https://cordova.apache.org/docs/en/5.1.1/guide/platforms/android/index.html) suggests installing API 22 (v5.1.1)).
  * Tools/Android SDK Build-tools version 19.1.0 or higher (23.0.2 works).
  * Extras/Android Support Repository
5. Set up Android emulator for development:
  * Install Intel x86 Atom System Image (from API 22) from Android SDK Manager.
    * Windows: Install Extras/Intel x86 Emulator Accelerator from Android SDK Manager.
    * Linux: Make sure `kvm` and `virtio` kernel modules are loaded:
      * `$ lsmod | grep kvm` and `$ lsmod | grep virtio`.
      * If either command gives no response, `# modprobe kvm` or `# modprobe virtio` will load the kernel modules.
  * Click **Tools -> Manage AVDs...** in the Android SDK Manager.
  * Click the **Device Definitions** tab.
  * Click on a device, e.g. **Nexus 5 by Google**, then click **Create AVD...** button.
    * Optionally modify the AVD name.
    * In the Target field, select the Android version.
    * In the CPU/ABI field, select **Intel Atom (x86)**.
    * In the Skin field, select a skin (**Skin with dynamic hardware controls** works).
    * In Emulation Options, select **Use Host GPU**.
6. If you plan to run the app in an Android device for development:
  * Install API matching the Android version on your device from Android SDK Manager.
  * Enable USB debugging on the device:
    * In **Settings -> About phone**, scroll down to the **Build number** field.
    * Tap the **Build number** field several times until **Developer options** are unlocked.
    * In **Settings -> Developer options**, enable **USB debugging**.
    * Connect the device to your computer via USB.
7. Install Cordova:
   * `$ npm install -g cordova`
   * `$ cordova --version` should be 5.4.0.
   * `$ npm install -g plugman`
8. Create a new project:
   * `$ cordova create hello com.example.hello HelloWorld`
   * `$ cd hello`
   * `$ cordova platform add android`
   * `$ cordova build`
9. Deploy the app:
  * `$ cordova run android --list` displays the deployment options available.
  * `$ cordvoa run android --target="target"` to deploy to device or emulator of choice.
  * App should be pushed to device, and you should see a screen with the Apache Cordova logo and a pulsing button stating the device is ready.
10. Open new project in Android Studio:
  * Launch Android Studio
  * Accept all the defaults from the startup wizard.
  * Select **Import Project**.
  * Select location where android platform is stored (`hello/platforms/android`)
  * Main activity is located at `android/java/com.example.hello/MainActivity.java`.
  * It should be possible to run the app from within Android Studio via **Run -> 'android'**.

### iOS
#### Tools for development using XCode

1. Mac with OS X 10.10.5 installed
2. Install Xcode 7.1 from Mac App Store
3. Install Xcode command line tools
4. Install HomeBrew using below command in terminal
   * `$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
   * Optionally `$ brew tap homebrew/versions`
5. Install Node.js with HomeBrew:
   * `$ brew install node`
6. Install Cordova using the below command
	 * `$ npm install -g cordova`
   * `$ cordova --version` should be 5.4.0.
   * `$ npm install -g plugman`
7. Create a new project:
   * `$ cordova create harvardcscie71 com.example.hello HelloWorld`
   * `$ cd harvardcscie71`
   * `$ cordova platform add ios`
   * `$ cordova build`
Optional - Install Github desktop from https://desktop.github.com/
Optional - If you have multiple versions of node.js and need to switch between them using homebrew versions

## Code Reviews
Review Ninja has been added to Github. Directions coming soon.

## Example CI Projects
* [iOS Cordova](https://github.com/eborysko-harvard/Test_CI_iOS) [![Build Status](https://travis-ci.org/eborysko-harvard/Test_CI_iOS.svg?branch=master)](https://travis-ci.org/eborysko-harvard/Test_CI_iOS) [![Coverage Status](https://coveralls.io/repos/eborysko-harvard/Test_CI_iOS/badge.svg?branch=master&service=github)](https://coveralls.io/github/eborysko-harvard/Test_CI_iOS?branch=master)
* [Android Cordova](https://github.com/eborysko-harvard/Test_CI_Android) [![Build Status](https://travis-ci.org/eborysko-harvard/Test_CI_Android.svg)](https://travis-ci.org/eborysko-harvard/Test_CI_Android)

Example projects use NPM to get dependencies, run build, and run tests. After cloning, run the following commands:
* <root of project>/npm i
* <root of project>/npm test
* <root of project>/npm run build

I will enable more commands shortly. iOS project requires Mac OSX and Node 4.1.1 to function. Android build should run on OSX or Linux. If someone has a Windows environment to, please let me know.
