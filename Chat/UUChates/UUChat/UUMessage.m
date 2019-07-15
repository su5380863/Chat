//
//  UUMessage.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessage.h"
#import "NSDate+Utils.h"
#import <CommonCrypto/CommonDigest.h>

@interface UUMessage()

@end


@implementation UUMessage

- (id)init
{
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

#pragma mark --设置消息参数
- (void)setWithDict:(NSMutableDictionary *)dict{
    
    _messageDic = dict;
    
    self.user_name = dict[UUMessageName];
    self.from_client_id = dict[UUMessageUserID];
    self.content =  dict[UUMessageContent];
    self.from = [dict[UUMessageFrom] intValue];
    
    self.time = dict[UUMessageTime];
    self.img = dict[UUMessageUserIcon];
    self.local_Soucre = dict[UUMessageLocal_soucre];
    
    NSString * type = dict[@"media"];
    
    if ([type isEqualToString:@"text"]) {
        self.type = UUMessageTypeText;
    }else if([type isEqualToString:@"image"]){
        self.type = UUMessageTypePicture;
    }else{
        CGFloat duration = [dict[UUMessageVoiceTime] floatValue];
        self.duration =[NSString stringWithFormat:@"%.0f",duration] ;
        self.type = UUMessageTypeVoice;
    }
    
}

- (NSString *)showMessage
{
    return _content;
}

-(NSDate *)getDateByString:(NSString *)Str
{
    long long time = [Str longLongValue];
    
    NSDate *date ;
    if(time >0){
        
        date = [NSDate dateWithTimeIntervalSince1970:time];
        
    }else{
        
        NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
        date = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return date;
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    
    NSDate *startDate = [self getDateByString:start];
    
    NSDate *endDate = [self getDateByString:end];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
}

- (BOOL)isMine
{
    BOOL mine = (self.from == UUMessageFromMe);
    
    return mine;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
