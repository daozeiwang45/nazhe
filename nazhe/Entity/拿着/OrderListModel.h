//
//  OrderListModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/23.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject

/**
 *  总页数
 */
@property (nonatomic, assign) int total;
/**
 *  当前页
 */
@property (nonatomic, assign) int page_count;
/**
 *  订单数组(OrderInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface OrderInfoModel : NSObject

/**
 *  年份
 */
@property (nonatomic, assign) int year;
/**
 *  月份
 */
@property (nonatomic, assign) int month;
/**
 *  日期
 */
@property (nonatomic, copy) NSString *date;
/**
 *  商品数组(GoodsInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *goods;
/**
 *  订单状态
 */
@property (nonatomic, assign) int state;

/**
 * 收货人
 */
@property (nonatomic, copy) NSString *receiverName;
/**
 * 手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 * 收货地址
 */
@property (nonatomic, copy) NSString *address;
/**
 * 订单编号
 */
@property (nonatomic, copy) NSString *orderId;
/**
 * 交易号
 */
@property (nonatomic, copy) NSString *tradingNumber;
/**
 * 创建时间
 */
@property (nonatomic, copy) NSString *createDate;
/**
 * 付款时间
 */
@property (nonatomic, copy) NSString *payDate;
/**
 * 发货时间
 */
@property (nonatomic, copy) NSString *sendDate;
/**
 * 折扣金额
 */
@property (nonatomic, assign) float discountPrice;
/**
 * 实付款金额
 */
@property (nonatomic, assign) float totalPrice;

@end

@interface GoodsInfoModel : NSObject

/**
 * 商品id
 */
@property (nonatomic, assign) int goodID;
/**
 *  商品缩略图
 */
@property (nonatomic, copy) NSString *img;
/**
 * 商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 * 数量
 */
@property (nonatomic, assign) int count;
/**
 * 总价
 */
@property (nonatomic, assign) float price;

@end
