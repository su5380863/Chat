//
//  UIButton+CommonBtn.m
//  Chat
//
//  Created by su_fyu on 15/6/24.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import "UIButton+CommonBtn.h"

@implementation UIButton (CommonBtn)


#pragma mark --按钮失效 延时
- (void)delayEnbable
{
    [self delayEnbableByTime:1.0];
}

- (void)delayEnbableByTime:(NSTimeInterval)timer
{
    self.enabled = NO;
//    self.userInteractionEnabled = NO;
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (timer * 1000ull) * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
//        weakSelf.userInteractionEnabled = YES;
        weakSelf.enabled = YES;

    });
}

#pragma mark --按钮失效 延时
- (void)delayUserInterface
{
    [self delayUserInterfaceByTime:1.0];
}

- (void)delayUserInterfaceByTime:(NSTimeInterval)timer
{
//    self.enabled = NO;
    self.userInteractionEnabled = NO;
    NSLog(@"btnStartEn");
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (timer * 1000ull) * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        weakSelf.userInteractionEnabled = YES;
//        weakSelf.enabled = YES;
        NSLog(@"btnEndEn");
    });
}



@end
