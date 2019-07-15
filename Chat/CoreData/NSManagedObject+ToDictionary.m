//
//  NSManagedObject+ToDictionary.m
//  Chat
//
//  Created by su_fyu on 15/6/18.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import "NSManagedObject+ToDictionary.h"
#import <objc/runtime.h>
#import "ChatTools.h"
@implementation NSManagedObject (ToDictionary)


- (void)setWithDictionary:(NSDictionary *)dictionary {
    
    for (NSString *key in [dictionary keyEnumerator]) {
        
        NSString * methodName = [self methodNameByKey:key];
        
        NSString * setSelector = [NSString stringWithFormat:@"set%@:", methodName];
        
        SEL selector = NSSelectorFromString(setSelector);
        
        if ([self respondsToSelector:selector]) {
            
            id value = [dictionary objectForKey:key];
            
            if ([value isKindOfClass:[NSSet class]]) continue;
            
            if([self containNotNSString:value]){//可为字符串
                
                NSString *valueStr = [ChatTools validString:value];
                value = valueStr;
            }

            if(value){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:selector withObject:value];
#pragma clang diagnostic pop
            }
            
        }
    }
    
}

#pragma mark --判断是可为字符串
-(BOOL)containNotNSString:(id)value
{
    
    if(!value) return YES;
    
    static NSArray *classArr = nil;
    
    if(classArr ==nil){ //如果是流和时间等特殊对象不转字符串
        
        NSMutableArray *classes = [[NSMutableArray alloc] init];
        
        [classes addObject:NSStringFromClass([NSData class])]; //流
        [classes addObject:NSStringFromClass([NSDate class])]; //时间对象
        classArr = classes;
    }
    
    NSString *valueClass = NSStringFromClass([value class]);
    
    if([classArr containsObject:valueClass]){
        
        return NO;
        
    }

    return YES;
}


-(NSString *)methodNameByKey:(NSString *)key
{
    if(!key) return @"";
    
    NSMutableString *methodName = [NSMutableString string];
    
    NSArray *keyArr = [key componentsSeparatedByString:@"_"];
    
    for(NSInteger i = 0; i< [keyArr count]; i++){
        
        NSString *name = keyArr[i];
        
        if(i == 0){ //第一个字符大写 其他不变
            
            NSString *first = [name substringToIndex:1];
            first = [first uppercaseString];
            NSString *endString = [name substringFromIndex:1];
            name = [NSString stringWithFormat:@"%@%@",first,endString];
        }
        
        [methodName appendString:name];
        
        if(i != [keyArr count] -1){
            
            [methodName appendString:@"_"];
        }
        
    }
    
    
    
    return methodName;
}

- (NSDictionary *)getDictionary
{
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    
    
    unsigned int nCount = 0;
    
    objc_property_t *popertylist = class_copyPropertyList([self class], &nCount);
    
    
    for (int i = 0; i < nCount; i++) {
        
        objc_property_t property = popertylist[i];
        
        NSString *attr_name = [NSString stringWithUTF8String:property_getName(property)];
        
        SEL selector = NSSelectorFromString(attr_name);
        
        if ([self respondsToSelector:selector]) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id value = [self performSelector:selector];
#pragma clang diagnostic pop
            if ([value isKindOfClass:[NSSet class]]) continue;
            
            if(value)
                [mutableDictionary setObject:value forKey:attr_name];
        }
        
    }
    
    return [[NSDictionary alloc] initWithDictionary:mutableDictionary];
    
}

@end
