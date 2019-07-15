//
//  UUMessageFrame.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "MatchParser.h"

#define MessageCellsSpaceing    18.f

#define TruthCellPaddingHeight  MessageCellsSpaceing



@class UUMessage;

@interface UUMessageFrame : NSObject

@property (nonatomic, assign, readonly) CGRect nameF;//名称
@property (nonatomic, assign, readonly) CGRect iconF;//头像
@property (nonatomic, assign, readonly) CGRect timeF;//时间
@property (nonatomic, assign, readonly) CGFloat extraHeight; //额外高度

@property (nonatomic, assign) CGRect contentF;//内容

@property (nonatomic, assign,readonly) CGFloat chatCellHeight;
@property (nonatomic, strong) UUMessage *message;
@property (nonatomic, assign) BOOL showTime;

@property (nonatomic, assign) BOOL isChangeImgFrame; //加载图片是否改变了大小

#pragma mark --通过图片大小 等比返回适合view大小
+(CGSize)currentImage:(UIImage *)image withViewSize:(CGSize)viewSize;

@end
