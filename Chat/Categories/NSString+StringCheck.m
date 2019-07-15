//
//  NSString+StringCheck.m
//  Chat
//
//  Created by su_fyu on 2019/7/12.
//  Copyright © 2019年 su_fyu. All rights reserved.
//

#import "NSString+StringCheck.h"

@implementation NSString (StringCheck)

- (BOOL)isWord{
    
    if ([self  isEqualToString:@""]) {
        return YES;
    }
    //    NSString *textRegex =      @"^\\w+$";
    NSString *textRegex =      @"^[a-zA-Z0-9_]+$";
    
    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    BOOL text = [textPredicate evaluateWithObject:self];
    
    return text;
}

- (BOOL)isChinese{
    if ([self  isEqualToString:@""]) {
        return YES;
    }
    NSString *textRegex = @"^[\u4e00-\u9fa5]+$";
    
    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    BOOL text = [textPredicate evaluateWithObject:self];
    
    return text;
}

-(BOOL)isChineseOrEnglishOrNumber{
    if ([self  isEqualToString:@""]) {
        return YES;
    }
    NSString *textRegex = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSString *chineseSymbolRegex = @"^[➋➌➍➎➏➐➑➒]";
    
    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    NSPredicate *chineseSymbolPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chineseSymbolRegex];
    
    BOOL text = [textPredicate evaluateWithObject:self];
    BOOL chineseSymbol = [chineseSymbolPredicate evaluateWithObject:self];
    
    return text | chineseSymbol;
}

- (BOOL)isEnglishOrNumber{
    if ([self isEqualToString:@""]) {
        return YES;
    }
    NSString *textRegex = @"^[a-zA-Z0-9]+$";
    
    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    BOOL text = [textPredicate evaluateWithObject:self];
    
    
    return text ;
}

- (BOOL)isNumber{
    NSString *textRegex = @"^[0-9]+$";
    
    
    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    BOOL text = [textPredicate evaluateWithObject:self];
    
    return text;
}

-(BOOL)isDigitalNumber
{
    NSString *textRegex = @"^[0-9]+(\\.[0-9]+)?$";
    
    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    BOOL isDigtal = [textPredicate evaluateWithObject:self];
    
    return isDigtal;
}

-(BOOL)isEmail{
    
    NSString *string = @"^[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isPhone{
    
    if ([self isNumber]) {
        
        
        //        NSString *phoneStr = @"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}";
        
        NSString *phoneStr = @"(\\(86\\))?(1[0-9])\\d{9}";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneStr];
        return [predicate evaluateWithObject:self];
        
        
    }else{
        return NO;
    }
    
}


-(BOOL)isWebLink
{
    return  [self isWebLinkByprotocol:NO];
}

-(BOOL)isWebLinkByprotocol:(BOOL)protocol
{
    NSString *webStr = @"";
    
    if(protocol){
        
        //必须http开头
        NSString *string = @"^((http|ftp|https):\\/\\/)[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?$";
        
        webStr = string;
    }else{
        //非必须http开头
        NSString *string = @"^((http|ftp|https)(:\\/\\/))?[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?$";
        
        webStr = string ;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", webStr];  //[c]不区分大小写
    
    BOOL isMatch = [predicate evaluateWithObject:self];
    
    return isMatch;
}


-(BOOL)isNullStr
{
    
    if([self length] <=0 || [self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"] || [self isEqualToString:@"null"]) {
        
        return YES;
    }
    
    return NO;
    
    
}


/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
- (BOOL)verifyIdentityCard:(NSString **)outInfo;
{
    // 兼容用户输入小写x情况
    NSString *formatID = [self uppercaseString];
    
    //判断位数
    if ([formatID length] < 15 || [formatID length] > 18)
    {
        
        *outInfo = @"身份证位数非法";
        return NO;
    }
    
    NSString *carid = formatID;
    long lSumQT = 0;
    //加权因子
    int R[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    //校验码
    unsigned char sChecker[11] = {'1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:formatID];
    if ([formatID length] == 15)
    {
        
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i = 0; i <= 16; i++)
        {
            p += (pid[i] - 48) * R[i];
        }
        
        int o = p % 11;
        NSString *string_content = [NSString stringWithFormat:@"%c", sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString *sProvince = [carid substringToIndex:2];
    
    if (![NSString areaCode:sProvince])
    {
        *outInfo = @"身份证地区非法";
        return NO;
    }
    
    //判断年月日是否有效
    //年份
    int strYear = [[NSString getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[NSString getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[NSString getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now = [NSDate date];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
    NSInteger currentYear = [comps year];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01", strYear, strMonth, strDay]];
    if (date == nil ||
        currentYear - strYear > 150 ||
        currentYear < strYear)
    {
        *outInfo = @"身份证出生日期非法";
        return NO;
    }
    
    const char *PaperId = [carid UTF8String];
    
    //检验长度
    if (18 != strlen(PaperId))
    {
        *outInfo = @"身份证15位号码都应为数字,18位号码除最后一位外，都应为数字。";
        return NO;
    }
    
    //校验数字
    for (int i = 0; i < 18; i++)
    {
        if (!isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i))
        {
            *outInfo = @"身份证15位号码都应为数字,18位号码除最后一位外，都应为数字。";
            return NO;
        }
    }
    //验证最末的校验码
    for (int i = 0; i <= 16; i++)
    {
        lSumQT += (PaperId[i] - 48) * R[i];
    }
    if (sChecker[lSumQT % 11] != PaperId[17])
    {
        *outInfo = @"身份证无效，校验码不正确";
        return NO;
    }
    
    return YES;
}

/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2;
{
    return [str substringWithRange:NSMakeRange(value1, value2)];
}

/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+ (BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil)
    {
        
        return NO;
    }
    return YES;
}


-(NSString *)trimByWhiteSpace
{
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
}

-(NSString *)trimByLineWhiteSpace
{
    
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //特殊字符 某种情况它不是转义字符 需要替换
    str = [str stringByReplacingOccurrencesOfString:@"\\\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\\\n" withString:@""];
    
    return str;
}

@end
