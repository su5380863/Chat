//
//  ShowMessageLabelView.m
//  Chat
//
//  Created by su_fyu on 15/6/3.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//


#import "AppDelegate.h"s

#define errorLabelWidth     150
#define errorLabelHeight    30

@implementation ShowMessageLabelView

static ShowMessageLabelView *toast = nil;

+ (id)getToast{
    @synchronized(self){
        if(toast == nil){
            toast = [[[self class] alloc] initWithFrame:CGRectZero superController:AppRootViewController];
        }
        return toast;
    }
}

+ (void)destroyToast {
    @synchronized(self){
        toast = nil;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorLabelWidth, errorLabelHeight)];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.backgroundColor = [UIColor hexRGB:0x434343];
        errorLabel.alpha = 1.0;
        errorLabel.layer.masksToBounds = YES;
        errorLabel.layer.cornerRadius = 4;
        errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        errorLabel.numberOfLines = 100;
        errorLabel.textColor = [UIColor whiteColor];
        errorLabel.font = [UIFont systemFontOfSize:14];
        _showTime = 3.0;
        [self addSubview:errorLabel];
        
        self.veryticalType = ShowMessageTypeVerticalDown;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame superController:(UIViewController*)superController
{
    self = [self initWithFrame:frame];
    if (self)
    {
        
        for(UIView *view in superController.view.subviews)
        {
            if([view isKindOfClass:[ShowMessageLabelView class]])
            {
                
                [((ShowMessageLabelView *)view).timeSlice invalidate];
                [view removeFromSuperview];
                break;
            }
        }
        // Initialization code
    }
    return self;
}

- (void)setLabeldescribe:(UILabel *)labelStr
{
    CGSize size = CGSizeMake(300, 10000);
    CGSize labelSize = [labelStr.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelStr.font} context:nil].size;
    CGRect frame;
    CGFloat heightPadding = 10.f;
    switch (_veryticalType) {
        case ShowMessageTypeVerticalUp:
            frame = CGRectMake(0, 135, kApplicationFrameWidth, labelSize.height + heightPadding);
            
            break;
        case ShowMessageTypeVerticalMiddle:
            
            frame = CGRectMake(0, kApplicationFrameHeight/2, kApplicationFrameWidth, labelSize.height + heightPadding);
            
            break;
        case ShowMessageTypeVerticalDown:
        default:
            
            frame = CGRectMake(0, kApplicationFrameHeight - 135, kApplicationFrameWidth, labelSize.height + heightPadding);
            
            break;
    }
    
    self.frame = frame;
    
    
    labelStr.frame = CGRectMake((self.frame.size.width - labelSize.width - 15) / 2, 0,
                                labelSize.width + 15, labelSize.height + heightPadding);
}


- (void)setErrorText:(NSString *)str
{
    errorLabel.text = str;
    if (str==nil || str.length == 0) {
        errorLabel.hidden = YES;
        return;
    }
    [self setLabeldescribe:errorLabel];
    self.timeSlice = [NSTimer scheduledTimerWithTimeInterval:_showTime target:self selector:@selector(delayRemove:) userInfo:nil repeats:NO];
}

- (void)delayRemove:(id)sender
{
    
    [self removeFromSuperview];
    //   [self release];
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark --MLeak
- (BOOL)willDealloc {

    return NO;
}

@end
