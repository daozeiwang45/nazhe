//
//  ShopBagModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/15.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopBagModel : NSObject

/**
 *  品牌商列表数组(ShopBagBrandModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface ShopBagBrandModel : NSObject

/**
 *  品牌商编号
 */
@property (nonatomic, assign) int shopId;
/**
 *  品牌商名称
 */
@property (nonatomic, copy) NSString *shopName;
/**
 *  商品列表数组(ShopBagGoodModel)
 */
@property (nonatomic, strong) NSMutableArray *goodsList;

@end

@interface ShopBagGoodModel : NSObject

/**
 *  购物车编号
 */
@property (nonatomic, assign) int goodId;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  市场价
 */
@property (nonatomic, assign) float totalPrice;
/**
 *  描述
 */
@property (nonatomic, copy) NSString *descript;
/**
 *  数量
 */
@property (nonatomic, assign) int count;
/**
 *  是否被选中
 */
@property (nonatomic, assign) BOOL selectState;
/**
 *  运费
 */
@property (nonatomic, assign) float expressPrice;

@end