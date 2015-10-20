//
//  NZChangeAddressViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/20.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZChangeAddressViewController.h"
#import "NZChangeAddressViewCell.h"
#import "NZChangeAddressViewModel.h"

@interface NZChangeAddressViewController ()<UITableViewDataSource, UITableViewDelegate> {
    MyDeliveryAddressModel *myDeliveryAddressModel; // 收货地址列表数据模型
    NSMutableArray *changeAddressVMArray; // 更换收货地址视图模型
    
    int pageNo; // 地址请求页码
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NZChangeAddressViewController

// 初始化数据
- (instancetype)init {
    self = [super init];
    if (self) {
        changeAddressVMArray = [NSMutableArray array];
        pageNo = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationItemTitleViewWithTitle:@"更换收货地址"];
    [self leftButtonTitle:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, ScreenWidth*30/375, ScreenWidth-ScreenWidth*50/375, ScreenHeight-ScreenWidth*40/375)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self requestMyAddressListData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return changeAddressVMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NZChangeAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZChangeAddressCellIdentify];
    if (cell == nil) {
        cell = [[NZChangeAddressViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZChangeAddressCellIdentify];
    }
    
    NZChangeAddressViewModel *changeAddressVM = changeAddressVMArray[indexPath.row];
    cell.changeAddressVM = changeAddressVM;
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZChangeAddressViewModel *changeAddressVM = changeAddressVMArray[indexPath.row];
    
    return CGRectGetMaxY(changeAddressVM.lineFrame);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark 请求收货地址列表
- (void)requestMyAddressListData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"page_no":[NSNumber numberWithInt:pageNo]
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
             myDeliveryAddressModel = [MyDeliveryAddressModel objectWithKeyValues:retInfo[@"result"]];
             
             int i = 0;
             for (MyDeliveryAddressInfoModel *model in myDeliveryAddressModel.list) {
                 
                 model.addressID = [retInfo[@"result"][@"list"][i][@"id"] intValue];
                 
                 NZChangeAddressViewModel *changeVM = [[NZChangeAddressViewModel alloc] init];
                 changeVM.myAddressInfoModel = model;
                 
                 [changeAddressVMArray addObject:changeVM];
                 
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
