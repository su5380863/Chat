//
//  Conversation+CoreDataProperties.h
//  Chat
//
//  Created by su_fyu on 2019/7/15.
//  Copyright © 2019年 su_fyu. All rights reserved.
//
//

#import "Conversation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Conversation (CoreDataProperties)

+ (NSFetchRequest<Conversation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *from_client_id;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *img;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *to_client_id;
@property (nullable, nonatomic, copy) NSString *user_name;
@property (nullable, nonatomic, copy) NSString *media;
@property (nullable, nonatomic, copy) NSString *duration;

@end

NS_ASSUME_NONNULL_END
