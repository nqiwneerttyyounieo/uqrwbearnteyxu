//
//  AppDelegate.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 05/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "AppDelegate.h"
#import "RightMenuViewController.h"
#import "SlideNavigationController.h"
#import "UserModel.h"
#import "CommansUtility.h"
#import "TabbarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard"
                                                             bundle: nil];

    RightMenuViewController *rightMenu = (RightMenuViewController*)[mainStoryboard
                                                                    instantiateViewControllerWithIdentifier: @"RightMenuViewController"];
    
    [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    

    UserModel *uModel = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
    if(uModel && uModel.strClientUserName.length){
        NSLog(@"User was logged in");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard" bundle:nil];
        
        //SlideNavigationController *sViewController = [storyboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
        
        TabbarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TabbarViewController"];

        [[SlideNavigationController sharedInstance] setViewControllers:[NSArray arrayWithObjects:tabBarVC, nil]];
        
        [UIApplication sharedApplication].keyWindow.rootViewController =     [SlideNavigationController sharedInstance];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        
        
        
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
