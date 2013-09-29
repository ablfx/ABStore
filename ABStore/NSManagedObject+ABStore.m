//
//  NSManagedObject+ABStore.m
//
//  Created by Alexander Blunck on 9/25/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import "NSManagedObject+ABStore.h"
#import "CoreData+ABStore.h"

@implementation NSManagedObject (ABStore)

#pragma mark - Creation
+(instancetype) createObject
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext defaultManagedObjectContext];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:defaultContext];
    
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext:defaultContext];
    
    return object;
}

+(instancetype) createUnassociatedObject
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext defaultManagedObjectContext];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:defaultContext];
    
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext:nil];
    
    return object;
}



#pragma mark - Delete
-(void) deleteObject
{
    [[NSManagedObjectContext defaultManagedObjectContext] deleteObject:self];
}



#pragma mark - Query
+(NSArray*) findAll
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    
    NSError *error = nil;
    
    NSArray *result = [[NSManagedObjectContext defaultManagedObjectContext] executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"ABStore: ERROR -> Could findAll \"%@\'s\"", [self entityName]);
        NSLog(@"ABStore: ERROR -> %@", error);
        return nil;
    }
    
    return result;
}

+(instancetype) findFirst
{
    return [[self findAll] firstObject];
}



#pragma mark - Unassociated Object
-(void) saveUnassociatedObject
{
    //Check if object has been inserted in a context, if it has it is not an unassociated object
    if (self.isInserted)
    {
        NSLog(@"ABStore: WARNING -> saveUnassociatedObject -> You can't save a non unassociated object with this method!");
        return;
    }
    
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext defaultManagedObjectContext];
    [defaultContext insertObject:self];
    
    [ABStore saveDefaultContext];
}



#pragma mark - Helper
+(NSString*) entityName
{
    return NSStringFromClass(self);
}

@end
