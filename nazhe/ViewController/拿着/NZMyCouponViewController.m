//
//  NZMyCouponViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZMyCouponViewController.h"
#import "NZDownArrowView.h"
#import "NZMyCouponCell.h"
#import "MyCouponModel.h"

@interface NZMyCouponViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    // 未使用Button
    UIButton *unusedBtn;
    // 已使用Button
    UIButton *usedBtn;
    // arrow
    NZDownArrowView *downArrowV;
    // arrow移动标记center
    CGPoint leftCenter;
    CGPoint rightCenter;
    
    // 优享券的两种状态
    enumtMyCouponState myCouponState;
    
    // 未使用优享券数组
    NSMutableArray *unUsedArray;
    // 已使用优享券数组
    NSMutableArray *usedArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NZMyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myCouponState = enumtMyCouponState_UnUsed; // 未使用
    unUsedArray = [NSMutableArray array];
    usedArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationItemTitleViewWithTitle:@"我的优享券"];
    [self leftButtonTitle:nil];
    
    [self initInterface]; // 初始化界面
    [self requestMyCouponsData]; // 请求我的优享券数据
}

#pragma mark 初始化界面
- (void)initInterface {
    // 顶部分类按钮栏
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
    topBackView.backgroundColor = toolBarColor;
    [self.view addSubview:topBackView];
    
    // 中间竖线
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-1)/2, 8, 1, 28)];
    centerLine.backgroundColor = [UIColor grayColor];
    [topBackView addSubview:centerLine];
    
    // 未使用
    unusedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth-1)/2, 44)];
    [unusedBtn setTitle:@"未使用" forState:UIControlStateNormal];
    [unusedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    unusedBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    unusedBtn.backgroundColor = [UIColor clearColor];
    [unusedBtn addTarget:self action:@selector(unusedClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:unusedBtn];
    
    // 已使用
    usedBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-1)/2+1, 0, (ScreenWidth-1)/2, 44)];
    [usedBtn setTitle:@"已使用" forState:UIControlStateNormal];
    [usedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    usedBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    usedBtn.backgroundColor = [UIColor clearColor];
    [usedBtn addTarget:self action:@selector(usedClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:usedBtn];
    
    // arrow
    downArrowV = [[NZDownArrowView alloc] initWithFrame:CGRectMake((unusedBtn.frame.size.width-10)/2, 33, 10, 5)];
    [topBackView addSubview:downArrowV];
    
    leftCenter = CGPointMake(unusedBtn.centerX, 35);
    rightCenter = CGPointMake(usedBtn.centerX, 35);
    
    // UITableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topBackView.frame), ScreenWidth, ScreenHeight-64-44)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (myCouponState == enumtMyCouponState_UnUsed) { // 未使用优享券
        return unUsedArray.count;
    } else if (myCouponState == enumtMyCouponState_Used) { // 已使用优享券
        return usedArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (myCouponState == enumtMyCouponState_UnUsed) { // 未使用优享券
        NZMyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:NZUnUsedCouponCellIdentify];
        if (cell == nil) {
            cell = [[NZMyCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZUnUsedCouponCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.couponInfoModel = unUsedArray[indexPath.row];
        return cell;
    } else { // 已使用优享券
        NZMyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:NZUsedCouponCellIdentify];
        if (cell == nil) {
            cell = [[NZMyCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZUsedCouponCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.couponInfoModel = usedArray[indexPath.row];
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, ScreenWidth*15/375)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    return whiteView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenWidth*110/375;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return ScreenWidth*15/375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark 未使用已使用按钮事件
- (void)unusedClick:(UIButton *)button {
    downArrowV.center = leftCenter;
    [unusedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [usedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    myCouponState = enumtMyCouponState_UnUsed;
    [_tableView reloadData];
}

- (void)usedClick:(UIButton *)button {
    downArrowV.center = rightCenter;
    [unusedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [usedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    myCouponState = enumtMyCouponState_Used;
    [_tableView reloadData];
}

#pragma mark 请求我的优享券数据
- (void)requestMyCouponsData {
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webMyCouponsList postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
         
         if( error )
         {
             [wSelf.view makeToast:@"网络错误"];
             return ;
         }
         if( retInfo == nil )
         {
             [wSelf.view makeToast:@"网络错误"];
             return ;
         }
         
         BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
         
         if( state )
         {
             MyCouponModel *myCouponModel = [MyCouponModel objectWithKeyValues:retInfo[@"result"]];
             
             for (MyCouponInfoModel *couponInfoModel in myCouponModel.list) {
                 if (couponInfoModel.state == 0) {
                     [unUsedArray addObject:couponInfoModel];
                 } else {
                     [usedArray addObject:couponInfoModel];
                 }
             }
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
    
}

@end
