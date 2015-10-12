//
//  MyProfileModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/18.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProfileModel : NSObject

/**
 *  头像url
 */
@property (nonatomic, copy) NSString *headImg;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  推荐人
 */
@property (nonatomic, copy) NSString *recommendMan;
/**
 *  星级
 */
@property (nonatomic, copy) NSString *star;
/**
 *  ID号
 */
@property (nonatomic, copy) NSString *idNum;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  所在地区
 */
@property (nonatomic, copy) NSString *province;
/**
 *  故乡
 */
@property (nonatomic, copy) NSString *hometown;
/**
 *  职业
 */
@property (nonatomic, copy) NSString *job;
/**
 *  生日
 */
@property (nonatomic, copy) NSString *birthday;
/**
 *  星座
 */
@property (nonatomic, copy) NSString *constellation;
/**
 *  真实姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  身份证号
 */
@property (nonatomic, copy) NSString *idCard;
/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  个性签名
 */
@property (nonatomic, copy) NSString *signature;


@end
