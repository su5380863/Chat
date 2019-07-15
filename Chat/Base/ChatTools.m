//
//  ChatTools.m
//  Chat
//
//  Created by su_fyu on 2019/6/30.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import "ChatTools.h"
#import "NSString+StringCheck.h"

@implementation ChatTools

#pragma mark --得到cache文件路径
+(NSString *)getCachePathByFold:(NSString *)foldName withFileName:(NSString *)fileName
{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString *fileCachepath = [cacheDir stringByAppendingPathComponent:foldName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager]; //得到文件管理器
    
    if (![fileManager fileExistsAtPath:fileCachepath]) {
        //创建缓存文件夹
        if(![fileManager createDirectoryAtPath:fileCachepath withIntermediateDirectories:YES attributes:nil error:NULL]){
            
            
        }
    }
    NSString *filePath = [fileCachepath stringByAppendingPathComponent:fileName];
    
    return filePath;
}


+(ShowMessageLabelView *)showLabelView :(NSString *) message
                              rootView :(UIView *) rootView
                       superController :(UIViewController *) superController
{
    return [self showLabelView:message rootView:rootView superController:superController showTypeVert:ShowMessageTypeVerticalMiddle];
    
}

+ (ShowMessageLabelView *)showLabelView :(NSString *) message
                               rootView :(UIView *) rootView
                        superController :(UIViewController *) superController
                           showTypeVert :(ShowMessageTypeVertical)showTypeVert
{
    ShowMessageLabelView *showView = [ShowMessageLabelView getToast];
    showView.veryticalType = showTypeVert;
    [showView setErrorText:message];
    [rootView addSubview:showView];
    return showView;
}

+(NSString * )validString:(id)string
{
    
    if(!string) return @"";
    
    if([string isKindOfClass:[NSNull class]]){
        return @"";
    }
    
    NSString *returnStr = nil;
    if([string isKindOfClass:[NSString class]]){
        returnStr = string;
    }else{
        returnStr = [NSString stringWithFormat:@"%@",string];
    }
    
    if([returnStr isNullStr]){
        
        return @"";
    }
    
    return returnStr;
    
}

@end
