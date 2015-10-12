//
//  NZDeliveryAddressViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZDeliveryAddressViewController.h"
#import "NZDeliveryAddressViewCell.h"
#import "MyDeliveryAddressModel.h"
#import "NZEditAddressViewController.h"

@interface NZDeliveryAddressViewController ()<UITableViewDataSource, UITableViewDelegate, NZDeliveryAddressDelegate, UIAlertViewDelegate> {
    
    
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *LeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) int defaultIndex;
@property (nonatomic, strong) MyDeliveryAddressModel *myAddressModel; // 我的收货地址数据实体

@property (nonatomic, assign) int deleteAddID; // 要删除的地址ID

@end

@implementation NZDeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItemTitleViewWithTitle:@"收货地址管理"];
    [self leftButtonTitle:nil];
    
    _topConstraint.constant = ScreenWidth * 20 / 375;
    _LeftConstraint.constant = ScreenWidth * 22 / 375;
    _rightConstraint.constant = ScreenWidth * 22 / 375;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 请求我的收货地址数据
    [self requestMyDeliveryAddress];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_myAddressModel.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZDeliveryAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZDeliveryAddressViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NZDeliveryAddressViewCell" owner:self options:nil] lastObject] ;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    
    MyDeliveryAddressInfoModel *infoModel = _myAddressModel.list[indexPath.row];
    
    cell.addressInfoModel = infoModel;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 89)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UIButton *addAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake((_tableView.frame.size.width-72)/2, 20, 72, 49)];
    [addAddressBtn setImage:[UIImage imageNamed:@"添加收货地址"] forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:addAddressBtn];
    
    return whiteView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 89.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        alertView = nil;
    } else {
        
        [self deleteAddress];
        
        alertView = nil;
    }
    
}


#pragma mark 请求我的收货地址数据
- (void)requestMyDeliveryAddress {
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webMyDeliveryAddress postDic:parameters
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
             _myAddressModel = [MyDeliveryAddressModel objectWithKeyValues:retInfo[@"result"]]; // 字典转模型
             
             int i = 0;
             for (MyDeliveryAddressInfoModel *model in _myAddressModel.list) {
                 
                 model.addressID = [retInfo[@"result"][@"list"][i][@"id"] intValue];
                 
                 if (model.isDefault) {
                     _defaultIndex = i;
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

#pragma mark 设置默认地址委托
- (void)setDefaultAddressWithIndex:(int)addID {
    if (_defaultIndex == addID) {
        return;
    }
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"id":[NSString stringWithFormat:@"%d",addID]
                                 } ;
    
    [handler postURLStr:webSetDefaultAddress postDic:parameters
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
             int i = 0;
             for (MyDeliveryAddressInfoModel *model in _myAddressModel.list) {
                 if (model.addressID == addID) {
                     _defaultIndex = i;
                     model.isDefault = YES;
                 } else {
                     model.isDefault = NO;
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

#pragma mark 删除地址委托
- (void)deleteAddressWithAddID:(int)addID {
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认要删除该收货地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.deleteAddID = addID;
    [alertview show];
}

- (void)deleteAddress {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"id":[NSString stringWithFormat:@"%d",self.deleteAddID]
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
             for (MyDeliveryAddressInfoModel *model in _myAddressModel.list) {
                 if (model.addressID == self.deleteAddID) {
                     [_myAddressModel.list removeObject:model];
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

#pragma mark 设置默认地址委托
- (void)editAddressWithIndex:(int)index {
    NZEditAddressViewController *addAddressVCTR = [[NZEditAddressViewController alloc] init];
    NSLog(@"index = %d",index);
    addAddressVCTR.addressID = index;
    addAddressVCTR.addressType = enumtAddressType_Edit;
    [self.navigationController pushViewController:addAddressVCTR animated:YES];
}

#pragma mark 跳转事件
- (void)addAddressClick:(UIButton *)button {
    NZEditAddressViewController *addAddressVCTR = [[NZEditAddressViewController alloc] init];
    addAddressVCTR.addressType = enumtAddressType_Add;
    [self.navigationController pushViewController:addAddressVCTR animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self requestMyDeliveryAddress];
}

@end
