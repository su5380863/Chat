//
//  CircleImage.m
//  Chat
//
//  Created by su_fyu on 15/5/26.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  圆形图片

#import "CircleImage.h"
#import "AppDelegate.h"

@interface CircleImage()

@property (atomic,retain) UIImage *originImg;

@end

@implementation CircleImage


#pragma mark --life circle
-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        [self initproperys];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    
    CGFloat size = MIN(CGRectGetHeight(frame), CGRectGetWidth(frame));
    frame.size.height = size;
    frame.size.width = size;
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self initproperys];
    }
    
    return self;
}

-(void)initproperys
{
    _isShowCorner = NO;
    _cornerRadius = 4;
    
//    self.layer.masksToBounds = YES;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawImage];

}

- (void)drawImage {
    
    CGRect rect = self.bounds;
    
    CGFloat heigth = CGRectGetHeight(rect);
    CGFloat width = CGRectGetWidth(rect);
    
    if(heigth > 0 && width >0) {
        
        if(self.originImg){
            
            __weak __typeof(self) weakSelf = self;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
                
                UIImage *image =  [weakSelf scaleToSize:rect.size withImage:weakSelf.originImg]; //weakSelf.originImg;
                
                CGFloat size = MIN(heigth, width);
                
                CGFloat corner = 0.f;
                
                if(_isShowCorner || _cornerRadius){
                    
                    corner = _cornerRadius?_cornerRadius:size/2;
                }
                
                CGContextAddPath(UIGraphicsGetCurrentContext(),
                                 [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner].CGPath);
                CGContextClip(UIGraphicsGetCurrentContext());
                
                [image drawInRect:rect];
                
                UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [super setImage:outImage];
                });
            });
        }
    }
}

- (UIImage*)scaleToSize:(CGSize)size withImage:(UIImage *)image
{
    if(!image){
        
        return nil;
    }
    
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;
    float radio = 1;
    if (verticalRadio > 1 && horizontalRadio > 1) {
        radio = verticalRadio < horizontalRadio ? horizontalRadio : verticalRadio;
    } else {
        radio = verticalRadio > horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width * radio;
    height = height * radio;
    
    int xPos = (size.width - width) / 2;
    int yPos = (size.height - height) / 2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}




#pragma mark -- public
- (void)setImage:(UIImage *)image {
    
    self.originImg = image;
    
    [self setNeedsLayout];
    
}

- (void)setCicleImage:(UIImage *)image {
    self.originImg = image;
    
    [self setNeedsLayout];
}

-(void)setImageUrl:(NSString *)url withDefaultImage:(NSString *)defaultImageStr
{
    UIImage *holdImage;
    if (defaultImageStr && defaultImageStr.length > 0) {
        holdImage = [UIImage imageNamed:defaultImageStr];
    }
    
}

@end
