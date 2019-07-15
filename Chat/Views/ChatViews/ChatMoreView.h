//
//  ChatMoreView.h
//  Chat
//
//  Created by su_fyu on 15/6/3.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  聊天 更多功能

#import <UIKit/UIKit.h>

#define ChatMore_ImageNameKey  @"chatMoreImage"  //图片key
#define ChatMore_TitleKey      @"chatMoreTitle"  //名称key

#define ChatMoreTitle_height 25.f  //标题高度25

@class ChatMoreView;
@protocol ChatMoreViewDelegate <NSObject>

-(void)didSelectedItem:(NSInteger)index forChatMoreView:(ChatMoreView *)view;

@end


@interface ChatMoreView : UIView

//按钮数组源
@property (nonatomic,retain) NSArray *itemArr;

//按钮的大小
@property (nonatomic,assign) CGSize butSize; //default (100.0f, 30.0f);

//每行显示按钮个数
@property (nonatomic,assign) int numberOfline ; //default 4

@property (nonatomic,assign) float titleFontSize; //default 14

@property (nonatomic,weak) id<ChatMoreViewDelegate>delegate;

@end
