//
//  NZOrderSelectedViewController.h
//  nazhe
//
//  Created by WSGG on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZViewController.h"

@interface NZOrderSelectedViewController : NZViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *goodNameLab;

@property (weak, nonatomic) IBOutlet UILabel *goodPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *goodNumLab;


@property (weak, nonatomic) IBOutlet UITableView *orderSelectedTable;


@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet UIButton *addShopButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (strong, nonatomic) UIView *selectedView;
@property (strong, nonatomic) UIView *selectedAllView;


@property (nonatomic, assign) int goodID; // 商品ID
//订单信息---用于网络请求参数
//@property (assign, nonatomic)float goodPayPrice;
//快递费
@property (assign, nonatomic)float expressPrice;
//订单产品参数
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

@end
