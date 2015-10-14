//
//  NZGlobal.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZGlobal : NSObject

/***
 * @brief 获取程序是IOS6还是IOS7
 *
 * @warning 不保证IOS7以上版本的正确性
 *
 * @return 若系统为IOS7以下，返回0.0f，否则返回20.0f
 */
- (float)IOS7PointY;

///***
// * @brief 计算字体大小
// */
//- (CGSize)textHeightWithString:(NSString *)textString Font:(UIFont *)textFont Size:(CGSize)size;

/**
 *  获取API完整URL路径
 *
 *  @param urlString URL
 *
 *  @return 完整APIURL路径
 */
+ (NSString *)GetBaseURL:(NSString *)urlString;

/**
 *  获取Img完整URL路径
 *
 *  @param urlString URL
 *
 *  @return 完整ImgURL路径
 */
+ (NSString *)GetImgBaseURL:(NSString *)urlString;

/**
 *  修改图片大小
 */
+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size;

///// 手机号码的有效性判断
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;


// 一个时间距现在的时间
+ (NSString *)intervalSinceNow: (NSString *) theDate;

// 判断字符串不为空的方法
+ (BOOL) isNotBlankString:(NSString *)string;

@end
