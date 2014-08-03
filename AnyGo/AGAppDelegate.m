//
//  AGAppDelegate.m
//  AnyGo
//
//  Created by WingleWong on 14-2-11.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGAppDelegate.h"
#import "PBFlatSettings.h"
#import "AGTabBarController.h"
#import "AGNavigationController.h"
#import "AGViewController.h"
#import "AGHomeViewController.h"
#import "AGLoginViewController.h"
#import "AGDistributeViewController.h"
#import "AGJieBanViewController.h"

#import "AGShareViewController.h"

#import <UMengAnalytics/MobClick.h>

//#import <PBFlatUI/PBFlatSettings.h>
#import "PBFlatSettings.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import <IQKeyboardManager/IQSegmentedNextPrevious.h>

@implementation AGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self umengTrack];
    [self buildViews];
    [IQKeyboardManager sharedManager].enable = YES;
    
    [self.window makeKeyAndVisible];
    return YES;
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

#pragma mark - Custom Methods
- (void)umengTrack {
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
#if DEBUG
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#endif
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)buildViews {
    AGJieBanViewController *viewController0 = [[AGJieBanViewController alloc] init];
    viewController0.view.backgroundColor = [UIColor redColor];
    AGNavigationController *navigationController0 = [[AGNavigationController alloc] initWithRootViewController:viewController0];
    
    AGViewController *viewController1 = [[AGViewController alloc] init];
    viewController1.view.backgroundColor = [UIColor greenColor];
    AGNavigationController *navigationController1 = [[AGNavigationController alloc] initWithRootViewController:viewController1];
    
    AGShareViewController *viewController2 = [[AGShareViewController alloc] init];
//    viewController2.view.backgroundColor = [UIColor yellowColor];
    AGNavigationController *navigationController2 = [[AGNavigationController alloc] initWithRootViewController:viewController2];
    
    AGDistributeViewController *viewController3 = [[AGDistributeViewController alloc] init];
    viewController3.view.backgroundColor = [UIColor lightGrayColor];
    AGNavigationController *navigationController3 = [[AGNavigationController alloc] initWithRootViewController:viewController3];
    
    AGTabBarController *tabBarContrller = [[AGTabBarController alloc] init];
    tabBarContrller.delegate = self;
    tabBarContrller.viewControllers = @[navigationController0, navigationController1, navigationController2, navigationController3];
    
    self.window.rootViewController = tabBarContrller;
    
    [PBFlatSettings sharedInstance].mainColor = [UIColor colorWithRed:132.f/255 green:208.f/255 blue:24.f/255 alpha:1.f];
    [PBFlatSettings sharedInstance].textFieldPlaceHolderColor = [UIColor clearColor];
    [[PBFlatSettings sharedInstance] navigationBarApperance];
    
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    LOG(@"online config has fininshed and note = %@", note.userInfo);
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *vc = (UINavigationController *)viewController;
        if ([vc.topViewController isKindOfClass:[AGHomeViewController class]]) {
            LOG(@"Home.....");
            [MobClick event:@"Shouye"];
        }else {
//            AGLoginViewController *loginViewContrller = [[AGLoginViewController alloc] init];
//            AGNavigationController *loginNavigationController = [[AGNavigationController alloc] initWithRootViewController:loginViewContrller];
//            [tabBarController presentViewController:loginNavigationController animated:YES completion:nil];
//            return NO;
        }
        
    }
    return YES;
}

@end
