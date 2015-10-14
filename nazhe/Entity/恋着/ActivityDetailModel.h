//
//  ActivityDetailModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/30.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

/**
 *  活动背景图
 */
@property (nonatomic, copy) NSString *img;
/**
 *  活动title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  活动主题
 */
@property (nonatomic, copy) NSString *theme;
/**
 *  活动内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  活动点赞数
 */
@property (nonatomic, assign) int countPraise;
/**
 *  活动评论数
 */
@property (nonatomic, assign) int countComment;
/**
 *  活动分享数
 */
@property (nonatomic, assign) int countShare;
/**
 *  是否赞过
 */
@property (nonatomic, assign) BOOL isPraise;

@end

@interface ActivityDetailModel : NSObject

@property (nonatomic, strong) ActivityModel *activity;
/**
 *  活动商品数组(AcGoodModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface AcGoodModel : NSObject

/**
 *  商品ID
 */
@property (nonatomic, assign) int goodID;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  市场价
 */
@property (nonatomic, assign) float marketPrice;
/**
 *  商品小标题
 */
@property (nonatomic, copy) NSString *descript;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  商品喜欢数
 */
@property (nonatomic, assign) int totalLike;
/**
 *  商品收藏数
 */
@property (nonatomic, assign) int totalCollection;
/**
 *  商品销量
 */
@property (nonatomic, assign) int sales;

@end
