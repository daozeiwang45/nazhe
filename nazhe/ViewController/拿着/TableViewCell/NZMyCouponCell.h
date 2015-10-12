//
//  NZMyCouponCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouponModel.h"

@interface NZMyCouponCell : UITableViewCell

@property(nonatomic,strong) UILabel *useTimeLab; // 使用时间
@property(nonatomic,strong) UILabel *daysLab; // 几天
@property(nonatomic,strong) UILabel *timeLab; // 还剩多久

@property(nonatomic, strong) UIImageView *usedIcon; // 已使用的标志

@property(nonatomic, strong) UIImageView *centerLine;

@property(nonatomic, strong) UILabel *moneyLab; // 优惠券价值
@property(nonatomic, strong) UIImageView *moneyIcon; // ￥标志
@property(nonatomic, strong) UILabel *conditionLab; // 使用条件
@property(nonatomic, strong) UILabel *useLab; // 就是右边竖着的，不知道取名字了

@property (nonatomic, strong) MyCouponInfoModel *couponInfoModel; // 优享券数据

@end
