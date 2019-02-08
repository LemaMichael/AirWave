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
BOOL tweakEnabled;

// Double Press Preferences
BOOL dSiri;
BOOL dPlayPause;
BOOL dNextTrack;
BOOL dPreviousTrack;

// Triple Press Preferences
BOOL tSiri;
BOOL tPlayPause;
BOOL tNextTrack;
BOOL tPreviousTrack;


%hook SpringBoard
- (_Bool)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 {
    long type = arg1.allPresses.allObjects[0].type;
    int force = arg1.allPresses.allObjects[0].force; // 1 -> button pressed, 0 -> button released
    
    if (tweakEnabled) {
        if (type == 104 && force == 1 && isDeviceAvailable) {
            sideButtonCounts++;
            
            // Delay for 0.5 seconds
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkCount];
            });
        }
        
    }
    return %orig;
}

%new
-(void)checkCount {
    NSLog(@"Side button pressed: %d times", sideButtonCounts);
    
    if (sideButtonCounts == 3) {
        /*
         BOOL tSiri;
         BOOL tPlayPause;
         BOOL tNextTrack;
         BOOL tPreviousTrack;
         */
        if (tSiri) {
            // Call Siri
            SBAssistantController *assistantController = [%c(SBAssistantController) sharedInstance];
            [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
            [assistantController handleSiriButtonUpEventFromSource:1];
        } if (tPlayPause) {
            MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
        } if (tNextTrack) {
            MRMediaRemoteSendCommand(kMRNextTrack, 0);
        } if (tPreviousTrack) {
            MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
        }
        
    } else if (sideButtonCounts == 2) {
        
        if (dSiri) {
            // Call Siri
            SBAssistantController *assistantController = [%c(SBAssistantController) sharedInstance];
            [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
            [assistantController handleSiriButtonUpEventFromSource:1];
        }  if (dPlayPause) {
            MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
        }  if (dNextTrack) {
            MRMediaRemoteSendCommand(kMRNextTrack, 0);
        }  if (dPreviousTrack) {
            MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
        }
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


static void settingsChangedWave(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    @autoreleasepool {
        NSDictionary *WavePrefs = [[[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.Lema.Michael.WAVE.plist"]?:[NSDictionary dictionary] copy];
        tweakEnabled = (BOOL)[[WavePrefs objectForKey:@"enableWave"]?:@YES boolValue];
        
        // Double Press Preferences
        dSiri = (BOOL)[[WavePrefs objectForKey:@"dSiri"]?:@NO boolValue];
        dPlayPause = (BOOL)[[WavePrefs objectForKey:@"dPlayPause"]?:@NO boolValue];
        dNextTrack = (BOOL)[[WavePrefs objectForKey:@"dNextTrack"]?:@NO boolValue];
        dPreviousTrack = (BOOL)[[WavePrefs objectForKey:@"dPreviousTrack"]?:@NO boolValue];
        
        
        // Triple Press Preferences
        tSiri = (BOOL)[[WavePrefs objectForKey:@"tSiri"]?:@NO boolValue];
        tPlayPause = (BOOL)[[WavePrefs objectForKey:@"tPlayPause"]?:@NO boolValue];
        tNextTrack = (BOOL)[[WavePrefs objectForKey:@"tNextTrack"]?:@NO boolValue];
        tPreviousTrack = (BOOL)[[WavePrefs objectForKey:@"tPreviousTrack"]?:@NO boolValue];
        
        NSLog(@"is tweak Enabled: %d, dSiri: %d, dPlayPause: %d,  dNextTrack: %d, dPreviousTrack: %d", tweakEnabled, dSiri, dPlayPause, dNextTrack, dPreviousTrack);
        NSLog(@"tSiri: %d, tPlayPause: %d,  tNextTrack: %d, tPreviousTrack: %d", tSiri, tPlayPause, tNextTrack, tPreviousTrack);
    }
}

__attribute__((constructor)) static void initialize_Wave()
{
    @autoreleasepool {
         CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedWave, CFSTR("com.Lema.Michael.WAVE-preferencesChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        settingsChangedWave(NULL, NULL, NULL, NULL, NULL);
    }
}

