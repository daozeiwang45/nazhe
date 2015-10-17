//
//  NZSettingViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZSettingViewController.h"
#import "NZSettingContentView.h"
#import "NZPersonalViewController.h"
#import "NZPrivacyViewController.h"
#import "NZPasswordViewController.h"
#import "NZDeliveryAddressViewController.h"
#import "NZProtocolViewController.h"
#import "NZBankCardViewController.h"
#import "SettingModel.h"

#define animationDuration 0.2

@interface NZSettingViewController () {
    NZSettingContentView *contentView;
    
    NSTimer *timer; // 定时器让弹框消失
    
    UIView *pickerBackView; // 弹框透明背景
    
    CGFloat cacheSize; // 缓存大小
    UILabel *label1;
    UILabel *label2;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *signatureLab; // 个性签名

@end

@implementation NZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItemTitleViewWithTitle:@"设置"];
    [self leftButtonTitle:nil];
    
    [self initInterface];
    [self addButtonAction];
    
    // 计算缓存大小
    cacheSize = [self folderSizeAtPath];
    contentView.cacheLab.text = [NSString stringWithFormat:@"%1.fMb",cacheSize];
    
    
}

#pragma mark 初始化界面
- (void)initInterface {
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    contentView = [[[NSBundle mainBundle] loadNibNamed:@"NZSettingContentView" owner:self options:nil] objectAtIndex:0];
    [self.scrollView addSubview:contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    _signatureLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 155, ScreenWidth - 80, 40)];
    _signatureLab.font = [UIFont systemFontOfSize:14.f];
    _signatureLab.numberOfLines = 0;
    [contentView addSubview:_signatureLab];

}

#pragma mark 添加界面跳转事件
- (void)addButtonAction {
    // 个人资料
    [contentView.personalBtn addTarget:self action:@selector(personalJump:) forControlEvents:UIControlEventTouchUpInside];
    // 银行卡
    [contentView.bankCardBtn addTarget:self action:@selector(bankCardJump:) forControlEvents:UIControlEventTouchUpInside];
    // 隐私设置
    [contentView.privacyBtn addTarget:self action:@selector(privacyJump:) forControlEvents:UIControlEventTouchUpInside];
    // 密码设置
    [contentView.passwordBtn addTarget:self action:@selector(passwordJump:) forControlEvents:UIControlEventTouchUpInside];
    // 收货地址管理
    [contentView.deliveryAddressBtn addTarget:self action:@selector(deliveryAddressJump:) forControlEvents:UIControlEventTouchUpInside];
    // 用户协议
    [contentView.protocolBtn addTarget:self action:@selector(protocolJump:) forControlEvents:UIControlEventTouchUpInside];
    
    // 清除缓存
    [contentView.cacheBtn addTarget:self action:@selector(cleanCache) forControlEvents:UIControlEventTouchUpInside];
    // 当前版本
    [contentView.versionBtn addTarget:self action:@selector(currentVersion) forControlEvents:UIControlEventTouchUpInside];
    
    // 退出登录
    [contentView.exitBtn setTitleColor:darkRedColor forState:UIControlStateNormal]; // 按钮文字颜色
    [contentView.exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 计算缓存大小

- (float)folderSizeAtPath {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if([fileManager fileExistsAtPath:cachePath]){
        folderSize = [fileManager attributesOfItemAtPath:cachePath error:nil].fileSize/1024.0/1024.0;
        NSLog(@"%f",folderSize);
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
//    return 0;
//    if ([fileManager fileExistsAtPath:cachePath]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
//        for (NSString *fileName in childerFiles) {
//            NSString *absolutePath=[cachePath stringByAppendingPathComponent:fileName];
//            folderSize += [self fileSizeAtPath:absolutePath];
//        }
        //SDWebImage框架自身计算缓存的实现
//    folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//    return folderSize;
//    }
    return 0;
}

#pragma mark 清除缓存
- (void)cleanCache {
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       // 清除SDWebImage的缓存
                       [[SDImageCache sharedImageCache] cleanDisk];
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
    // 弹框动画
    pickerBackView = [[UIView alloc] initWithFrame:self.view.bounds];
//    NSLog(@"%f   %f",contentView.frame.size.height,self.scrollView.contentSize.height);
    pickerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pickerBackView];
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*305/375)/2, 305, ScreenWidth*305/375, ScreenWidth*218/375)];
    animationView.backgroundColor = [UIColor clearColor];
    [pickerBackView addSubview:animationView];
    
    UIImageView *cacheBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*305/375, ScreenWidth*218/375)];
    cacheBack.image = [UIImage imageNamed:@"左底"];
    [animationView addSubview:cacheBack];
    
    UIImageView *cache = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth*305/375-ScreenWidth*102/375)/2, ScreenWidth*35/375, ScreenWidth*102/375, ScreenWidth*77/375)];
    cache.image = [UIImage imageNamed:@"缓存"];
    [animationView addSubview:cache];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*127/375, ScreenWidth*305/375, 15)];
    label1.font = [UIFont systemFontOfSize:11.f];
    label1.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:label1];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*127/375+25, ScreenWidth*305/375, 15)];
    label2.font = [UIFont systemFontOfSize:11.f];
    label2.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:label2];
    
    /*********************     animationView动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = animationDuration;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake((ScreenWidth-70)/4, ScreenWidth*523/375)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:animationView.center];
    //    positionAnimation.fillMode = kCAFillModeForwards;
    //    positionAnimation.removedOnCompletion = NO;
    [animationView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = animationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.1f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.f];
    //    scaleAnimation.fillMode = kCAFillModeForwards;
    //    scaleAnimation.removedOnCompletion = NO;
    [animationView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

- (void)clearCacheSuccess {
    // 计算清除掉的缓存大小
    CGFloat currentCacheSize = [self folderSizeAtPath];
    
    CGFloat clearCacheSize = cacheSize - currentCacheSize;
    if (clearCacheSize < 1) {
        label1.text = @"当前缓存";
        label2.text = @"没有什么好清理的～";
    } else {
        label1.text = @"恭喜您";
        label2.text = [NSString stringWithFormat:@"清理了%1.fMb的缓存～",clearCacheSize];
    }
    
    cacheSize = currentCacheSize;
    contentView.cacheLab.text = [NSString stringWithFormat:@"%1.fMb",cacheSize];
}

#pragma mark 计时2秒弹框消失
- (void)dismiss {
    [pickerBackView removeFromSuperview];
    label1 = nil;
    label2 = nil;
    pickerBackView = nil;
    
    // 释放定时器，视图还原，关闭动画
    if (timer.isValid) {
        [timer invalidate];
    }
    timer = nil;
}

#pragma mark 查询版本
- (void)currentVersion {
    // 弹框动画
    pickerBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    pickerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pickerBackView];
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*305/375)/2, 305, ScreenWidth*305/375, ScreenWidth*218/375)];
    animationView.backgroundColor = [UIColor clearColor];
    [pickerBackView addSubview:animationView];
    
    UIImageView *versionBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*305/375, ScreenWidth*218/375)];
    versionBack.image = [UIImage imageNamed:@"右底"];
    [animationView addSubview:versionBack];
    
    UIImageView *version = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth*305/375-ScreenWidth*102/375)/2, ScreenWidth*35/375, ScreenWidth*102/375, ScreenWidth*77/375)];
    version.image = [UIImage imageNamed:@"版本"];
    [animationView addSubview:version];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*127/375, ScreenWidth*305/375, 15)];
    label1.text = @"恭喜您！";
    label1.font = [UIFont systemFontOfSize:11.f];
    label1.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:label1];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*127/375+25, ScreenWidth*305/375, 15)];
    label2.text = @"当前是最新版本1.0～";
    label2.font = [UIFont systemFontOfSize:11.f];
    label2.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:label2];
    
    /*********************     animationView动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = animationDuration;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake((ScreenWidth-70)/4*3, ScreenWidth*523/375)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:animationView.center];
    //    positionAnimation.fillMode = kCAFillModeForwards;
    //    positionAnimation.removedOnCompletion = NO;
    [animationView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = animationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.1f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.f];
    //    scaleAnimation.fillMode = kCAFillModeForwards;
    //    scaleAnimation.removedOnCompletion = NO;
    [animationView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

#pragma mark 界面跳转
- (void)personalJump:(UIButton *)button {
    NZPersonalViewController *personalVCTR = [[NZPersonalViewController alloc] init];
//    personalVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalVCTR animated:YES];
}

- (void)bankCardJump:(UIButton *)button {
    NZBankCardViewController *bankCardVCTR = [[NZBankCardViewController alloc] init];
    [self.navigationController pushViewController:bankCardVCTR animated:YES];
}

- (void)privacyJump:(UIButton *)button {
    NZPrivacyViewController *privacyVCTR = [[NZPrivacyViewController alloc] init];
    //    privacyVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:privacyVCTR animated:YES];
}

- (void)passwordJump:(UIButton *)button {
    NZPasswordViewController *passwordVCTR = [[NZPasswordViewController alloc] init];
    //    passwordVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:passwordVCTR animated:YES];
}

- (void)deliveryAddressJump:(UIButton *)button {
    NZDeliveryAddressViewController *addressVCTR = [[NZDeliveryAddressViewController alloc] init];
    //    addressVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVCTR animated:YES];
}

- (void)protocolJump:(UIButton *)button {
    NZProtocolViewController *protocolVCTR = [[NZProtocolViewController alloc] init];
    //    protocolVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:protocolVCTR animated:YES];
}

#pragma mark 请求设置界面数据
- (void)requestSettingData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webSettingPage postDic:parameters
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
             SettingModel *settingModel = [[SettingModel alloc] init];
             settingModel = [SettingModel objectWithKeyValues:retInfo[@"detail"]];
             
             // 设置头像
             if ([[settingModel.headImg trim] isNotEqualsToString:emptyString]) {
                 settingModel.headImg = [handler GetImgBaseURL:settingModel.headImg];
                 if ([settingModel.sex isEqualToString:@"女"]) {
                     [contentView.headImage sd_setImageWithURL:[NSURL URLWithString:settingModel.headImg] placeholderImage:[UIImage imageNamed:@"头像女"]];
                 } else {
                     [contentView.headImage sd_setImageWithURL:[NSURL URLWithString:settingModel.headImg] placeholderImage:[UIImage imageNamed:@"头像男"]];
                 }
             } else {
                 if ([settingModel.sex isEqualToString:@"女"]) {
                     contentView.headImage.image = [UIImage imageNamed:@"头像女"];
                 } else {
                     contentView.headImage.image = [UIImage imageNamed:@"头像男"];
                 }
             }
             
             contentView.nickNameLab.text = settingModel.nickName;
             
             contentView.phoneLab.text = settingModel.phone;
             
             if ([settingModel.recommendMan isEqualToString:emptyString]) {
                 contentView.recommendLab.text = @"推荐人： 无";
             } else {
                 contentView.recommendLab.text = [NSString stringWithFormat:@"推荐人： %@",settingModel.recommendMan];
             }
             
             NSMutableAttributedString *starStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d 星级",settingModel.star]];
             [starStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
             [starStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(1,starStr.length-1)];
             contentView.levelLab.attributedText = starStr;
             
             NSMutableAttributedString *IDStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ID %@",settingModel.idNum]];
             [IDStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,2)];
             [IDStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2,IDStr.length-2)];
             contentView.IDLab.attributedText = IDStr;
             
             NSMutableAttributedString *areaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"地区 %@",settingModel.province]];
             [areaStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,2)];
             [areaStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2,areaStr.length-2)];
             contentView.areaLab.attributedText = areaStr;
             
             NSMutableAttributedString *hometownStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"故乡 %@",settingModel.hometown]];
             [hometownStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,2)];
             [hometownStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2,hometownStr.length-2)];
             contentView.homtownLab.attributedText = hometownStr;
             
             NSMutableAttributedString *signatureStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"个性签名: %@",settingModel.signature]];
             NSLog(@"%ld",signatureStr.length);
//             NSLog(@"%ld",@"个性签名:");
             [signatureStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,5)];
             [signatureStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5,signatureStr.length-5)];
             NSLog(@"%@",signatureStr);
             _signatureLab.attributedText = signatureStr;
            [_signatureLab sizeToFit];
             
             contentView.privacyLab.text = [NSString stringWithFormat:@"资料开放%d%%",settingModel.openPercent];
             
             contentView.passwordLab.text = [NSString stringWithFormat:@"级别%@",settingModel.passwordLevel];
             
             contentView.deliveryAddLab.text = [NSString stringWithFormat:@"%d个",settingModel.countAddress];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}


#pragma mark 退出登录
- (void)exitAction:(UIButton *)button {
    NZUser *user = [NZUserManager sharedObject].user;
    [user clear];
    
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark contentView约束
- (void)viewDidLayoutSubviews {
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:self.scrollView.frame.size.width]);
        make.height.equalTo([NSNumber numberWithFloat:603]);
    }];
    
    [super viewDidLayoutSubviews];
}

#pragma mark 视图出现
- (void)viewWillAppear:(BOOL)animated {
    [self requestSettingData]; // 请求数据
}

#pragma mark 视图消失
- (void)viewWillDisappear:(BOOL)animated {
    if (pickerBackView) {
        [pickerBackView removeFromSuperview];
        label1 = nil;
        label2 = nil;
        pickerBackView = nil;
    }
}

@end
