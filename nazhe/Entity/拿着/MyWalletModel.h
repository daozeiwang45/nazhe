//
//  MyWalletModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWalletModel : NSObject

/**
 *  排名
 */
@property (nonatomic, assign) int ranking;
/**
 *  当前账户总额（元）
 */
@property (nonatomic, assign) float totalAccount;
/**
 *  总收益（元）
 */
@property (nonatomic, assign) float totalIncome;
/**
 *  新收益（元）
 */
@property (nonatomic, assign) float todayIncome;
/**
 *  固定账户（元）
 */
@property (nonatomic, assign) float fixedAccount;
/**
 *  活动账户（元）
 */
@property (nonatomic, assign) float currentAccount;
/**
 *  我的积分
 */
@property (nonatomic, assign) int integration;
/**
 *  我的优享券
 */
@property (nonatomic, assign) int countTicket;

@end
