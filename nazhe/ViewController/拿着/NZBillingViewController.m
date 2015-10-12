//
//  NZBillingViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZBillingViewController.h"
#import "NZBillingViewCell.h"
#import "BillingRecordModel.h"

@interface NZBillingViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    enumtBillRecordState billRecordState; // 账单种类
    BillingRecordModel *billRecordModel; // 账单纪录数据
    NSMutableDictionary *billDictionary; // 当前种类账单字典（要区分年份为key值）
}

@property (strong, nonatomic) IBOutlet UIView *moveView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moveViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moveViewRight;

@property (strong, nonatomic) IBOutlet UILabel *countRechageLab;
@property (strong, nonatomic) IBOutlet UILabel *countBuyLab;
@property (strong, nonatomic) IBOutlet UILabel *countCashLab;
@property (strong, nonatomic) IBOutlet UILabel *countScoreLab;
@property (strong, nonatomic) IBOutlet UILabel *countCouponsLab;


- (IBAction)selectAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moveViewLeft;

@end

@implementation NZBillingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    billRecordState = enumtBillRecordState_Recharge; // 充值
    billDictionary = [NSMutableDictionary dictionary];
    
    [self createNavigationItemTitleViewWithTitle:@"账单纪录"];
    [self leftButtonTitle:nil];
    
    _moveViewTop.constant = 64 + ScreenWidth*15/375;
    _moveViewLeft.constant = ScreenWidth*25/375;
    _moveViewRight.constant = ScreenWidth*25/375;
    
    _moveView.backgroundColor = darkGoldColor;
    UILabel *label1 = (UILabel *)[self.view viewWithTag:1];
    label1.textColor = goldColor;
    UILabel *label2 = (UILabel *)[self.view viewWithTag:6];
    label2.textColor = darkGoldColor;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIDefaultBackgroundColor;
    
    [self requestBillOrderDataWith:0]; // 请求充值账单数据
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [billDictionary allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [billDictionary allKeys][section];
    
    NSArray *ary = [billDictionary objectForKey:key];
    
    return ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NZBillingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZBillingViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NZBillingViewCell" owner:self options:nil] lastObject] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *key = [billDictionary allKeys][indexPath.section];
    
    NSArray *ary = [billDictionary objectForKey:key];
    
    NSDictionary *dic = ary[indexPath.row];
    
    cell.dateLab.text = [dic objectForKey:@"date"];
    cell.timeLab.text = [dic objectForKey:@"time"];
    
    CGFloat money = [[dic objectForKey:@"money"] floatValue];
    cell.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",money];
    
    cell.fromLab.text = [dic objectForKey:@"info"];
    
    if (billRecordState == enumtBillRecordState_Recharge) {
        
        cell.typeLab.text = @"充值金额";
        
    } else if (billRecordState == enumtBillRecordState_Buy) {
        
        cell.typeLab.text = @"消费金额";
        
    } else if (billRecordState == enumtBillRecordState_Cash) {
        
        cell.typeLab.text = @"提现金额";
        
    } else if (billRecordState == enumtBillRecordState_Score) {
        
        int state = [[dic objectForKey:@"state"] intValue];
        if (state == 0) {
            cell.typeLab.text = @"获得积分";
        } else if (state == 1) {
            cell.typeLab.text = @"消耗积分";
        }
        
    } else if (billRecordState == enumtBillRecordState_Coupons) {
        
        int state = [[dic objectForKey:@"state"] intValue];
        if (state == 0) {
            cell.typeLab.text = @"获得优享券";
        } else {
            cell.typeLab.text = @"使用优享券";
        }
    }
        
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *yearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    yearView.backgroundColor = [UIColor whiteColor];
    
    NSString *key = [billDictionary allKeys][section];
    UILabel *yearLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    yearLab.text = key;
    yearLab.textColor = [UIColor grayColor];
    yearLab.font = [UIFont systemFontOfSize:17.f];
    [yearView addSubview:yearLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(65, 19.5, ScreenWidth-85, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [yearView addSubview:lineView];
    
    return yearView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark 请求账单数据
- (void)requestBillOrderDataWith:(int)type {
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSString *typeStr = [NSString stringWithFormat:@"%d",type];
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"type":typeStr
                                 } ;
    
    [handler postURLStr:webBillRecord postDic:parameters
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
             billRecordModel = [BillingRecordModel objectWithKeyValues:retInfo[@"result"]];
             
             if (type == 0) {
                 BillingCountModel *billCountModel = [BillingCountModel objectWithKeyValues:retInfo];
                 
                 _countRechageLab.text = [NSString stringWithFormat:@"%d",billCountModel.countRecharge];
                 
                 _countBuyLab.text = [NSString stringWithFormat:@"%d",billCountModel.countBuy];
                 
                 _countCashLab.text = [NSString stringWithFormat:@"%d",billCountModel.countCash];
                 
                 _countScoreLab.text = [NSString stringWithFormat:@"%d",billCountModel.countScore];
                 
                 _countCouponsLab.text = [NSString stringWithFormat:@"%d",billCountModel.countCoupons];
             }
             
             [billDictionary removeAllObjects];
             
             for (int i=0; i<billRecordModel.list.count; i++) {
                 BillingRecordInfoModel *model = billRecordModel.list[i];
                 NSString *yearStr = [model.time substringWithRange:NSMakeRange(0, 4)];
                 
                 NSDictionary *dic = @{
                                       @"info":model.info,
                                       @"money":[NSNumber numberWithFloat:model.money],
                                       @"date":[model.time substringWithRange:NSMakeRange(5, 5)],
                                       @"time":[model.time substringWithRange:NSMakeRange(11, 5)],
                                       @"state":[NSNumber numberWithInt:model.state]
                                       };
                 
                 if([[billDictionary allKeys] containsObject:yearStr]) {
                     
                     NSMutableArray *array = [billDictionary objectForKey:yearStr];
                     
                     [array addObject:dic];
                     
                     [billDictionary setObject:array forKey:yearStr];
                     
                 } else {
    
                     
                     
                     NSMutableArray *array = [NSMutableArray arrayWithObject:dic];
                     
                     [billDictionary setObject:array forKey:yearStr];
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


// 顶部浮动条点击
- (IBAction)selectAction:(UIButton *)sender {
    int btnTag = (int)sender.tag;
    switch (btnTag) {
        case 101: {
            [UIView animateWithDuration:0.2f animations:^{
                _moveView.center = CGPointMake((ScreenWidth-ScreenWidth*50/375)/10, 2.5);
            }];
            
            for (int i = 1; i < 11; i++) {
                UILabel *label = (UILabel *)[self.view viewWithTag:i];
                if (i == 1 || i == 6) {
                    label.textColor = darkGoldColor;
                } else {
                    label.textColor = [UIColor grayColor];
                }
            }
            
            billRecordState = enumtBillRecordState_Recharge;
            [self requestBillOrderDataWith:0]; // 请求充值账单纪录
            [_tableView reloadData];
        }
            break;
        case 102: {
            [UIView animateWithDuration:0.2f animations:^{
                _moveView.center = CGPointMake((ScreenWidth-ScreenWidth*50/375)*3/10, 2.5);
            }];
            
            for (int i = 1; i < 11; i++) {
                UILabel *label = (UILabel *)[self.view viewWithTag:i];
                if (i == 2 || i == 7) {
                    label.textColor = darkGoldColor;
                } else {
                    label.textColor = [UIColor grayColor];
                }
            }
            
            billRecordState = enumtBillRecordState_Buy;
            [self requestBillOrderDataWith:1]; // 请求消费账单纪录
            [_tableView reloadData];
        }
            break;
        case 103: {
            [UIView animateWithDuration:0.2f animations:^{
                _moveView.center = CGPointMake((ScreenWidth-ScreenWidth*50/375)*5/10, 2.5);
            }];
            
            for (int i = 1; i < 11; i++) {
                UILabel *label = (UILabel *)[self.view viewWithTag:i];
                if (i == 3 || i == 8) {
                    label.textColor = darkGoldColor;
                } else {
                    label.textColor = [UIColor grayColor];
                }
            }
            
            billRecordState = enumtBillRecordState_Cash;
            [self requestBillOrderDataWith:2]; // 请求提现账单纪录
            [_tableView reloadData];
        }
            break;
        case 104: {
            [UIView animateWithDuration:0.2f animations:^{
                _moveView.center = CGPointMake((ScreenWidth-ScreenWidth*50/375)*7/10, 2.5);
            }];
            
            for (int i = 1; i < 11; i++) {
                UILabel *label = (UILabel *)[self.view viewWithTag:i];
                if (i == 4 || i == 9) {
                    label.textColor = darkGoldColor;
                } else {
                    label.textColor = [UIColor grayColor];
                }
            }
            
            billRecordState = enumtBillRecordState_Score;
            [self requestBillOrderDataWith:3]; // 请求积分账单纪录
            [_tableView reloadData];
        }
            break;
        case 105: {
            [UIView animateWithDuration:0.2f animations:^{
                _moveView.center = CGPointMake((ScreenWidth-ScreenWidth*50/375)*9/10, 2.5);
            }];
            
            for (int i = 1; i < 11; i++) {
                UILabel *label = (UILabel *)[self.view viewWithTag:i];
                if (i == 5 || i == 10) {
                    label.textColor = darkGoldColor;
                } else {
                    label.textColor = [UIColor grayColor];
                }
            }
            
            billRecordState = enumtBillRecordState_Coupons;
            [self requestBillOrderDataWith:4]; // 请求优享券账单纪录
            [_tableView reloadData];
        }
            break;
        default:
            break;
    }
}

@end
