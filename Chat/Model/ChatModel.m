//
//  ChatModel.m
//  UUChatTableView
//
//  Created by su_fyu on 15/1/6.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import "ChatModel.h"
#import "NSManagedObjectContext+SafyCommit.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "Conversation+CoreDataClass.h"

@interface ChatModel()

@property (nonatomic, copy) NSString *previousTime;

@end

@implementation ChatModel

-(id)init
{
    self = [super init];
    if(self){

        _isGroupChat = NO;
        _dataSource = [[NSMutableArray alloc ] init];
    }
    return self;
}

-(void)dealloc
{
    _previousTime = nil;
}

- (void)resetPriousTime {
    
    _previousTime = nil;
}


// 添加自己的item
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *iconStr =@"";
    
    [dataDic setObject:@(UUMessageFromMe) forKey:UUMessageFrom];
    
    NSString *timeStr = dataDic[UUMessageTime];
    
    if(!timeStr){
        timeStr =[NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970];
        [dataDic setObject:timeStr forKey:UUMessageTime];
    }

    [dataDic setObject:@"" forKey:UUMessageName];
    [dataDic setObject:iconStr forKey:UUMessageUserIcon];
    
    [message setWithDict:dataDic];
    
    [message minuteOffSetStart:_previousTime end:dataDic[UUMessageTime]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    if (message.showDateLabel) {
        _previousTime = dataDic[UUMessageTime];
    }
    [self.dataSource addObject:messageFrame];
}


- (void)addOtherItem:(NSDictionary *)receiveDic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:receiveDic];

    [dataDic setObject:@(UUMessageFromOther) forKey:UUMessageFrom];

    [message setWithDict:dataDic];
    
    [message minuteOffSetStart:_previousTime end:dataDic[UUMessageTime]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    if (message.showDateLabel) {
        _previousTime = dataDic[UUMessageTime];
    }

    [self.dataSource addObject:messageFrame];
}


#pragma mark --添加表消息数据  及其表没存其它参数
- (void)addMessageObjectEntity:(Conversation *)messageEntity withMoreParams:(NSDictionary *)moreDic
{
    
    NSMutableDictionary *messageDic =[[NSMutableDictionary alloc ]initWithDictionary: [messageEntity getDictionary]];

    if(moreDic){
        
        NSArray *keys = [moreDic allKeys];

        for (NSString *key in keys) {

            // 根据key获取value
            id value = [moreDic objectForKey:key];
            
            [messageDic setObject:value forKey:key];
        }
        
    }
#
    //类型
    NSInteger type = 0;
    if([messageEntity.media isEqualToString:@"text"]){ //文本
        
        type = UUMessageTypeText;
        
    }else if ([messageEntity.media isEqualToString:@"image"]){ //图片
        
        type = UUMessageTypePicture;
        
    }else if ([messageEntity.media isEqualToString:@"audio"]){ //语音
        
        type = UUMessageTypeVoice;
    }
    //设置数据
    [messageDic setObject:@(type) forKey:UUMessageType];
    
    NSString *from_client_id = messageEntity.from_client_id;
    
    NSString *user_id = UserSelf;//自己的id
    if([from_client_id isEqualToString:user_id]){ //如果是自己
        
        [self addSpecifiedItem:messageDic];
        
    }else{ //别人的
        
        [self addOtherItem:messageDic];
        
    }
    
}


+(BOOL)saveMessageDataForDic:(NSDictionary *)dic{
    
    NSManagedObjectContext * managerContext = [NSManagedObjectContext createNewManagedObjectContext];
    Conversation * conversationObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Conversation class]) inManagedObjectContext:managerContext];
    
    [conversationObject setWithDictionary:dic];
   
    
    return [managerContext safeCommit];
}


@end
