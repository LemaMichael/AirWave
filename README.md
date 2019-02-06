# Wave
Tweak for AirPods using the Side button (iPhone 6 and later)


## Tools Used
- [MonkeyDev](https://github.com/AloneMonkey/MonkeyDev) for creating Tweaks 

## MediaRemote.h not found or symbol(s) not found for architecture arm64?
1. This project requires **MediaRemote.h** and the **MediaRemote.framework**. Make sure to download the sdks [here](https://github.com/theos/sdks) and add the **MediaRemote.framework** from *iPhoneOS11.2.sdk/System/Library/PrivateFrameworks* to "Linked Frameworks and Libraries"

<p align="ceneter">
 <img src = "/Assets/Help.png">
</p>

2. Copy **MediaRemote.framework** to */opt/theos/vendor/lib*

<p align="ceneter">
 <img src = "/Assets/Help2.png">
</p>

3. Next add ["MediaRemote.h"](https://github.com/theos/headers/blob/master/MediaRemote/MediaRemote.h) to the project. Don't forget to include the following to the xm file.

```objective-C
#import "MediaRemote.h" 
```

See this [issue](https://github.com/AloneMonkey/MonkeyDev/issues/64) if you still need help.





