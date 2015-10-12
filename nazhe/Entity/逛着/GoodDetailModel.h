//
//  GoodDetailModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

/**
 *  商品ID
 */
@property (nonatomic, assign) int goodID;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *goodsName;
/**
 *  商品编号
 */
@property (nonatomic, copy) NSString *GoodsNumber;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *DetailImg;

/**
 *  品牌中文名
 */
@property (nonatomic, copy) NSString *shopName;
/**
 *  商品参数
 */
@property (nonatomic, copy) NSString *Parameter;
/**
 *  商品喜欢数
 */
@property (nonatomic, assign) int TotalLike;
/**
 *  商品收藏数
 */
@property (nonatomic, assign) int TotalCollection;
/**
 *  商品销量
 */
@property (nonatomic, assign) int Sales;
/**
 *  市场价
 */
@property (nonatomic, assign) float MarketPrice;

@end

@interface UserStateModel : NSObject

/**
 *  是否喜欢
 */
@property (nonatomic, assign) BOOL isLike;
/**
 *  是否收藏
 */
@property (nonatomic, assign) BOOL isCollect;

@end

@interface NextGoodModel : NSObject

/**
 *  下一个商品名
 */
@property (nonatomic, copy) NSString *nextOneName;
/**
 *  下一个商品ID
 */
@property (nonatomic, assign) int nextId;

@end

@interface LastGoodModel : NSObject

/**
 *  上一个商品名
 */
@property (nonatomic, copy) NSString *lastOneName;
/**
 *  上一个商品ID
 */
@property (nonatomic, assign) int lastId;

@end

@interface GoodDetailModel : NSObject

/**
 *  商品详情数据
 */
@property (nonatomic, strong) DetailModel *goodsDetail;
/**
 *  商品评论数组(EvaluationModel)
 */
@property (nonatomic, strong) NSMutableArray *goodsEvaluation;
/**
 *  用户对当前商品的点赞评论状态
 */
@property (nonatomic, strong) UserStateModel *userState;
/**
 *  评论数
 */
@property (nonatomic, assign) int evaluationCount;
/**
 *  下一个商品
 */
@property (nonatomic, strong) NextGoodModel *nextOne;
/**
 *  上一个商品
 */
@property (nonatomic, strong) LastGoodModel *lastOne;

@end



@interface EvaluationModel : NSObject

/**
 *  评论用户名
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  评论星级
 */
@property (nonatomic, assign) int star;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  评论日期
 */
@property (nonatomic, copy) NSString *CTDATE;

@end


