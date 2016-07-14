//
//  AppDelegate.m
//  DateEating
//
//  Created by user on 16/7/11.
//  Copyright © 2016年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "YTabBarController.h"
#import "YOpenViewController.h"
#import <EMSDK.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#pragma mark--环信--
    EMOptions *options = [EMOptions optionsWithAppkey:@"znw#dateeating"];
    options.apnsCertName = @"0309DevPush";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
#pragma mark--Leancloud--
    [AVOSCloud setApplicationId:@"HG6nn22YGNtjgFvfVPpbdRaE-gzGzoHsz"
                      clientKey:@"Ce6WOl25IXT1Ck2RabzVh60k"];
    AVUser *currentUser = [AVUser currentUser];
#pragma mark--界面--
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor yellowColor];
    [self.window makeKeyAndVisible];
    // 添加UITabBarC ontroller
    UITabBarController *tabBarController = [[YTabBarController alloc] init];
    if (nil == currentUser) {
        YOpenViewController *openVC = [YOpenViewController new];
        self.window.rootViewController = openVC;
    }else if(currentUser && nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]){
        self.window.rootViewController = tabBarController;
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
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
