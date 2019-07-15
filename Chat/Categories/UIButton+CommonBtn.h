//
//  UIButton+CommonBtn.h
//  Chat
//
//  Created by su_fyu on 15/6/24.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CommonBtn)

#pragma mark --按钮失效 延时
- (void)delayEnbable;

- (void)delayUserInterface;

#pragma mark --按钮失效 延时timer 秒
- (void)delayEnbableByTime:(NSTimeInterval)timer;

@end
