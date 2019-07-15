//
//  UUVoiceProgressShow.m
//  Chat
//
//  Created by lianggq on 15/6/28.
//  Copyright (c) 2015年 YHM. All rights reserved.
//

#import "UUVoiceProgressShow.h"
#import "UIColor+Utility.h"

@interface UUVoiceProgressShow()

@property (nonatomic,strong) UIView *voiceCanelView;
@property (nonatomic,strong) UIImageView *cancelImgV;

@property (nonatomic,strong) UIView *voiceshowView;
@property (nonatomic,strong) UIView *showBackView;
@property (nonatomic,strong) UIImageView *voiceImgV;
@property (nonatomic,strong) UIImageView *voiceImgAnimateV;

@property (nonatomic,strong) UILabel *tipMessageL;

@end

@implementation UUVoiceProgressShow

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self initPropertys];
        
        [self initComponents];
    }
    
    return self;
}


-(void)initPropertys
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4.f;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

-(void)initComponents
{
    //取消
    _voiceCanelView = [[UIView alloc] init];
    _voiceCanelView.backgroundColor = [UIColor clearColor];
    [self addSubview:_voiceCanelView];
    
    _cancelImgV = [[UIImageView alloc] init];
    _cancelImgV.image = [UIImage imageNamed:@"message_im_sound_cancel"];
    [_voiceCanelView addSubview:_cancelImgV];
    
    //显示
    _voiceshowView = [[UIView alloc] init];
    _voiceshowView.backgroundColor = [UIColor clearColor];
    [self addSubview:_voiceshowView];
    
    _showBackView = [[UIView alloc] init];
    _showBackView.backgroundColor = [UIColor clearColor];
    [_voiceshowView addSubview:_showBackView];

    
    _voiceImgV = [[UIImageView alloc] init];
    _voiceImgV.image = [UIImage imageNamed:@"message_im_sound_mic"];
    [_showBackView addSubview:_voiceImgV];
    
    _voiceImgAnimateV = [[UIImageView alloc] init];
    NSMutableArray *animiates = [[NSMutableArray alloc] initWithCapacity:6];
    for(int i = 1; i<=6; i++){
        
        NSString *imageName = [NSString stringWithFormat:@"message_im_sound_v%d",i];
        UIImage *img = [UIImage imageNamed:imageName];
        if(img){
            [animiates addObject:img];
        }
    }
    _voiceImgAnimateV.animationImages = animiates;
    _voiceImgAnimateV.animationDuration = 1.2;
    _voiceImgAnimateV.animationRepeatCount = 0;
    [_showBackView addSubview:_voiceImgAnimateV];
    
    //文字
    _tipMessageL = [[UILabel alloc] init];
    _tipMessageL.numberOfLines = 0;
    _tipMessageL.backgroundColor = [UIColor clearColor];
    _tipMessageL.font = [UIFont systemFontOfSize:14.f];
    _tipMessageL.textColor = [UIColor whiteColor];
    _tipMessageL.textAlignment = NSTextAlignmentCenter;
    _tipMessageL.layer.cornerRadius = 2.f;
    [self addSubview:_tipMessageL];
}


//松开取消
- (void)showCancelView
{
    [_voiceCanelView setHidden:NO];
    [_voiceshowView setHidden:YES];
    [self setMessageTip:@"松开手指 取消发送"];
    [_voiceImgAnimateV stopAnimating];
    _tipMessageL.backgroundColor = [UIColor hexRGB:0x9e0000];

}

//上划可取消
- (void)showVoiceView
{
    [_voiceCanelView setHidden:YES];
    [_voiceshowView setHidden:NO];
    [self setMessageTip:@"手指上划 取消发送"];
    [_voiceImgAnimateV startAnimating];
    _tipMessageL.backgroundColor = [UIColor clearColor];
}

- (void)setMessageTip:(NSString *)message
{
    _tipMessageL.text = message;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat panddingX = 10.f;
    CGFloat panddingY = 10.f;
    
    CGFloat viewH = 100.f;
    //
    _voiceCanelView.frame = CGRectMake(panddingX, panddingY, width - 2*panddingX, viewH);
    _cancelImgV.frame = CGRectMake(0.f, 0.f, 56,65);
    _cancelImgV.center = CGPointMake(CGRectGetWidth(_voiceCanelView.bounds)/2, CGRectGetHeight(_voiceCanelView.bounds)/2 );
    
    //
    _voiceshowView.frame = CGRectMake(panddingX, panddingY, width - 2*panddingX, viewH);
    _voiceImgV.frame = CGRectMake(0.f, 0.f, 44.f, 64.f);
    _voiceImgAnimateV.frame = CGRectMake(CGRectGetMaxX(_voiceImgV.frame) + panddingX, 2.f, 36.f, 62.f);
    _showBackView.frame = CGRectMake(0.f, 0.f, 80.f, 66.f);
    
    _showBackView.center = CGPointMake(CGRectGetWidth(_voiceshowView.bounds)/2, CGRectGetHeight(_voiceshowView.bounds)/2 );
    
    //
    CGFloat labH = 25.f;
    _tipMessageL.frame = CGRectMake(panddingX, height - labH - panddingY, width - 2* panddingX, labH);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
