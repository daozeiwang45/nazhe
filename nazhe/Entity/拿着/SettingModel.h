//
//  SettingModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/22.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

/**
 *  头像url
 */
@property (nonatomic, copy) NSString *headImg;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
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
@property (nonatomic, assign) int star;
/**
 *  ID号
 */
@property (nonatomic, copy) NSString *idNum;
/**
 *  个人资料完整度
 */
@property (nonatomic, copy) NSString *integrity;
/**
 *  地区
 */
@property (nonatomic, copy) NSString *province;
/**
 *  故乡
 */
@property (nonatomic, copy) NSString *hometown;
/**
 *  个性签名
 */
@property (nonatomic, copy) NSString *signature;
/**
 *  资料开放度
 */
@property (nonatomic, assign) int openPercent;
/**
 *  密码设置级别
 */
@property (nonatomic, copy) NSString *passwordLevel;
/**
 *  收货地址个数
 */
@property (nonatomic, assign) int countAddress;


@end
