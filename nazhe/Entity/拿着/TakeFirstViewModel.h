//
//  TakeFirstViewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeFirstViewModel : NSObject

/**
 *  头像
 */
@property (nonatomic, copy) NSString *headImg;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickName;
/**
 *  连续签到天数
 */
@property (nonatomic, assign) int signDays;
/**
 *  积分
 */
@property (nonatomic, assign) int integration;
/**
 *  星级
 */
@property (nonatomic, assign) int star;
/**
 *  今日收益
 */
@property (nonatomic, assign) double TodayIncome;
/**
 *  总收益
 */
@property (nonatomic, assign) double TotalIncome;
/**
 *  好友人数
 */
@property (nonatomic, assign) int CountFriend;
/**
 *  信息条数
 */
@property (nonatomic, assign) int CountMsg;
/**
 *  正在交易的订单数
 */
@property (nonatomic, assign) int CountOrder;
/**
 *  收藏夹个数
 */
@property (nonatomic, assign) int CountFavorites;
/**
 *  已点亮特权个数
 */
@property (nonatomic, assign) int CountPrivilege;
/**
 *  购物袋个数
 */
@property (nonatomic, assign) int CountshippingBage;

/**
 *  客服回复未读条数
 */
@property (nonatomic, assign) int CountNotRead;

/**
 *  获得游戏奖品个数
 */
@property (nonatomic, assign) int CountPrize;

/**
 *  当前版本数
 */
@property (nonatomic, copy) NSString *version;

@end
