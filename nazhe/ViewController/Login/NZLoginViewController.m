//
//  NZLoginViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZLoginViewController.h"
#import "NZSelectBindingViewController.h"

#define tintBrown [UIColor colorWithRed:163/255.f green:105/255.f blue:68/255.f alpha:1.0] // 注册和忘记密码的字体颜色

@interface NZLoginViewController ()<UITextFieldDelegate> {
    
    UIView *backView; // 背景底图
    
    UITextField *phoneNumField; // ☎️输入框
    UILabel *noExistLab; // 号码不存在
    
    UITextField *passwordField; // 密码输入框
    UIImageView *closeEyes; // 暗文密码
    UIImageView *openEyes; // 明文密码

    UIButton *loginBtn; // 登录按钮
    
    NSTimer *timer; // 定时器让弹框消失
    
    BOOL isOpenEye; // 明暗文密码
    BOOL loginPhone; // 登录手机是否输入正确
    BOOL password; // 登录密码是否输入正确
    
    BOOL canLogin; // 能否登录
}

@end

@implementation NZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isOpenEye = NO;
    
    loginPhone = NO;
    password = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self initInterface]; // 初始化登录界面
}

#pragma mark 初始化注册界面
- (void)initInterface {
    // 背景底图
    backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    // 登录关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(ScreenWidth*30/375, 20+ScreenWidth*20/375, ScreenWidth*21/375, ScreenWidth*21/375)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"登录叉号"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backToLastView:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
    
    /********************   手机号   ***********************/
    // 图标
    UIImageView *phoneNumIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*55/375, CGRectGetMaxY(closeBtn.frame)+ScreenWidth*225/375, ScreenWidth*21/375, ScreenWidth*25/375)];
    phoneNumIcon.image = [UIImage imageNamed:@"登录"];
    [backView addSubview:phoneNumIcon];
    
    // 输入框
    phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneNumIcon.frame)+ScreenWidth*20/375, phoneNumIcon.origin.y, ScreenWidth-ScreenWidth*151/375, ScreenWidth*25/375)];
    phoneNumField.font = [UIFont fontWithName:@"Arial" size:17.f];
    phoneNumField.placeholder = @"手机号";
    //    phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.returnKeyType = UIReturnKeyDone;
    phoneNumField.delegate = self;
    [backView addSubview:phoneNumField];
    
    // 号码不存在
    noExistLab = [[UILabel alloc] initWithFrame:phoneNumField.frame];
    noExistLab.text = @"号码不存在";
    noExistLab.textColor = darkRedColor;
    noExistLab.font = [UIFont systemFontOfSize:11.f];
    noExistLab.textAlignment = NSTextAlignmentRight;
    noExistLab.hidden = YES;
    [backView addSubview:noExistLab];
    [backView sendSubviewToBack:noExistLab];
    
    // 输入框底线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(phoneNumField.origin.x-ScreenWidth*10/375, CGRectGetMaxY(phoneNumField.frame)+8, phoneNumField.frame.size.width+ScreenWidth*10/375, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line1];
    
    /********************   登录密码   ***********************/
    // 图标
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*55/375, CGRectGetMaxY(phoneNumIcon.frame)+ScreenWidth*35/375, ScreenWidth*21/375, ScreenWidth*23/375)];
    passwordIcon.image = [UIImage imageNamed:@"登录密码"];
    [backView addSubview:passwordIcon];
    
    // 输入框
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordIcon.frame)+ScreenWidth*20/375, passwordIcon.origin.y-ScreenWidth*1/375, ScreenWidth-ScreenWidth*151/375, ScreenWidth*25/375)];
    passwordField.font = [UIFont fontWithName:@"Arial" size:17.f];
    passwordField.placeholder = @"登录密码";
    passwordField.secureTextEntry = YES;
    //    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.keyboardType = UIKeyboardTypeAlphabet;
    passwordField.returnKeyType = UIReturnKeyDone;
    [passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    passwordField.delegate = self;
    [backView addSubview:passwordField];
    
    // 暗文标记
    closeEyes = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordField.frame)-ScreenWidth*18/375, passwordField.origin.y+ScreenWidth*6.5/375, ScreenWidth*18/375, ScreenWidth*17/375)];
    closeEyes.image = [UIImage imageNamed:@"闭眼"];
    [backView addSubview:closeEyes];
    
    // 明文标记
    openEyes = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordField.frame)-ScreenWidth*18/375, passwordField.origin.y+ScreenWidth*10/375, ScreenWidth*18/375, ScreenWidth*10/375)];
    openEyes.image = [UIImage imageNamed:@"开眼"];
    openEyes.hidden = YES;
    [backView addSubview:openEyes];
    
    UIButton *eyesBtn = [[UIButton alloc] initWithFrame:closeEyes.frame];
    [eyesBtn addTarget:self action:@selector(passwordOpenOrClose) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyesBtn];
    
    // 输入框底线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(passwordField.origin.x-ScreenWidth*10/375, CGRectGetMaxY(passwordField.frame)+8, passwordField.frame.size.width+ScreenWidth*10/375, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line2];
    
    /********************   登录按钮   ***********************/
    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*175/375)/2, CGRectGetMaxY(line2.frame)+ScreenWidth*35/375, ScreenWidth*175/375, ScreenWidth*40/375)];
    loginBtn.backgroundColor = [UIColor lightGrayColor];
    [loginBtn setTitle:@"登     录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    loginBtn.layer.cornerRadius = 1.f;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:loginBtn];
    
    // 注册和找回密码中间的分割线
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-1)/2, CGRectGetMaxY(loginBtn.frame)+ScreenWidth*20/375, 1, 10)];
    centerLine.backgroundColor = tintBrown;
    [backView addSubview:centerLine];
    
    // 账号注册
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(centerLine.origin.x-ScreenWidth*20/375-50, centerLine.origin.y, 50, 10)];
    [registBtn setTitle:@"账号注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:tintBrown forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [backView addSubview:registBtn];
    // 找回密码
    UIButton *findPassBtn = [[UIButton alloc] initWithFrame:CGRectMake(centerLine.origin.x+1+ScreenWidth*20/375, centerLine.origin.y, 50, 10)];
    [findPassBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPassBtn setTitleColor:tintBrown forState:UIControlStateNormal];
    findPassBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [backView addSubview:findPassBtn];
    
    // 微信图标
    UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*50/375)/2, CGRectGetMaxY(centerLine.frame)+ScreenWidth*65/375, ScreenWidth*50/375, ScreenWidth*50/375)];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:weixinBtn];
    
    UILabel *weixinLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weixinBtn.frame)+ScreenWidth*10/375, ScreenWidth, 10)];
    weixinLab.text = @"微信登录";
    weixinLab.textColor = [UIColor lightGrayColor];
    weixinLab.font = [UIFont systemFontOfSize:12.f];
    weixinLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:weixinLab];
    
    // 微信图标两边虚线
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder]; // 按Done后，关闭键盘
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if ([textField isEqual:phoneNumField]) {
        noExistLab.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    if ([textField isEqual:phoneNumField]) {
        if ([NZGlobal isMobileNumber:textField.text]) {
            loginPhone = YES;
        } else {
            noExistLab.hidden = NO;
            loginPhone = NO;
        }
    } else if ([textField isEqual:passwordField]) {
        if (passwordField.text.length>5 && passwordField.text.length<17) {
            password = YES;
        } else {
            if (passwordField.text.length == 0) {
                password = YES;
            } else {
                password = NO;
            }
            
        }
    }
    
    if (loginPhone && password) {
        canLogin = YES;
        loginBtn.backgroundColor = darkRedColor;
    } else {
        canLogin = NO;
        loginBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark 明暗文密码
- (void)passwordOpenOrClose {
    if (isOpenEye) {
        openEyes.hidden = YES;
        closeEyes.hidden = NO;
        passwordField.secureTextEntry = YES;
    } else {
        openEyes.hidden = NO;
        closeEyes.hidden = YES;
        passwordField.secureTextEntry = NO;
    }
    isOpenEye = !isOpenEye;
}

#pragma mark 登录事件
- (void)loginAction:(UIButton *)button {
    
    if (canLogin) {
        __weak typeof(self)wSelf = self ;
        
        NZWebHandler *handler = [[NZWebHandler alloc] init] ;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText = @"请稍候..." ;
        
        NZUser *user = [NZUserManager sharedObject].user ;
        
        NSString *pushToken = [NSString stringWithFormat:@"%@",user.pushToken] ;
        
        NSDictionary *parameters = @{
                                     @"phone":phoneNumField.text,
                                     @"password":passwordField.text,
                                     @"pushToken":pushToken
                                     } ;
        
        [handler postURLStr:webLogin postDic:parameters
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
             
             BOOL state = [[retInfo objectForKey:@"state"] boolValue];
             
             if( state )
             {
                 NZUser *user = [NZUserManager sharedObject].user ;
                 
                 user.userId = [NSString stringWithFormat:@"%d",[retInfo[@"detail"][@"userId"] intValue]];
                 
                 user.token = retInfo[@"detail"][@"token"];
                 
                 user.phone = phoneNumField.text;
                 
                 [self showLoginSuccess]; // 登录成功动画
             }
             
             else
             {
                 [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
             }
         }] ;
    }
    
}

#pragma mark 微信登录
- (void)weixinLogin:(UIButton *)button {
    NZSelectBindingViewController *selectBindingVCTR = [[NZSelectBindingViewController alloc] init];
    selectBindingVCTR.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:selectBindingVCTR animated:YES];
}

#pragma mark 登录成功动画
- (void)showLoginSuccess {
    UIView *maskBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskBackView.backgroundColor = [UIColor blackColor];
    maskBackView.alpha = 0.8f;
    [backView addSubview:maskBackView];
    
    UIImageView *successImg = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*130/375)/2, ScreenWidth*145/375+20, ScreenWidth*130/375, ScreenWidth*130/375)];
    successImg.image = [UIImage imageNamed:@"登录成功"];
    [maskBackView addSubview:successImg];
    
    UILabel *successLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(successImg.frame)+ScreenWidth*20/375, ScreenWidth, 20)];
    successLab.text = @"登录成功";
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 关闭登录界面
- (void)backToLastView:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark navigationBar收缩自如
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

@end
