//
//  ChatTools.h
//  Chat
//
//  Created by su_fyu on 2019/6/30.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShowMessageLabelView.h"
@interface ChatTools : NSObject

#pragma mark - 提示内容 toast
+(ShowMessageLabelView *)showLabelView :(NSString *) message
                               rootView :(UIView *) rootView
                        superController :(UIViewController *) superController ;

#pragma mark --得到cache文件 foldName文件夹名 fileName 文件名
+(NSString *)getCachePathByFold:(NSString *)foldName withFileName:(NSString *)fileName;


#pragma mark -- 处理空字符
+(NSString * )validString:(id)string;



@end

