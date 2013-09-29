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
+(NSArray*) findAll;
+(instancetype) findFirst;

//Unassociated Object
-(void) saveUnassociatedObject;

@end
