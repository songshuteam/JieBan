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
#import "AGLoginIndexViewController.h"

#pragma mark -- chat
#import "ChatListViewController.h"

#import "AGShareViewController.h"

#import <UMengAnalytics/MobClick.h>

//#import <PBFlatUI/PBFlatSettings.h>
#import "PBFlatSettings.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import <IQKeyboardManager/IQSegmentedNextPrevious.h>
#import "EaseMob.h"

@implementation AGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [self umengTrack];
    
    [PBFlatSettings sharedInstance].mainColor = [UIColor colorWithRed:132.f/255 green:208.f/255 blue:24.f/255 alpha:1.f];
    [PBFlatSettings sharedInstance].textFieldPlaceHolderColor = [UIColor clearColor];
    [[PBFlatSettings sharedInstance] navigationBarApperance];
    
    long long userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    if (userId == 0) {
        AGLoginIndexViewController *viewController = [[AGLoginIndexViewController alloc] init];
        AGNavigationController *navigationController = [[AGNavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = navigationController;
    }else{
        [self buildViews];
        
        NSString *userStr = [NSString stringWithFormat:@"%lld",userId];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORD];
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userStr password:[password md5Encrypt] completion:^(NSDictionary *loginInfo, EMError *error) {
            if (error) {
                NSLog(@"聊天登陆失败");
            }else{
                NSLog(@"聊天登陆成功");
            }
        } onQueue:nil];
    }
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildViews) name:LOGINFINISH object:nil];
    
    // 真机的情况下,notification提醒设置
	UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    
	//注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
	NSString *apnsCertName = @"jieban";
	[[EaseMob sharedInstance] registerSDKWithAppKey:ChatAPPKey apnsCertName:apnsCertName];
	[[EaseMob sharedInstance] enableBackgroundReceiveMessage];
	[[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"anyGo"]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
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

-(void)loginStateChange:(NSNotification *)notification
{

   
}


- (void)buildViews {
    AGJieBanViewController *viewController0 = [[AGJieBanViewController alloc] init];
    AGNavigationController *navigationController0 = [[AGNavigationController alloc] initWithRootViewController:viewController0];
    navigationController0.title = @"结伴";
    
    [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    ChatListViewController *viewController1 = [[ChatListViewController alloc] init];
    AGNavigationController *navigationController1 = [[AGNavigationController alloc] initWithRootViewController:viewController1];
    navigationController1.title = @"消息";
    
    AGLoginIndexViewController *viewController2 = [[AGLoginIndexViewController alloc] init];
    AGNavigationController *navigationController2 = [[AGNavigationController alloc] initWithRootViewController:viewController2];
    navigationController2.title = @"我的";
    
    AGShareViewController *viewController3 = [[AGShareViewController alloc] init];
    AGNavigationController *navigationController3 = [[AGNavigationController alloc] initWithRootViewController:viewController3];
    navigationController3.title = @"组队";
    
    AGDistributeViewController *viewController4 = [[AGDistributeViewController alloc] init];
    viewController3.view.backgroundColor = [UIColor lightGrayColor];
    AGNavigationController *navigationController4 = [[AGNavigationController alloc] initWithRootViewController:viewController4];
    navigationController4.title = @"发布";
    
    AGTabBarController *tabBarContrller = [[AGTabBarController alloc] init];
    tabBarContrller.delegate = self;
    tabBarContrller.viewControllers = @[navigationController0, navigationController1, navigationController2, navigationController3,navigationController4];
    
    UITabBar *tabbar = tabBarContrller.tabBar;
    if (SYM_VERSION >= 7) {
        tabbar.translucent = NO;
    }
    
    UITabBarItem *jiebanItem = tabbar.items[0];
    UITabBarItem *xiaoxiItem = tabbar.items[1];
    UITabBarItem *wodeItem = tabbar.items[2];
    UITabBarItem *zuduiItem = tabbar.items[3];
    UITabBarItem *fabuItem = tabbar.items[4];
    
    jiebanItem.image = [UIImage imageNamed:@"jieban"];
    xiaoxiItem.image = [UIImage imageNamed:@"xiaoxi"];
    wodeItem.image = [UIImage imageNamed:@"wode"];
    zuduiItem.image = [UIImage imageNamed:@"zudui"];
    fabuItem.image = [UIImage imageNamed:@"fabu"];
    
    tabbar.tintColor = [UIColor colorWithRed:132.f/255 green:190.f/255 blue:60.f/255 alpha:1.f];
    
    
    self.window.rootViewController = tabBarContrller;
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
