//
//  NZConfirmOrderViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZConfirmOrderViewController.h"
#import "NZSettleViewCell.h"
#import "NZAddressListModel.h"
#import "NZChangeAddressViewController.h"

@interface NZConfirmOrderViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NZAddressModel *selectAddress; // 用户选择的收货地址
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NZConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationItemTitleViewWithTitle:@"订单确认"];
    [self leftButtonTitle:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-ScreenWidth*45/375) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-ScreenWidth*45/375, ScreenWidth, ScreenWidth*45/475)];
    bottomBar.backgroundColor = BKColor;
    [self.view addSubview:bottomBar];
    
    int count = 0;
    float totalPrice = 0.0;
    for (int i=0; i<_shopBagModel.list.count; i++) {
        ShopBagBrandModel *brandModel = _shopBagModel.list[i];
        for (int j=0; j<brandModel.goodsList.count; j++) {
            ShopBagGoodModel *goodModel  = brandModel.goodsList[j];
            count ++;
            totalPrice += goodModel.totalPrice;
            totalPrice += goodModel.expressPrice;
        }
    }
    
    UILabel *goodsNumLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*30/375, ScreenWidth*12.5/375, 100, ScreenWidth*20/375)];
    goodsNumLab.font = [UIFont systemFontOfSize:14.f];
    goodsNumLab.text = [NSString stringWithFormat:@"共计%d件商品", count];
    goodsNumLab.textColor = [UIColor grayColor];
    [bottomBar addSubview:goodsNumLab];
    
    UILabel *totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsNumLab.frame), goodsNumLab.origin.y, ScreenWidth-ScreenWidth*105/375-CGRectGetMaxX(goodsNumLab.frame), goodsNumLab.frame.size.height)];
    totalPriceLab.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共计 ¥%.2f",totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:darkRedColor range:NSMakeRange(2,str.length-2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:NSMakeRange(0, str.length)];
    totalPriceLab.attributedText = str;
    [bottomBar addSubview:totalPriceLab];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*98/375, ScreenWidth*10/375, ScreenWidth*88/375, ScreenWidth*25/375)];
    payBtn.backgroundColor = darkRedColor;
    [payBtn setTitle:@"确认付款" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    payBtn.layer.cornerRadius = 1.f;
    [bottomBar addSubview:payBtn];
    
    [self requestDefaultAddress]; // 请求默认收货地址
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shopBagModel.list.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    ShopBagBrandModel *brandModel = _shopBagModel.list[section-1];
    return brandModel.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NZSettleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZSettleCellIdentify];
    if (cell == nil) {
        cell = [[NZSettleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZSettleCellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ((int)indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    
    ShopBagBrandModel *brandModel = _shopBagModel.list[indexPath.section-1];
    if ((int)indexPath.row == brandModel.goodsList.count-1) {
        cell.bottomLine.hidden = YES;
    }
    
    ShopBagGoodModel *goodModel = brandModel.goodsList[indexPath.row];
    NZSettleGoodsViewModel *settleVM = [[NZSettleGoodsViewModel alloc] init];
    settleVM.shopBagGoodModel = goodModel;
    cell.settleGoodsVM = settleVM;
        
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        
        if (selectAddress) {
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*30/375, ScreenWidth*5/375, ScreenWidth-ScreenWidth*60/375-110, ScreenWidth*20/375)];
            nameLab.text = [NSString stringWithFormat:@"收货人  %@", selectAddress.name];
            nameLab.textColor = [UIColor blackColor];
            nameLab.font = [UIFont systemFontOfSize:15.f];
            [whiteView addSubview:nameLab];
            
            UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame), nameLab.origin.y, 110, ScreenWidth*20/375)];
            phoneLab.text = [NSString stringWithFormat:@"%@", selectAddress.phone];
            phoneLab.textColor = [UIColor blackColor];
            phoneLab.font = [UIFont systemFontOfSize:15.f];
            phoneLab.textAlignment = NSTextAlignmentRight;
            [whiteView addSubview:phoneLab];
            
            NSString *detailAddressStr = [NSString stringWithFormat:@"收货地址  %@", selectAddress.addressDetail];
            UIFont *contentFont = [UIFont systemFontOfSize:15.f];
            NSDictionary *attribute = @{NSFontAttributeName:contentFont};
            CGSize limitSize = CGSizeMake(ScreenWidth-ScreenWidth*60/375, MAXFLOAT);
            // 计算尺寸
            CGSize contentSize = [detailAddressStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*30/375, ScreenWidth*30/375, limitSize.width, contentSize.height)];
            addressLab.text = detailAddressStr;
            addressLab.textColor = [UIColor blackColor];
            addressLab.font = contentFont;
            addressLab.numberOfLines = 0;
            [whiteView addSubview:addressLab];
            
            UIButton *changeAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*90/375, CGRectGetMaxY(addressLab.frame)+ScreenWidth*5/375, ScreenWidth*60/375, ScreenWidth*20/375)];
            [changeAddBtn setTitle:@"更换地址" forState:UIControlStateNormal];
            [changeAddBtn setTitleColor:darkRedColor forState:UIControlStateNormal];
            changeAddBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            changeAddBtn.layer.cornerRadius = 1.f;
            changeAddBtn.layer.masksToBounds = YES;
            changeAddBtn.layer.borderColor = darkRedColor.CGColor;
            changeAddBtn.layer.borderWidth = 0.5f;
            [changeAddBtn addTarget:self action:@selector(changeAddAction:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:changeAddBtn];
            
            whiteView.frame = CGRectMake(0, 0, ScreenWidth, contentSize.height+ScreenWidth*65/375);
        }
        
    } else {
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 40);
        
        UILabel *brandNameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-20, 39.5)];
        ShopBagBrandModel *shopBrandModel = _shopBagModel.list[section-1];
        brandNameLab.text = shopBrandModel.shopName;
        brandNameLab.textColor = [UIColor darkGrayColor];
        brandNameLab.font = [UIFont systemFontOfSize:17.f];
        [whiteView addSubview:brandNameLab];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
        line2.backgroundColor = [UIColor grayColor];
        [whiteView addSubview:line2];
    }
    
    return whiteView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*10/375)];
        lightGrayView.backgroundColor = [UIColor lightGrayColor];
        return lightGrayView;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*130/375)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth*30/375, 0, ScreenWidth-ScreenWidth*60/375, ScreenWidth*40/375)];
    textF.backgroundColor = BKColor;
    textF.font = [UIFont systemFontOfSize:13.f];
    textF.placeholder = @"（选填）买家留言：如有特殊要求客服将与您联系";
    [bottomView addSubview:textF];
    
    int count = 0;
    float totalPrice = 0.0;
    float expressPrice = 0.0;
    ShopBagBrandModel *brandModel = _shopBagModel.list[section-1];
    for (int i=0; i<brandModel.goodsList.count; i++) {
        ShopBagGoodModel *goodModel  = brandModel.goodsList[i];
        count ++;
        totalPrice += goodModel.totalPrice;
        expressPrice += goodModel.expressPrice;
    }
    
    UILabel *goodsNumLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*30/375, ScreenWidth*60/375, 100, ScreenWidth*20/375)];
    goodsNumLab.font = [UIFont systemFontOfSize:15.f];
    goodsNumLab.text = [NSString stringWithFormat:@"共%d件商品", count];
    goodsNumLab.textColor = [UIColor blackColor];
    [bottomView addSubview:goodsNumLab];
    
    UILabel *totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsNumLab.frame), goodsNumLab.origin.y, ScreenWidth-ScreenWidth*30/375-CGRectGetMaxX(goodsNumLab.frame), goodsNumLab.frame.size.height)];
    totalPriceLab.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计 ¥%.2f",totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:darkRedColor range:NSMakeRange(2,str.length-2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:NSMakeRange(0, str.length-3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(str.length-3 , 3)];
    totalPriceLab.attributedText = str;
    [bottomView addSubview:totalPriceLab];
    
    UILabel *expressPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*30/375, CGRectGetMaxY(totalPriceLab.frame), ScreenWidth-ScreenWidth*60/375, ScreenWidth*15/375)];
    expressPriceLab.textColor = [UIColor grayColor];
    expressPriceLab.font = [UIFont systemFontOfSize:13.f];
    expressPriceLab.textAlignment = NSTextAlignmentRight;
    if (expressPrice > 0) {
        expressPriceLab.text = [NSString stringWithFormat:@"运费：%2.f元", expressPrice];
    } else {
        expressPriceLab.text = @"不含运费";
    }
    [bottomView addSubview:expressPriceLab];
    
    UIView *lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*115/375, ScreenWidth, ScreenWidth*10/375)];
    lightGrayView.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lightGrayView];
    return bottomView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopBagBrandModel *brandModel = _shopBagModel.list[indexPath.section-1];
    ShopBagGoodModel *goodModel = brandModel.goodsList[indexPath.row];
    NZSettleGoodsViewModel *settleVM = [[NZSettleGoodsViewModel alloc] init];
    settleVM.shopBagGoodModel = goodModel;
    return CGRectGetMaxY(settleVM.bottomLineFrame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *detailAddressStr = [NSString stringWithFormat:@"收货地址  %@", selectAddress.addressDetail];
        UIFont *contentFont = [UIFont systemFontOfSize:15.f];
        NSDictionary *attribute = @{NSFontAttributeName:contentFont};
        CGSize limitSize = CGSizeMake(ScreenWidth-ScreenWidth*60/375, MAXFLOAT);
        // 计算尺寸
        CGSize contentSize = [detailAddressStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return contentSize.height + ScreenWidth*65/375;
    }
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return ScreenWidth*10/375;
    }
    return ScreenWidth*125/375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark 立即购买请求当前用户的收货地址（默认）
- (void)requestDefaultAddress {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId
                                 } ;
    
    [handler postURLStr:webGetDefaultAddress postDic:parameters
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
             selectAddress = [NZAddressModel objectWithKeyValues:retInfo[@"addressInfo"][0]];
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 跳转更换地址界面
- (void)changeAddAction:(UIButton *)button {
    NZChangeAddressViewController *changeAddVCTR = [[NZChangeAddressViewController alloc] init];
    [self.navigationController pushViewController:changeAddVCTR animated:YES];
}

@end
