#import <UIKit/UIKit.h>
#import "MediaRemote.h"

@interface UIGestureDelayedPress : NSObject
-(UIPressesEvent *)event;
@end

%hook SpringBoard
- (_Bool)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 {
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
    return %orig;
}
%end
