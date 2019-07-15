//
//  NSString+Tools.h
//  Chat
//
//  Created by su_fyu on 2019/7/12.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"
typedef enum : NSInteger
{
    kTypeImg,     //图片
    kTypeAudio,   //语音
    kTypeMovie    //视频
} LoadType;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Tools)
#pragma mark --得到类型的文件名
+ (NSString *)nameKeyByMessageMedia:(LoadType)type;
#pragma mark --得到类型的文件名 + 时间
+ (NSString *)nameKeyByMessageMedia:(LoadType)type withDuration:(CGFloat)duration;
@end

NS_ASSUME_NONNULL_END
