//
//  UIDevice+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "UIDevice+Category.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Category)

-(NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

-(NSString *)platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"]) {
        return IPHONE_1G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPhone1,2"]) {
        return IPHONE_3G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPhone2,1"]) {
        return IPHONE_3GS_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPhone3,1"]) {
        return IPHONE_4G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPhone4,1"]) {
        return IPHONE_4GS_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPhone5,1"]) {
        return IPHONE_5G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPod1,1"]) {
        return IPOD_1G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPod2,1"]) {
        return IPOD_2G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPod3,1"]) {
        return IPOD_3G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPod4,1"]) {
        return IPOD_4G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPod5,1"]) {
        return IPOD_5G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPad1,1"]) {
        return IPAD_1G_NAMESTRING;
    }
    if ([platform isEqualToString:@"iPad2,1"])     return @"iPad2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return @"iPad2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return @"iPad2 (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])     return @"iPad3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])     return @"iPad3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])     return @"iPad3 (CDMA)";
    if ([platform isEqualToString:@"i386"]) {
        return SIMULATOR;
    }
    
    return NO;
}

-(BOOL)hasMicrophone{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return YES;
	if ([platform isEqualToString:@"iPhone1,2"]) return YES;
	if ([platform isEqualToString:@"iPhone2,1"]) return YES;
	if ([platform isEqualToString:@"iPhone3,1"]) return YES;
    if ([platform isEqualToString:@"iPhone4,1"]) return YES;
	if ([platform isEqualToString:@"iPhone5,1"]) return YES;
	if ([platform isEqualToString:@"iPod1,1"])   return NO;
	if ([platform isEqualToString:@"iPod2,1"])   return NO;
	if ([platform isEqualToString:@"iPod3,1"])   return NO;
    if ([platform isEqualToString:@"iPod4,1"])   return NO;
	if ([platform isEqualToString:@"iPod5,1"])   return NO;
	if ([platform isEqualToString:@"iPad1,1"])   return NO;
    if ([platform isEqualToString:@"iPad2,1"])   return NO;
	if ([platform isEqualToString:@"iPad2,2"])   return NO;
	if ([platform isEqualToString:@"iPad2,3"])   return NO;
    if ([platform isEqualToString:@"iPad3,1"])   return NO;
	if ([platform isEqualToString:@"iPad3,2"])   return NO;
	if ([platform isEqualToString:@"iPad3,3"])   return NO;

    return NO;
}

+ (BOOL)isIOS7 {
    static BOOL isIOS7 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] > 7.0f;
    });
    
    return isIOS7;
}

@end
