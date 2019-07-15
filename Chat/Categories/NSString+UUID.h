//
//  NSString+UUID.h
//  NewProduct
//
//  Created by zqf on 13-12-6.
//  Copyright (c) 2013年 Lee. All rights reserved.
//  得到uuid

#import <Foundation/Foundation.h>

@interface NSString (UUID)
#pragma mark 32位UUID
+ (NSString *)uuidString;

#pragma mark 12位UUID
+ (NSString *)uuidString12;

@end
