//
//  ShowMessageLabelView.h
//  Chat
//
//  Created by su_fyu on 15/6/3.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger
{
    ShowMessageTypeVerticalUp = 0,   //上部
    ShowMessageTypeVerticalMiddle = 1,   //中间
    ShowMessageTypeVerticalDown = 2      //下部
    
}ShowMessageTypeVertical; //发送消息状态

@interface ShowMessageLabelView : UIView

{
    UILabel *errorLabel;
}

+ (id)getToast;
+ (void)destroyToast;

- (void)setErrorText:(NSString *)str;
- (id)initWithFrame:(CGRect)frame superController:(UIViewController*)superController;

@property (nonatomic) ShowMessageTypeVertical veryticalType;

@property (nonatomic,strong) NSTimer *timeSlice;

@property (nonatomic, assign) CGFloat showTime;



@end
