//
//  NZTakeController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZTakeController.h"
#import "NZTakeContentView.h"
#import "NZSettingViewController.h"
#import "NZOrderViewController.h"
#import "NZShoppingBagViewController.h"
#import "NZPrivilegeViewController.h"
#import "NZMessageViewController.h"
#import "NZMyWalletViewController.h"
#import "NZCustomerServiceViewController.h"
#import "NZLoginViewController.h"
#import "TakeFirstViewModel.h"

@interface NZTakeController () {
    NZTakeContentView *contentView;
    
    TakeFirstViewModel *takeModel; // 拿着一级页面数据模型
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NZTakeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItemTitleViewWithTitle:@"拿着"];
    [self createLeftAndRightNavigationItemButton];
    
    [self initInterface];
    [self cuttingAllViews];
    [self addBtnAction];
}

#pragma mark 初始化界面
- (void)initInterface {
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    contentView = [[[NSBundle mainBundle] loadNibNamed:@"NZTakeContentView" owner:self options:nil] lastObject];
    [self.scrollView addSubview:contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    
}

#pragma mark 切圆角
- (void)cuttingAllViews {
    contentView.headImageView.layer.cornerRadius = contentView.headImageView.frame.size.width / 2;
    contentView.headImageView.layer.masksToBounds = YES;
    
    [self cuttingCornerRadius:contentView.serviceView];
    [self cuttingCornerRadius:contentView.settingView];
    [self cuttingCornerRadius:contentView.gameView];
    [self cuttingCornerRadius:contentView.favoritesView];
    [self cuttingCornerRadius:contentView.shopBagView];
    [self cuttingCornerRadius:contentView.privilegeView];
    [self cuttingCornerRadius:contentView.friendsView];
    [self cuttingCornerRadius:contentView.messageView];
    [self cuttingCornerRadius:contentView.orderView];
}

- (void)cuttingCornerRadius:(UIView *)view {
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark 添加点击事件
- (void)addBtnAction {
    [contentView.intoWalletBtn addTarget:self action:@selector(intoWalletAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.rewardBtn addTarget:self action:@selector(rewardAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView.friendsBtn addTarget:self action:@selector(friendsAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.messageBtn addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.orderBtn addTarget:self action:@selector(orderAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.favoritesBtn addTarget:self action:@selector(favoritesAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.privilegeBtn addTarget:self action:@selector(privilegeAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.shopBagBtn addTarget:self action:@selector(shopBagAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.serviceBtn addTarget:self action:@selector(serviceAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.gameBtn addTarget:self action:@selector(gameAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.settingBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)intoWalletAction:(UIButton *)button {
    NZMyWalletViewController *myWalletVCTR = [[NZMyWalletViewController alloc] initWithNibName:@"NZMyWalletViewController" bundle:nil];
    myWalletVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWalletVCTR animated:YES];
}

- (void)rewardAction:(UIButton *)button {
    
}
/**********************   好友   ***************************/
- (void)friendsAction:(UIButton *)button {
    
}
/**********************   信息   ***************************/
- (void)messageAction:(UIButton *)button {
    NZMessageViewController *messageVCTR = [[NZMessageViewController alloc] initWithNibName:@"NZMessageViewController" bundle:nil];
    messageVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVCTR animated:YES];
}
/**********************   订单   ***************************/
- (void)orderAction:(UIButton *)button {
    NZOrderViewController *orderVCTR = [[NZOrderViewController alloc] initWithNibName:@"NZOrderViewController" bundle:nil];
    orderVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVCTR animated:YES];
}
/**********************   收藏   ***************************/
- (void)favoritesAction:(UIButton *)button {
    
}
/**********************   特权   ***************************/
- (void)privilegeAction:(UIButton *)button {
    NZPrivilegeViewController *privilegeVCTR = [[NZPrivilegeViewController alloc] initWithNibName:@"NZPrivilegeViewController" bundle:nil];
    privilegeVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:privilegeVCTR animated:YES];
}
/**********************   购物袋   ***************************/
- (void)shopBagAction:(UIButton *)button {
    NZShoppingBagViewController *shopBagVCTR = [[NZShoppingBagViewController alloc] initWithNibName:@"NZShoppingBagViewController" bundle:nil];
    shopBagVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopBagVCTR animated:YES];
}
/**********************   客服   ***************************/
- (void)serviceAction:(UIButton *)button {
    NZCustomerServiceViewController *serviceVCTR = [[NZCustomerServiceViewController alloc] initWithNibName:@"NZCustomerServiceViewController" bundle:nil];
    serviceVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:serviceVCTR animated:YES];
}
/**********************   游戏（暂未开通）   ***************************/
- (void)gameAction:(UIButton *)button {
    
}
/**********************   设置   ***************************/
- (void)settingAction:(UIButton *)button {
    NZSettingViewController *settingVCTR = [[NZSettingViewController alloc] initWithNibName:@"NZSettingViewController" bundle:nil];
    settingVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVCTR animated:YES];
}

#pragma mark 请求拿着一级页面数据
- (void) requestDate {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webTakeFirstPage postDic:parameters
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
             takeModel = [TakeFirstViewModel objectWithKeyValues:retInfo[@"detail"]]; // 字典转模型
             
             takeModel.headImg = [handler GetImgBaseURL:takeModel.headImg];
             
             
             
             [contentView.headImageView sd_setImageWithURL:[NSURL URLWithString:takeModel.headImg] placeholderImage:[UIImage imageNamed:@"头像男"]];
             
             contentView.nickNameLab.text = takeModel.nickName;
             
             NSMutableAttributedString *signDayStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"连续登录%d天",takeModel.signDays]];
             [signDayStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
             [signDayStr addAttribute:NSForegroundColorAttributeName value:darkRedColor range:NSMakeRange(4,signDayStr.length-5)];
             [signDayStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(signDayStr.length-1,1)];
             contentView.signDaysLab.attributedText = signDayStr;
             
             contentView.integralLab.text = [NSString stringWithFormat:@"积分 %d  /",takeModel.integration];
             
             if (takeModel.star == 1) {
                 contentView.starBar.image = [UIImage imageNamed:@"黑一星"];
             } else if (takeModel.star == 2) {
                 contentView.starBar.image = [UIImage imageNamed:@"黑二星"];
             } else if (takeModel.star == 3) {
                 contentView.starBar.image = [UIImage imageNamed:@"黑三星"];
             } else if (takeModel.star == 4) {
                 contentView.starBar.image = [UIImage imageNamed:@"黑四星"];
             } else if (takeModel.star == 5) {
                 contentView.starBar.image = [UIImage imageNamed:@"黑五星"];
             }
             
             NSString *incomeStr = [NSString stringWithFormat:@"%.2f",takeModel.TotalIncome];
             UIFont *font = [UIFont systemFontOfSize:29.f];
             NSDictionary *attribute = @{NSFontAttributeName:font};
             
             CGSize limitSize = CGSizeMake(MAXFLOAT, 25);
             // 计算总收益的尺寸
             CGSize incomeSize = [incomeStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
             // 总收益label要根据文字内容宽度决定它的位置
             if (contentView.totalIncomeLab) {
                 contentView.totalIncomeLab.frame = CGRectMake((ScreenWidth-ScreenWidth*180/375-incomeSize.width)/2+ScreenWidth*160/375, ScreenWidth*25/375, incomeSize.width, 25);
             } else {
                 contentView.totalIncomeLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*180/375-incomeSize.width)/2+ScreenWidth*160/375, ScreenWidth*25/375, incomeSize.width, 25)];
                 [contentView addSubview:contentView.totalIncomeLab];
             }
             contentView.totalIncomeLab.font = font;
             contentView.totalIncomeLab.textAlignment = NSTextAlignmentCenter;
             contentView.totalIncomeLab.text = [NSString stringWithFormat:@"%.2f",takeModel.TotalIncome];
             contentView.totalIncomeLab.textColor = darkGoldColor;
             
             // 总收益右边的箭头只能根据它的位置确定自己的位置
             if (contentView.upArrow) {
                 contentView.upArrow.frame = CGRectMake(CGRectGetMaxX(contentView.totalIncomeLab.frame)+5, contentView.totalIncomeLab.origin.y-3, 9, 17);
             } else {
                 contentView.upArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentView.totalIncomeLab.frame)+5, contentView.totalIncomeLab.origin.y-3, 9, 17)];
                 contentView.upArrow.image = [UIImage imageNamed:@"金色箭头"];
                 [contentView addSubview:contentView.upArrow];
             }
             
             contentView.countFriendLab.text = [NSString stringWithFormat:@"%d人",takeModel.CountFriend];
             
             contentView.countMsgLab.text = [NSString stringWithFormat:@"%d条未读",takeModel.CountMsg];
             
             contentView.countOrderLab.text = [NSString stringWithFormat:@"%d个交易中",takeModel.CountOrder];
             
             contentView.countFavoritesLab.text = [NSString stringWithFormat:@"%d个",takeModel.CountFavorites];
             
             contentView.countPrivilegeLab.text = [NSString stringWithFormat:@"已点亮%d个",takeModel.CountPrivilege];
             
             contentView.countBagLab.text = [NSString stringWithFormat:@"%d个商品",takeModel.CountshippingBage];
             
             contentView.countServiceLab.text = [NSString stringWithFormat:@"%d条留言",takeModel.CountNotRead];
             
             contentView.countPrizeLab.text = [NSString stringWithFormat:@"获得奖品%d个",takeModel.CountPrize];
             
             contentView.versionLab.text = [NSString stringWithFormat:@"当前版本%@",takeModel.version];
             
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
//        NSLog(@"%@",[NSNumber numberWithFloat:CGRectGetMaxY(contentView.starBar.frame)+ScreenWidth+ScreenWidth*35/375]);
//        CGFloat height = CGRectGetMaxY(contentView.starBar.frame)+ScreenWidth+ScreenWidth*35/375;
        
//        make.width.mas_equalTo(ScreenWidth);
//        make.height.mas_equalTo(CGRectGetMaxY(contentView.starBar.frame)+ScreenWidth+ScreenWidth*35/375);
//        if (IS_IPHONE_6P) {
//            make.height.equalTo([NSNumber numberWithFloat:623]);
//        } else {
//            make.height.equalTo([NSNumber numberWithFloat:554]);
//        }
        make.height.equalTo([NSNumber numberWithFloat:ScreenWidth*160/375+ScreenWidth+20]);
    }];
    
    [super viewDidLayoutSubviews];
}

#pragma mark 四个主视图的tabBar收缩自如
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    self.hidesBottomBarWhenPushed = NO;
    
    //     判断有没有登录，需不需要显示登录界面
    NZFastOperate *fastOpt = [NZFastOperate sharedObject];
    if ([fastOpt isLogin] == NO) {
        NZLoginViewController *loginVCTR = [[NZLoginViewController alloc] init];
        loginVCTR.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVCTR animated:YES];
    } else {
        [self requestDate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.hidesBottomBarWhenPushed = YES;
}

@end
