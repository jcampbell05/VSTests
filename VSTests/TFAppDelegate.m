//
//  TFAppDelegate.m
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import "TFAppDelegate.h"
#import "TFMasterViewController.h"
#import "TFDetailViewController.h"

@interface TFAppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) TFMasterViewController *masterViewController;
@property (nonatomic, strong) UINavigationController *masterNavigationViewController;
@property (nonatomic, strong) TFDetailViewController *detailViewController;
@property (nonatomic, strong) UINavigationController *detailNavigationViewController;

@end

@implementation TFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = self.rootViewController;
    
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarHidden = YES;

    return YES;
}

- (UIViewController *)rootViewController
{
    if (!_rootViewController)
    {
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        splitViewController.delegate = self;
        splitViewController.viewControllers = @[self.masterNavigationViewController,
                                                self.detailNavigationViewController];
        
        _rootViewController = splitViewController;
    }
    
    return _rootViewController;
}

- (UINavigationController *)masterNavigationViewController
{
    if (!_masterNavigationViewController)
    {
        _masterNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.masterViewController];
    }
    
    return _masterNavigationViewController;
}

- (TFMasterViewController *)masterViewController
{
    if (!_masterViewController)
    {
        _masterViewController = [[TFMasterViewController alloc] init];
        _masterViewController.detailViewController = self.detailViewController;
    }
    
    return _masterViewController;
}

- (UINavigationController *)detailNavigationViewController
{
    if (!_detailNavigationViewController)
    {
        _detailNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
    }
    
    return _detailNavigationViewController;
}

- (TFDetailViewController *)detailViewController
{
    if (!_detailViewController)
    {
        _detailViewController = [[TFDetailViewController alloc] init];
    }
    
    return _detailViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

@end
