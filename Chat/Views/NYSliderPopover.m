//
//  NYSliderPopover.m
//  NYReader
//
//  Created by Cassius Pacheco on 21/12/12.
//  Copyright (c) 2012 Nyvra Software. All rights reserved.
//

#import "NYSliderPopover.h"

@implementation NYSliderPopover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self.popover class];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark -
#pragma mark UISlider methods

- (NYPopover *)popover
{
    if (_popover == nil) {
        //Default size, can be changed after
        [self addTarget:self action:@selector(updatePopoverFrame) forControlEvents:UIControlEventValueChanged];
        _popover = [[NYPopover alloc] init];
        [self updatePopoverFrame];
        
        _popover.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 36, 48, 36);
        [self addSubview:_popover];
        
    }
    
    return _popover;
}

- (void)setValue:(float)value
{
    [super setValue:value];
    
    [self updatePopoverFrame];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updatePopoverFrame];
    [self showPopoverAnimated:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self hidePopoverAnimated:YES];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self hidePopoverAnimated:YES];
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark -
#pragma mark - Popover methods

- (void)updatePopoverFrame
{
    //Inspired in Collin Ruffenach's ELCSlider https://github.com/elc/ELCSlider/blob/master/ELCSlider/ELCSlider.m#L53
    
    int valueInt = self.value;
    
    self.popover.textLabel.text = [NSString stringWithFormat:@"%zi", valueInt];
	
    CGRect thumbRect = [self thumbRect];
    
    CGRect conver = thumbRect;
    
    CGFloat centerX = (CGRectGetMinX(conver) + CGRectGetMaxX(conver)) /2;
    
    CGRect popoverRect = self.popover.frame;

    popoverRect.origin.y = thumbRect.origin.y - popoverRect.size.height ;
    self.popover.frame = popoverRect;
    
    
    CGPoint center = self.popover.center;
    center.x = centerX;
    self.popover.center = center;
}

- (CGRect)thumbRect
{
    return [self thumbRectForBounds:self.bounds
                          trackRect:[self trackRectForBounds:self.bounds]
                              value:self.value];
}

- (void)showPopover
{
    [self showPopoverAnimated:NO];
}

- (void)showPopoverAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 1.0;
        }];
    } else {
        self.popover.alpha = 1.0;
    }
}

- (void)hidePopover
{
    [self hidePopoverAnimated:NO];
}

- (void)hidePopoverAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 0;
        }];
    } else {
        self.popover.alpha = 0;
    }
}

@end
