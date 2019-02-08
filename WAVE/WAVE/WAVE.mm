#line 1 "/Users/michael/Wave/WAVE/WAVE/WAVE.xm"
#import <UIKit/UIKit.h>
#import "MediaRemote.h"



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
-(void)checkCount; 
@end

int sideButtonCounts;
BOOL isDeviceAvailable = false;
BOOL tweakEnabled;


BOOL dSiri;
BOOL dPlayPause;
BOOL dNextTrack;
BOOL dPreviousTrack;


BOOL tSiri;
BOOL tPlayPause;
BOOL tNextTrack;
BOOL tPreviousTrack;



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class BluetoothManager; @class SBAssistantController; @class SpringBoard; 
static _Bool (*_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); static _Bool _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); static void _logos_method$_ungrouped$SpringBoard$checkCount(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BluetoothManager$postNotificationName$object$)(_LOGOS_SELF_TYPE_NORMAL BluetoothManager* _LOGOS_SELF_CONST, SEL, id, id); static void _logos_method$_ungrouped$BluetoothManager$postNotificationName$object$(_LOGOS_SELF_TYPE_NORMAL BluetoothManager* _LOGOS_SELF_CONST, SEL, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBAssistantController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBAssistantController"); } return _klass; }
#line 38 "/Users/michael/Wave/WAVE/WAVE/WAVE.xm"

static _Bool _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPressesEvent * arg1) {
    long type = arg1.allPresses.allObjects[0].type;
    int force = arg1.allPresses.allObjects[0].force; 
    
    if (tweakEnabled) {
        if (type == 104 && force == 1 && isDeviceAvailable) {
            sideButtonCounts++;
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkCount];
            });
        }
        
    }
    return _logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(self, _cmd, arg1);
}


static void _logos_method$_ungrouped$SpringBoard$checkCount(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"Side button pressed: %d times", sideButtonCounts);
    
    if (sideButtonCounts == 3) {
        
        if (tSiri) {
            
            SBAssistantController *assistantController = [_logos_static_class_lookup$SBAssistantController() sharedInstance];
            [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
            [assistantController handleSiriButtonUpEventFromSource:1];
        } else if (tPlayPause) {
            MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
        } else if (tNextTrack) {
            MRMediaRemoteSendCommand(kMRNextTrack, 0);
        } else if (tPreviousTrack) {
            MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
        }
        
    } else if (sideButtonCounts == 2) {
        
        if (dSiri) {
            
            SBAssistantController *assistantController = [_logos_static_class_lookup$SBAssistantController() sharedInstance];
            [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
            [assistantController handleSiriButtonUpEventFromSource:1];
        }  else if (dPlayPause) {
            MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
        }  else if (dNextTrack) {
            MRMediaRemoteSendCommand(kMRNextTrack, 0);
        }  else if (dPreviousTrack) {
            MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
        }
        
    } else {
        
    }
    
    
    sideButtonCounts = 0;
}





static void _logos_method$_ungrouped$BluetoothManager$postNotificationName$object$(_LOGOS_SELF_TYPE_NORMAL BluetoothManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2) {
    
    






    
    _logos_orig$_ungrouped$BluetoothManager$postNotificationName$object$(self, _cmd, arg1, arg2);
    
    if ([arg1 isKindOfClass:[NSString class]]) {
        
        NSString *notificationName = (NSString *)arg1;
        
        if ([notificationName isEqualToString: @"BluetoothDeviceConnectSuccessNotification"]) {
            isDeviceAvailable = YES;
        } else if ([notificationName isEqualToString: @"BluetoothDeviceDisconnectSuccessNotification"]) {
            isDeviceAvailable = NO;
        } else {
            
        }
    }
}




static void settingsChangedWave(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    @autoreleasepool {
        NSDictionary *WavePrefs = [[[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.Lema.Michael.WAVE.plist"]?:[NSDictionary dictionary] copy];
        tweakEnabled = (BOOL)[[WavePrefs objectForKey:@"enableWave"]?:@YES boolValue];
        
        
        dSiri = (BOOL)[[WavePrefs objectForKey:@"dSiri"]?:@NO boolValue];
        dPlayPause = (BOOL)[[WavePrefs objectForKey:@"dPlayPause"]?:@NO boolValue];
        dNextTrack = (BOOL)[[WavePrefs objectForKey:@"dNextTrack"]?:@NO boolValue];
        dPreviousTrack = (BOOL)[[WavePrefs objectForKey:@"dPreviousTrack"]?:@NO boolValue];
        
        
        
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

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_handlePhysicalButtonEvent:), (IMP)&_logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(checkCount), (IMP)&_logos_method$_ungrouped$SpringBoard$checkCount, _typeEncoding); }Class _logos_class$_ungrouped$BluetoothManager = objc_getClass("BluetoothManager"); MSHookMessageEx(_logos_class$_ungrouped$BluetoothManager, @selector(postNotificationName:object:), (IMP)&_logos_method$_ungrouped$BluetoothManager$postNotificationName$object$, (IMP*)&_logos_orig$_ungrouped$BluetoothManager$postNotificationName$object$);} }
#line 164 "/Users/michael/Wave/WAVE/WAVE/WAVE.xm"
