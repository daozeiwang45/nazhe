//
//  NZGlobal.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZGlobal.h"
#import "NSString+NZ_Category.h"

@implementation NZGlobal

- (float)IOS7PointY {
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue] ;
    if( systemVersion >=7.0 ){
        return 20.0 ;
    }
    return 0.0 ;
}

+ (NSString *)GetBaseURL:(NSString *)urlString{
    
    NSString *baseURL = [NSString stringWithFormat:@"%@/%@", apiBaseUrl, urlString];
    return baseURL;
}

+ (NSString *)GetImgBaseURL:(NSString *)urlString{
    
    NSString *baseURL = [NSString stringWithFormat:@"%@/%@", imgBaseUrl, urlString];
    return baseURL;
}

#pragma mark 修改图像大小
+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

///// 手机号码的有效性判断
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//#pragma 正则匹配手机号
//+ (BOOL)checkTelNumber:(NSString *) telNumber
//{
//    NSString *pattern = @^1+[3578]+\d{9};
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:telNumber];
//    return isMatch;
//}
//
//
//#pragma 正则匹配用户密码6-18位数字和字母组合
//+ (BOOL)checkPassword:(NSString *) password
//{
//    NSString *pattern = @^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18};
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:password];
//    return isMatch;
//    
//}

//#pragma 正则匹配用户姓名,20位的中文或英文
//+ (BOOL)checkUserName : (NSString *) userName
//{
//    NSString *pattern = @^[a-zA-Z一-龥]{1,20};
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:userName];
//    return isMatch;
//    
//}
//
//
//#pragma 正则匹配用户身份证号15或18位
//+ (BOOL)checkUserIdCard: (NSString *) idCard
//{
//    NSString *pattern = @(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$);
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:idCard];
//    return isMatch;
//}
//
//#pragma 正则匹员工号,12位的数字
//+ (BOOL)checkEmployeeNumber : (NSString *) number
//{
//    NSString *pattern = @^[0-9]{12};
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:number];
//    return isMatch;
//    
//}
//
//#pragma 正则匹配URL
//+ (BOOL)checkURL : (NSString *) url
//{
//    NSString *pattern = @^[0-9A-Za-z]{1,50};
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:url];
//    return isMatch;
//    
//}




// 一个时间距现在的时间
+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"HH:mm:ss"];
    
    
    //获得系统时间
    NSDate *senddate = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    
    NSDate *d1=[date dateFromString:locationString];
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:theDate];
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    
    NSArray *timeArrayNow = [locationString componentsSeparatedByString:@":"];
    int hourNow = [[timeArrayNow objectAtIndex:0] intValue];
    int minNow = [[timeArrayNow objectAtIndex:1] intValue];
    int secNow = [[timeArrayNow objectAtIndex:2] intValue];
    
    NSArray *timeArrayTo = [theDate componentsSeparatedByString:@":"];
    int hourTo = [[timeArrayTo objectAtIndex:0] intValue];
    int minTO = [[timeArrayTo objectAtIndex:1] intValue];
    int secTo = [[timeArrayTo objectAtIndex:2] intValue];
    
    BOOL overToday;// 是否超过今天这个点
    if (hourNow>hourTo) {
        overToday = YES;
    } else if (hourNow == hourTo) {
        if (minNow>minTO) {
            overToday = YES;
        } else if (minNow == minTO) {
            if (secNow>secTo) {
                overToday = YES;
            } else {
                overToday = NO;
            }
        } else {
            overToday = NO;
        }
    } else {
        overToday = NO;
    }
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    
    if (overToday) {
        sen = [NSString stringWithFormat:@"%d", 60+(int)cha%60];
        // min = [min substringToIndex:min.length-7];
        // 秒
        sen=[NSString stringWithFormat:@"%@", sen];
        
        
        min = [NSString stringWithFormat:@"%d", 60+(int)cha/60%60];
        // min = [min substringToIndex:min.length-7];
        // 分
        min=[NSString stringWithFormat:@"%@", min];
        
        
        // 小时
        house = [NSString stringWithFormat:@"%d", 24+(int)cha/3600];
        // house = [house substringToIndex:house.length-7];
        house=[NSString stringWithFormat:@"%@", house];
    } else {
        sen = [NSString stringWithFormat:@"%d", (int)cha%60];
        // min = [min substringToIndex:min.length-7];
        // 秒
        sen=[NSString stringWithFormat:@"%@", sen];
        
        
        min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
        // min = [min substringToIndex:min.length-7];
        // 分
        min=[NSString stringWithFormat:@"%@", min];
        
        
        // 小时
        house = [NSString stringWithFormat:@"%d", (int)cha/3600];
        // house = [house substringToIndex:house.length-7];
        house=[NSString stringWithFormat:@"%@", house];
    }
    
    
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    return timeString;
}

// 判断字符串不为空的方法
+ (BOOL) isNotBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

@end
