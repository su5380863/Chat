//
//  BaseMessageCell.m
//  Chat
//
//  Created by su_fyu on 16/1/5.
//  Copyright © 2016年 su_fyu. All rights reserved.
//  消息聊天cell的基类

#import "BaseMessageCell.h"

#import "DialogTextCell.h"
#import "DialogImageCell.h"
#import "DialogVoiceCell.h"

@implementation BaseMessageCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.contentView.backgroundColor = [UIColor hexRGB:0xeeeeee];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints {
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

- (void)dealloc {
    
    NSLog(@"class self name = %@",NSStringFromClass([self class]));
}

#pragma mark --publick
-(void)setMessageFrame:(UUMessageFrame *)messageFrame withIndex:(NSIndexPath *)indexPath withTable:(UITableView *)tableView {
    
    _aIndexPath = indexPath;
    
    _messageType = messageFrame.message.type;
}

#pragma mark ---cell
+ (BaseMessageCell *)tableView:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath
             messageType:(UUMessageEnumType )messageType {
    
    if(messageType == UUMessageTypeText){ //文本
        
        return [self textCellForTableView:tableView cellForRowAtIndexPath:indexPath ];
        
    }else if (messageType == UUMessageTypePicture) { //图片
        
        return [self imageCellForTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else if (messageType == UUMessageTypeVoice) {  //语音
        
        return [self voiceCellIdCellForTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }
    //默认文本
    return [self textCellForTableView:tableView cellForRowAtIndexPath:indexPath ];
}

#pragma mark --文本
+ (DialogTextCell *)textCellForTableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *textCellId = @"dialogTextCellId";
    
    DialogTextCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellId];
    
    if (cell == nil) {
        
        cell = [[DialogTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellId];
    }
    
    return cell;
}

#pragma mark --图片
+ (DialogImageCell *)imageCellForTableView:(UITableView *)tableView
                   cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *imageCellId = @"dialogImageCellId";
    
    DialogImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellId];
    
    if (cell == nil) {
        
        cell = [[DialogImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellId];
    }
    
    return cell;
}

#pragma mark --语音
+ (DialogVoiceCell *)voiceCellIdCellForTableView:(UITableView *)tableView
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *voiceCellId = @"dialogVoiceCellId";
    
    DialogVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:voiceCellId];
    
    if (cell == nil) {
        
        cell = [[DialogVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceCellId];
    }
    
    return cell;
}

@end
