//
//  FaceIconFile.m
//  Chat
//
//  Created by su_fyu on 15/6/1.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  获取表情文件

#import "FaceIconFile.h"

@implementation FaceIconFile



#pragma mark 获取plist 图片库
+ (NSDictionary *)getFaceMap{

    static NSDictionary *dic =nil;
    if(dic ==nil){
        NSString *path =[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
        dic =[NSDictionary dictionaryWithContentsOfFile:path];
    }
    return dic;
}

#pragma mark 根据iconkey值找到 image 名称
+ (NSString *)faceKeyForValue:(NSString *)iconKey map:(NSDictionary *)map{

    NSArray *keys = [map allKeys];
    NSUInteger count = [keys count];
    
    for(int i= 0; i<count; i++){
        
        NSString *key =[keys objectAtIndex:i];
        
        if([[map objectForKey:key] isEqualToString:iconKey]){
            return key;
        }
        continue;
    }
    
    return  nil;
}

+ (NSArray *)getAllNames{

    static NSMutableArray *allArr = nil;
    
    if(!allArr){
        
        allArr =[[NSMutableArray alloc] init];
        
        NSArray *nameCore = [self getNamesCore];
        [allArr addObjectsFromArray:nameCore];
        
        NSArray *spcialName = [self getSpaceciNames];
        [allArr addObjectsFromArray:spcialName];
        
    }
    
    return allArr;
    
}


@end
