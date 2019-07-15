//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PhotesBrows.h"
#import "UUChatHearder.h"

#define UUInputView_DefaultHeight   45
#define UUEdageY   (kIs_iPhoneX ? 34 : 0)

@class UUInputFunctionView;
@protocol UUInputFunctionViewDelegate <NSObject>

@optional
// 文字
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message;

// 单个image
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image;

// 音频
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(CGFloat)second;

//多选照片
-(void)UUInputFunctionView:(UUInputFunctionView *)funcView sendAssets:(NSArray *)assets;

//取消
-(void)UUInputFunctionViewDidPhotosCancel:(UUInputFunctionView *)funcView;

//改变frame
-(void)UUInputFunctionViewChangeFrame:(UUInputFunctionView *)funcView animate:(BOOL)anmate;

@end

@interface UUInputFunctionView : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) UIButton *btnSendMessage; //发送消息
@property (nonatomic, retain) UIButton *btnChangeVoiceState;//语音按钮
@property (nonatomic, retain) UIButton *btnVoiceRecord; //录音按钮
@property (nonatomic, retain) UITextView *TextViewInput;

@property (nonatomic, retain) UIButton *faceBtn;//表情按钮

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, weak) UIViewController *superVC;

@property (nonatomic, weak) id<UUInputFunctionViewDelegate>delegate;

- (id)initWithSuperVC:(UIViewController *)superVC;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

- (void)resignFirstResponderText;
- (void)cancelVoiceRecordIfNeed;

- (void)addNotifications;
- (void)removeNotications;

@end
