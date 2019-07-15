//
//  DialogueBaseCell.m
//  Chat
//
//  Created by su_fyu on 16/1/5.
//  Copyright © 2016年 su_fyu. All rights reserved.
//  对话消息cell

#import "DialogueBaseCell.h"

@interface DialogueBaseCell()

@property (nonatomic, strong, readonly) UILabel *labelTime; //时间

@property (nonatomic, strong) UIView *statusView; //状态view
@property (nonatomic, strong) UIButton *statusBtn; //状态
@property (nonatomic, strong) UIActivityIndicatorView *statusIndictor;//状态标记

@end

@implementation DialogueBaseCell
@dynamic delegate;


#pragma mark --life circle
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self initComponents];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        [self initComponents];
        
    }
    
    return  self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _bgView.frame = self.contentView.bounds;
    
//    CGFloat width = CGRectGetWidth(self.contentView.bounds);
//    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    
    //内容布局
    CGRect contentFrame = _dialogContentView.frame;
    
    CGFloat contentX = 0.f;
    
    CGFloat contentW = CGRectGetWidth(_dialogContentView.bounds);
    CGFloat contentH = CGRectGetHeight(_dialogContentView.bounds);
    
    //状态frame
    CGFloat statusX = 0.f;
    //背景气泡图X坐标
    CGFloat sendbackX = 0.f;
    
    if([self isMyMessage]){ ///

        contentX = CGRectGetMinX(_headImage.frame) - ChatMargin/2 - CGRectGetWidth(contentFrame);
        
        statusX = 0.f;
        
        sendbackX = ChatStauteSize.width;
    
    }else{

        contentX = CGRectGetMaxX(_headImage.frame) + ChatMargin/2 ;
        
        statusX = contentW - ChatStauteSize.width;
        
        sendbackX = 0.f;
    }

    contentFrame.origin.x =contentX;
    _dialogContentView.frame = contentFrame;
    
    //状态
    _statusView.frame = CGRectMake(statusX, (contentH - ChatStauteSize.height)/2, ChatStauteSize.width, ChatStauteSize.height);
    
    CGFloat insetPadding = 5.f;
    _statusBtn.frame = CGRectInset(_statusView.bounds, insetPadding, insetPadding);
    _statusIndictor.frame = CGRectInset(_statusView.bounds, insetPadding/2, insetPadding/2);
    
    //气泡
    _sendBackBBView.frame = CGRectMake(sendbackX, 0.f, contentW - ChatStauteSize.width, contentH);
}

- (void)updateConstraints {
    
    [super updateConstraints];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --custom method
- (void)initComponents {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //背景view
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bgView];
    
    // 时间
    _labelTime = [[UILabel alloc] init];
    _labelTime.backgroundColor = [UIColor clearColor];
    _labelTime.textAlignment = NSTextAlignmentCenter;
    _labelTime.textColor = CUSTOMHEBCOLOR(0x9e9e9e);
    _labelTime.font = ChatTimeFont;
    [_bgView addSubview:_labelTime];
    
    //头像
    _headImage = [[CircleImage alloc] init];
    _headImage.userInteractionEnabled = YES;
    [_headImage setCicleImage:[UIImage imageNamed:@"head"]];
    _headImage.backgroundColor = [UIColor clearColor];
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView  addSubview:_headImage];
    
    //内容
    _dialogContentView = [[UIView alloc] init];
    _dialogContentView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_dialogContentView];
    
    //消息状态
    _statusView = [[UIView alloc] init];
    _statusView.backgroundColor = [UIColor clearColor];
    //
    _statusIndictor = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //
    _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusBtn.enabled = NO;
    _statusBtn.backgroundColor = [UIColor clearColor];
    
    [_dialogContentView addSubview:_statusView];
    [_statusView addSubview:_statusBtn];
    [_statusBtn addSubview:_statusIndictor];
    //重发
//    [_statusBtn addTarget:self action:@selector(reSendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    //背景气泡
    _sendBackBBView = [[UIImageView alloc] init];
    _sendBackBBView.backgroundColor = [UIColor clearColor];
    _sendBackBBView.userInteractionEnabled = YES;
    [_dialogContentView addSubview:_sendBackBBView];
    
}

#pragma mark --public
-(void)setMessageFrame:(UUMessageFrame *)messageFrame withIndex:(NSIndexPath *)indexPath withTable:(UITableView *)tableView {
    
    [super setMessageFrame:messageFrame withIndex:indexPath withTable:tableView];
    
    _messageFrame = messageFrame;
    
    UUMessage *message = messageFrame.message;
    
    NSString *sex = nil;
    
    UIImage *bbImg = nil; //气泡图
    //消息来源设置

    if([self isMyMessage]){
        
        
        bbImg = [UIImage imageNamed:@"message_im_chatf_r"];
        //        bbImg = [bbImg resizableImageWithCapInsets:UIEdgeInsetsMake(25, 30.f, 20.f, 30.f) resizingMode:UIImageResizingModeStretch];
        
    }else {
        
        //如果不是自己发得 状态直接为成功
    
        bbImg = [UIImage imageNamed:@"message_im_chatf_l"];
    }

    // 1、设置时间
    if(message.showDateLabel){ //显示时间
        self.labelTime.text =[NSDate getTimeShowByTimeSeconds:message.time withChinese:NO];
    }else{
        self.labelTime.text = @"";
    }
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    self.headImage.frame = messageFrame.iconF;
    
    self.headImage.image = [UIImage imageNamed:@"head"];
    self.headImage.layer.cornerRadius = ChatIconWH/2;
    
    
    //背景content
    self.dialogContentView.frame = messageFrame.contentF;
    
    self.sendBackBBView.image = bbImg;
    
    [self layoutIfNeeded];
}

- (BOOL)isMyMessage {
    
    return [_messageFrame.message isMine];
}

@end
