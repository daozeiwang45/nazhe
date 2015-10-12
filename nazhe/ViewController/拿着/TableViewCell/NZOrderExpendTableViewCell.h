//
//  NZOrderExpendTableViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZOrderViewModel.h"

@interface NZOrderExpendTableViewCell : UITableViewCell

@property (nonatomic, strong) NZOrderViewModel *orderVM; // 视图模型

/********************   下面是一次性的  *************************/

@property (nonatomic, strong) UIImageView *imgV; // 商品图片

@property (nonatomic, strong) UILabel *nameL; // 商品名称Label

@property (nonatomic, strong) UILabel *dateL; // 订单日期Label

@property (nonatomic, strong) UILabel *countL; // 商品数量

@property (nonatomic, strong) UILabel *stateL; // 订单状态


/********************   下面是重复使用的  *************************/
@property (nonatomic, strong) UIView *imgBackView; // 商品图片外圈圆

@property (nonatomic, strong) UIImageView *imgView; // 商品图片

@property (nonatomic, strong) UILabel *nameLab; // 商品名称Label

@property (nonatomic, strong) UILabel *dateLab; // 订单日期Label

@property (nonatomic, strong) UILabel *countLab; // 商品数量

@property (nonatomic ,strong) UIView *bottomLine; // 商品图下面竖线


@property (nonatomic, strong) UIButton *takeBackBtn; // 收回按钮

@property (nonatomic, strong) UIButton *button2; // 右下角按钮2（根据订单状态变）

@property (nonatomic, strong) UIButton *button1; // 右下角按钮1（根据订单状态变）

@end
