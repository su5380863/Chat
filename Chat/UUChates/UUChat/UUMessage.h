//
//  UUMessage.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UUChatHearder.h"

@interface UUMessage : NSObject

typedef void (^UUDownSoundBlock)(NSData *soundData,BOOL success);


@property (nonatomic, copy) NSString *img; //用户头像
@property (nonatomic, copy) NSString *from_client_id;   //用户id
@property (nonatomic, copy) NSString *time;  //消息时间
@property (nonatomic, copy) NSString *user_name; //用户名

@property (nonatomic, copy) NSString *content;  //消息内容 或文件路径

@property (nonatomic, copy) NSString *duration; //语音时长
@property (nonatomic, copy) NSString *local_Soucre; //本地文件路径

@property (nonatomic, assign) UUMessageEnumType type; //消息类型
@property (nonatomic, assign) UUMessageEnumFrom from; //消息发送者类型

@property (nonatomic, assign) BOOL showDateLabel;

- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

- (NSString *)showMessage;  //需要显示的内容

@property (nonatomic, strong) NSMutableDictionary *messageDic;//消息

- (BOOL)isMine; //是否我的消息

@end
