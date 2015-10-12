//
//  NZOrderViewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderListModel.h"

@interface NZOrderViewModel : NSObject

@property (nonatomic, strong) OrderInfoModel *orderInfo;

// 订单详情尺寸
@property (nonatomic, assign) CGRect orderDetailFrame;

// 收货人尺寸
@property (nonatomic, assign) CGRect consigneeFrame;

// 收货地址尺寸
@property (nonatomic, assign) CGRect receivingAddressFrame;

// 订单编号尺寸
@property (nonatomic, assign) CGRect orderIDFrame;

// 交易号尺寸
@property (nonatomic, assign) CGRect tradingNumberFrame;

// 创建时间尺寸
@property (nonatomic, assign) CGRect createTimeFrame;

// 付款时间尺寸
@property (nonatomic, assign) CGRect payTimeFrame;

// 发货时间尺寸
@property (nonatomic, assign) CGRect sendTimeFrame;

// 折扣尺寸
@property (nonatomic, assign) CGRect discountFrame;

// 实付款尺寸
@property (nonatomic, assign) CGRect totalPriceFrame;

// button2尺寸
@property (nonatomic, assign) CGRect button2Frame;

// button1尺寸
@property (nonatomic, assign) CGRect button1Frame;

// line2尺寸
@property (nonatomic, assign) CGRect line2Frame;

@end
