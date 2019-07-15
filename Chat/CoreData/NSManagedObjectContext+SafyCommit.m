//
//  NSManagedObjectContext+SafyCommit.m
//  Chat
//
//  Created by su_fyu on 15/8/19.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  coreData 安全机制

#import "NSManagedObjectContext+SafyCommit.h"
#import "AppDelegate.h"

@implementation NSManagedObjectContext (SafyCommit)

+ (instancetype)createNewManagedObjectContext {

    NSManagedObjectContext *managedObjectContext = nil;
    managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    NSPersistentStoreCoordinator *presistentStore = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext.persistentStoreCoordinator;
    
    [managedObjectContext setPersistentStoreCoordinator:presistentStore];

    return managedObjectContext;

}

#pragma mark --保存
- (BOOL)safeCommit {

    return [self safeCommit:nil];
}

- (BOOL)safeCommit:(NSError **)error {

    
    BOOL saveStatus = NO;
    
    if ([self hasChanges]) {
        
        @try {
            //[self lock];
            saveStatus = [self save:error];
            //[self unlock];
        }
        @catch (NSException *exception) {
            NSLog(@"reason =%@,name =%@",exception.reason,exception.name);
            [self rollback];
        }
        @finally {
            
        }
        
    }
    
    return saveStatus;

}

#pragma mark --获取查询体
- (NSFetchRequest *)createFectchRequestWithClass:(Class)managedObjectClass predicate:(NSPredicate *)predt sorts:(NSArray *)sorts {
    
    NSAssert([managedObjectClass isSubclassOfClass:[NSManagedObject class]], @"prama class is must be NSManagedObject Class");
    
    NSAssert(predt != nil, @"predt is not nil");
    
    NSFetchRequest *requstSql =[[NSFetchRequest alloc ] init];
    
    NSEntityDescription * entity =[NSEntityDescription entityForName:NSStringFromClass(managedObjectClass)  inManagedObjectContext:self];
    
    [requstSql setEntity:entity];
    
    [requstSql setPredicate:predt];
    
    if(sorts.count >0){
        
        [requstSql setSortDescriptors:sorts];
    }
    
    return requstSql;
    
}

#pragma mark --查询数据
- (NSArray *)queryDatas:(Class)managedObjectClass predicate:(NSPredicate *)predt {

    return [self queryDatas:managedObjectClass predicate:predt sorts:nil];
}

- (NSArray *)queryDatas:(Class)managedObjectClass predicate:(NSPredicate *)predt sorts:(NSArray *)sorts {
    
    NSFetchRequest *requstSql = [self createFectchRequestWithClass:managedObjectClass predicate:predt sorts:sorts];
    
    NSError *getError = nil;
    //获取数据
    NSArray *mutablResult = [self executeFetchRequest:requstSql error:&getError];
    
    return mutablResult;
    
}

#pragma mark --得到一条数据 或新数据
- (id)getQueryOrNewOne:(Class)managedObjectClass predicate:(NSPredicate *)predt {
    
    return [self getQueryOrNewOne:managedObjectClass predicate:predt sorts:nil];
}

- (id)getQueryOrNewOne:(Class)managedObjectClass predicate:(NSPredicate *)predt sorts:(NSArray *)sorts{
 
    NSArray *quertDatas = [self queryDatas:managedObjectClass predicate:predt sorts:sorts];
    
    NSManagedObject *mo = nil;
    
    if([quertDatas count] >0){
        
        mo = quertDatas[0];
        
    }else{
        mo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(managedObjectClass) inManagedObjectContext:self];
    }
    
    return mo;
    
}

@end
