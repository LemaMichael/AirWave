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

@class BluetoothManager; @class SpringBoard; @class SBAssistantController; 
static _Bool (*_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); static _Bool _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); static void _logos_method$_ungrouped$SpringBoard$checkCount(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BluetoothManager$postNotificationName$object$)(_LOGOS_SELF_TYPE_NORMAL BluetoothManager* _LOGOS_SELF_CONST, SEL, id, id); static void _logos_method$_ungrouped$BluetoothManager$postNotificationName$object$(_LOGOS_SELF_TYPE_NORMAL BluetoothManager* _LOGOS_SELF_CONST, SEL, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBAssistantController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBAssistantController"); } return _klass; }
#line 26 "/Users/michael/Wave/WAVE/WAVE/WAVE.xm"

static _Bool _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPressesEvent * arg1) {
    long type = arg1.allPresses.allObjects[0].type;
    int force = arg1.allPresses.allObjects[0].force; 
    
    if (type == 104 && force == 1 && isDeviceAvailable && tweakEnabled) {
        sideButtonCounts++;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkCount];
        });
    }
    return _logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(self, _cmd, arg1);
}


static void _logos_method$_ungrouped$SpringBoard$checkCount(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"Side button pressed: %d times", sideButtonCounts);
    
    if (sideButtonCounts == 3) {
        
        
        SBAssistantController *assistantController = [_logos_static_class_lookup$SBAssistantController() sharedInstance];
        [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
        [assistantController handleSiriButtonUpEventFromSource:1];
        
    } else if (sideButtonCounts == 2) {
        MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
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




static void loadPrefs()
{
    NSMutableDictionary *WavePrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.Lema.Michael.WAVE.plist"];
    if(WavePrefs)
    {
        tweakEnabled = [WavePrefs objectForKey:@"enableWave"] ? [[WavePrefs objectForKey:@"enableWave"] boolValue] : tweakEnabled;
        NSLog(@"is tweak Enabled: %d", tweakEnabled);
        
    }
    [WavePrefs release];
}

static __attribute__((constructor)) void _logosLocalCtor_a97da629(int __unused argc, char __unused **argv, char __unused **envp)
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.Lema.Michael.WAVE-preferencesChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
    
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_handlePhysicalButtonEvent:), (IMP)&_logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(checkCount), (IMP)&_logos_method$_ungrouped$SpringBoard$checkCount, _typeEncoding); }Class _logos_class$_ungrouped$BluetoothManager = objc_getClass("BluetoothManager"); MSHookMessageEx(_logos_class$_ungrouped$BluetoothManager, @selector(postNotificationName:object:), (IMP)&_logos_method$_ungrouped$BluetoothManager$postNotificationName$object$, (IMP*)&_logos_orig$_ungrouped$BluetoothManager$postNotificationName$object$);} }
#line 116 "/Users/michael/Wave/WAVE/WAVE/WAVE.xm"
