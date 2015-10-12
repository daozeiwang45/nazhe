//
//  NZRegistFinalViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZRegistFinalViewController.h"
#import "FileDetail.h"

@interface NZRegistFinalViewController () {
    UIScrollView *scrollView;
    
    UIImageView *giftImgV; // 礼盒
    UILabel *tipLab; // 提示
    UILabel *detailTitleLab; // 订单详情
    UILabel *menberLab; // 收货人
    UILabel *addressLab; // 收货地址
    // 订单编号
    UILabel *orderNumLab;
    // 交易号
    UILabel *tradingNumLab;
    // 创建时间
    UILabel *creatingTimeLab;
    // 付款时间
    UILabel *payTimeLab;
    // 折扣
    UILabel *discountLab;
    // 实付款
    UILabel *payLab;
    UIButton *takingBtn; // 开始拿着按钮
    
    NSTimer *timer; // 定时器让弹框消失
}

@end

@implementation NZRegistFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItemTitleViewWithTitle:@"注册"];
    [self leftButtonTitle:nil];
    
    [self initInterface]; // 初始化注册界面
    [self registered]; // 注册
}

#pragma mark 初始化注册界面
- (void)initInterface {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    NZRegistInformation *registInfo = [NZUserManager sharedObject].registInfo;
    
    // 注册步骤
    UIImageView *registStepFinal = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*296/375)/2, 10, ScreenWidth*296/375, ScreenWidth*74/375)];
    registStepFinal.image = [UIImage imageNamed:@"注册条3"];
    [scrollView addSubview:registStepFinal];
    
    /***********************   礼盒   ***************************/
    giftImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*130/375)/2, CGRectGetMaxY(registStepFinal.frame)+ScreenWidth*25/375, ScreenWidth*130/375, ScreenWidth*130/375)];
    giftImgV.image = [UIImage imageNamed:@"注册成功礼盒"];
    giftImgV.backgroundColor = [UIColor clearColor];
    giftImgV.hidden = YES;
    [scrollView addSubview:giftImgV];
    
    /***********************   恭喜您获得礼品   ***************************/
    tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(giftImgV.frame)+ScreenWidth*20/375, ScreenWidth, 20)];
    tipLab.textColor = [UIColor grayColor];
    tipLab.font = [UIFont systemFontOfSize:22.f];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:tipLab];
    
    /***********************   订单详情   ***************************/
    detailTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(tipLab.frame)+ScreenWidth*20/375, ScreenWidth-ScreenWidth*160/375, 15)];
    detailTitleLab.text = @"注册有礼-订单详情";
    detailTitleLab.textColor = [UIColor grayColor];
    detailTitleLab.font = [UIFont systemFontOfSize:15.f];
    detailTitleLab.hidden = YES;
    [scrollView addSubview:detailTitleLab];
    // 收货人
    menberLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(detailTitleLab.frame)+3, ScreenWidth-ScreenWidth*160/375, 15)];
    menberLab.text = [NSString stringWithFormat:@"收货人：%@  %@",registInfo.name, registInfo.phone];
    menberLab.textColor = [UIColor grayColor];
    menberLab.font = [UIFont systemFontOfSize:13.f];
    menberLab.hidden = YES;
    [scrollView addSubview:menberLab];
    
    // 收货地址
    NSString *addressStr = [NSString stringWithFormat:@"收货地址：%@",registInfo.address];
    UIFont *font = [UIFont systemFontOfSize:13.f];
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize limitSize = CGSizeMake(ScreenWidth-ScreenWidth*160/375, MAXFLOAT);
    // 计算提问内容的尺寸
    CGSize addressSize = [addressStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    addressLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(menberLab.frame)+3, addressSize.width, addressSize.height)];
    addressLab.text = addressStr;
    addressLab.textColor = [UIColor grayColor];
    addressLab.font = [UIFont systemFontOfSize:13.f];
    addressLab.numberOfLines = 0;
    addressLab.hidden = YES;
//    addressLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:addressLab];
    
    // 订单编号
    orderNumLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(addressLab.frame)+ScreenWidth*15/375, ScreenWidth-ScreenWidth*160/375, 15)];
    orderNumLab.text = @"订单编号  115111114452";
    orderNumLab.textColor = [UIColor grayColor];
    orderNumLab.font = [UIFont systemFontOfSize:13.f];
    orderNumLab.hidden = YES;
    [scrollView addSubview:orderNumLab];
    
    // 交易号
    tradingNumLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(orderNumLab.frame)+3, ScreenWidth-ScreenWidth*160/375, 15)];
    tradingNumLab.text = @"交易号  2015082112155151155151";
    tradingNumLab.textColor = [UIColor grayColor];
    tradingNumLab.font = [UIFont systemFontOfSize:13.f];
    tradingNumLab.hidden = YES;
    [scrollView addSubview:tradingNumLab];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    // 创建时间
    creatingTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(tradingNumLab.frame)+3, ScreenWidth-ScreenWidth*160/375, 15)];
    creatingTimeLab.text = [NSString stringWithFormat:@"创建时间  %@",strDate];
    creatingTimeLab.textColor = [UIColor grayColor];
    creatingTimeLab.font = [UIFont systemFontOfSize:13.f];
    creatingTimeLab.hidden = YES;
    [scrollView addSubview:creatingTimeLab];
    
    // 付款时间
    payTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(creatingTimeLab.frame)+3, ScreenWidth-ScreenWidth*160/375, 15)];
    payTimeLab.text = [NSString stringWithFormat:@"付款时间  %@",strDate];
    payTimeLab.textColor = [UIColor grayColor];
    payTimeLab.font = [UIFont systemFontOfSize:13.f];
    payTimeLab.hidden = YES;
    [scrollView addSubview:payTimeLab];
    
    // 折扣
    discountLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(payTimeLab.frame)+ScreenWidth*15/375, ScreenWidth-ScreenWidth*160/375, 15)];
    discountLab.text = @"折扣  -￥8500.00";
    discountLab.textColor = [UIColor grayColor];
    discountLab.font = [UIFont systemFontOfSize:13.f];
    discountLab.hidden = YES;
    [scrollView addSubview:discountLab];
    
    // 实付款
    payLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*80/375, CGRectGetMaxY(discountLab.frame)+3, ScreenWidth-ScreenWidth*160/375, 15)];
    payLab.text = @"实付款  ￥0.00";
    payLab.textColor = [UIColor grayColor];
    payLab.font = [UIFont systemFontOfSize:13.f];
    payLab.hidden = YES;
    [scrollView addSubview:payLab];
    
    /***********************   开始拿着   ***************************/
    takingBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*175/375)/2, CGRectGetMaxY(payLab.frame)+ScreenWidth*30/375, ScreenWidth*175/375, ScreenWidth*40/375)];
    takingBtn.backgroundColor = darkRedColor;
    [takingBtn setTitle:@"开始拿着" forState:UIControlStateNormal];
    takingBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    takingBtn.layer.cornerRadius = 2.f;
    takingBtn.layer.masksToBounds = YES;
    takingBtn.hidden = YES;
    [takingBtn addTarget:self action:@selector(takingAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:takingBtn];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(takingBtn.frame)+ScreenWidth*100/375);
}

#pragma mark 真正把注册信息发送给服务器，注册成功
- (void)registered {
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZRegistInformation *registInfo = [NZUserManager sharedObject].registInfo;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *recomPhone;
    if (registInfo.recommendPhone) {
        recomPhone = registInfo.recommendPhone;
    } else {
        recomPhone = emptyString;
    }
    
    if (registInfo.headImg) {
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f.png", a];
        
        FileDetail *file = [FileDetail fileWithName:timeString data:registInfo.headImg];
        
        NSDictionary *params = @{
                                        @"phone":registInfo.phone,
                                        @"password":registInfo.password,
                                        @"code":registInfo.code,
                                        @"recommendPhone":recomPhone,
                                        @"nickName":registInfo.nickName,
                                        @"sex":registInfo.sex,
                                        @"birthday":registInfo.birthday,
                                        @"province":registInfo.province,
                                        @"city":registInfo.city,
                                        @"hometown":registInfo.hometown,
                                        @"job":@"互联网-iOS工程狮",
                                        @"name":registInfo.name,
                                        @"address":registInfo.address,
                                        @"pushToken":user.pushToken,
                                        @"headImg":file
                                        } ;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *result = [NZWebHandler upload:[NSString stringWithFormat:@"http://10.0.0.177:8000/app/Client/Register"] widthParams:params];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (nil == result) {
                    [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
                    tipLab.text = @"请再次注册领取奖品吧～";
                    tipLab.hidden = NO;
//                    [self.view makeToast:@"注册失败"];
                    return;
                } else if ([result[@"detail"][@"isSuccess"] isEqualToString:@"success"]) {
                    [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
                    
                    giftImgV.hidden = NO;
                    tipLab.text = @"恭喜您获得礼品！";
                    tipLab.hidden = NO;
                    detailTitleLab.hidden = NO;
                    menberLab.hidden = NO;
                    addressLab.hidden = NO;
                    orderNumLab.hidden = NO;
                    tradingNumLab.hidden = NO;
                    creatingTimeLab.hidden = NO;
                    payTimeLab.hidden = NO;
                    discountLab.hidden = NO;
                    payLab.hidden = NO;
                    takingBtn.hidden = NO;
                    orderNumLab.text = [NSString stringWithFormat:@"订单编号  %@", result[@"detail"][@"orderId"]];
                    
                    tradingNumLab.text = [NSString stringWithFormat:@"交易号  %@",result[@"detail"][@"tradingNo"]];
                    
                    creatingTimeLab.text = [NSString stringWithFormat:@"创建时间  %@",result[@"detail"][@"createDate"]];
                    
                    payTimeLab.text = [NSString stringWithFormat:@"付款时间  %@",result[@"detail"][@"payDate"]];
                    
                    discountLab.text = [NSString stringWithFormat:@"折扣  -￥%@",result[@"detail"][@"discountMoney"]];
                    
                    payLab.text = [NSString stringWithFormat:@"实付款  ￥%@",result[@"detail"][@"payMoney"]];
                    
//                    [self.view makeToast:@"注册成功，请开始拿着"];
                    return;
                } else {
                    [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
                    tipLab.text = @"请再次注册领取奖品吧～";
                    tipLab.hidden = NO;
//                    [self.view makeToast:result[@"detail"][@"msg"]];
                    return;
                }

            });
            
        });
        

        
    } else {
        
        NSDictionary *parameters = @{
                                     @"phone":registInfo.phone,
                                     @"password":registInfo.password,
                                     @"code":registInfo.code,
                                     @"recommendPhone":recomPhone,
                                     @"nickName":registInfo.nickName,
                                     @"sex":registInfo.sex,
                                     @"birthday":registInfo.birthday,
                                     @"province":registInfo.province,
                                     @"city":registInfo.city,
                                     @"hometown":registInfo.hometown,
                                     @"job":@"互联网-iOS工程狮",
                                     @"name":registInfo.name,
                                     @"address":registInfo.address,
                                     @"pushToken":user.pushToken
                                     } ;
        
        [handler postURLStr:webRegister postDic:parameters
                      block:^(NSDictionary *retInfo, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
             
             if( error )
             {
                 [wSelf.view makeToast:@"网络错误,注册失败"];
                 return ;
             }
             
             if( retInfo == nil )
             {
                 [wSelf.view makeToast:@"网络错误,注册失败"];
                 return ;
             }
             
             BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
             
             if( state )
             {
                 
                 if ([retInfo[@"detail"][@"isSuccess"] isEqualToString:@"success"]) {
                     giftImgV.hidden = NO;
                     tipLab.text = @"恭喜您获得礼品！";
                     tipLab.hidden = NO;
                     detailTitleLab.hidden = NO;
                     menberLab.hidden = NO;
                     addressLab.hidden = NO;
                     orderNumLab.hidden = NO;
                     tradingNumLab.hidden = NO;
                     creatingTimeLab.hidden = NO;
                     payTimeLab.hidden = NO;
                     discountLab.hidden = NO;
                     payLab.hidden = NO;
                     takingBtn.hidden = NO;
                     
                     orderNumLab.text = [NSString stringWithFormat:@"订单编号  %@", retInfo[@"detail"][@"orderId"]];
                     
                     tradingNumLab.text = [NSString stringWithFormat:@"交易号  %@",retInfo[@"detail"][@"tradingNo"]];
                     
                     creatingTimeLab.text = [NSString stringWithFormat:@"创建时间  %@",retInfo[@"detail"][@"createDate"]];
                     
                     payTimeLab.text = [NSString stringWithFormat:@"付款时间  %@",retInfo[@"detail"][@"payDate"]];
                     
                     discountLab.text = [NSString stringWithFormat:@"折扣  -￥%@",retInfo[@"detail"][@"discountMoney"]];
                     
                     payLab.text = [NSString stringWithFormat:@"实付款  ￥%@",retInfo[@"detail"][@"payMoney"]];
                     
                     [wSelf.view makeToast:@"注册成功，请开始拿着"];
                 } else {
                     [wSelf.view makeToast:retInfo[@"detail"][@"isSuccess"]];
                 }
                 
             }
             
             else
             {
                 tipLab.text = @"请再次注册领取奖品吧～";
                 tipLab.hidden = NO;
                 [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
             }
         }] ;
    }
    
    
}

- (void)takingAction:(UIButton *)button {
    
    [self showRegistSuccess]; // 注册成功动画
    
}

#pragma mark 注册成功动画
- (void)showRegistSuccess {
    UIView *maskBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskBackView.backgroundColor = [UIColor blackColor];
    maskBackView.alpha = 0.8f;
    [self.view addSubview:maskBackView];
    
    UIImageView *successImg = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*130/375)/2, ScreenWidth*145/375+20, ScreenWidth*130/375, ScreenWidth*130/375)];
    successImg.image = [UIImage imageNamed:@"登录成功"];
    [maskBackView addSubview:successImg];
    
    UILabel *successLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(successImg.frame)+ScreenWidth*20/375, ScreenWidth, 20)];
    successLab.text = @"注册成功";
    successLab.textColor = [UIColor whiteColor];
    successLab.font = [UIFont systemFontOfSize:22.f];
    successLab.textAlignment = NSTextAlignmentCenter;
    [maskBackView addSubview:successLab];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

#pragma mark 计时1秒弹框消失
- (void)dismiss {
    // 释放定时器，视图还原，关闭动画
    if (timer.isValid) {
        [timer invalidate];
    }
    timer = nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
