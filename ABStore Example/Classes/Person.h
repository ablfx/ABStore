//
//  Person.h
//  ABStore Example
//
//  Created by Alexander Blunck on 9/28/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t age;

@end
