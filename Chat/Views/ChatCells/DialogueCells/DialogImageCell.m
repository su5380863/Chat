//
//  DialogImageCell.m
//  Chat
//
//  Created by su_fyu on 16/1/6.
//  Copyright © 2016年 su_fyu. All rights reserved.
//  图片消息cell

#import "DialogImageCell.h"

@interface DialogImageCell()

@property (nonatomic, strong) UIImageView *messageImageView;// imgae图片

@property (nonatomic, strong) UILabel *destroyLabel; //阅后即焚Label;

@property (nonatomic, strong) UIActivityIndicatorView *imageIndictor; //加载状态

@end

@implementation DialogImageCell

#pragma mark -- lift override
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        [self initImageComponents];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat sendbackWidth = CGRectGetWidth(self.sendBackBBView.bounds);
    CGFloat sendbackHeight = CGRectGetHeight(self.sendBackBBView.bounds);
    
    CGFloat imageCenter = -6.f; //背景图片的空白长度
    
    if([self isMyMessage]){ //交换过来
        imageCenter = -imageCenter;
    }
    
    //图片
    CGRect imgFrame = CGRectMake(0.f, 0.f, sendbackWidth - ChatContentLeft -ChatContentRight, sendbackHeight - 2 * ChatPicPaddingY);
    _messageImageView.frame = imgFrame;
    _messageImageView.center = CGPointMake(sendbackWidth/2 - imageCenter/2, sendbackHeight/2);
    
    _imageIndictor.center = _messageImageView.center;
    
    _destroyLabel.frame = _messageImageView.bounds;
    
}

#pragma mark --override
- (void)setMessageFrame:(UUMessageFrame *)messageFrame withIndex:(NSIndexPath *)indexPath withTable:(UITableView *)tableView {
    
    [super setMessageFrame:messageFrame withIndex:indexPath withTable:tableView];
    
    UUMessage *message = self.messageFrame.message;
    
    NSData *data = nil;
    //本地查找缓存
        
    NSString *path = [ChatTools getCachePathByFold:UUImageFileCache withFileName:message.content];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    data = [[NSData alloc] initWithContentsOfURL:fileUrl];
    UIImage *image = [[UIImage alloc] initWithData:data];
    _messageImageView.image = image;
    
}

#pragma mark --custom methods
- (void)initImageComponents {
    //图片
    _messageImageView = [[UIImageView alloc]init];
    _messageImageView.userInteractionEnabled = YES;
    _messageImageView.layer.cornerRadius = 5;
    _messageImageView.clipsToBounds  = YES;
    _messageImageView.contentMode =UIViewContentModeScaleAspectFit   ;
    _messageImageView.backgroundColor = [UIColor clearColor];
    //阅后即焚提示
    _destroyLabel = [[UILabel alloc] init];
    _destroyLabel.textAlignment = NSTextAlignmentCenter;
    _destroyLabel.numberOfLines = 0;
    _destroyLabel.font = [UIFont systemFontOfSize:14.f];
    
    [_messageImageView addSubview:_destroyLabel];
    [self.sendBackBBView addSubview:_messageImageView];
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
    imgTap.numberOfTapsRequired = 1;
    imgTap.numberOfTouchesRequired = 1;
    [_messageImageView addGestureRecognizer:imgTap];
    
    _imageIndictor = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.sendBackBBView addSubview:_imageIndictor];
}

#pragma mark --图片点击事件
- (void)imgClick:(UITapGestureRecognizer *)tapGesture {
    
    UUMessage *message = self.messageFrame.message;
    
    NSString *imageKey = message.content; //[NSString stringWithFormat:@"%@%@",SDomainMuaiImage ,message.content];
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        [[(UIViewController *)self.delegate view] endEditing:YES];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dialogImageCellDidClick:imageKey:withIndexPath:)]){
        
        [self.delegate dialogImageCellDidClick:self imageKey:imageKey withIndexPath:self.aIndexPath];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
