//
//  Conversation+CoreDataProperties.m
//  Chat
//
//  Created by su_fyu on 2019/7/15.
//  Copyright © 2019年 su_fyu. All rights reserved.
//
//

#import "Conversation+CoreDataProperties.h"

@implementation Conversation (CoreDataProperties)

+ (NSFetchRequest<Conversation *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Conversation"];
}

@dynamic content;
@dynamic from_client_id;
@dynamic id;
@dynamic img;
@dynamic time;
@dynamic to_client_id;
@dynamic user_name;
@dynamic media;
@dynamic duration;

@end
