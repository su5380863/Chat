//
//  UIColor+Utility.m
//  Chat
//
//  Created by su_fyu on 2019/7/1.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

+(UIColor *)hexRGB:(unsigned int)rgbValue
{
    CGFloat a =1.0;
    
    return [[self class] hexRGB:rgbValue alpha:a];
}


+(UIColor *)hexRGB:(unsigned int)rgbValue alpha:(CGFloat) a
{
    //颜色由4字节32位表示 前8位为透明度 后面依次为 红 蓝 绿 计算机‘与’ ‘或’ 运算最快
    const  float r = (rgbValue & 0XFF0000) >>16 ;
    
    const  float g = (rgbValue & 0XFF00) >>8;
    
    const  float b = (rgbValue & 0XFF);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

@end
