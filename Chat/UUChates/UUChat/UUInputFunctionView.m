//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputFunctionView.h"
#import "Mp3Recorder.h"
//#import "UUProgressHUD.h"
#import "ACMacros.h"
#import "FaceViews.h"
#import "ChatMoreView.h"
#import "UUAVAudioPlayer.h"
#import "UUVoiceProgressShow.h"
#import "AppDelegate.h"

#define FaceViewSize    CGSizeMake(Main_Screen_Width,216.f)  //默认表情等其他高度
static CGFloat UUkeyAinima = 0.3; //动画时间

@interface UUInputFunctionView ()<UITextViewDelegate,Mp3RecorderDelegate,PhotesBrowsDelegate,FaceViewSelectedDelegate,ChatMoreViewDelegate>
{
    BOOL isbeginVoiceRecord; //是否在录音
    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;

    
    UIView *_otherBackView; //表情 相册等父视图
    FaceViews *_faceView;
    ChatMoreView *_moreView;

    PhotesBrows * photobrow; //相册选择器
    
    UUVoiceProgressShow *voiceShowView;
}

@property (nonatomic, assign) BOOL showOhter; //是否已展示表情或其他更多界面

@end

@implementation UUInputFunctionView

- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.superVC = superVC;
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(superVC.view.bounds)-UUInputView_DefaultHeight - UUEdageY, Main_Screen_Width, UUInputView_DefaultHeight);
    NSLog(@"UUEdageY=====%f",UUEdageY);
    self = [super initWithFrame:frame];
    if (self) {
        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
        self.backgroundColor = [UIColor whiteColor];
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"message_btn_function1_re"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //表情按钮
        _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_faceBtn setBackgroundImage:[UIImage imageNamed:@"message_btn_function2_re"] forState:UIControlStateNormal];
        [_faceBtn addTarget:self action:@selector(showFace:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_faceBtn];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"message_btn_function3_re"] forState:UIControlStateNormal];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];

        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.layer.cornerRadius = 2.f;
        self.btnVoiceRecord.layer.borderColor = CUSTOMHEBCOLOR(0xbdbdbd).CGColor;
        self.btnVoiceRecord.layer.borderWidth = 0.5f;
        [self.btnVoiceRecord setExclusiveTouch:YES];
        self.btnVoiceRecord.frame = CGRectMake(70, 5, Main_Screen_Width-70*2, 30);
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.btnVoiceRecord setBackgroundImage:[UIImage createImageWithColor:CUSTOMHEBCOLOR(0xbdbdbd)] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setBackgroundImage:[UIImage createImageWithColor:CUSTOMHEBCOLOR(0xbdbdbd)] forState:UIControlStateSelected];
        
        [self.btnVoiceRecord setTitleColor:CUSTOMHEBCOLOR(0xbdbdbd) forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:CUSTOMHEBCOLOR(0x424242) forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitleColor:CUSTOMHEBCOLOR(0x424242) forState:UIControlStateSelected];

        [self.btnVoiceRecord setTitle:@"按住说话" forState:UIControlStateNormal];
        
        //[self.btnVoiceRecord setTitle:@"松开接受" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        //[self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchDownRepeat];
        
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(45, 5, Main_Screen_Width-2*45, 30)];
        self.TextViewInput.backgroundColor = [UIColor whiteColor];
        self.TextViewInput.layoutManager.allowsNonContiguousLayout=NO;
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.font = [UIFont systemFontOfSize:14.f];
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.returnKeyType = UIReturnKeySend;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];

        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;

        //加载图文表情
        CGRect otherFrame = CGRectMake(0.f,_superVC.view.bounds.size.height , FaceViewSize.width, FaceViewSize.height); //其他view
        _otherBackView = [[UIView alloc] initWithFrame:otherFrame];
        _otherBackView.hidden = YES;
        _otherBackView.backgroundColor = [UIColor clearColor];
        [_superVC.view addSubview:_otherBackView];
        
        _faceView  = [[FaceViews alloc] initWithFrame:_otherBackView.bounds];
        _faceView.butSize = CGSizeMake(30.f, 30.f);
        [_faceView setFaceIconViews];
        _faceView.delegate = self;
        _faceView.hidden = YES;
        _faceView.backgroundColor = [UIColor whiteColor];
        [_otherBackView addSubview:_faceView];
        
        //更多功能
        _moreView = [[ChatMoreView alloc] initWithFrame:_otherBackView.bounds];
        _moreView.titleFontSize = 13.f;
        _moreView.backgroundColor = [UIColor whiteColor];
        [self initChatMoreView];
        [_otherBackView addSubview:_moreView];
        [self setHiddenOtherView];
        
        //语音显示
        voiceShowView = [[UUVoiceProgressShow alloc] initWithFrame:CGRectMake(0.f, 0.f, 160.f, 160.f)];
    }
    return self;
}

-(void)initChatMoreView
{
    _moreView.numberOfline = 4;
    _moreView.butSize = CGSizeMake(55, 55+ChatMoreTitle_height);
    _moreView.delegate = self;
    _moreView.hidden = YES;
    
    NSMutableArray *itemArr =[[NSMutableArray alloc] init];

    NSMutableDictionary *photo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [photo setObject:@"message_btn_more2" forKey:ChatMore_ImageNameKey];
    [photo setObject:@"相册" forKey:ChatMore_TitleKey];
    [itemArr addObject:photo];
    
    NSMutableDictionary *camera = [[NSMutableDictionary alloc] initWithCapacity:2];
    [camera setObject:@"message_btn_more3" forKey:ChatMore_ImageNameKey];
    [camera setObject:@"拍照" forKey:ChatMore_TitleKey];
    [itemArr addObject:camera];
    
    _moreView.itemArr = itemArr;
    
}

- (void)addNotifications
{
    //添加通知 sxl316093932
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)removeNotications
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 更多显示
-(void)showMoreChat:(UIButton *)sender
{

    if(!_faceView.hidden){
        
        _showOhter = NO;
        [_faceView setHidden:YES];
    }

    [self changeOtherViewShow:_moreView];
}

#pragma mark --表情图片显示
-(void)showFace:(UIButton *)sender
{
    if(!_moreView.hidden){
        
        _showOhter = NO;
        [_moreView setHidden:YES];
    }
    
    [self changeOtherViewShow:_faceView];
    
}

-(void)changeOtherViewShow:(UIView *)view
{
    if(!view) return;
    
    if(_showOhter){
        _otherBackView.hidden = YES;
        [_TextViewInput becomeFirstResponder];
        
        _showOhter = NO;
        
    }else{
        
        [view setHidden:NO];
        _otherBackView.hidden = NO;
        [_TextViewInput resignFirstResponder];
        [self textviewCanEdit];

        [UIView animateWithDuration:UUkeyAinima animations:^{
            _otherBackView.frame = CGRectMake(0.f,_superVC.view.bounds.size.height - FaceViewSize.height, FaceViewSize.width, FaceViewSize.height);
            
            CGFloat minY = CGRectGetMinY(_otherBackView.frame);
            
            CGRect putFrame = self.frame;
            
            putFrame.origin.y = minY - CGRectGetHeight(putFrame);
            
            self.frame = putFrame;
            
            if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionViewChangeFrame:animate:)]){
                
                [_delegate UUInputFunctionViewChangeFrame:self animate:YES];
            }
            
        }completion:^(BOOL finish){
            
            [view setHidden:NO];
            
            _showOhter = YES;
            
        }];
        
    }
}

#pragma mark - 录音touch事件
-(void)addVoiceProShow
{
    
    [AppLicationWindow addSubview:voiceShowView];
    voiceShowView.center = AppLicationWindow.center;
}

- (void)beginRecordVoice:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VoicePlayHasInterrupt object:nil];
    BOOL iscanRecor = [MP3 startRecord];
    if(!iscanRecor) {
        [button delayEnbable];
        return;
    }
    
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    
    [self addVoiceProShow];
    [voiceShowView showVoiceView];
}

- (void)endRecordVoice:(UIButton *)button
{
    button.selected = NO;
    [self removeVoiceProView];
    if (playTimer) {
        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    button.selected = NO;
    [self removeVoiceProView];
    if (playTimer) {
        [MP3 cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)RemindDragExit:(UIButton *)button
{
    button.selected = YES;
    if(!playTimer) return;
    [self addVoiceProShow];
    [voiceShowView showCancelView];
    NSLog(@"dragOut");
}

- (void)RemindDragEnter:(UIButton *)button
{
    button.selected = NO;
    if(!playTimer) return;
    [self addVoiceProShow];
    [voiceShowView showVoiceView];
    NSLog(@"dragin");
}


- (void)countVoiceTime
{
    playTime ++;
    
    if (playTime >= MaxVoiceTime) {
        [self endRecordVoice:nil];
    }
}

- (void)removeVoiceProView
{
    if(voiceShowView.superview){
        
        [voiceShowView removeFromSuperview];
    }
}

#pragma mark - Mp3RecorderDelegate

#pragma mark -- 回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    CGFloat duraion = [UUAVAudioPlayer getMP3DataTime:voiceData];
    
    [self.delegate UUInputFunctionView:self sendVoice:voiceData time:duraion];
    [self removeVoiceProView];
   
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)failRecord
{
    [self removeVoiceProView];
    [ChatTools showLabelView:@"语音太短" rootView:AppLicationWindow superController:AppRootViewController];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

#pragma mark -- 改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"message_btn_function4_re"] forState:UIControlStateNormal];
        _showOhter = YES;
        [self resignFirstResponderText];
        
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"message_btn_function3_re"] forState:UIControlStateNormal];
        [self.TextViewInput becomeFirstResponder];
        
        
    }
}

#pragma mark -- （文字图片 替换）
- (void)sendMessage:(UIButton *)sender
{
//    if (self.isAbleToSendTextMessage) {
//        
//        [self sendMessageText];
//        
//    }else{
//        
//        //[self resignFirstResponderText];
//        
//        [self showMoreChat:sender];
//
//    }
    
    [self showMoreChat:sender];
}

-(void)sendMessageText
{
    
    NSString *resultStr = [self.TextViewInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([resultStr isEqualToString:@""]){
        
        return;
        //resultStr = @" ";
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionView:sendMessage:)]){
        
        [_delegate UUInputFunctionView:self sendMessage:resultStr];
    }

}

#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _showOhter = NO;
    
    [self textviewCanEdit];
}

-(void)textviewCanEdit
{
    _TextViewInput.hidden = NO;
    self.btnVoiceRecord.hidden = YES;
    isbeginVoiceRecord = NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeFrameByString];
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{  //取消发送和选择
//    self.isAbleToSendTextMessage = !isPhoto;
//    [self.btnSendMessage setTitle:isPhoto?@"":@"发送" forState:UIControlStateNormal];
//    self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
//    UIImage *image = [UIImage imageNamed:isPhoto?@"message_btn_function1_re":@"chat_send_message"];
//    [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        
        [self sendMessageText];
        return NO;

    }
    
    return YES;
}


-(void)changeFrameByString
{
    NSString *text = _TextViewInput.text;
    
    [self changeSendBtnWithPhoto:text.length>0?NO:YES];
    
    CGFloat textHeight = [text labelSizeWithWidth:CGRectGetWidth(_TextViewInput.frame) - 20 font:_TextViewInput.font].height;
    if(textHeight >= UUInputView_DefaultHeight * 2 ){
        
         textHeight = UUInputView_DefaultHeight * 3 ;
    
    }else if (textHeight >= UUInputView_DefaultHeight * 0.8){
        
        textHeight = UUInputView_DefaultHeight * 2 ;
        
    }else{
        
        textHeight = UUInputView_DefaultHeight;
    }
    
    CGRect frame = self.frame;
    CGFloat uppingY = textHeight - CGRectGetHeight(frame);
    
    CGSize content=  _TextViewInput.contentSize;
    CGRect rect = _TextViewInput.bounds;
    CGRect visibRect = CGRectMake(0.f, content.height - CGRectGetHeight(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    [_TextViewInput scrollRectToVisible:visibRect animated:NO];

    if(uppingY == 0.f) return;
    
    [UIView animateWithDuration:UUkeyAinima animations:^{
        
        CGRect frameA = self.frame;
        frameA.origin.y -=uppingY;
        frameA.size.height = textHeight;
        self.frame = frameA;
        
        if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionViewChangeFrame:animate:)]){
            
            [_delegate UUInputFunctionViewChangeFrame:self animate:NO];
        }
        
        
    }completion:^(BOOL finish){
        
        [self layoutIfNeeded];
    }];
}

#pragma mark --
-(void)resignFirstResponderText
{
    
    CGFloat minY = CGRectGetMinY(self.frame);
    
    CGFloat vh = CGRectGetHeight(_superVC.view.bounds);
    
    CGFloat ext = vh - minY;
    
    if(ext <= UUInputView_DefaultHeight) return;
    
    //if(!_showOhter) return;
    _otherBackView.hidden = YES;
    if([_TextViewInput isFirstResponder]){
        
        _showOhter = YES;
        [_TextViewInput resignFirstResponder];
        
        if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionViewChangeFrame:animate:)]){
            
            
            [_delegate UUInputFunctionViewChangeFrame:self animate:YES];
        }
        
    }else{
        
        [self setHiddenOtherView];
        
        [UIView animateWithDuration:UUkeyAinima animations:^{
        
            CGRect frame = CGRectMake(0, Main_Screen_Height-UUInputView_DefaultHeight - UUEdageY, Main_Screen_Width, UUInputView_DefaultHeight);
            
            self.frame  = frame;
            
            if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionViewChangeFrame:animate:)]){
                
                
                [_delegate UUInputFunctionViewChangeFrame:self animate:NO];
            }
            
        }completion:^(BOOL finish){
            

            
        }];

        
        
        
    }
    
    _showOhter = NO;

}



#pragma mark --隐藏表情其他更多 视图view
-(void)setHiddenOtherView
{
    [_faceView setHidden:YES];
    [_moreView setHidden:YES];
    
    _otherBackView.frame = CGRectMake(0.f,_superVC.view.bounds.size.height , FaceViewSize.width, FaceViewSize.height);

    
}

#pragma mark keyBorad
#pragma mark --键盘弹出
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [self setHiddenOtherView];
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - UUEdageY;
    self.frame = newFrame;
    

}

-(void)keyboardWillHide:(NSNotification *)notification
{

    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [self setHiddenOtherView];
     
    if(_otherBackView.hidden){
        CGRect newFrame = self.frame;
        newFrame.size.height = UUInputView_DefaultHeight;
        
        newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - UUEdageY;

        self.frame = newFrame;
    }
    
    
}


#pragma mark - Add Picture

#pragma mark --PhotesBrowsDelegate
//拍照相册
-(void)didSelectCameraPicture:(UIImage *)cameraImage withBrows:(PhotesBrows *)brows
{
    if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionView:sendPicture:)]){
        
        [self.delegate UUInputFunctionView:self sendPicture:cameraImage];
        
    }
}

//照片多选
- (void)didFinishPickingAssets:(NSArray *)assets withBrows:(PhotesBrows *)brows
{
    if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionView:sendAssets:)]){
        
        [_delegate UUInputFunctionView:self sendAssets:assets];
        
    }
}

//取消
- (void)didCancelWithBrows:(PhotesBrows *)brows
{
    [self didPhotosCancel];
}

#pragma mark -- 相册取消
-(void)didPhotosCancel
{
    if(_delegate && [_delegate respondsToSelector:@selector(UUInputFunctionViewDidPhotosCancel:)]){
        
        [_delegate UUInputFunctionViewDidPhotosCancel:self];
        
    }
}

#pragma mark -faceViewDelegate
-(void)didSelectedFaceIndex:(NSInteger)index withFaceText:(NSString *)faceText withView:(FaceViews *)faceView
{
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:_TextViewInput.text];
    
    [text appendString:faceText];
    
    _TextViewInput.text = text;
    
    [self changeFrameByString];
}

-(void)didDeleteIconImageWithView:(FaceViews *)faceView
{
    NSString *text = _TextViewInput.text;
    
    if(text.length <1) return;
    
    NSString *subText = [text substringToIndex:text.length - 1];
    
    _TextViewInput.text = subText;
    
    [self changeFrameByString];
}

-(void)didSenderMessageWithView:(FaceViews *)faceView
{
    [self sendMessageText];
}

#pragma mark -chatMoreViewDelegate
-(void)didSelectedItem:(NSInteger)index forChatMoreView:(ChatMoreView *)view
{
    
    if(!photobrow){ //相册
        photobrow = [[PhotesBrows alloc] initWithViewController:_superVC withDelegate:self];
        
        photobrow.maxNumberOfPhotos = 1;
    }

    if (index ==0){ //相册
        
        [photobrow showPhotos];
        
    }
    else if(index == 1){ //拍照
        
        [photobrow showCarema];
        
    }
}

#pragma mark 布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat panddingY = 5.f; //top间距
    CGFloat btnSize = 30; //按钮大小
    CGFloat btnY = (UUInputView_DefaultHeight - btnSize) /2; //按钮top间距
    
    CGFloat panddingX = 5.f; //水平间距
    
    //相册
    _btnSendMessage.frame = CGRectMake(width-btnSize -panddingX, btnY, btnSize, btnSize);
    
    //表情按钮
    CGFloat _faceBtnX = CGRectGetMinX(_btnSendMessage.frame) -panddingX - btnSize;
    _faceBtn.frame = CGRectMake(_faceBtnX, btnY, btnSize, btnSize);

    //语音按钮
    _btnChangeVoiceState.frame = CGRectMake(panddingX, btnY, btnSize, btnSize);
    
    //输入框
    CGFloat textInputX = CGRectGetMaxX(_btnChangeVoiceState.frame) + panddingX;
    CGFloat textInputWidth = CGRectGetMinX(_faceBtn.frame) -panddingX - textInputX ;
    _TextViewInput.frame = CGRectMake(textInputX,panddingY , textInputWidth, height - 2 * panddingY);
    
    //语音录入键
    _btnVoiceRecord.frame = _TextViewInput.frame;
    
}

#pragma mark --dealloc
-(void)destroyTimer
{
    if(playTimer){
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelVoiceRecordIfNeed
{
    [MP3 cancelRecordIfNeed];
}

-(void)dealloc{
    
    [self destroyTimer];
    [self removeVoiceProView];
    [self removeNotications];
}

@end
