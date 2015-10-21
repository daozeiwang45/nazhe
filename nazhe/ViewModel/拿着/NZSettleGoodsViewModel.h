//
//  NZSettleGoodsViewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopBagModel.h"

@interface NZSettleGoodsViewModel : NSObject

@property (nonatomic, strong) ShopBagGoodModel *shopBagGoodModel;

// 商品名称尺寸
@property (nonatomic, assign) CGRect goodNameLabFrame;

// 商品总价尺寸
@property (nonatomic, assign) CGRect priceLabFrame;

// 规格尺寸
@property (nonatomic, assign) CGRect specificationsFrame;

// 数量尺寸
@property (nonatomic, assign) CGRect numberLabFrame;

// 下竖线尺寸
@property (nonatomic, assign) CGRect bottomLineFrame;

@end
