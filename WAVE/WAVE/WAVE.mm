#line 1 "/Users/michael/Desktop/WAVE/WAVE/WAVE.xm"
#import <UIKit/UIKit.h>
#import "MediaRemote.h"

@interface UIGestureDelayedPress : NSObject
-(UIPressesEvent *)event;
@end


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

@class SpringBoard; 
static _Bool (*_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); static _Bool _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); 

#line 8 "/Users/michael/Desktop/WAVE/WAVE/WAVE.xm"

static _Bool _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPressesEvent * arg1) {
    long type = arg1.allPresses.allObjects[0].type;
    int force = arg1.allPresses.allObjects[0].force;
    if(type == 104 && force == 0) {
        NSLog(@"Home button pressed!");
        
        static int count = 0;
        count ++;
        if(count % 2 != 0){
            MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
        }else{
            NSLog(@"Else");
        }
    }
    return _logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(self, _cmd, arg1);
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_handlePhysicalButtonEvent:), (IMP)&_logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$);} }
#line 26 "/Users/michael/Desktop/WAVE/WAVE/WAVE.xm"
