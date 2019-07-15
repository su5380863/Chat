//
//  NSString+StringCheck.h
//  Chat
//
//  Created by su_fyu on 2019/7/12.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (StringCheck)
- (BOOL)isWord;    //匹配由数字、26个英文字母或者下划线组成的字符串
- (BOOL)isChinese; //判断是否为中文

- (BOOL)isChineseOrEnglishOrNumber;  //  判断是否为中文、英文、数字
- (BOOL)isEnglishOrNumber;  //  判断是否为英文、数字
- (BOOL)isNumber;  //是否为纯数字
- (BOOL)isDigitalNumber;  //是否为十进制数字 可以有小数
- (BOOL)isEmail;
- (BOOL)isPhone;
- (BOOL)isWebLink; //判断网址(无需要协议)
- (BOOL)isWebLinkByprotocol:(BOOL)protocol; //判断网址(是否需要协议)
- (BOOL)isNullStr; //判断是否为空值

- (BOOL)verifyIdentityCard:(NSString **)outInfo; //仅仅只判断身份证格式合法性

-(NSString *)trimByWhiteSpace; //只去掉首尾空格
-(NSString *)trimByLineWhiteSpace; //去掉换行 +首尾空格
@end

NS_ASSUME_NONNULL_END
