//
//  BaseMessageCell.h
//  Chat
//
//  Created by su_fyu on 16/1/5.
//  Copyright © 2016年 su_fyu. All rights reserved.
//  消息聊天cell的基类

#import <UIKit/UIKit.h>
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "UUChatHearder.h"

@protocol MABaseMessageDegate <NSObject>

@end

@interface BaseMessageCell : UITableViewCell

@property (atomic,readonly) UUMessageEnumType messageType; //消息类型

@property (nonatomic,weak) id<MABaseMessageDegate> delegate; //执行代理
@property (nonatomic,retain,readonly) NSIndexPath *aIndexPath; //索引


-(void)setMessageFrame:(UUMessageFrame *)messageFrame
             withIndex:(NSIndexPath *)indexPath
             withTable:(UITableView *)tableView;

//返回cell
+ (BaseMessageCell *)tableView:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath
             messageType:(UUMessageEnumType )messageType;

@end

