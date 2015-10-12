//
//  NZMyWalletViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/6.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZMyWalletViewController.h"
#import "NZMyWalletContentView.h"
#import "NZBillingViewController.h"
#import "NZMyCouponViewController.h"
#import "MyWalletModel.h"

@interface NZMyWalletViewController () {
    NZMyWalletContentView *contentView;
    
    MyWalletModel *myWalletModel; // 我的钱包数据模型
    
    BOOL expend;
    
    UILabel *balanceLab; // 当前帐户总余额
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NZMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    expend = NO;
    
    [self createNavigationItemTitleViewWithTitle:@"我的钱包"];
    [self leftButtonTitle:nil];

    [self initInterface];
    [self addButtonAction];

    [self requestMyWalletData]; // 请求我的钱包数据
}

#pragma mark 初始化界面
- (void)initInterface {
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    contentView = [[[NSBundle mainBundle] loadNibNamed:@"NZMyWalletContentView" owner:self options:nil] lastObject];
    [self.scrollView addSubview:contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    
    
    // 当前帐户总余额
    NSString *balanceStr = @"58,005.00";
    CGSize balanceLimitSzie = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSDictionary *balanceAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:30.f]};
    // 根据获取到的字符串以及字体计算label需要的size
    CGSize balanceSize = [balanceStr boundingRectWithSize:balanceLimitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:balanceAttribute context:nil].size;
    balanceLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 100, balanceSize.width, balanceSize.height)];
    balanceLab.text = balanceStr;
    balanceLab.textColor = darkRedColor;
    balanceLab.font = [UIFont systemFontOfSize:30.f];
    [contentView addSubview:balanceLab];
    
    UIImageView *redUpArrow = [[UIImageView alloc] init];
    redUpArrow.image = [UIImage imageNamed:@"红上箭头"];
    [contentView addSubview:redUpArrow];
    [redUpArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).with.offset(105);
        make.height.mas_equalTo(17);
        make.left.equalTo(balanceLab.mas_right).with.offset(5);
        make.width.mas_equalTo(9);
    }];
    
    // 充值和提现按钮圆角边框
    contentView.rechargeBtn.layer.cornerRadius = 2.f;
    contentView.rechargeBtn.layer.masksToBounds = YES;
    contentView.rechargeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    contentView.rechargeBtn.layer.borderWidth = 0.5f;
    
    contentView.withdrawalsBtn.layer.cornerRadius = 2.f;
    contentView.withdrawalsBtn.layer.masksToBounds = YES;
    contentView.withdrawalsBtn.layer.borderColor = [UIColor grayColor].CGColor;
    contentView.withdrawalsBtn.layer.borderWidth = 0.5f;
    // 确认充值
    contentView.commitRechargeBtn.layer.cornerRadius = 2.f;
    contentView.commitRechargeBtn.layer.masksToBounds = YES;
    contentView.commitRechargeBtn.layer.borderColor = [UIColor redColor].CGColor;
    contentView.commitRechargeBtn.layer.borderWidth = 0.5f;
    // 申请提现
    contentView.commitWithdrawalsBtn.layer.cornerRadius = 2.f;
    contentView.commitWithdrawalsBtn.layer.masksToBounds = YES;
    contentView.commitWithdrawalsBtn.layer.borderColor = [UIColor grayColor].CGColor;
    contentView.commitWithdrawalsBtn.layer.borderWidth = 0.5f;
}

#pragma mark 让充值和提现界面动起来
- (void)addButtonAction {
    // 给打开充值添加Action
    [contentView.rechargeBtn addTarget:self action:@selector(openRecharge:) forControlEvents:UIControlEventTouchUpInside];
    // 给打开提现添加Action
    [contentView.withdrawalsBtn addTarget:self action:@selector(openWithdrawals:) forControlEvents:UIControlEventTouchUpInside];
    // 添加关闭Action
    [contentView.rechargeCloseBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.withdrawalsCloseBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 查看优享券
    [contentView.checkCouponBtn addTarget:self action:@selector(checkCouponJump:) forControlEvents:UIControlEventTouchUpInside];
    // 账单纪录
    [contentView.billRecordBtn addTarget:self action:@selector(billRecordJump:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ButtonAction
- (void)openRecharge:(UIButton *)button {
    expend = YES;
    [self.view layoutIfNeeded];
    
    // 充值和提现按钮圆角边框
    contentView.rechargeBtn.backgroundColor = [UIColor redColor];
    [contentView.rechargeBtn setTitleColor:[UIColor whiteColor
                                            ] forState:UIControlStateNormal];
    contentView.rechargeBtn.layer.borderWidth = 0.f;

    contentView.withdrawalsBtn.backgroundColor = [UIColor whiteColor];
    [contentView.withdrawalsBtn setTitleColor:[UIColor blackColor
                                            ] forState:UIControlStateNormal];
    contentView.withdrawalsBtn.layer.borderWidth = 0.5f;
    
    contentView.rechargView.hidden = NO;
    contentView.withdrawalsView.hidden = YES;
    
    [UIView animateWithDuration:0.2f animations:^{
        contentView.moveView.center = CGPointMake(ScreenWidth/2, 493.5);
    }];
}

- (void)openWithdrawals:(UIButton *)button {
    expend = YES;
    [self.view layoutIfNeeded];
    
    // 充值和提现按钮圆角边框
    contentView.withdrawalsBtn.backgroundColor = [UIColor redColor];
    [contentView.withdrawalsBtn setTitleColor:[UIColor whiteColor
                                            ] forState:UIControlStateNormal];
    contentView.withdrawalsBtn.layer.borderWidth = 0.f;
    
    contentView.rechargeBtn.backgroundColor = [UIColor whiteColor];
    [contentView.rechargeBtn setTitleColor:[UIColor blackColor
                                            ] forState:UIControlStateNormal];
    contentView.rechargeBtn.layer.borderWidth = 0.5f;
    
    contentView.rechargView.hidden = YES;
    contentView.withdrawalsView.hidden = NO;
    
    [UIView animateWithDuration:0.2f animations:^{
        contentView.moveView.center = CGPointMake(ScreenWidth/2, 493.5);
    }];
}

- (void)closeAction:(UIButton *)button {
    expend = NO;
    
    contentView.rechargeBtn.backgroundColor = [UIColor whiteColor];
    [contentView.rechargeBtn setTitleColor:[UIColor blackColor
                                            ] forState:UIControlStateNormal];
    contentView.rechargeBtn.layer.borderWidth = 0.5f;
    
    contentView.withdrawalsBtn.backgroundColor = [UIColor whiteColor];
    [contentView.withdrawalsBtn setTitleColor:[UIColor blackColor
                                            ] forState:UIControlStateNormal];
    contentView.withdrawalsBtn.layer.borderWidth = 0.5f;
    
    [UIView animateWithDuration:0.2f animations:^{
        contentView.moveView.center = CGPointMake(ScreenWidth/2, 313.5);
    }];
}

- (void)checkCouponJump:(UIButton *)button {
    NZMyCouponViewController *myCouponVCTR = [[NZMyCouponViewController alloc] init];
    [self.navigationController pushViewController:myCouponVCTR animated:YES];
}

- (void)billRecordJump:(UIButton *)button {
    NZBillingViewController *billVCTR = [[NZBillingViewController alloc] init];
    [self.navigationController pushViewController:billVCTR animated:YES];
}

#pragma mark 请求我的钱包数据
- (void)requestMyWalletData {
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webMyWalletDetail postDic:parameters
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
             
             myWalletModel = [MyWalletModel objectWithKeyValues:retInfo[@"detail"]];
             
             // 土豪榜排名
             NSMutableAttributedString *rankStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"好圈友土豪排行第%d名",myWalletModel.ranking]];
             NSLog(@"%ld",rankStr.length);
             [rankStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 8)];
             //    [rankStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9, 10)];
             //    [rankStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(11, 11)];
             //    [rankStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 8)];
             //    [rankStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:NSMakeRange(9, 10)];
             //    [rankStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(11, 11)];
             contentView.rankLab.attributedText = rankStr;
             
             // 当前帐户总余额
             NSString *balanceStr = [NSString stringWithFormat:@"%.2f",myWalletModel.totalAccount];
             CGSize balanceLimitSzie = CGSizeMake(MAXFLOAT, MAXFLOAT);
             NSDictionary *balanceAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:30.f]};
             // 根据获取到的字符串以及字体计算label需要的size
             CGSize balanceSize = [balanceStr boundingRectWithSize:balanceLimitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:balanceAttribute context:nil].size;
             balanceLab.frame = CGRectMake(25, 100, balanceSize.width, balanceSize.height);
             balanceLab.text = balanceStr;
             // 总收益
             contentView.totalIncomeLab.text = [NSString stringWithFormat:@"%.2f",myWalletModel.totalIncome];
             // 新收益
             contentView.todayIncomeLab.text = [NSString stringWithFormat:@"%.2f",myWalletModel.todayIncome];
             // 固定账户
             contentView.fixedAccountLab.text = [NSString stringWithFormat:@"%.2f",myWalletModel.fixedAccount];
             // 活动账户
             contentView.currentAccountLab.text = [NSString stringWithFormat:@"%.2f",myWalletModel.currentAccount];
             // 我的积分
             contentView.integrationLab.text = [NSString stringWithFormat:@"%d",myWalletModel.integration];
             // 我的优享券张数
             contentView.countTicketLab.text = [NSString stringWithFormat:@"%d",myWalletModel.countTicket];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
    
}

#pragma mark contentView约束
- (void)viewDidLayoutSubviews {
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:ScreenWidth]);
//        if (expend) {
            make.height.equalTo([NSNumber numberWithFloat:contentView.moveView.origin.y+contentView.moveView.frame.size.height+50+180]);
//        } else {
//            make.height.equalTo([NSNumber numberWithFloat:contentView.moveView.origin.y+contentView.moveView.frame.size.height+100]);
//        }
    }];
    
    [super viewDidLayoutSubviews];
}

@end
