//
//  GoodListModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/25.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodListModel : NSObject

/**
 *  总页数
 */
@property (nonatomic, assign) int total;
/**
 *  当前页
 */
@property (nonatomic, assign) int page_count;
/**
 *  商品数组(GoodModel)
 */
@property (nonatomic, strong) NSMutableArray *goodsList;

@end

@interface GoodModel : NSObject

/**
 *  商品ID
 */
@property (nonatomic, assign) int goodID;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *goodsName;
/**
 *  品牌英文名
 */
@property (nonatomic, copy) NSString *englishName;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *listImg;
/**
 *  是不是大图（大小图两个尺寸）
 */
@property (nonatomic, assign) int isBig;
/**
 *  品牌中文名
 */
@property (nonatomic, copy) NSString *shopName;
/**
 *  logo图片
 */
@property (nonatomic, copy) NSString *logo;

@end
