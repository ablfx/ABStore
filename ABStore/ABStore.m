//
//  ABStore.m
//
//  Created by Alexander Blunck on 9/24/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import "ABStore.h"
#import "CoreData+ABStore.h"

@interface ABStore ()
{
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}
@end

@implementation ABStore

#pragma mark - Singleton
+(instancetype) sharedClass
{
    static ABStore *sharedClass = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{sharedClass = [[self alloc] init];});
    return sharedClass;
}



#pragma mark - Setup
+(void) setupCoreDataStack
{
    ABStore *sharedClass = [self sharedClass];
    
    //Trigger initialization of stack and by doing so perform any auto migration needed
    if (![sharedClass persistentStoreCoordinator])
    {
        NSLog(@"ABStore: ERROR -> setupCoreDataStack Failed!");
    }
}



#pragma mark - Save
+(void) saveDefaultContext
{
    ABStore *sharedClass = [self sharedClass];
    
    NSManagedObjectContext *context = [sharedClass managedObjectContext];
    
    if ([context hasChanges])
    {
        NSError *error = nil;
        BOOL successful = [context save:&error];
        if (!successful)
        {
            NSLog(@"ABStore: ERROR -> Couldn't save defaultManagedObjectContext!");
            NSLog(@"ABStore: ERROR -> %@", error);
        }
    }
}



#pragma mark - Core Data Stack
#pragma mark - Core Data Stack - NSManagedObjectContext
-(NSManagedObjectContext*) managedObjectContext
{
    if (_managedObjectContext) return _managedObjectContext;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
    
    if (!persistentStoreCoordinator)
    {
        NSLog(@"ABStore: ERROR -> Couldn't initialize managedObjectContext");
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return _managedObjectContext;
}


#pragma mark - Core Data Stack - NSManagedObjectModel
-(NSManagedObjectModel*) managedObjectModel
{
    if (_managedObjectModel) return _managedObjectModel;
    
    NSURL *modelURL = [self managedObjectModelURLInMainBundle];
    if (!modelURL)
    {
        NSLog(@"ABStore: ERROR -> Couldn't initialize managedObjectModel!");
        return nil;
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}


#pragma mark - Core Data Stack - NSPersistentStoreCoordinator
-(NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
    NSManagedObjectModel *managedObjectModel = [self managedObjectModel];
    if (!managedObjectModel)
    {
        NSLog(@"ABStore: ERROR -> Couldn't initialize persistentStoreCoordinator!");
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *error = nil;
    
    //Options for allowing auto migration for new version of model
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES};
    
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                         configuration:nil
                                                                                   URL:[self defaultPersistentStoreURL]
                                                                               options:options
                                                                                 error:&error];
    
    if (!store)
    {
        NSLog(@"ABStore: ERROR -> Couldn't add persistentStore!");
        NSLog(@"ABStore: ERROR -> %@", error);
        return nil;
    }
    
    return _persistentStoreCoordinator;
}



#pragma mark - URL's
-(NSURL*) defaultPersistentStoreURL
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    appName = [appName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", appName]];
}

-(NSURL*) managedObjectModelURLInMainBundle
{
    NSArray *urls = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"momd" subdirectory:nil];
    
    if (urls.count == 0)
    {
        NSLog(@"ABStore: ERROR -> Couldn't find a *.xcdatamodeld in the application bundle!");
        return nil;
    }
    else if (urls.count > 1)
    {
        NSLog(@"ABStore: WARNING -> Found more than one *.xcdatamodeld in the application bundle, using %@ .", [urls firstObject]);
    }
    
    return [urls firstObject];
}

@end
