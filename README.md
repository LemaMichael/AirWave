# Wave
Tweak for AirPods using the Side button (iPhone 6 and later)


## Get Started
- Double and Triple Press the lock screen button for more actions
<p align="center">
 <img src = "/Assets/Demo1.PNG" height = "475"> 
 <img src = "/Assets/Demo2.PNG" height = "475">
</p>




## Tools Used
- [MonkeyDev](https://github.com/AloneMonkey/MonkeyDev) for creating Tweaks 

## MediaRemote.h not found or symbol(s) not found for architecture arm64?
1. This project requires **MediaRemote.h** and the **MediaRemote.framework**. Make sure to download the sdks [here](https://github.com/theos/sdks) and add the **MediaRemote.framework** from *iPhoneOS11.2.sdk/System/Library/PrivateFrameworks* to "Linked Frameworks and Libraries"

<p align="ceneter">
 <img src = "/Assets/Help.png">
</p>

2. Copy **MediaRemote.framework** to */opt/theos/vendor/lib*

<p align="center">
 <img src = "/Assets/Help2.png">
</p>

3. Next add ["MediaRemote.h"](https://github.com/theos/headers/blob/master/MediaRemote/MediaRemote.h) to the project. Follow the same steps to add the **Preferences.framework**


See this [issue](https://github.com/AloneMonkey/MonkeyDev/issues/64) if you still need help.



## Issue:
- [x] The Respring Button does not work



