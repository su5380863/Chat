//
//  UUMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "MatchParser.h"

@implementation UUMessageFrame

- (void)setMessage:(UUMessage *)message{
    
    _message = message;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    _timeF = CGRectMake(0.f, 0.f, 0.f, 0.f);
    // 1、计算时间的位置
    if (_showTime){
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [_message.time sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];

        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
    }
    
    // 2、计算头像位置
    CGFloat iconX = ChatMargin;
    if (_message.from == UUMessageFromMe) {
        iconX = screenW - ChatMargin - ChatIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + ChatMargin;
    _iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX, iconY+ChatMargin, ChatIconWH, 20);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF)+ChatMargin;
    CGFloat contentY = iconY + 1.5f;
   
    //根据种类分
    CGSize contentSize;
    
    //_qaSize = CGSizeMake(0.f, 0.f);
    _extraHeight = 0.f;
    
    switch (_message.type) {
       
        case UUMessageTypeText:
            
            contentSize = [self getContentTextSize];
 
            break;
        case UUMessageTypePicture:
            
            if(_message.content){
                
                NSString *path = [ChatTools getCachePathByFold:UUImageFileCache withFileName:message.content];
                NSURL *fileUrl = [NSURL fileURLWithPath:path];
                NSData *data = [[NSData alloc] initWithContentsOfURL:fileUrl];
                if(data){
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    CGSize imgViewSize = [[self class] currentImage:image withViewSize:CGSizeMake(ChatPicWH, ChatPichH)];
                    
                    contentSize = imgViewSize;
                }else{
                   contentSize = CGSizeMake(ChatPicWH, ChatPichH);
                }

            }else{
                contentSize = CGSizeMake(ChatPicWH, ChatPichH);
            }
            
            break;
        case UUMessageTypeVoice:
            contentSize = CGSizeMake(120, 20);
            break;
            
      
//        case UUMessageTypeTruthResult:
//
//            contentSize = CGSizeMake(216.f - (ChatContentLeft + ChatContentRight ) + ChatStauteSize.width, 80 - (ChatContentTop + ChatContentBottom));
//            // 结果显示宽度为160 + 2 *ChatStauteSize.width， 高度为60
//
//            break;
        default:
            contentSize = [self getContentTextSize];
            break;
    }
    
    CGFloat contentFWidth = contentSize.width + ChatContentLeft + ChatContentRight + ChatStauteSize.width; //内容长度
    
    if (_message.from == UUMessageFromMe) {
        contentX = iconX - contentFWidth;
    }
    
    self.contentF = CGRectMake(contentX, contentY, contentFWidth, contentSize.height + ChatContentTop + ChatContentBottom);
}

#pragma mark --得到文本高度
-(CGSize)getContentTextSize
{
    
    NSString *text = [_message showMessage];
    
    NSString *soucre = [[self class] getNewTextBy:text];
    
    CGSize textSize =[soucre labelSizeWithWidth:ChatContentW font:ChatContentFont];
    if(IOS9){
        textSize.width +=4;
    }
    
    textSize.width = textSize.width > ChatContentW ? ChatContentW:textSize.width;

    MatchParser * match=[[MatchParser alloc]init];
    match.urlLink =NO;
    match.phoneLink = NO;
    match.mobieLink = NO;
    match.nameLink = NO;
    match.font = ChatContentFont;  //self.font;
    
    match.iconSize = ChatContentFont.pointSize + IconSize_Match_ExtraSize;
    
    match.width = textSize.width;
    
    [match match:soucre];
    
    textSize.height = match.height ;
    
    return textSize;
}

+(NSString *)getNewTextBy:(NSString *)source
{
    NSMutableString * text=[[NSMutableString alloc]init];
    
    static NSRegularExpression * regular = nil;
    
    if(regular == nil){
        
        regular=[[NSRegularExpression alloc]initWithPattern:MatchImage_Regular options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    }
    
    NSArray * array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    
    NSInteger location=0;
    NSInteger count=[array count];
    for(int i=0;i<count;i++){
        NSTextCheckingResult * result=[array objectAtIndex:i];
        NSString * string=[source substringWithRange:result.range];
        NSString * icon=[MatchParser faceKeyForValue:string map:[MatchParser getFaceMap]];
        [text appendString:[source substringWithRange:NSMakeRange(location, result.range.location-location)]];
        if(icon!=nil){
            [text appendString:@"     "]; //表情内容用5个空格替换
        }else{
            [text appendString:string];
        }
        location=result.range.location+result.range.length;
    }
    
    [text appendString:[source substringWithRange:NSMakeRange(location, [source length]-location)]];
    
    return text;
}


-(void)setContentF:(CGRect)contentF
{
    _contentF = contentF;
    
    _chatCellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF)) + _extraHeight + MessageCellsSpaceing ;
}


#pragma mark --通过图片大小 等比返回适合view大小
+(CGSize)currentImage:(UIImage *)image withViewSize:(CGSize)viewSize
{
    if(!image) return viewSize;
    
    CGSize imgSize = image.size;
    
    CGSize imgViewSize = CGSizeMake(ChatPicWH, ChatPichH);
    
    if(imgSize.height < imgViewSize.height && imgSize.width < imgViewSize.width){
        
        imgViewSize = imgSize;
        
    }else{
        
        
        CGFloat imgW = imgSize.width;
        CGFloat imgH = imgSize.height;
        
        CGFloat salceW = imgViewSize.width / imgW;
        CGFloat salceH = imgViewSize.height / imgH;
        
        CGFloat sacle = MIN(salceH, salceW);
        
        imgW = imgW * sacle;
        imgH = imgH * sacle;
        
        imgViewSize.width = imgW;
        imgViewSize.height = imgH;
    }
    
    CGSize contentSize = imgViewSize;
    
    return contentSize;
    
}


@end
