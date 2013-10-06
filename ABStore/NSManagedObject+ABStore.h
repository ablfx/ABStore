//
//  NSManagedObject+ABStore.h
//
//  Created by Alexander Blunck on 9/25/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ABStore)

//Creation
+(instancetype) createObject;
+(instancetype) createUnassociatedObject;

//Delete
-(void) deleteObject;

//Query
+(instancetype) findFirst;
+(instancetype) findFirstByAttribute:(NSString*)attribute withValue:(id)value;
+(NSArray*) findAll;
+(NSArray*) findAllByAttribute:(NSString*)attribute withValue:(id)value;
+(NSArray*) findAllByAttribute:(NSString*)attribute withValue:(id)value sortedBy:(NSString*)sortKey ascending:(BOOL)ascending;
+(NSArray*) executeFetchRequestWithPredicate:(NSPredicate*)predicate sortedBy:(NSString*)sortKey ascending:(BOOL)ascending;

//Unassociated Object
-(void) saveUnassociatedObject;

@end
