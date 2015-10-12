//
//  NZMyWalletContentView.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZMyWalletContentView : UIView

@property (strong, nonatomic) IBOutlet UILabel *rankLab;
@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn; // 打开确认充值
@property (strong, nonatomic) IBOutlet UIButton *withdrawalsBtn; // 打开申请提现

@property (strong, nonatomic) IBOutlet UIButton *commitRechargeBtn; // 确认充值
@property (strong, nonatomic) IBOutlet UIButton *commitWithdrawalsBtn; // 申请提现

@property (strong, nonatomic) IBOutlet UIView *moveView; // 移动View
@property (strong, nonatomic) IBOutlet UIView *rechargView; // 确认充值View
@property (strong, nonatomic) IBOutlet UIView *withdrawalsView; // 申请提现View

@property (strong, nonatomic) IBOutlet UIButton *rechargeCloseBtn; // 关闭确认充值
@property (strong, nonatomic) IBOutlet UIButton *withdrawalsCloseBtn; // 关闭申请提现

@property (strong, nonatomic) IBOutlet UIButton *checkCouponBtn; // 查看我的优享券
@property (strong, nonatomic) IBOutlet UIButton *billRecordBtn; // 查看我的账单纪录

@property (strong, nonatomic) IBOutlet UILabel *totalIncomeLab; // 总收益
@property (strong, nonatomic) IBOutlet UILabel *todayIncomeLab; // 新收益
@property (strong, nonatomic) IBOutlet UILabel *fixedAccountLab; // 固定账户
@property (strong, nonatomic) IBOutlet UILabel *currentAccountLab; // 活动账户
@property (strong, nonatomic) IBOutlet UILabel *integrationLab; // 我的积分
@property (strong, nonatomic) IBOutlet UILabel *countTicketLab; // 我的优享券


@end
