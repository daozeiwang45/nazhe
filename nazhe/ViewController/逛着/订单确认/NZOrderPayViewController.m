//
//  NZOrderPayViewController.m
//  nazhe
//
//  Created by WSGG on 15/10/8.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"


@interface NZOrderPayViewController ()

//是否选种余额支付
@property (nonatomic,assign)BOOL isSelectBlance;
//是否选中支付宝支付
@property (nonatomic,assign)BOOL isSelectApipay;
//是否余额够支付
@property (nonatomic,assign)int isEnough;

@end

@implementation NZOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"支付订单"];
    [self leftButtonTitle:nil];
    
    [self initView];
}

#pragma mark  初始化
-(void)initView{
    
    self.orderPayButton.backgroundColor = darkRedColor;
    self.orderPayButton.layer.cornerRadius = 2;
    self.orderPayButton.layer.masksToBounds = YES;
    
    self.isSelectBlance = NO;
    self.isSelectApipay = NO;
    self.isEnough = 0;
    
    //给页面元素赋值
    self.orderNumberLab.text = self.orderNumberStr;
    self.payPriceLab.text = [NSString stringWithFormat:@"￥%.2f",self.orderTotalPrice-self.orderDiscountPrice];
    self.totalPriceLab.text = [NSString stringWithFormat:@"￥%.2f",self.orderTotalPrice];
    self.myBalanceLab.text = self.myBalanceStr;
    self.moreMyBalanceLab.hidden = YES;
    
    //看是否金额足够否
    if ([self.myBalanceStr floatValue] >= (self.orderTotalPrice-self.orderDiscountPrice)) {
        
        self.isEnough = 1;
    }else{
        
        self.isEnough = 2;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"33333333333";
    
    return cell;
}
- (IBAction)payMomeyWithBlanceActon:(id)sender {
    
    //看是否有没选中
    if (self.isSelectBlance == NO) {
        //看是否足够支付
        if (self.isEnough == 2) {

            self.moreMyBalanceLab.hidden = NO;
            self.moreMyBalanceLab.text = [NSString stringWithFormat:@"还需支付:%.2f",(self.orderTotalPrice-self.orderDiscountPrice)-[self.myBalanceStr floatValue]];
            
            [self.payMomeyWithAlipayButton setBackgroundImage:[UIImage imageNamed:@"红圈"] forState:UIControlStateNormal];
            self.isSelectApipay = YES;
            
        }else{
           
            [self.payMomeyWithAlipayButton setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
            self.isSelectApipay = NO;

        }
        
        [self.payMomeyWithBlanceButton setBackgroundImage:[UIImage imageNamed:@"红圈"] forState:UIControlStateNormal];
        self.isSelectBlance = YES;
        
    }else{
        
        self.moreMyBalanceLab.hidden = YES;
        [self.payMomeyWithBlanceButton setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
        self.isSelectBlance = NO;
    }
    
    

}


- (IBAction)payMomeyWithAlipayActon:(id)sender {
    
    //金额要是不足并且有选余额支付  该按钮为选中状态
    
    if (self.isEnough ==2 && self.isSelectBlance == YES) {
        
        //不操作
        
    }else{
        
        if (self.isSelectApipay == NO) {
            
            [self.payMomeyWithBlanceButton setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
            self.isSelectBlance = NO;
            
            [self.payMomeyWithAlipayButton setBackgroundImage:[UIImage imageNamed:@"红圈"] forState:UIControlStateNormal];
            self.isSelectApipay = YES;
        }else{
            
            [self.payMomeyWithAlipayButton setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
            self.isSelectApipay = NO;
        }

    }
    
}

#pragma mark   ---支付按钮
- (IBAction)orderPayAction:(id)sender {
    
    if (self.isSelectApipay == YES) {
        
        [self payMoneyAction];
    }
}

-(void)payMoneyAction{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021757690380";
    NSString *seller = @"27147142@qq.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALCfU/CPE/J7nUEt\r\nWcqtEJMP/kEl1rs3C00PraSugiIT7iije19FXEPfzve7hAcAiT8MlvDIkFumslPJ\r\n6hdaOoi7ha0G0919eYwh1CQJUmpAT5fCdE/ZRoPYJcI6zCCvvm0MjE7rnoqbc1XH\r\nDqiVDYn/BgJM/hgBwX+XSJ71vns3AgMBAAECgYEAinP7awHd0yGPvj38u2I7Me1B\r\nlHRDBfM6SqhVqFib7nbNJNIyrhZDI3nYVl6KOqry65fE4u92KkJcXE5V0QSMCMHp\r\n/S4U/KmJeKZ3cT3NP3EtoeaabJSKDABE+DsRcqWYpJq+wDX6QI/wpaOe+C5qTUyS\r\n9ufK9QjtNE2qyKCuBHECQQDaNMMHEM2rr3ABR3OAJ7cK0k2DpRCe/sc/85CdbjRv\r\nlJ9K1bWQHV5i0UeU07UbJ2GI1cc7VH4cFPVmo72aYz7VAkEAzza/XRV/d6pEY//4\r\nIuHIGIhOo6UvG40wHs3DOssiFRz3Y2WjsE3YL5Pn2F9jY5ADIlePR24y6u9WLrH7\r\n+qRP2wJAQ7m+kpHXlCMGm48GvU8WU+iEIIj6CK9BPoslZoePBNbXPg3opYtIAVm9\r\nYub2vi/R6PuZM8P8xFCI/ktyDNoi5QJAc7ItxttqAHahGPSip1dJUelJfzWLx+Zd\r\nJ9XbW8hvjzpNJsJpUtckDeyXVshrxftyxIn/BfMRmvtnM0tNVfTIYQJAQ1Hg3H//\r\nfDxTgyGgVkO+wpcfR1NKlFRXGRl17cgbsBDot841+xlsv6fbD0YYuhf4bSzHaJwv\r\nu2xlp23pyPXF0A==";
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"爱若"; //商品标题
    order.productDescription = @"好东西"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",self.orderTotalPrice-self.orderDiscountPrice]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            //支付返回的结果---------
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }

    
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
