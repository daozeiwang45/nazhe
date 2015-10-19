//
//  LoveModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoveModel : NSObject

/**
 *  轮播数组(BrandModel)
 */
@property (nonatomic, strong) NSMutableArray *activityList;
/**
 *  限时抢数组(LimitedTimeGrabModel)
 */
@property (nonatomic, strong) NSMutableArray *limitTime;
/**
 *  新品汇数组(NewGoodsModel)
 */
@property (nonatomic, strong) NSMutableArray *nGoodsList;
/**
 *  优享券数组(CouponModel)
 */
@property (nonatomic, strong) NSMutableArray *coupon;
/**
 *  星座数组(StarModel)
 */
@property (nonatomic, strong) NSMutableArray *starImgList;

@end



@interface BrandModel : NSObject

/**
 *  活动编号
 */
@property (nonatomic, assign) int brandID;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  主题
 */
@property (nonatomic, copy) NSString *theme;
/**
 *  背景图片
 */
@property (nonatomic, copy) NSString *bgImg;

@end



@interface LimitedTimeGrabModel : NSObject

/**
 *  截至时间点
 */
@property (nonatomic, copy) NSString *endTime;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  商品价格
 */
@property (nonatomic, assign) int marketPrice;
/**
 *  仅剩数量
 */
@property (nonatomic, assign) int count;

@end


@interface NewGoodsModel : NSObject

/**
 *  新品商品ID
 */
@property (nonatomic, assign) int goodID;
/**
 *  新品商品图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  新品商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  新品商品价格
 */
@property (nonatomic, assign) int marketPrice;

@end


@interface CouponModel : NSObject

/**
 *  品牌商logo
 */
@property (nonatomic, copy) NSString *logo;
/**
 *  背景图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  现金券额度
 */
@property (nonatomic, assign) int money;
/**
 *  积分
 */
@property (nonatomic, assign) int score;
/**
 *  仅剩数量
 */
@property (nonatomic, assign) int count;

@end



@interface StarModel : NSObject

/**
 *  星座图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  星座ID
 */
@property (nonatomic, assign) int starNo;
/**
 *  图片ID
 */
@property (nonatomic, assign) int starImgID;

@end
