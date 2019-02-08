//
//  MyListController.m
//  WAVE
//
//  Created by Michael Lema on 2/8/19.
//

#include <spawn.h>
#import <notify.h>


@interface MyListController
@end

@implementation MyListController

-(void)respring {
    //: Updated for iOS 11.4
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

@end

