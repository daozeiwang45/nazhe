//
//  BillingRecordModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillingCountModel : NSObject
/**
 *  充值次数
 */
@property (nonatomic, assign) int countRecharge;
/**
 *  消费次数
 */
@property (nonatomic, assign) int countBuy;
/**
 *  提现次数
 */
@property (nonatomic, assign) int countCash;
/**
 *  积分消费次数
 */
@property (nonatomic, assign) int countScore;
/**
 *  卡券次数
 */
@property (nonatomic, assign) int countCoupons;

@end

@interface BillingRecordModel : NSObject

/**
 *  总页数
 */
@property (nonatomic, assign) int total;
/**
 *  当前页
 */
@property (nonatomic, assign) int page_count;
/**
 *  账单数组(BillingRecordInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end


@interface BillingRecordInfoModel : NSObject

/**
 *  时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  金额
 */
@property (nonatomic, assign) float money;
/**
 *  说明
 */
@property (nonatomic, copy) NSString *info;
/**
 *  1.充值(0:充值流动账户,1:充值固定账户)
 *  2.消费(0:打赏出去,1:得到打赏)
 *  3.提现(0:待审核,1:已提现)
 *  4.积分(0:获得积分,1:扣除积分)
 *  5.卡券(0:正常,1:已过期,2:已使用)
 */
@property (nonatomic, assign) int state;

@end
