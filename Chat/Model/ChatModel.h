//
//  ChatModel.h
//  UUChatTableView
//
//  Created by su_fyu on 15/1/6.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUChatHearder.h"
#import "Conversation+CoreDataClass.h"

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic) BOOL isGroupChat; //是否群聊

#pragma mark --回复上一次时间privious time
- (void)resetPriousTime;

#pragma mark --添加自己发得消息
- (void)addSpecifiedItem:(NSDictionary *)dic;

#pragma mark --添加别人发给我的消息
- (void)addOtherItem:(NSDictionary *)receiveDic;

#pragma mark --添加表消息数据  及其表没存其它参数
- (void)addMessageObjectEntity:(Conversation *)messageEntity withMoreParams:(NSDictionary *)moreDic;

#pragma mark -- 保存数据

+(BOOL)saveMessageDataForDic:(NSDictionary *)dic;

@end
