//
//  FaceViews.h
//  Chat
//
//  Created by su_fyu on 15/6/1.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseMuaiView.h"
#import "FaceIconFile.h"

@class FaceViews;
@protocol FaceViewSelectedDelegate <NSObject>

@optional
-(void)didSelectedFaceIndex:(NSInteger)index withFaceText:(NSString *)faceText withView:(FaceViews *)faceView;

-(void)didDeleteIconImageWithView:(FaceViews *)faceView;

-(void)didSenderMessageWithView:(FaceViews *)faceView;

@end

@interface FaceViews : UIView

//按钮的大小
@property (nonatomic,assign) CGSize butSize; //default (20.f, 20.0f);

@property (nonatomic,assign) id<FaceViewSelectedDelegate> delegate;

-(void)setFaceIconViews;

@end
