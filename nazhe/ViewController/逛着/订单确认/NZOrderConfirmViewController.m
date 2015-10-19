//
//  NZOrderConfirmViewController.m
//  nazhe
//
//  Created by WSGG on 15/9/25.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderConfirmViewController.h"
#import "NZDeliveryAddressViewController.h"
#import "NZOrderPayViewController.h"


@interface NZOrderConfirmViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong)NSDictionary *addressDict;
@property (nonatomic,strong)NSDictionary *orderPayDict;

@end

@implementation NZOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavigationItemTitleViewWithTitle:@"订单确认"];
    [self leftButtonTitle:nil];
    
    [self creteInitValue];
}

#pragma mark 上个页面传下来的信息
-(void)creteInitValue{
    
    [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:self.orderGoodImgView]] placeholderImage:defaultImage];
    self.goodName.text = self.orderGoodName;
    self.goodPrice.text = self.orderGoodPrice;
    self.goodNum.text = self.orderGoodNum;
    self.goodAllNum.text = self.orderGoodAllNum;
    self.goodAllPrice.text = self.orderGoodAllPrice;
    
    [self.orderConfirmTable reloadData];

}

#pragma mark  地址信息赋值
-(void)initView{
    
    self.payMomeyButton.backgroundColor = darkRedColor;
    self.payMomeyButton.layer.cornerRadius = 2;
    self.payMomeyButton.layer.masksToBounds = YES;
    
    self.userName.text = [self.addressDict objectForKey:@"name"];
    self.userPhoneNumber.text = [self.addressDict objectForKey:@"phone"];
    self.userAddress.text = [self.addressDict objectForKey:@"addressDetail"];
//    if () {
//        <#statements#>
//    }
    NSNumber *numHeight = [self calculateHightWithText:self.userAddress.text];
    self.addressHeight.constant = [numHeight floatValue];
}

-(void)loadData{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 
                                 @"userId":user.userId,
                                 @"token":@""
                                 
                                 };
    NSString *webGoodParameters = @"Goods/BuyNow";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
             NSArray *infoArry = [retInfo objectForKey:@"addressInfo"];
             if (infoArry.count!=0) {
                 
                 self.addressDict = [[retInfo objectForKey:@"addressInfo"]objectAtIndex:0];
                 NSLog(@"########---%@",self.addressDict);
                 //数据请求完-------初始化页面
                 [self initView];

             }
             
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;

}

-(void)loadDataOrderPay{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"goodsId":[NSNumber numberWithInt:53],
                                 @"count":[NSNumber numberWithInt:self.goodPayNum],
                                 @"totalPrice":[NSNumber numberWithFloat:self.goodPayPrice],
                                 @"expressPrice":[NSNumber numberWithInt:10],
                                 @"size":self.sizeStr,
                                 @"weight":self.weightStr,
                                 @"grade":self.gradeStr,
                                 @"color":self.colorStr,
                                 @"hardness":self.hardnessStr,
                                 @"fillIn":self.fillInStr,
                                 @"accessories":self.accessoriesStr,
                                 @"pack":self.packStr,
                                 @"ReceiverName":self.userName.text,
                                 @"Address":self.userAddress.text,
                                 @"ZipCode":@"361000",
                                 @"Phone":self.userPhoneNumber.text,
                                 @"Remarks":self.userMessage.text
                                 
                                 };
    NSString *webGoodParameters = @"Goods/ConfirmPay";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
             
             self.orderPayDict = retInfo;
             NSLog(@"#####FFFF###---%@",self.orderPayDict);
             _orderPayViewCtr.orderTotalPrice = [[self.orderPayDict objectForKey:@"totalPrice"] floatValue];
             _orderPayViewCtr.orderNumberStr = [self.orderPayDict objectForKey:@"orderId"];
             _orderPayViewCtr.orderDiscountPrice = [[self.orderPayDict objectForKey:@"discountPrice"] floatValue];
             _orderPayViewCtr.myBalanceStr = [self.orderPayDict objectForKey:@"myBalance"];
             
             [self.navigationController pushViewController:_orderPayViewCtr animated:YES];

         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
    
}


//计算地址高度
-(NSNumber *)calculateHightWithText:(NSString *)textString{
    
    //设置表格单元兰高度
    UILabel *hightLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 200, 30)];
        hightLb.font = [UIFont systemFontOfSize:17];
    hightLb.numberOfLines = 0;
    hightLb.lineBreakMode = NSLineBreakByWordWrapping;
    hightLb.text = textString;
    
    CGSize sizeHight = [hightLb sizeThatFits:CGSizeMake(ScreenWidth-180, MAXFLOAT)];
    NSNumber *numHeight = [NSNumber numberWithFloat:sizeHight.height+5];
    return numHeight;
    
}

#pragma mark  表格代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"";
    
    return cell;
}

- (IBAction)modifyAddressAction:(UIButton *)sender {
    
    NZDeliveryAddressViewController *addressVCTR = [[NZDeliveryAddressViewController alloc] init];
    //    addressVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVCTR animated:YES];
}
- (IBAction)payMomeyButtonAction:(UIButton *)sender {
    
    if (self.addressDict == nil) {
        
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收货地址不能为空，请添加收货地址！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];

        
    }else{
        
        _orderPayViewCtr = [[NZOrderPayViewController alloc] initWithNibName:@"NZOrderPayViewController" bundle:nil];
        //做生成订单网络请求
        [self loadDataOrderPay];
    }
    
   
}

#pragma mark alertView  代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NZDeliveryAddressViewController *addressVCTR = [[NZDeliveryAddressViewController alloc] init];
        //    addressVCTR.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressVCTR animated:YES];

    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    //加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
