# Wave
Tweak for AirPods using the Power button 

Since the release of iOS 11,  each AirPod can be configured to a different action when double-tapped. Although there are no wires,  it is a nuisance to control. It is not practical to double-tap each AirPod when jogging or on a crowded subway/bus. Being limited to just one action per AirPod doesn't help either. This is where Wave helps. Wave allows you to keep your customized control for each AirPod by utilizing the power button to control the music. If you assigned the Left and Right AirPod to Play/Pause and Next Track, you can now double and triple press the power button to activate Siri and play the Previous Track. The double and triple actions are configurable for you to decide. Wave activates when your phone connects to your AirPods and deactivates when you put it back in your charging case.  


## Get Started
- Go to **General** -> **Settings** -> **Wave** to configure the Power button actions.
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



