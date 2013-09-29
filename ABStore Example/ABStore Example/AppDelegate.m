//
//  AppDelegate.m
//  ABStore Example
//
//  Created by Alexander Blunck on 9/28/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "Person.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //CoreData setup
    [ABStore setupCoreDataStack];
    
    //View
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TableViewController new]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
