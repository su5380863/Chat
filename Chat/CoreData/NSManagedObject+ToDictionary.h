//
//  NSManagedObject+ToDictionary.h
//  Chat
//
//  Created by su_fyu on 15/6/18.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ToDictionary)


- (NSDictionary *)getDictionary;


- (void)setWithDictionary:(NSDictionary *)dictionary;
@end
