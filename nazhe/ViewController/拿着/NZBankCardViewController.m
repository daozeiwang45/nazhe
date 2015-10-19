//
//  NZBankCardViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/18.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZBankCardViewController.h"
#import "NZBankCardCell.h"
#import "BankCardModel.h"

@interface NZBankCardViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    BankCardModel *bankCardModel;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) int deleteCardID; // 删除银行卡ID

@end

@implementation NZBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItemTitleViewWithTitle:@"银行卡"];
    [self leftButtonTitle:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*45/375, 0, ScreenWidth-ScreenWidth*90/375, ScreenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self requestBankCardData]; // 请求银行卡数据
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return bankCardModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NZBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NZBankCardCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NZBankCardCell" owner:self options:nil] lastObject] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BankCardInfoModel *bankCardInfo = bankCardModel.list[indexPath.row];
    
    [cell.bankImgV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:bankCardInfo.bankIcon]] placeholderImage:defaultImage];
    
    cell.bankNameLab.text = bankCardInfo.bankName;
    
//    NSString *numberStr = [bankCardInfo.cardNumber substringFromIndex:14];
    cell.numberLab.text = [NSString stringWithFormat:@"尾号%@", bankCardInfo.cardNumber];
    
    cell.subLab.text = bankCardInfo.bankBranch;
    
    objc_setAssociatedObject(cell.deleteBtn, "cardID", [NSNumber numberWithInt:bankCardInfo.ID], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.deleteBtn addTarget:self action:@selector(deleteBankCard:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *addAddressImgV = [[UIImageView alloc] initWithFrame:CGRectMake((_tableView.frame.size.width-59)/2, 20, 59, 49)];
    addAddressImgV.image = [UIImage imageNamed:@"添加银行"];
    [whiteView addSubview:addAddressImgV];
    
    UIImageView *attentionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(23, 155, 18, 23)];
    attentionIcon.image = [UIImage imageNamed:@"注意"];
    [whiteView addSubview:attentionIcon];
    
    UILabel *attentionLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 146.5, _tableView.frame.size.width-50-15, 40)];
    attentionLab.text = @"亲～要正确填写提现的储蓄卡信息哦，以免提现失败！";
    attentionLab.textColor = [UIColor grayColor];
    attentionLab.font = [UIFont systemFontOfSize:13.f];
    attentionLab.numberOfLines = 0;
    [whiteView addSubview:attentionLab];
    
    return whiteView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 200.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        alertView = nil;
    } else {
        
        [self deleteBankCard];
        
        alertView = nil;
    }
    
}

#pragma mark 请求银行卡数据
- (void)requestBankCardData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *phoneType = @"1";
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"type":phoneType
                                 } ;
    
    [handler postURLStr:webBankCardList postDic:parameters
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
             bankCardModel = [BankCardModel objectWithKeyValues:retInfo]; // 字典转模型
             
             int i = 0;
             for (BankCardInfoModel *model in bankCardModel.list) {
                 model.ID = [retInfo[@"list"][i][@"id"] intValue];
                 
                 i ++;
             }
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 删除银行卡数据
- (void)deleteBankCard:(UIButton *)button {
    
    int cardID = [objc_getAssociatedObject(button, "cardID") intValue];
    
    self.deleteCardID = cardID;
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认要删除该银行卡吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertview show];
    
}

- (void)deleteBankCard {
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"id":[NSNumber numberWithInt:self.deleteCardID]
                                 } ;
    
    [handler postURLStr:webDeleteAddress postDic:parameters
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
             [wSelf.view makeToast:@"删除成功"];
             
             int i = 0;
             for (BankCardInfoModel *model in bankCardModel.list) {
                 if (model.ID == self.deleteCardID) {
                     [bankCardModel.list removeObject:model];
                     break;
                 }
                 i ++;
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
