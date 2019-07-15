//
//  NSString+Tools.m
//  Chat
//
//  Created by su_fyu on 2019/7/12.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import "NSString+Tools.h"
#import "NSString+UUID.h"


@implementation NSString (Tools)

#pragma mark --得到类型的文件名
+(NSString *)nameKeyByMessageMedia:(LoadType)type
{
    return [self nameKeyByMessageMedia:type withDuration:0];
}

#pragma mark --得到类型的文件名
+(NSString *)nameKeyByMessageMedia:(LoadType)type withDuration:(CGFloat)duration
{
    NSMutableString *nameKey = [NSMutableString string];
    
    NSString *uuid = [NSString uuidString12] ;
    
    NSString *suffix = [self getSuffixByType:type];
    
    NSString *durationStr = @"";
    if(duration > 0.001){
        
        durationStr = [NSString stringWithFormat:@"_%.0f_",duration];
        
    }
    
    NSString *name = @"";
   
    name = [NSString stringWithFormat:@"%@-%@%@%@",nameKey,uuid,durationStr,suffix];
   
    [nameKey appendString:name];
    
    return nameKey;
    
}


+(NSString *)getSuffixByType:(LoadType)type
{
    NSString *suffix = @"";
    switch (type) {
        case kTypeImg:
            
            break;
            
        case kTypeAudio:
            
            suffix = @".mp3";
            break;
        case kTypeMovie:
            suffix = @".mp4";
        default:
            break;
    }
    
    return suffix;
}

@end
