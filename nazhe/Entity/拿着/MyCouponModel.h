//
//  MyCouponModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCouponModel : NSObject

/**
 *  总页数
 */
@property (nonatomic, assign) int total;
/**
 *  当前页
 */
@property (nonatomic, assign) int page_count;
/**
 *  我的优享券数组(MyCouponInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface MyCouponInfoModel : NSObject

/**
 *  状态（0:正常,1:已过期,2:已使用）
 */
@property (nonatomic, assign) int state;
/**
 *  类型
 */
@property (nonatomic, copy) NSString *type;
/**
 *  面值
 */
@property (nonatomic, assign) float money;
/**
 *  满多少钱使用
 */
@property (nonatomic, assign) float fullMoney;
/**
 *  品牌商图片url
 */
@property (nonatomic, copy) NSString *imgUrl;
/**
 *  还剩多少天过期
 */
@property (nonatomic, assign) int expiredDays;

@end
