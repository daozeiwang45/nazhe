//
//  AppDelegate.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "AppDelegate.h"
#import "JJNewFeatureController.h"

#define JJVersionKey @"version"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    user.userId = @"6";
    
    /**********************    键盘事件的自动监听   **********************/
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:60];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // 1.获取当前的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    // 2.获取上一次的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:JJVersionKey];
    
    //判断当前是否有新的版本
    if ([currentVersion isEqualToString:lastVersion]) { // 没有最新的版本号
        
        self.window.rootViewController = [[NZFastOperate sharedObject] createInstanceStoryboardName:@"Main" bundle:nil] ;
    }else { // 有最新的版本
        JJNewFeatureController *newFeature = [[JJNewFeatureController alloc] init];
        NSArray *imageArray = [NSArray arrayWithObjects:@"new_feature_1.png", @"new_feature_2.jpeg", @"new_feature_3.jpeg", @"new_feature_4.jpeg", nil];
        newFeature.imageArray = imageArray;
        
        self.window.rootViewController = newFeature;
        
        // 保存最新的版本号，用用户偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:JJVersionKey];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window makeKeyAndVisible];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    return YES;
}

- (void)registerRemoteNotification
{

    if([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
        
    {
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings
                                                                            
                                                                            settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge)
                                                                            
                                                                            categories:nil]];
        
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    }else{
        
        
        /** 注册推送通知功能, */
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"apns -> 生成的devToken:%@", token);
    NSString *strDeviceToken = [[token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NZUser *user = [NZUserManager sharedObject].user ;
    user.pushToken = strDeviceToken;
//    _deviceToken = strDeviceToken;
//    //把deviceToken发送到我们的推送服务器
//    //    DeviceSender* sender = [[[DeviceSender alloc]initWithDelegate:self ]autorelease];
//    //    [sender sendDeviceToPushServer:token ];
//    if (gexinPusher) {
//        [gexinPusher registerDeviceToken:_deviceToken];
//    }
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
