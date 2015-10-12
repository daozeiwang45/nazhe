//
//  NZUser.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZUser : NSObject

/**@brief 用户id */
@property (nonatomic , strong) NSString * userId ;
/**@brief 登陆凭证*/
@property (nonatomic , strong) NSString *token ;

/**@brief 用户推送token*/
@property (nonatomic , strong) NSString * pushToken ;
/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *phone;

- (void) clear ;

@end

@interface NZRegistInformation : NSObject

/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
/**
 *  验证码
 */
@property (nonatomic, copy) NSString *code;
/**
 *  推荐人手机号
 */
@property (nonatomic, copy) NSString *recommendPhone;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickName;
/**
 *  性别（男、女）
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  生日（年月日）
 */
@property (nonatomic, copy) NSString *birthday;
/**
 *  省份
 */
@property (nonatomic, copy) NSString *province;
/**
 *  城市
 */
@property (nonatomic, copy) NSString *city;
/**
 *  故乡
 */
@property (nonatomic, copy) NSString *hometown;
/**
 *  职业
 */
@property (nonatomic, copy) NSString *job;
/**
 *  真实姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  收货地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  头像（）
 */
@property (nonatomic, readwrite) NSData *headImg;
/**
 *  推送token
 */
@property (nonatomic, copy) NSString *pushToken;

- (void) clear ;

@end
