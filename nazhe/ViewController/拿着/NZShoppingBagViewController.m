//
//  NZShoppingBagViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/2.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZShoppingBagViewController.h"
#import "NZShopBagTableViewCell.h"
#import "NZShopBagExpandTableViewCell.h"
#import "NZCommodityModel.h"
#import "ShopBagModel.h"
#import "NZShopBagViewModel.h"
#import "GoodSpecificationsModel.h"
#import "NZConfirmOrderViewController.h"

#define classFont [UIFont systemFontOfSize:15.f]
#define specFont [UIFont systemFontOfSize:13.f]
#define weightTag 100
#define sizeTag 200
#define gradeTag 300
#define colorTag 400
#define hardnessTag 500
#define fillInTag 600
#define accessoriesTag 700
#define packTag 800

@interface NZShoppingBagViewController ()<UITableViewDataSource, UITableViewDelegate, NZShopBagDelegate, NZShopBagExpendDelegate> {
    
    IBOutlet NSLayoutConstraint *bottomHeight; // 底部栏的高度的约束
    
    int currentSection; // 当前编辑cell的section
    int currentRow; // 当前编辑cell的row
    
    BOOL isAllSelect; // 是否全选
    
    NSMutableArray *shopBagVMArray; // 购物袋列表视图模型数组
    ShopBagModel *shopBagModel; // 购物袋列表数据存储模型
//    NSMutableArray *settleGoodsVMArray; // 结算商品列表视图模型数组（要传给订单确认界面）
    
    GoodSpecificationsModel *goodSpecModel; // 商品参数模型
    
    int deleteSection; // 要删除的商品的section
    int deleteRow; // 要删除的商品的row
    double deletePrice; // 要删除的商品的单价
    int deleteNumber; // 要删除的商品的数量
    BOOL deleteState; // 删除时的选中状态
    
    /************** 编辑商品规格的选中状态 ****************/
    int selectWeight;
    int selectSize;
    int selectGrade;
    int selectColor;
    int selectHardness;
    int selectFillIn;
    int selectAccessories;
    int selectPack;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *settelView;
@property (strong, nonatomic) IBOutlet UIImageView *selectImgV;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *expressPriceLab;

@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) double editPrice;
@property (nonatomic, assign) double expressPrice;
@property (strong, nonatomic) IBOutlet UIButton *settleBtn;
@property (assign, nonatomic) int settleNumber;

/************** 规格选择模板 ***************/
@property (nonatomic, strong) UIView *shadowView; // 背景阴影view
@property (nonatomic, strong) UIView *specificationsView; // 规格选择view
@property (nonatomic, strong) UIScrollView *specificationsScrollV; // 规格内容scrollView
@property (nonatomic, strong) UILabel *specClassLab; // 规格种类label
@property (nonatomic, strong) UIButton *specParamBtn; // 规格参数buuton
@property (nonatomic, strong) UIView *bottomLine; // 规格种类分割线

- (IBAction)allSelectAction:(UIButton *)sender;
- (IBAction)settleAction:(UIButton *)sender;

@end

@implementation NZShoppingBagViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super self];
    if (self) {
        currentSection = -1;
        currentRow = -1;
        
        _totalPrice = 0.0;
        _editPrice = 0.0;
        _expressPrice = 0.0;
        
        _settleNumber = 0;
        
        shopBagVMArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"购物袋"];
    [self leftButtonTitle:nil];
    
    // 给下面的结算view添加阴影，附加层次感
    [self addShadowSubLayer];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    bottomHeight.constant = ScreenWidth*45/375; // 底部栏的动态45高
    
//    // 判断有几个选择了，算进总价和结算个数中（实际不需要，都为未选）
//    for (int i = 0; i < infoArr.count; i++) {
//        NZCommodityModel *commodityModel = infoArr[i];
//        if (commodityModel.selectState) {
//            self.totalPrice += commodityModel.commodityNum * [commodityModel.commodityPrice doubleValue];
//            self.settleNumber ++;
//        }
//    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
    _totalPriceLab.attributedText = str;
    
    [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
    
    /************** 规格选择模板 ***************/
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _shadowView.backgroundColor = [UIColor blackColor];
    _shadowView.alpha = 0.6;
    [self.view addSubview:_shadowView];
    [self.view sendSubviewToBack:_shadowView];
    
    _specificationsView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*305/375)/2, (ScreenHeight-ScreenWidth*372/375)/2, ScreenWidth*305/375, ScreenWidth*372/375)];
    _specificationsView.backgroundColor = [UIColor whiteColor];
    _specificationsView.layer.cornerRadius = 5.f;
    _specificationsView.layer.masksToBounds = YES;
    [self.view addSubview:_specificationsView];
    [self.view sendSubviewToBack:_specificationsView];
    
    _specificationsScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScreenWidth*20/375, ScreenWidth*306/375, ScreenWidth*300/375)];
    _specificationsScrollV.backgroundColor = [UIColor whiteColor];
    [_specificationsView addSubview:_specificationsScrollV];
    
    UIButton *cancelSpeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*38/375, ScreenWidth*331/375, ScreenWidth*100/375, ScreenWidth*27/375)];
    cancelSpeBtn.backgroundColor = [UIColor whiteColor];
    [cancelSpeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSpeBtn setTitleColor:darkRedColor forState:UIControlStateNormal];
    cancelSpeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    cancelSpeBtn.layer.cornerRadius = 1.f;
    cancelSpeBtn.layer.masksToBounds = YES;
    cancelSpeBtn.layer.borderColor = darkRedColor.CGColor;
    cancelSpeBtn.layer.borderWidth = 0.5f;
    [cancelSpeBtn addTarget:self action:@selector(commitSpeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_specificationsView addSubview:cancelSpeBtn];
    
    UIButton *commitSpeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*168/375, ScreenWidth*331/375, ScreenWidth*100/375, ScreenWidth*27/375)];
    commitSpeBtn.backgroundColor = darkRedColor;
    [commitSpeBtn setTitle:@"确认" forState:UIControlStateNormal];
    [commitSpeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitSpeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    commitSpeBtn.layer.cornerRadius = 1.f;
    commitSpeBtn.layer.masksToBounds = YES;
    [commitSpeBtn addTarget:self action:@selector(commitSpeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_specificationsView addSubview:commitSpeBtn];
    
    [self requestShopBagListData];
    
//    // 判断有没有全选
//    isAllSelect = YES;
//    for (int i = 0; i < infoArr.count; i++) {
//        NZCommodityModel *commodityModel = infoArr[i];
//        if (!commodityModel.selectState) {
//            isAllSelect = NO;
//            break;
//        }
//    }
//    
//    if (isAllSelect) {
//        _selectImgV.image = [UIImage imageNamed:@"圆-已选"];
//        
//    } else {
//        _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
//    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return shopBagVMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *shopBagVMAry = shopBagVMArray[section];
    return shopBagVMAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((int)indexPath.section == currentSection && (int)indexPath.row == currentRow) {
        NZShopBagExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZShopBagExpendCellIdentify];
        if (cell == nil) {
            cell = [[NZShopBagExpandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZShopBagExpendCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ((int)indexPath.row == 0) {
            cell.topLine.hidden = YES;
        }
        
        cell.delegate = self;
        cell.section = (int)indexPath.section;
        cell.row = (int)indexPath.row;
        
        NSArray *shopBagVMAry = shopBagVMArray[indexPath.section];
        cell.shopBagViewModel = shopBagVMAry[indexPath.row];
        
        return cell;
    } else {
        
        NZShopBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZShopBagCellIdentify];
        if (cell == nil) {
            cell = [[NZShopBagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZShopBagCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ((int)indexPath.row == 0) {
            cell.topLine.hidden = YES;
        }
        NSArray *shopBagVMAry = shopBagVMArray[indexPath.section];
        if ((int)indexPath.row == shopBagVMAry.count-1) {
            cell.bottomLine.hidden = YES;
        }
        
        cell.delegate = self;
        cell.section = (int)indexPath.section;
        cell.row = (int)indexPath.row;
        
        cell.shopBagViewModel = shopBagVMAry[indexPath.row];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UILabel *brandNameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-20, 39.5)];
    ShopBagBrandModel *shopBrandModel = shopBagModel.list[section];
    brandNameLab.text = shopBrandModel.shopName;
    brandNameLab.textColor = [UIColor darkGrayColor];
    brandNameLab.font = [UIFont systemFontOfSize:17.f];
    [whiteView addSubview:brandNameLab];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
    line2.backgroundColor = [UIColor grayColor];
    [whiteView addSubview:line2];
    
    return whiteView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*10/375)];
    lightGrayView.backgroundColor = [UIColor lightGrayColor];
    return lightGrayView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((int)indexPath.section == currentSection && (int)indexPath.row == currentRow) {
        NSArray *shopBagVMAry = shopBagVMArray[indexPath.section];
        NZShopBagViewModel *shopBagVM = shopBagVMAry[indexPath.row];
        return CGRectGetMaxY(shopBagVM.commitBtnFrame)+ScreenWidth*15/375;
    } else {
        NSArray *shopBagVMAry = shopBagVMArray[indexPath.section];
        NZShopBagViewModel *shopBagVM = shopBagVMAry[indexPath.row];
        return CGRectGetMaxY(shopBagVM.editBtnFrame)+ScreenWidth*15/375;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == shopBagVMArray.count-1) {
        return 0.f;
    }
    return ScreenWidth*10/375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        alertView = nil;
    } else {
        
        [self deleteShopBagGood];
        alertView = nil;
    }
    
}

#pragma mark NZShopBagDelegate
- (void)deleteClickWithSection:(int)section andRow:(int)row andState:(BOOL)selectState andPrice:(double)price andNumber:(int)number {
    
    deleteSection = section;
    deleteRow = row;
    deletePrice = price;
    deleteNumber = number;
    deleteState = selectState;
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认要删除该商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertview show];
    
    
}

- (void)selectClickWithSection:(int)section andRow:(int)row andState:(BOOL)selectState andPrice:(double)price andNumber:(int)number andExpressPrice:(float)expressPrice {
    // 不论是选择还是取消选择，都将结果纪录下来
    NSArray *shopBagVMAry = shopBagVMArray[section];
    NZShopBagViewModel *shopBagVM = shopBagVMAry[row];
    shopBagVM.shopBagGoodModel.selectState = selectState;
    shopBagVM.shopBagGoodModel.count = number;
    
    if (selectState) { // 如果是选择
        self.totalPrice += price * number; // 总价要加
        self.settleNumber ++; // 结算个数要加
        self.expressPrice += expressPrice; // 运费要加
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        // 判断有没有全选，如有，全选的图标要换已选
        isAllSelect = YES;
        for (int i = 0; i < shopBagVMArray.count; i++) {
            NSArray *shopBagVMAry = shopBagVMArray[i];
            for (int j=0; j<shopBagVMAry.count; j++) {
                NZShopBagViewModel *shopBagVM = shopBagVMAry[j];
                if (!shopBagVM.shopBagGoodModel.selectState) {
                    isAllSelect = NO;
                    break;
                }
            }
        }
        
        if (isAllSelect) {
            _selectImgV.image = [UIImage imageNamed:@"圆-已选"];
            
        } else {
            _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
        }
        
        [_tableView reloadData];
    } else { // 如果是取消选择
        self.totalPrice -= price * number; // 总价要减
        self.settleNumber --; // 结算个数要减
        self.expressPrice -= expressPrice; // 运费要减
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
    _totalPriceLab.attributedText = str;
    
    if (self.expressPrice>0) {
        NSString *expressPriceStr = [NSString stringWithFormat:@"运费：%.2f元",self.expressPrice];
        _expressPriceLab.text = expressPriceStr;
    } else {
        _expressPriceLab.text = @"不含运费";
    }
    
}

- (void)editClickWithSection:(int)section andRow:(int)row {
    if (section < 0) {
        currentSection = section;
        currentRow = row;
        [_tableView reloadData];
    } else {
        currentSection = section;
        currentRow = row;
        
        self.totalPrice -= self.editPrice;
        self.editPrice = 0.0;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
        
        [_tableView reloadData];
    }
}

#pragma mark NZShopBagExpendDelegate
- (void)specificationsWithSection:(int)section andRow:(int)row {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSArray *shopBagVMAry = shopBagVMArray[section];
    NZShopBagViewModel *shopBagVM = shopBagVMAry[row];
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"id":[NSNumber numberWithInt:shopBagVM.shopBagGoodModel.goodId]
                                 } ;
    
    [handler postURLStr:webShoppingBagsSpecs postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
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
             goodSpecModel = [GoodSpecificationsModel objectWithKeyValues:retInfo];
             
             int startX = ScreenWidth*20/375;
             int i = 0;
             
             // 重量
             if (goodSpecModel.weightList.count != 0) {
                 if (i != 0) {
                     _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
                     _bottomLine.backgroundColor = [UIColor grayColor];
                     [_specificationsScrollV addSubview:_bottomLine];
                 } else {
                     i ++;
                 }
                 
                 _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
                 _specClassLab.text = @"重量分类";
                 _specClassLab.textColor = [UIColor blackColor];
                 _specClassLab.font = classFont;
                 [_specificationsScrollV addSubview:_specClassLab];
                 
                 for (int i=0; i<goodSpecModel.weightList.count; i++) {
                     NSDictionary *attribute = @{NSFontAttributeName:specFont};
                     CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
                     // 计算尺寸
                     BagParametersModel *paramsModel = goodSpecModel.weightList[i];
                     CGSize contentSize = [paramsModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                     if (i == 0) {
                         _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                         
                     } else {
                         if ((ScreenWidth*306/375-CGRectGetMaxX(_specParamBtn.frame)-ScreenWidth*28/375)<contentSize.width) {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         } else {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         }
                     }
                     _specParamBtn.backgroundColor = BKColor;
                     [_specParamBtn setTitle:paramsModel.name forState:UIControlStateNormal];
                     if (paramsModel.count == 0) {
                         [_specParamBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _specParamBtn.userInteractionEnabled = NO;
                     } else {
                         [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     }
                     if (paramsModel.isChose) {
                         _specParamBtn.backgroundColor = darkRedColor;
                         [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         selectWeight = weightTag+i;
                     }
                     _specParamBtn.titleLabel.font = specFont;
                     _specParamBtn.layer.cornerRadius = 1.f;
                     _specParamBtn.layer.masksToBounds = YES;
                     [_specParamBtn setTag:weightTag+i];
                     [_specParamBtn addTarget:self action:@selector(weightAction:) forControlEvents:UIControlEventTouchUpInside];
                     [_specificationsScrollV addSubview:_specParamBtn];
                 }
             }
             
             // 规格
             if (goodSpecModel.sizeList.count != 0) {
                 
                 if (i != 0) {
                     _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
                     _bottomLine.backgroundColor = [UIColor grayColor];
                     [_specificationsScrollV addSubview:_bottomLine];
                 } else {
                     i ++;
                 }
                 
                 if (_bottomLine) {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, CGRectGetMaxY(_bottomLine.frame)+ScreenWidth*5/375, 200, ScreenWidth*20/375)];
                 } else {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
                 }
                 _specClassLab.text = @"规格分类";
                 _specClassLab.textColor = [UIColor blackColor];
                 _specClassLab.font = classFont;
                 [_specificationsScrollV addSubview:_specClassLab];
                 
                 for (int i=0; i<goodSpecModel.sizeList.count; i++) {
                     NSDictionary *attribute = @{NSFontAttributeName:specFont};
                     CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
                     // 计算尺寸
                     BagParametersModel *paramsModel = goodSpecModel.sizeList[i];
                     CGSize contentSize = [paramsModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                     if (i == 0) {
                         _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                         
                     } else {
                         if ((ScreenWidth*306/375-CGRectGetMaxX(_specParamBtn.frame)-ScreenWidth*28/375)<contentSize.width) {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         } else {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         }
                     }
                     _specParamBtn.backgroundColor = BKColor;
                     [_specParamBtn setTitle:paramsModel.name forState:UIControlStateNormal];
                     if (paramsModel.count == 0) {
                         [_specParamBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _specParamBtn.userInteractionEnabled = NO;
                     } else {
                         [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     }
                     if (paramsModel.isChose) {
                         _specParamBtn.backgroundColor = darkRedColor;
                         [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         selectSize = sizeTag + i;
                     }
                     _specParamBtn.titleLabel.font = specFont;
                     _specParamBtn.layer.cornerRadius = 1.f;
                     _specParamBtn.layer.masksToBounds = YES;
                     [_specParamBtn setTag:sizeTag+i];
                     [_specParamBtn addTarget:self action:@selector(sizeAction:) forControlEvents:UIControlEventTouchUpInside];
                     [_specificationsScrollV addSubview:_specParamBtn];
                 }
             }
             
             // 等级
             if (goodSpecModel.gradeList.count != 0) {
                 if (i != 0) {
                     _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
                     _bottomLine.backgroundColor = [UIColor grayColor];
                     [_specificationsScrollV addSubview:_bottomLine];
                 } else {
                     i ++;
                 }
                 
                 if (_bottomLine) {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, CGRectGetMaxY(_bottomLine.frame)+ScreenWidth*5/375, 200, ScreenWidth*20/375)];
                 } else {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
                 }
                 _specClassLab.text = @"等级分类";
                 _specClassLab.textColor = [UIColor blackColor];
                 _specClassLab.font = classFont;
                 [_specificationsScrollV addSubview:_specClassLab];
                 
                 for (int i=0; i<goodSpecModel.gradeList.count; i++) {
                     NSDictionary *attribute = @{NSFontAttributeName:specFont};
                     CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
                     // 计算尺寸
                     BagParametersModel *paramsModel = goodSpecModel.gradeList[i];
                     CGSize contentSize = [paramsModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                     if (i == 0) {
                         _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                         
                     } else {
                         if ((ScreenWidth*306/375-CGRectGetMaxX(_specParamBtn.frame)-ScreenWidth*28/375)<contentSize.width) {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         } else {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         }
                     }
                     _specParamBtn.backgroundColor = BKColor;
                     [_specParamBtn setTitle:paramsModel.name forState:UIControlStateNormal];
                     if (paramsModel.count == 0) {
                         [_specParamBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _specParamBtn.userInteractionEnabled = NO;
                     } else {
                         [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     }
                     if (paramsModel.isChose) {
                         _specParamBtn.backgroundColor = darkRedColor;
                         [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         selectGrade = gradeTag + i;
                     }
                     _specParamBtn.titleLabel.font = specFont;
                     _specParamBtn.layer.cornerRadius = 1.f;
                     _specParamBtn.layer.masksToBounds = YES;
                     [_specParamBtn setTag:gradeTag+i];
                     [_specParamBtn addTarget:self action:@selector(gradeAction:) forControlEvents:UIControlEventTouchUpInside];
                     [_specificationsScrollV addSubview:_specParamBtn];
                 }
             }
             
             // 颜色
             if (goodSpecModel.colorList.count != 0) {
                 if (i != 0) {
                     _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
                     _bottomLine.backgroundColor = [UIColor grayColor];
                     [_specificationsScrollV addSubview:_bottomLine];
                 } else {
                     i ++;
                 }
                 
                 if (_bottomLine) {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, CGRectGetMaxY(_bottomLine.frame)+ScreenWidth*5/375, 200, ScreenWidth*20/375)];
                 } else {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
                 }
                 _specClassLab.text = @"颜色分类";
                 _specClassLab.textColor = [UIColor blackColor];
                 _specClassLab.font = classFont;
                 [_specificationsScrollV addSubview:_specClassLab];
                 
                 for (int i=0; i<goodSpecModel.colorList.count; i++) {
                     NSDictionary *attribute = @{NSFontAttributeName:specFont};
                     CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
                     // 计算尺寸
                     BagParametersModel *paramsModel = goodSpecModel.colorList[i];
                     CGSize contentSize = [paramsModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                     if (i == 0) {
                         _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                         
                     } else {
                         if ((ScreenWidth*306/375-CGRectGetMaxX(_specParamBtn.frame)-ScreenWidth*23/375)<contentSize.width) {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         } else {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         }
                     }
                     _specParamBtn.backgroundColor = BKColor;
                     [_specParamBtn setTitle:paramsModel.name forState:UIControlStateNormal];
                     if (paramsModel.count == 0) {
                         [_specParamBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _specParamBtn.userInteractionEnabled = NO;
                     } else {
                         [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     }
                     if (paramsModel.isChose) {
                         _specParamBtn.backgroundColor = darkRedColor;
                         [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         selectColor = colorTag + i;
                     }
                     _specParamBtn.titleLabel.font = specFont;
                     _specParamBtn.layer.cornerRadius = 1.f;
                     _specParamBtn.layer.masksToBounds = YES;
                     [_specParamBtn setTag:colorTag+i];
                     [_specParamBtn addTarget:self action:@selector(colorAction:) forControlEvents:UIControlEventTouchUpInside];
                     [_specificationsScrollV addSubview:_specParamBtn];
                 }
             }
             
             // 硬度分类
             if (goodSpecModel.hardnessList.count != 0) {
                 if (i != 0) {
                     _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
                     _bottomLine.backgroundColor = [UIColor grayColor];
                     [_specificationsScrollV addSubview:_bottomLine];
                 } else {
                     i ++;
                 }
                 
                 if (_bottomLine) {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, CGRectGetMaxY(_bottomLine.frame)+ScreenWidth*5/375, 200, ScreenWidth*20/375)];
                 } else {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
                 }
                 _specClassLab.text = @"硬度分类";
                 _specClassLab.textColor = [UIColor blackColor];
                 _specClassLab.font = classFont;
                 [_specificationsScrollV addSubview:_specClassLab];
                 
                 for (int i=0; i<goodSpecModel.hardnessList.count; i++) {
                     NSDictionary *attribute = @{NSFontAttributeName:specFont};
                     CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
                     // 计算尺寸
                     BagParametersModel *paramsModel = goodSpecModel.hardnessList[i];
                     CGSize contentSize = [paramsModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                     if (i == 0) {
                         _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                         
                     } else {
                         if ((ScreenWidth*306/375-CGRectGetMaxX(_specParamBtn.frame)-ScreenWidth*23/375)<contentSize.width) {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         } else {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         }
                     }
                     _specParamBtn.backgroundColor = BKColor;
                     [_specParamBtn setTitle:paramsModel.name forState:UIControlStateNormal];
                     if (paramsModel.count == 0) {
                         [_specParamBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _specParamBtn.userInteractionEnabled = NO;
                     } else {
                         [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     }
                     if (paramsModel.isChose) {
                         _specParamBtn.backgroundColor = darkRedColor;
                         [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         selectHardness = hardnessTag + i;
                     }
                     _specParamBtn.titleLabel.font = specFont;
                     _specParamBtn.layer.cornerRadius = 1.f;
                     _specParamBtn.layer.masksToBounds = YES;
                     [_specParamBtn setTag:hardnessTag+i];
                     [_specParamBtn addTarget:self action:@selector(hardnessAction:) forControlEvents:UIControlEventTouchUpInside];
                     [_specificationsScrollV addSubview:_specParamBtn];
                 }
             }
             
             // 镶嵌
             if (goodSpecModel.fillInList.count != 0) {
                 if (i != 0) {
                     _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
                     _bottomLine.backgroundColor = [UIColor grayColor];
                     [_specificationsScrollV addSubview:_bottomLine];
                 } else {
                     i ++;
                 }
                 
                 if (_bottomLine) {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, CGRectGetMaxY(_bottomLine.frame)+ScreenWidth*5/375, 200, ScreenWidth*20/375)];
                 } else {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
                 }
                 _specClassLab.text = @"镶嵌分类";
                 _specClassLab.textColor = [UIColor blackColor];
                 _specClassLab.font = classFont;
                 [_specificationsScrollV addSubview:_specClassLab];
                 
                 for (int i=0; i<goodSpecModel.fillInList.count; i++) {
                     NSDictionary *attribute = @{NSFontAttributeName:specFont};
                     CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
                     // 计算尺寸
                     BagParametersModel *paramsModel = goodSpecModel.fillInList[i];
                     CGSize contentSize = [paramsModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                     if (i == 0) {
                         _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                         
                     } else {
                         if ((ScreenWidth*306/375-CGRectGetMaxX(_specParamBtn.frame)-ScreenWidth*23/375)<contentSize.width) {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         } else {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         }
                     }
                     _specParamBtn.backgroundColor = BKColor;
                     [_specParamBtn setTitle:paramsModel.name forState:UIControlStateNormal];
                     if (paramsModel.count == 0) {
                         [_specParamBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _specParamBtn.userInteractionEnabled = NO;
                     } else {
                         [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     }
                     if (paramsModel.isChose) {
                         _specParamBtn.backgroundColor = darkRedColor;
                         [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         selectFillIn = fillInTag + i;
                     }
                     _specParamBtn.titleLabel.font = specFont;
                     _specParamBtn.layer.cornerRadius = 1.f;
                     _specParamBtn.layer.masksToBounds = YES;
                     [_specParamBtn setTag:fillInTag+i];
                     [_specParamBtn addTarget:self action:@selector(fillInAction:) forControlEvents:UIControlEventTouchUpInside];
                     [_specificationsScrollV addSubview:_specParamBtn];
                 }
             }
             
             // 配饰
             if (goodSpecModel.accessoriesList.count != 0) {
                 if (i != 0) {
                     _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
                     _bottomLine.backgroundColor = [UIColor grayColor];
                     [_specificationsScrollV addSubview:_bottomLine];
                 } else {
                     i ++;
                 }
                 
                 if (_bottomLine) {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, CGRectGetMaxY(_bottomLine.frame)+ScreenWidth*5/375, 200, ScreenWidth*20/375)];
                 } else {
                     _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
                 }
                 _specClassLab.text = @"配饰分类";
                 _specClassLab.textColor = [UIColor blackColor];
                 _specClassLab.font = classFont;
                 [_specificationsScrollV addSubview:_specClassLab];
                 
                 for (int i=0; i<goodSpecModel.accessoriesList.count; i++) {
                     NSDictionary *attribute = @{NSFontAttributeName:specFont};
                     CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
                     // 计算尺寸
                     BagParametersModel *paramsModel = goodSpecModel.accessoriesList[i];
                     CGSize contentSize = [paramsModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                     if (i == 0) {
                         _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                         
                     } else {
                         if ((ScreenWidth*306/375-CGRectGetMaxX(_specParamBtn.frame)-ScreenWidth*23/375)<contentSize.width) {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         } else {
                             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
                             
                         }
                     }
                     _specParamBtn.backgroundColor = BKColor;
                     [_specParamBtn setTitle:paramsModel.name forState:UIControlStateNormal];
                     if (paramsModel.count == 0) {
                         [_specParamBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _specParamBtn.userInteractionEnabled = NO;
                     } else {
                         [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                     }
                     if (paramsModel.isChose) {
                         _specParamBtn.backgroundColor = darkRedColor;
                         [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         selectAccessories = accessoriesTag + i;
                     }
                     _specParamBtn.titleLabel.font = specFont;
                     _specParamBtn.layer.cornerRadius = 1.f;
                     _specParamBtn.layer.masksToBounds = YES;
                     [_specParamBtn setTag:accessoriesTag+i];
                     [_specParamBtn addTarget:self action:@selector(accessoriesAction:) forControlEvents:UIControlEventTouchUpInside];
                     [_specificationsScrollV addSubview:_specParamBtn];
                 }
             }
             
             // 包装
             _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*10/375, ScreenWidth*306/375, 0.5)];
             _bottomLine.backgroundColor = [UIColor grayColor];
             [_specificationsScrollV addSubview:_bottomLine];
             
             if (_bottomLine) {
                 _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, CGRectGetMaxY(_bottomLine.frame)+ScreenWidth*5/375, 200, ScreenWidth*20/375)];
             } else {
                 _specClassLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*15/375, 0, 200, ScreenWidth*20/375)];
             }
             _specClassLab.text = @"包装";
             _specClassLab.textColor = [UIColor blackColor];
             _specClassLab.font = classFont;
             [_specificationsScrollV addSubview:_specClassLab];
             
             NSDictionary *attribute = @{NSFontAttributeName:specFont};
             CGSize limitSize = CGSizeMake(MAXFLOAT, ScreenWidth*18/375);
             // 计算尺寸
             CGSize contentSize = [@"四个字呢" boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_specClassLab.frame)+ScreenWidth*5/375, contentSize.width+ScreenWidth*20/375, limitSize.height)];
             [_specParamBtn setTitle:@"普通包装" forState:UIControlStateNormal];
             if ([goodSpecModel.pack isEqualToString:@"普通包装"]) {
                 _specParamBtn.backgroundColor = darkRedColor;
                 [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 selectPack = packTag + 0;
             } else {
                 _specParamBtn.backgroundColor = BKColor;
                 [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             }
             _specParamBtn.titleLabel.font = specFont;
             _specParamBtn.layer.cornerRadius = 1.f;
             _specParamBtn.layer.masksToBounds = YES;
             [_specParamBtn setTag:packTag+0];
             [_specParamBtn addTarget:self action:@selector(packAction:) forControlEvents:UIControlEventTouchUpInside];
             [_specificationsScrollV addSubview:_specParamBtn];
             
             _specParamBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_specParamBtn.frame)+ScreenWidth*10/375, _specParamBtn.origin.y, contentSize.width+ScreenWidth*20/375, limitSize.height)];
             [_specParamBtn setTitle:@"礼盒包装" forState:UIControlStateNormal];
             if ([goodSpecModel.pack isEqualToString:@"礼盒包装"]) {
                 _specParamBtn.backgroundColor = darkRedColor;
                 [_specParamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 selectPack = packTag + 1;
             } else {
                 _specParamBtn.backgroundColor = BKColor;
                 [_specParamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             }
             _specParamBtn.titleLabel.font = specFont;
             _specParamBtn.layer.cornerRadius = 1.f;
             _specParamBtn.layer.masksToBounds = YES;
             [_specParamBtn setTag:packTag+1];
             [_specParamBtn addTarget:self action:@selector(packAction:) forControlEvents:UIControlEventTouchUpInside];
             [_specificationsScrollV addSubview:_specParamBtn];
             
             _specificationsScrollV.contentOffset = CGPointMake(0, 0);
             _specificationsScrollV.contentSize = CGSizeMake(ScreenWidth*306/375, CGRectGetMaxY(_specParamBtn.frame)+ScreenWidth*3/37);
             
             [self.view bringSubviewToFront:_shadowView];
             [self.view bringSubviewToFront:_specificationsView];
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

- (void)addSelectState:(BOOL)selectState andSinglePrice:(double)price {
    if (selectState) {
        self.editPrice += price;
        self.totalPrice += price;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
    }
    
}

- (void)reduceSelectState:(BOOL)selectState andSinglePrice:(double)price {
    if (selectState) {
        self.editPrice -= price;
        self.totalPrice -= price;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
    }
}

- (void)commitWithSection:(int)section andRow:(int)row andNumber:(int)number andSinglePrice:(double)price {
    
    currentSection = -1;
    currentRow = -1;
    
    [self requestEditShopBagGoodNumberWithSection:(int)section andRow:(int)row andNumber:(int)number andSinglePrice:(double)price]; // 修改数量
    
}

- (void)cancelWithSection:(int)section andRow:(int)row andNumber:(int)number andSinglePrice:(double)price {
    
    currentSection = -1;
    currentRow = -1;
    
    self.totalPrice -= self.editPrice;
    self.editPrice = 0.0;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
    _totalPriceLab.attributedText = str;
    
    [_tableView reloadData];
}

#pragma mark 请求购物袋列表数据
- (void)requestShopBagListData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webShoppingBagsList postDic:parameters
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
             shopBagModel = [ShopBagModel objectWithKeyValues:retInfo];
             
             // 转商品ID
             int i;
             int j;
             for (i=0; i<shopBagModel.list.count; i++) {
                 ShopBagBrandModel *shopBagBrandModel = shopBagModel.list[i];
                 NSMutableArray *array = [NSMutableArray array];
                 for (j=0; j<shopBagBrandModel.goodsList.count; j++) {
                     ShopBagGoodModel *shopBagGoodModel = shopBagBrandModel.goodsList[j];
                     shopBagGoodModel.goodId = [retInfo[@"list"][i][@"goodsList"][j][@"id"] intValue];
                     shopBagGoodModel.selectState = NO; // 都为为选中
                     
                     NZShopBagViewModel *shopBagVM = [[NZShopBagViewModel alloc] init];
                     shopBagVM.shopBagGoodModel = shopBagGoodModel;
                     [array addObject:shopBagVM];
                 }
                 [shopBagVMArray addObject:array];
             }
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 购物袋编辑数量接口
- (void)requestEditShopBagGoodNumberWithSection:(int)section andRow:(int)row andNumber:(int)number andSinglePrice:(double)price {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSArray *shopBagVMAry = shopBagVMArray[section];
    NZShopBagViewModel *shopBagVM = shopBagVMAry[row];
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"id":[NSNumber numberWithInt:shopBagVM.shopBagGoodModel.goodId],
                                 @"count":[NSNumber numberWithInt:number]
                                 } ;
    
    [handler postURLStr:webShoppingBagsGoodNumberEdit postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
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
             self.editPrice = 0.0;
             
             shopBagVM.shopBagGoodModel.count = number;
             shopBagVM.shopBagGoodModel.totalPrice = number * price;
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
             
             self.totalPrice -= self.editPrice;
             self.editPrice = 0.0;
             
             NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
             [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
             [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
             [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
             _totalPriceLab.attributedText = str;
         }
     }] ;
}

#pragma mark 删除购物袋
- (void)deleteShopBagGood {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSArray *shopBagVMAry = shopBagVMArray[deleteSection];
    NZShopBagViewModel *shopBagVM = shopBagVMAry[deleteRow];
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"ids":[NSNumber numberWithInt:shopBagVM.shopBagGoodModel.goodId]
                                 } ;
    
    [handler postURLStr:webShoppingBagsGoodDelete postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
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
             NSMutableArray *shopBagVMAry = shopBagVMArray[deleteSection];
             [shopBagVMAry removeObjectAtIndex:deleteRow];
             if (shopBagVMAry.count == 0) {
                 [shopBagVMArray removeObjectAtIndex:deleteSection];
             }
             
             if (deleteState) { // 如果删除的时候是选择状态
                 self.totalPrice -= deletePrice * deleteNumber; // 总价要加
                 self.settleNumber --; // 结算个数要加
                 [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
             }
             NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
             [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
             [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
             [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
             _totalPriceLab.attributedText = str;
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 添加带阴影的子Layer（层）
- (void)addShadowSubLayer {
//    //添加子layer
//    CALayer *shadowLayer = [CALayer layer];
//    shadowLayer.backgroundColor = [UIColor cyanColor].CGColor;
//    shadowLayer.bounds = _settelView.bounds;
//    shadowLayer.position = CGPointZero;
    _settelView.layer.shadowOffset = CGSizeMake(0, 3); //设置阴影的偏移量
    _settelView.layer.shadowRadius = 10.0;  //设置阴影的半径
    _settelView.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
    _settelView.layer.shadowOpacity = 0.9; //设置阴影的不透明度
    
    _settelView.backgroundColor = BKColor;
    
}

#pragma mark 商品规格点击更改事件
- (void)weightAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectWeight];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectWeight = (int)button.tag;
}

- (void)sizeAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectSize];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectSize = (int)button.tag;
}

- (void)gradeAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectGrade];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectGrade = (int)button.tag;
}

- (void)colorAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectColor];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectColor = (int)button.tag;
}

- (void)hardnessAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectHardness];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectHardness = (int)button.tag;
}

- (void)fillInAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectFillIn];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectFillIn = (int)button.tag;
}

- (void)accessoriesAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectAccessories];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectAccessories = (int)button.tag;
}
- (void)packAction:(UIButton *)button {
    UIButton *lastBtn = (UIButton *)[_specificationsScrollV viewWithTag:selectPack];
    lastBtn.backgroundColor = BKColor;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.backgroundColor = darkRedColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectPack = (int)button.tag;
}

#pragma mark 按钮点击事件

- (void)commitSpeAction:(UIButton *)button {
    [self.view sendSubviewToBack:_specificationsView];
    [self.view sendSubviewToBack:_shadowView];
    
    [_specificationsScrollV removeAllSubviews];
}

- (IBAction)allSelectAction:(UIButton *)sender {
    // 编辑中不可选
    if (currentSection > -1) {
        return;
    }
    
    isAllSelect = YES;
    // 判断有没有全选
    for (int i = 0; i < shopBagVMArray.count; i++) {
        NSArray *shopBagVMAry = shopBagVMArray[i];
        for (int j=0; j<shopBagVMAry.count; j++) {
            NZShopBagViewModel *shopBagVM = shopBagVMAry[j];
            if (!shopBagVM.shopBagGoodModel.selectState) {
                isAllSelect = NO;
                break;
            }
        }
    }
    
    if (isAllSelect) {
        self.settleNumber = 0;
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
        for (int i = 0; i < shopBagVMArray.count; i++) {
            NSArray *shopBagVMAry = shopBagVMArray[i];
            for (int j=0; j<shopBagVMAry.count; j++) {
                NZShopBagViewModel *shopBagVM = shopBagVMAry[j];
                shopBagVM.shopBagGoodModel.selectState = NO;
            }
        }
        
        self.totalPrice = 0.0;
        self.expressPrice = 0.0;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
        
        _expressPriceLab.text = @"不含运费";
    } else {
        int count = 0;
        for (int i = 0; i < shopBagVMArray.count; i++) {
            NSArray *shopBagVMAry = shopBagVMArray[i];
            for (int j=0; j<shopBagVMAry.count; j++) {
                count ++;
            }
        }
        self.settleNumber = count;
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        _selectImgV.image = [UIImage imageNamed:@"圆-已选"];
        for (int i = 0; i < shopBagVMArray.count; i++) {
            NSArray *shopBagVMAry = shopBagVMArray[i];
            for (int j=0; j<shopBagVMAry.count; j++) {
                NZShopBagViewModel *shopBagVM = shopBagVMAry[j];
                if (!shopBagVM.shopBagGoodModel.selectState) {
                    self.totalPrice += shopBagVM.shopBagGoodModel.totalPrice;
                    self.expressPrice += shopBagVM.shopBagGoodModel.expressPrice;
                }
                shopBagVM.shopBagGoodModel.selectState = YES;
            }
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
        
        NSString *expressPriceStr = [NSString stringWithFormat:@"运费：%.2f元",self.expressPrice];
        _expressPriceLab.text = expressPriceStr;
    }
    
    [_tableView reloadData];

}

- (IBAction)settleAction:(UIButton *)sender {
    if (self.settleNumber == 0) {
        [self.view makeToast:@"请先选择商品"];
    } else {
        ShopBagModel *settleBagModel = [[ShopBagModel alloc] init];
        settleBagModel.list = [NSMutableArray array];
        for (int i = 0; i < shopBagModel.list.count; i++) {
            ShopBagBrandModel *settleBrandModel = [[ShopBagBrandModel alloc] init];
            settleBrandModel.goodsList = [NSMutableArray array];
            ShopBagBrandModel *brandModel = shopBagModel.list[i];
            for (int j=0; j<brandModel.goodsList.count; j++) {
                ShopBagGoodModel *goodModel = brandModel.goodsList[j];
                if (goodModel.selectState) {
                    [settleBrandModel.goodsList addObject:goodModel];
                }
            }
            if (settleBrandModel.goodsList.count != 0) {
                settleBrandModel.shopId = brandModel.shopId;
                settleBrandModel.shopName = brandModel.shopName;
                [settleBagModel.list addObject:settleBrandModel];
            }
        }
        
        NZConfirmOrderViewController *confirmOrderVCTR = [[NZConfirmOrderViewController alloc] init];
        confirmOrderVCTR.shopBagModel = settleBagModel;
        [self.navigationController pushViewController:confirmOrderVCTR animated:YES];
    }
}

@end
