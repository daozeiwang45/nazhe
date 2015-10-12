//
//  NZOrderTableViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@interface NZOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) OrderInfoModel *orderInfo; // 订单数据模型

@property (nonatomic, strong) UIImageView *imgView; // 商品图片

@property (nonatomic, strong) UILabel *nameLab; // 商品名称Label

@property (nonatomic, strong) UILabel *dateLab; // 订单日期Label

@property (nonatomic, strong) UILabel *stateLab; // 订单状态

@property (nonatomic, strong) UIButton *deleteBtn; // 删除按钮

@property (nonatomic, strong) UIButton *button2; // 右下角按钮2（根据订单状态变）

@property (nonatomic, strong) UIButton *button1; // 右下角按钮1（根据订单状态变）

@end
