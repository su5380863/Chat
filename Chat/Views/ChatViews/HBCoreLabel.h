//
//  HBCoreLabel.h
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//  表情图片

#import <UIKit/UIKit.h>
#import "MatchParser.h"


@class HBCoreLabel;
@protocol HBCoreLabelDelegate <NSObject>
@optional
-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel nameClick:(NSString *)linkStr;
@end

@interface HBCoreLabel : UILabel<UIActionSheetDelegate,UIGestureRecognizerDelegate,MatchParserDelegate>
{
    //MatchParser* _match;
    
    BOOL touch;
    
    NSString * _linkStr;
    
    NSString * _linkType;
    
    BOOL _copyEnableAlready;
    
    BOOL _attributed;
}

@property(nonatomic,strong ) MatchParser * match;

@property(nonatomic,weak) id<MatchParserDelegate> data;

@property(nonatomic,weak) id<HBCoreLabelDelegate> delegate;

@property(nonatomic) BOOL linesLimit;

-(void)registerCopyAction;

#pragma mark --匹配图文表情 屏蔽关键字
-(void)setSoucreText:(NSString *)text;

-(void)setSoucreText:(NSString *)text withUserId:(NSString *)userId;

-(void)setSoucreText:(NSString *)text withUserId:(NSString *)userId withSpeacel:(BOOL)sepacel;

@end
