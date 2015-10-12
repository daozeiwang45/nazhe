//
//  NZOrderConfirmViewController.h
//  nazhe
//
//  Created by WSGG on 15/9/25.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZViewController.h"
@class NZOrderPayViewController;

@interface NZOrderConfirmViewController : NZViewController

@property (weak, nonatomic) IBOutlet UITableView *orderConfirmTable;

@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodNum;
@property (weak, nonatomic) IBOutlet UILabel *goodAllNum;
@property (weak, nonatomic) IBOutlet UILabel *userAddress;
@property (weak, nonatomic) IBOutlet UITextField *userMessage;
@property (weak, nonatomic) IBOutlet UILabel *goodAllPrice;
@property (weak, nonatomic) IBOutlet UIButton *payMomeyButton;

@property (strong,nonatomic)NZOrderPayViewController *orderPayViewCtr;

//订单信息---用于界面显示
@property (strong, nonatomic)NSString *orderGoodImgView;
@property (strong, nonatomic)NSString *orderGoodName;
@property (strong, nonatomic)NSString *orderGoodPrice;
@property (strong, nonatomic)NSString *orderGoodNum;
@property (strong, nonatomic)NSString *orderGoodAllNum;
@property (strong, nonatomic)NSString *orderGoodAllPrice;

//订单信息---用于网络请求参数
@property (assign, nonatomic)float goodPayPrice;
@property (assign, nonatomic)int goodPayNum;
//订单产品参数
@property (nonatomic, assign) int goodID; // 商品ID
//重量
@property (nonatomic,strong)NSString *weightStr;
//尺寸
@property (nonatomic,strong)NSString *sizeStr;
//等级
@property (nonatomic,strong)NSString *gradeStr;
//硬度
@property (nonatomic,strong)NSString *hardnessStr;
//镶嵌
@property (nonatomic,strong)NSString *fillInStr;
//配饰
@property (nonatomic,strong)NSString *accessoriesStr;
//颜色
@property (nonatomic,strong)NSString *colorStr;
//包装
@property (nonatomic,strong)NSString *packStr;

//地址
//@property (strong, nonatomic)NSString *orderUserName;
//@property (strong, nonatomic)NSString *orderUserPhoneNumber;
//@property (strong, nonatomic)NSString *orderUserAddress;
//@property (strong, nonatomic)NSString *orderUserMessage;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;

@end
