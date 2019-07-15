//
//  DialogueBaseCell.h
//  Chat
//
//  Created by su_fyu on 16/1/5.
//  Copyright © 2016年 su_fyu. All rights reserved.
//  对话消息cell

#import "BaseMessageCell.h"
#import "CircleImage.h"
#import "NSDate+Utils.h"

@class DialogueBaseCell;
@protocol DialogueCellDelegate ;
//the dialoge prtocol
@protocol DialogueCellDelegate <MABaseMessageDegate>

@optional
//图片类型点击
- (void)dialogImageCellDidClick:(DialogueBaseCell *)cell imageKey:(NSString *)imageKey withIndexPath:(NSIndexPath *)indexPath;

@end

@interface DialogueBaseCell : BaseMessageCell

@property (nonatomic, weak) id<DialogueCellDelegate> delegate;

@property (nonatomic, strong, readonly) UIView *bgView;//背景底层view;

@property (nonatomic, strong, readonly) CircleImage *headImage ; //头像

@property (nonatomic, strong, readonly) UIView *dialogContentView; //对话内容View

@property (nonatomic, retain, readonly) UIImageView *sendBackBBView; //背景气泡图 (内容)

@property (nonatomic, readonly, retain) UUMessageFrame *messageFrame;

- (BOOL)isMyMessage; //是否我的消息

@end



