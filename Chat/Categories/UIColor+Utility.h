//
//  UIColor+Utility.h
//  Chat
//
//  Created by su_fyu on 2019/7/1.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Utility)
//16进制图片 速度更快
+(UIColor *)hexRGB:(unsigned int)rgbValue;

+(UIColor *)hexRGB:(unsigned int)rgbValue alpha:(CGFloat) a;
@end

NS_ASSUME_NONNULL_END
