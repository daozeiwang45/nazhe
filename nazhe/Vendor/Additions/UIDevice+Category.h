//
//  UIDevice+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SIMULATOR @"Simulator"
#define IPHONE_1G_NAMESTRING @"iPhone 1"
#define IPHONE_3G_NAMESTRING @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING @"iPhone 3GS"
#define IPHONE_4G_NAMESTRING @"iPhone 4"
#define IPHONE_4GS_NAMESTRING @"iPhone 4S"
#define IPHONE_5G_NAMESTRING @"iPhone 5"
#define IPOD_1G_NAMESTRING @"iPod Touch 1"
#define IPOD_2G_NAMESTRING @"iPod Touch 2"
#define IPOD_3G_NAMESTRING @"iPod Touch 3"
#define IPOD_4G_NAMESTRING @"iPod Touch 4"
#define IPOD_5G_NAMESTRING @"iPod Touch 5"
#define IPAD_1G_NAMESTRING @"iPad 1"

@interface UIDevice (Category)
//判断设备型号
-(NSString *)platform;
-(NSString *)platformString;
//判断设备是否能拨号
-(BOOL)hasMicrophone;
+ (BOOL)isIOS7;
@end
