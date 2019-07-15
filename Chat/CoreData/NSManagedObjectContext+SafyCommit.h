//
//  NSManagedObjectContext+SafyCommit.h
//  Chat
//
//  Created by su_fyu on 15/8/19.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  coreData 安全机制

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (SafyCommit)


+(instancetype)createNewManagedObjectContext;


/* @提交所有的更新操作，包括delete, insert
 *return 是否成功
 */
- (BOOL)safeCommit;

- (BOOL)safeCommit:(NSError **)error;

/* @返回查询命令
 *param managedObjectClass      查询对象类型
 *param predt                   表达式
 *param sorts                   排序方式
 *return                        一个表达式查询命令
 */
- (NSFetchRequest *)createFectchRequestWithClass:(Class)managedObjectClass predicate:(NSPredicate *)predt sorts:(NSArray *)sorts;

/* @查询数据 集合
 *param managedObjectClass      查询对象类型
 *param predt                   表达式
 */
- (NSArray *)queryDatas:(Class)managedObjectClass predicate:(NSPredicate *)predt;

/* @查询数据 集合
 *param managedObjectClass      查询对象类型
 *param predt                   表达式
 *param sorts                   排序方式
 */
- (NSArray *)queryDatas:(Class)managedObjectClass predicate:(NSPredicate *)predt sorts:(NSArray *)sorts;


/* @查询数据单个 或创建新数据
 *param managedObjectClass      查询对象类型
 *param predt                   表达式
 *return 返回一条数据             NSManagedObject
 */
- (id)getQueryOrNewOne:(Class)managedObjectClass predicate:(NSPredicate *)predt;

/* @查询数据单个 或创建新数据
 *param managedObjectClass      查询对象类型
 *param predt                   表达式
 *param sorts                   排序方式
 *return 返回一条数据             NSManagedObject
 */
- (id)getQueryOrNewOne:(Class)managedObjectClass predicate:(NSPredicate *)predt sorts:(NSArray *)sorts;

@end
