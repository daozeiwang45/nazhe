//
//  NZNewProductViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZNewProductViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *leftNameLabel;
@property (nonatomic, strong) UILabel *leftPriceLabel;
@property (nonatomic, strong) UILabel *rightNameLabel;
@property (nonatomic, strong) UILabel *rightPriceLabel;

// 新品CLUB 和 立即抢购的图标对应不同的界面切换显示
@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView *rightIcon;
@property (nonatomic, strong) UIImageView *leftGrabIcon;
@property (nonatomic, strong) UIImageView *rightGrabIcon;

// 设置新品club或者立即抢购的图标隐藏
@property (nonatomic, assign) enumtNewClubOrBuyNow newOrBuy;

@end
