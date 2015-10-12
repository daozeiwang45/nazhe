//
//  NZOrderPayViewController.h
//  nazhe
//
//  Created by WSGG on 15/10/8.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZViewController.h"

@interface NZOrderPayViewController : NZViewController
@property (weak, nonatomic) IBOutlet UITableView *orderPayTable;
@property (weak, nonatomic) IBOutlet UIButton *orderPayButton;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *myBalanceLab;
@property (weak, nonatomic) IBOutlet UILabel *moreMyBalanceLab;
@property (weak, nonatomic) IBOutlet UIButton *payMomeyWithBlanceButton;
@property (weak, nonatomic) IBOutlet UIButton *payMomeyWithAlipayButton;

//订单支付信息
@property (strong, nonatomic)  NSString *orderNumberStr;
@property (assign, nonatomic)  float orderTotalPrice;
@property (assign, nonatomic)  float orderDiscountPrice;
@property (strong, nonatomic)  NSString *myBalanceStr;

@end
