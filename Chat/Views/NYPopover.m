//
//  NYPopover.m
//  NYReader
//
//  Created by Cassius Pacheco on 21/12/12.
//  Copyright (c) 2012 Nyvra Software. All rights reserved.
//

#import "NYPopover.h"

@implementation NYPopover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initComponets];
    }
    
    return self;
}

- (void)initComponets
{
    
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.image = [UIImage imageNamed:@"message_im_pricerange"];//24 * 32
    [self addSubview:_imgView];
    
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont boldSystemFontOfSize:11];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = YES;
    
    [_imgView addSubview:_textLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    
    CGFloat imgW = 24.f;
    CGFloat imgH = 32.f;
    
    _imgView.frame = CGRectMake((width - imgW)/2, 0.f, imgW, imgH);
    //
    CGFloat textY = -2.0f;
    _textLabel.frame = CGRectMake(0.f, textY, imgW, imgH);
    
}

@end
