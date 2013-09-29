//
//  ABStore.h
//
//  Created by Alexander Blunck on 9/24/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ABStore : NSObject

//Singleton
+(instancetype) sharedClass;

//Setup
+(void) setupCoreDataStack;

//Save
+(void) saveDefaultContext;

//Core Data Stack
-(NSManagedObjectContext*) managedObjectContext;
-(NSManagedObjectModel*) managedObjectModel;
-(NSPersistentStoreCoordinator*) persistentStoreCoordinator;

@end
