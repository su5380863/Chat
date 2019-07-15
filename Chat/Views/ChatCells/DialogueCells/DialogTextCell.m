//
//  DialogTextCell.m
//  Chat
//
//  Created by su_fyu on 16/1/5.
//  Copyright © 2016年 su_fyu. All rights reserved.
//  文本消息

#import "DialogTextCell.h"
#import "NSString+StringCheck.h"
#import "AppDelegate.h"

@interface DialogTextCell()<HBCoreLabelDelegate,UIActionSheetDelegate>

@property (nonatomic, strong,readonly) HBCoreLabel *textLab;

@property (nonatomic,copy) NSString *linkString; //点击返回的内容

@end

@implementation DialogTextCell

#pragma mark -- lift override
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        [self initTextComponents];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat sendbackWidth = CGRectGetWidth(self.sendBackBBView.bounds);
    CGFloat sendbackHeight = CGRectGetHeight(self.sendBackBBView.bounds);
    
    //文字
    CGFloat paddingLeft = ChatContentLeft; //左边距 背景图 左右边距
    CGFloat paddingRight = ChatContentRight; //右边距
    
    if([self isMyMessage]){ //交换过来
        
        CGFloat temp = paddingLeft;
        paddingLeft = paddingRight;
        paddingRight = temp;
    }
    
    CGFloat paddingTextY = ChatContentTop;//高间距
    
    CGRect textFrame = CGRectMake(paddingLeft, paddingTextY, sendbackWidth - paddingLeft - paddingRight , sendbackHeight - ChatContentTop - ChatContentBottom);
    
    _textLab.frame = textFrame;

}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark --custom methods
- (void)initTextComponents {
    
    _textLab = [[HBCoreLabel alloc] init];
    _textLab.delegate = self;
    _textLab.backgroundColor = [UIColor clearColor];
    _textLab.font = ChatContentFont;
    _textLab.userInteractionEnabled = YES;
    [_textLab registerCopyAction];
    [self.sendBackBBView addSubview:_textLab];
}

#pragma mark -- override func
- (void)setMessageFrame:(UUMessageFrame *)messageFrame withIndex:(NSIndexPath *)indexPath withTable:(UITableView *)tableView {
    
    [super setMessageFrame:messageFrame withIndex:indexPath withTable:tableView];
    
    if([self isMyMessage]){
        _textLab.textColor = [UIColor whiteColor];
    }else {
        _textLab.textColor = CUSTOMHEBCOLOR(0x424242);
    }
    
    UUMessage *message = self.messageFrame.message;
    
    NSString *showmessage = message.content;
    
    BOOL isOther = ![self isMyMessage];
    //别人发的才显示关键字 + 10000号官方
    
    CGRect textFrame = _textLab.frame; //先重置宽度解决重用时宽度来不及改变bug
    textFrame.size.width = self.messageFrame.contentF.size.width - ChatContentLeft - ChatContentRight - ChatStauteSize.width;
    _textLab.frame = textFrame;
    
    [_textLab setSoucreText:showmessage withUserId:message.from_client_id withSpeacel:isOther];
}

#pragma mark --HBLabelDelegate
-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    
    [[UIApplication sharedApplication] openURL:url];
    
}
-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr
{
    _linkString = linkStr;
    
    [self showActionSheet];
}
-(void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr
{
    _linkString = linkStr;
    
    [self showActionSheet];
}


#pragma mark ----------- actionSheet
-(void)showActionSheet
{
    NSLog(@"linstr = %@",_linkString) ;
    
    UIActionSheet * action =[[UIActionSheet alloc]initWithTitle:_linkString
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"复制", nil];
    
    if([_linkString isPhone]){
        
        [action addButtonWithTitle:@"通话"];
        
    }
    
    [action showInView:AppLicationWindow];
    
}

#pragma mark actionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){ //复制
        
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = _linkString;
        
    }else if(buttonIndex == 1){ //取消
        
    }else if (buttonIndex ==2){ //通话
        
        NSString *telePhone = [NSString stringWithFormat:@"tel://%@",_linkString];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telePhone]];
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
