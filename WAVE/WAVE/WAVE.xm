#import <UIKit/UIKit.h>
#import "MediaRemote.h"
// https://bit.ly/2Df8ZqP
// https://www.reddit.com/r/jailbreak/comments/93juw0/request_any_airpod_tweaks/

@interface UIGestureDelayedPress : NSObject
-(UIPressesEvent *)event;
@end

@interface SBAssistantController
+(BOOL)isAssistantVisible;
+ (id)sharedInstance;
- (void)handleSiriButtonUpEventFromSource:(int)arg1;
- (_Bool)handleSiriButtonDownEventFromSource:(int)arg1 activationEvent:(int)arg2;
@end

@interface SpringBoard
-(void)checkCount; // New
@end

int sideButtonCounts;
BOOL isDeviceAvailable = false;

%hook SpringBoard
- (_Bool)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 {
    long type = arg1.allPresses.allObjects[0].type;
    int force = arg1.allPresses.allObjects[0].force; // 1 -> button pressed, 0 -> button released
    
    if (type == 104 && force == 1 && isDeviceAvailable) {
        sideButtonCounts++;
        
        // Delay for 0.5 seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkCount];
        });
    }
    return %orig;
}

%new
-(void)checkCount {
    NSLog(@"Side button pressed: %d times", sideButtonCounts);
    
    if (sideButtonCounts == 3) {
        
        // Call Siri
        SBAssistantController *assistantController = [%c(SBAssistantController) sharedInstance];
        [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
        [assistantController handleSiriButtonUpEventFromSource:1];
        
    } else if (sideButtonCounts == 2) {
        MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
    } else {
        // Do Nothing
    }
    
    // Resetting the button count
    sideButtonCounts = 0;
}
%end



%hook BluetoothManager
-(void)postNotificationName:(id)arg1 object:(id)arg2 {
    
    /*
     arg1 can be many things:
        - BluetoothAvailabilityChangedNotification
        - BluetoothDeviceDisconnectSuccessNotification
        - BluetoothDeviceConnectSuccessNotification
        - BluetoothDeviceUpdatedNotification
     */
    //NSLog(@"arg1: %@, arg2: %@", (NSString *)arg1, arg2);
    %orig;
    
    if ([arg1 isKindOfClass:[NSString class]]) {
        
        NSString *notificationName = (NSString *)arg1;
        
        if ([notificationName isEqualToString: @"BluetoothDeviceConnectSuccessNotification"]) {
            isDeviceAvailable = YES;
        } else if ([notificationName isEqualToString: @"BluetoothDeviceDisconnectSuccessNotification"]) {
            isDeviceAvailable = NO;
        } else {
            // NotificationName will most likely be BluetoothAvailabilityChangedNotification but that doesn't determine if a bluetooth device is connected or not.
        }
    }
}

%end

BOOL Enabled;
static void settingsChangedWave(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    @autoreleasepool {
        NSDictionary *WavePrefs = [[[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.Lema.Michael.WAVE.plist"]?:[NSDictionary dictionary] copy];
        Enabled = (BOOL)[[WavePrefs objectForKey:@"enableWave"]?:@YES boolValue];
        NSLog(@"is Enabled: %d", Enabled);
    }
}

__attribute__((constructor)) static void initialize_Wave()
{
    @autoreleasepool {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedWave, CFSTR("com.Lema.Michael.WAVE-preferencesChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        settingsChangedWave(NULL, NULL, NULL, NULL, NULL);
    }
}
