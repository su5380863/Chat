//
//  UUChatHearder.h
//  Chat
//
//  Created by su_fyu on 15/5/27.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#pragma mark /-----消息keys设置-----------/

#define UUMessageTime       @"time"         //消息时间
#define UUMessageName       @"user_name"     //用户名称
#define UUMessageUserIcon   @"img"          //头像
#define UUMessageUserID     @"from_client_id"       //用户id
#define UUMessageTo_UserID  @"to_client_id"     //消息接受人
#define UUMessageContent    @"content"      //消息内容
#define UUMessageVoiceTime  @"duration"     //语音时长
#define UUMessageId         @"id"           //消息id


#define UUMessageType       @"mediaType"         //消息类型
#define UUMessageFrom       @"messagefrom"         //消息来源
#define UUMessageLocal_soucre   @"local_soucre" //本地资源路径

#pragma mark /-----消息view 高宽设置-----------/

#define ChatMargin 10       //间隔
#define ChatIconWH 44       //头像宽高height、width
#define ChatPicWH 100       //图片宽高
#define ChatPichH 166
#define ChatPicPaddingY 10.f //图片top值
#define ChatContentW [UIScreen mainScreen].bounds.size.width - 70*2    //内容宽度

#define ChatStauteSize      CGSizeMake(30.f,30.f) //消息状态size

#define ChatTimeMarginW 15  //时间文本与边框间隔宽度方向
#define ChatTimeMarginH 10  //时间文本与边框间隔高度方向

#define ChatContentTop 10   //文本内容与按钮上边缘间隔
#define ChatContentLeft 15  //文本内容与按钮左边缘间隔
#define ChatContentBottom 10 //文本内容与按钮下边缘间隔
#define ChatContentRight 9 //文本内容与按钮右边缘间隔

#define ChatTimeFont [UIFont systemFontOfSize:11]   //时间字体
#define ChatContentFont [UIFont systemFontOfSize:16]//内容字体

#define VoicePlayHasInterrupt           @"voicePlayHasInterrupt" //语音打断通知
#define VoicePlayMessageFinish          @"voicePlayMessageFinish" //语音播放结束通知

typedef NS_ENUM(NSInteger, UUMessageEnumType) { //消息发送格式
    UUMessageTypeText     = 0,  // 文字
    UUMessageTypePicture  = 1,  // 图片
    UUMessageTypeVoice    = 2 ,  // 语音
};

typedef NS_ENUM(NSInteger, UUMessageEnumFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};
