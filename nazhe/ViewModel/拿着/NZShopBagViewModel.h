//
//  NZShopBagViewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopBagModel.h"

@interface NZShopBagViewModel : NSObject

@property (nonatomic, strong) ShopBagGoodModel *shopBagGoodModel;

// 规格尺寸
@property (nonatomic, assign) CGRect specificationsFrame;

// 数量尺寸
@property (nonatomic, assign) CGRect numberLabFrame;

// 编辑按钮尺寸
@property (nonatomic, assign) CGRect editBtnFrame;

// 下竖线尺寸
@property (nonatomic, assign) CGRect bottomLineFrame;

/***** expand *****/

// 向下箭头尺寸
@property (nonatomic, assign) CGRect downArrowFrame;

// 修改规格按钮尺寸
@property (nonatomic, assign) CGRect editSpeBtnFrame;

// 动态数量尺寸
@property (nonatomic, assign) CGRect dyNumberLabFrame;

// 减一尺寸
@property (nonatomic, assign) CGRect reduceBtnFrame;

// 加一尺寸
@property (nonatomic, assign) CGRect addBtnFrame;

// 取消按钮尺寸
@property (nonatomic, assign) CGRect cancelBtnFrame;

// 完成按钮尺寸
@property (nonatomic, assign) CGRect commitBtnFrame;

// 下竖线2尺寸
@property (nonatomic, assign) CGRect bottomLine2Frame;

// 下面横线尺寸
@property (nonatomic, assign) CGRect lineFrame;

@end
