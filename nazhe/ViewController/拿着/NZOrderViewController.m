//
//  NZOrderViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/31.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderViewController.h"
#import "ProgressBarView.h"
#import "NZOrderTableViewCell.h"
#import "NZOrderExpendTableViewCell.h"
#import "OrderListModel.h"
#import "NZOrderViewModel.h"

@interface NZOrderViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL expand;
    int selectIndex;
    NSIndexPath *selectIndexPath;
    NSIndexPath *lastIndexPath;
    
    OrderListModel *orderListModel; // 订单列表数据
    int type; // 订单列表类型(0:全部,1:待付款,2:待收货,3:已完成)
    float percent;
    
    NSMutableDictionary *orderDictionary; // 当前类型订单字典（要区分年份为key值）

}

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) ProgressBarView *progressBarView;
@property (nonatomic, strong) UILabel *totalMoneyLab; // 消费总金额(这个要根据文字长度设置frame)
@property (nonatomic, strong) UIImageView *upArrow; // 金额上标根据上面的label变

@property (strong, nonatomic) IBOutlet UILabel *nextLevelLab;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (strong, nonatomic) IBOutlet UIView *shadeView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *allLab;
@property (strong, nonatomic) IBOutlet UILabel *allNumber;
@property (strong, nonatomic) IBOutlet UILabel *waitPayLab;
@property (strong, nonatomic) IBOutlet UILabel *waitPayNumber;
@property (strong, nonatomic) IBOutlet UILabel *waitReceiptLab;
@property (strong, nonatomic) IBOutlet UILabel *waitReceiptNumber;
@property (strong, nonatomic) IBOutlet UILabel *endServiceLab;
@property (strong, nonatomic) IBOutlet UILabel *endServiceNumber;

@property (assign, nonatomic) NSInteger buttonIndicator ; // 如果那个点击的某一个按钮，则立即将该按钮的tag赋值给buttonIndicator

- (IBAction)allClick:(UIButton *)sender;
- (IBAction)waitPayClick:(UIButton *)sender;
- (IBAction)waitReceiptClick:(UIButton *)sender;
- (IBAction)endServiceClick:(UIButton *)sender;


@end

@implementation NZOrderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super self];
    if (self) {
        [self initDataSource];
        orderDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)initDataSource {
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    expand = NO;
    selectIndex = -1;
    type = 0;
    
    [self createNavigationItemTitleViewWithTitle:@"订单"];
    [self leftButtonTitle:nil];
    
    _centerView.backgroundColor = orderBarColor;
    _levelLabel.textColor = darkRedColor;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.progressBarView = [[ProgressBarView alloc]initWithFrame:CGRectMake(30, 17, 96, 96)];
    [self.progressBarView setBackgroundColor:[UIColor clearColor]];
    self.progressBarView.delegate = self;
    [self.topView addSubview: self.progressBarView];
    [self.topView sendSubviewToBack:self.progressBarView];
    
    // 消费总金额label
    NSString *moneyStr = @"90500.00";
    UIFont *contentFont = [UIFont systemFontOfSize:36.f];
    NSDictionary *attribute = @{NSFontAttributeName:contentFont};
    CGSize limitSize = CGSizeMake(MAXFLOAT, 35);
    // 计算尺寸
    CGSize contentSize = [moneyStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    _totalMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-140-contentSize.width)/2+120, 38, contentSize.width, 35)];
    _totalMoneyLab.text = moneyStr;
    _totalMoneyLab.textColor = darkGoldColor;
    _totalMoneyLab.font = contentFont;
    [self.topView addSubview:_totalMoneyLab];
    
    // 金额右边向上图标
    _upArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_totalMoneyLab.frame)+5, _totalMoneyLab.origin.y+2, 9, 17)];
    _upArrow.image = [UIImage imageNamed:@"金色箭头"];
    [self.topView addSubview:_upArrow];
    
    [self requestOrderListData]; // 请求订单列表数据
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sectionNum = 0;

    for (int i=0; i<[orderDictionary allKeys].count; i++) {
        NSDictionary *dic = [orderDictionary objectForKey:[orderDictionary allKeys][i]];
        for (int j=0; j<[dic allKeys].count; j++) {
            sectionNum ++;
        }
    }
    
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int sectionNum = 0;
    int i;
    int j;
    for (i=0; i<[orderDictionary allKeys].count; i++) {
        NSDictionary *dic = [orderDictionary objectForKey:[orderDictionary allKeys][i]];
        for (j=0; j<[dic allKeys].count; j++) {
            if (section == sectionNum) {
                NSArray *array = [dic objectForKey:[dic allKeys][j]];
                return array.count;
            }
            sectionNum ++;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    int sectionNum = 0;
    int i;
    int j;
    for (i=0; i<[orderDictionary allKeys].count; i++) {
        NSDictionary *dic = [orderDictionary objectForKey:[orderDictionary allKeys][i]];
        for (j=0; j<[dic allKeys].count; j++) {
            if (indexPath.section == sectionNum) {
                NSArray *array = [dic objectForKey:[dic allKeys][j]];
                OrderInfoModel *orderInfo = array[indexPath.row];
                
                if (indexPath == selectIndexPath) {
                    NZOrderExpendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZOrderExpendViewCellIdentify];
                    if (cell == nil) {
                        cell = [[NZOrderExpendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZOrderExpendViewCellIdentify];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        //删除cell的所有子视图
                        while ([cell.contentView.subviews lastObject] != nil)
                        {
                            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
                        }
                    }
                    NZOrderViewModel *orderVM = [[NZOrderViewModel alloc] init];
                    orderVM.orderInfo = orderInfo;
                    cell.orderVM = orderVM;
                    return cell;
                } else {
                    NZOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZOrderViewCellIdentify];
                    if (cell == nil) {
                        cell = [[NZOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZOrderViewCellIdentify];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        //删除cell的所有子视图
                        while ([cell.contentView.subviews lastObject] != nil)
                        {
                            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
                        }
                    }
                    cell.orderInfo = orderInfo;
                    return cell;
                }
            }
            sectionNum ++;
        }
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    int sectionNum = 0;
    int i;
    int j;
    for (i=0; i<[orderDictionary allKeys].count; i++) {
        NSDictionary *dic = [orderDictionary objectForKey:[orderDictionary allKeys][i]];
        int dicKeyNumber = [[NSNumber numberWithUnsignedInteger:[dic allKeys].count] intValue]; // uiinteger转nsnumber 再转int
        for (j=dicKeyNumber-1; j>-1; j--) {
            if (section == sectionNum) {
                
                if (section == 0) {
                    headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
                    
                    UILabel *yearLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 100, 20)];
                    yearLab.text = [orderDictionary allKeys][i];
                    yearLab.textColor = [UIColor grayColor];
                    yearLab.font = [UIFont systemFontOfSize:20.f];
                    yearLab.textAlignment = NSTextAlignmentCenter;
                    [headerView addSubview:yearLab];
                    
                    UILabel *monthLab = [[UILabel alloc] initWithFrame:CGRectMake(154, 20, 100, 20)];
                    monthLab.text = [NSString stringWithFormat:@"%@月",[dic allKeys][j]];
                    monthLab.textColor = [UIColor grayColor];
                    monthLab.font = [UIFont systemFontOfSize:20.f];
                    [headerView addSubview:monthLab];
                    
                } else {
                    headerView.frame = CGRectMake(0, 0, ScreenWidth, 20);
                    
                    UILabel *yearLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 20)];
                    yearLab.text = [orderDictionary allKeys][i];
                    yearLab.textColor = [UIColor grayColor];
                    yearLab.font = [UIFont systemFontOfSize:20.f];
                    yearLab.textAlignment = NSTextAlignmentCenter;
                    [headerView addSubview:yearLab];
                    
                    UILabel *monthLab = [[UILabel alloc] initWithFrame:CGRectMake(154, 0, 100, 20)];
                    monthLab.text = [NSString stringWithFormat:@"%@月",[dic allKeys][j]];
                    monthLab.textColor = [UIColor grayColor];
                    monthLab.font = [UIFont systemFontOfSize:20.f];
                    [headerView addSubview:monthLab];
                }
            }
            sectionNum ++;
        }
    }
    
    return headerView;

}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == selectIndexPath) {
        int sectionNum = 0;
        int i;
        int j;
        for (i=0; i<[orderDictionary allKeys].count; i++) {
            NSDictionary *dic = [orderDictionary objectForKey:[orderDictionary allKeys][i]];
            for (j=0; j<[dic allKeys].count; j++) {
                if (indexPath.section == sectionNum) {
                    NSArray *array = [dic objectForKey:[dic allKeys][j]];
                    OrderInfoModel *orderInfo = array[indexPath.row];
                    NZOrderViewModel *orderVM = [[NZOrderViewModel alloc] init];
                    orderVM.orderInfo = orderInfo;
                    
                    return CGRectGetMaxY(orderVM.button2Frame)+ScreenWidth*15/375;
                }
                sectionNum ++;
            }
        }
        
    }
    return ScreenWidth*125/375;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.f;
    }
    return 20.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (expand) {
        if (indexPath == selectIndexPath) {
            selectIndex = -1;
            selectIndexPath = nil;
            lastIndexPath = nil;
            expand = NO;
            [_tableView reloadData];
            return;
        } else {
            selectIndex = (int)indexPath.row;
            selectIndexPath = indexPath;
            [_tableView reloadData];
            lastIndexPath = selectIndexPath;
            return;
        }
    } else {
        selectIndex = (int)indexPath.row;
        selectIndexPath = indexPath;
        [_tableView reloadData];
        lastIndexPath = selectIndexPath;
        expand = YES;
    }
}

#pragma mark 请求订单列表数据
- (void)requestOrderListData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"state":[NSNumber numberWithInt:type],
                                 @"page_no":[NSNumber numberWithInt:1]
                                 } ;
    
    [handler postURLStr:webOrderList postDic:parameters
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
             if (type == 0) {
                 _levelLabel.text = [NSString stringWithFormat:@"%d",[retInfo[@"star"] intValue]];
                 _nextLevelLab.text = [NSString stringWithFormat:@"%d",[retInfo[@"star"] intValue]+1];
                 _percentLabel.text = [NSString stringWithFormat:@"%.1f%%",[retInfo[@"percent"] floatValue]];
                 
                 percent = [retInfo[@"percent"] floatValue] / 100;
//                 [self.progressBarView run: 0.0f andPercent: 0.839f];
                 
                 // 消费总金额label
                 NSString *moneyStr = [NSString stringWithFormat:@"%.2f",[retInfo[@"totalMoney"] floatValue]];
                 UIFont *contentFont = [UIFont systemFontOfSize:36.f];
                 NSDictionary *attribute = @{NSFontAttributeName:contentFont};
                 CGSize limitSize = CGSizeMake(MAXFLOAT, 35);
                 // 计算尺寸
                 CGSize contentSize = [moneyStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                 
                 _totalMoneyLab.frame = CGRectMake((ScreenWidth-140-contentSize.width)/2+120, 38, contentSize.width, 35);
                 _totalMoneyLab.text = moneyStr;
                 
                 // 金额右边向上图标
                 _upArrow.frame = CGRectMake(CGRectGetMaxX(_totalMoneyLab.frame)+5, _totalMoneyLab.origin.y+2, 9, 17);

                 _allNumber.text = [NSString stringWithFormat:@"%d",[retInfo[@"countAll"] intValue]];
                 _waitPayNumber.text = [NSString stringWithFormat:@"%d",[retInfo[@"countPay"] intValue]];
                 _waitReceiptNumber.text = [NSString stringWithFormat:@"%d",[retInfo[@"countReceipt"] intValue]];
                 _endServiceNumber.text = [NSString stringWithFormat:@"%d",[retInfo[@"countFinish"] intValue]];
             }
             
             orderListModel = [OrderListModel objectWithKeyValues:retInfo[@"result"]];
             
             [orderDictionary removeAllObjects];
             
             // 因为商品参数有一个叫id的，转模型转不过来，要手动转
             int i;
             int j;
             for (i=0; i<orderListModel.list.count; i++) {
                 OrderInfoModel *model = orderListModel.list[i];
                 for (j=0; j<model.goods.count; j++) {
                     GoodsInfoModel *goodModel = model.goods[j];
                     int goodsID = [retInfo[@"result"][@"list"][i][@"goods"][j][@"id"] intValue];
                     goodModel.goodID = goodsID;
                 }
                 
                 /*******************    给不同的年月分section   ********************/
//                 NSDictionary *dic = @{
//                                       @"year":[NSNumber numberWithInt:model.year],
//                                       @"month":[NSNumber numberWithInt:model.month],
//                                       @"date":model.date,
//                                       @"state":[NSNumber numberWithInt:model.state],
//                                       @"receiverName":model.receiverName,
//                                       @"address":model.address,
//                                       @"goods":model.goods,
//                                       @"orderId":model.orderId,
//                                       @"tradingNumber":model.tradingNumber,
//                                       @"createDate":model.createDate,
//                                       @"payDate":model.payDate,
//                                       @"sendDate":model.sendDate,
//                                       @"discountPrice":[NSNumber numberWithFloat:model.discountPrice],
//                                       @"totalPrice":[NSNumber numberWithFloat:model.totalPrice]
//                                       };
                 
                 if([[orderDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d",model.year]]) {
                     
                     NSMutableDictionary *yearDic = orderDictionary[[NSString stringWithFormat:@"%d",model.year]];
                     
                     if([[yearDic allKeys] containsObject:[NSString stringWithFormat:@"%d",model.month]]) {
                         
                         NSMutableArray *dicArray = [yearDic objectForKey:[NSString stringWithFormat:@"%d",model.month]];
                         
                         [dicArray addObject:model];
                         
//                         [yearDic setObject:dicArray forKey:[NSString stringWithFormat:@"%d",model.month]];
                         
                     } else {
                         
                         NSMutableArray *dicArray = [NSMutableArray arrayWithObject:model];
                         
                         /***************** 在这里yearDic已经不是可变字典，需要再把它转成可变字典 ***************/
                         NSMutableDictionary *yearDic2 = [NSMutableDictionary dictionaryWithDictionary:orderDictionary[[NSString stringWithFormat:@"%d",model.year]]];
                         
                         yearDic = yearDic2;
                         
                         [yearDic setObject:dicArray forKey:[NSString stringWithFormat:@"%d",model.month]];
                         
                     }
                     
                     [orderDictionary setObject:yearDic forKey:[NSString stringWithFormat:@"%d",model.year]];
                     
                     
                 } else {
                     
                     NSMutableArray *dicArray = [NSMutableArray arrayWithObject:model];
                     
                     NSDictionary *monthDic = [NSDictionary dictionaryWithObject:dicArray forKey:[NSString stringWithFormat:@"%d",model.month]];
                     
                     [orderDictionary setObject:monthDic forKey:[NSString stringWithFormat:@"%d",model.year]];
                    
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

#pragma mark 让经验条动起来的方法
- (void)animationDidStop:(CAAnimation *)processAnimation finished:(BOOL)flag {
    
    float currentProgress = self.progressBarView.currentProgress * 100;
    
    if (self.progressBarView.currentProgress < percent) {
        self.percentLabel.text = [NSString stringWithFormat:@"%.1f%@", currentProgress, @"%"];
        [self.progressBarView run:self.progressBarView.currentProgress andPercent:percent];
    }
}

#pragma mark 订单选择按钮动画
- (void)moveShadeView:(UIButton*)btn{
    
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         
         CGRect frame = self.shadeView.frame;
         frame.origin.x = btn.frame.origin.x;
         self.shadeView.frame = frame;
    
     } completion:^(BOOL finished){//do other thing
     }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (IBAction)allClick:(UIButton *)sender {
    [self moveShadeView:sender];
    expand = NO;
    selectIndex = -1;
    selectIndexPath = nil;
    type = 0;
    [self requestOrderListData];
}

- (IBAction)waitPayClick:(UIButton *)sender {
    [self moveShadeView:sender];
    expand = NO;
    selectIndex = -1;
    selectIndexPath = nil;
    type = 1;
    [self requestOrderListData];
}

- (IBAction)waitReceiptClick:(UIButton *)sender {
    [self moveShadeView:sender];
    expand = NO;
    selectIndex = -1;
    selectIndexPath = nil;
    type = 2;
    [self requestOrderListData];
}

- (IBAction)endServiceClick:(UIButton *)sender {
    [self moveShadeView:sender];
    expand = NO;
    selectIndex = -1;
    selectIndexPath = nil;
    type = 3;
    [self requestOrderListData];
}
@end
