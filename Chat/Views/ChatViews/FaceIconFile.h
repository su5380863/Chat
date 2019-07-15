//
//  FaceIconFile.h
//  Chat
//
//  Created by su_fyu on 15/6/1.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceIconFile : NSObject


#pragma mark 获取plist 图片库
+(NSDictionary *)getFaceMap;

#pragma mark 根据iconkey值找到 image 名称
+(NSString *)faceKeyForValue:(NSString *)iconKey map:(NSDictionary *)map;

#pragma mark --获取特定文字
+(NSArray *)getNamesCore;

#pragma mark --获取个别字符
+(NSArray *)getSpaceciNames;

#pragma mark --获取全部特定文字
+(NSArray *)getAllNames;

@end
