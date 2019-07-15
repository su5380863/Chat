//
//  CircleImage.h
//  Chat
//
//  Created by su_fyu on 15/5/26.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  圆形图片

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CircleImage : UIImageView

@property (nonatomic) BOOL isShowCorner; //是否切圆角 default yes

@property (nonatomic) CGFloat cornerRadius;

-(void)setImageWithImgStr1:(NSString *)str withSex:(NSString *)sex;

-(void)setImageUrl:(NSString *)url withSex:(NSString *)sex;
-(void)setImageWithImgStr1:(NSString *)str withSex:(NSString *)sex andWidth:(CGFloat)imgWidth;

-(void)setCicleImage:(UIImage *)image;

-(void)setImageUrl:(NSString *)url withDefaultImage:(NSString *)defaultImageStr;



@end
