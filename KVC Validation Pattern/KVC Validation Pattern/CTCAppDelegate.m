//
//  CTCAppDelegate.m
//  KVC Validation Pattern
//
//  Created by John Szumski on 2/18/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCAppDelegate.h"
#import "CTCViewController.h"

@implementation CTCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	self.viewController = [[CTCViewController alloc] initWithNibName:@"CTCViewController" bundle:nil];
	
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end