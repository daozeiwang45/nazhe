//
//  NZBindingViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZBindingViewController.h"

@interface NZBindingViewController () {
    
    UIView *backView; // 背景底图
    
    UITextField *passwordField; // 密码输入框
    UIImageView *closeEyes; // 暗文密码
    UIImageView *openEyes; // 明文密码
    
    UIButton *bindingBtn; // 绑定按钮
    
    NSTimer *timer; // 定时器让弹框消失
}

@end

@implementation NZBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(ScreenWidth*30/375, 20+ScreenWidth*20/375, ScreenWidth*11/375, ScreenWidth*22/375)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    /********************   手机号   ***********************/
    // 图标
    UIImageView *phoneNumIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*55/375, CGRectGetMaxY(backBtn.frame)+ScreenWidth*225/375, ScreenWidth*21/375, ScreenWidth*25/375)];
    phoneNumIcon.image = [UIImage imageNamed:@"登录"];
    [backView addSubview:phoneNumIcon];
    
    // 输入框
    UITextField *phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneNumIcon.frame)+ScreenWidth*20/375, phoneNumIcon.origin.y, ScreenWidth-ScreenWidth*151/375, ScreenWidth*25/375)];
    phoneNumField.font = [UIFont fontWithName:@"Arial" size:17.f];
    phoneNumField.placeholder = @"手机号";
    phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.returnKeyType =UIReturnKeyNext;
    [backView addSubview:phoneNumField];
    
    // 号码不存在
    UILabel *noExistLab = [[UILabel alloc] initWithFrame:phoneNumField.frame];
    noExistLab.text = @"号码不存在";
    noExistLab.textColor = darkRedColor;
    noExistLab.font = [UIFont systemFontOfSize:11.f];
    noExistLab.textAlignment = NSTextAlignmentRight;
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
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.returnKeyType =UIReturnKeyNext;
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
    
    // 输入框底线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(passwordField.origin.x-ScreenWidth*10/375, CGRectGetMaxY(passwordField.frame)+8, passwordField.frame.size.width+ScreenWidth*10/375, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line2];
    
    /********************   登录按钮   ***********************/
    bindingBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*175/375)/2, CGRectGetMaxY(line2.frame)+ScreenWidth*35/375, ScreenWidth*175/375, ScreenWidth*40/375)];
    bindingBtn.backgroundColor = [UIColor lightGrayColor];
    [bindingBtn setTitle:@"绑     定" forState:UIControlStateNormal];
    bindingBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    bindingBtn.layer.cornerRadius = 1.f;
    bindingBtn.layer.masksToBounds = YES;
    [bindingBtn addTarget:self action:@selector(bindingSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:bindingBtn];
}

#pragma mark 绑定成功
- (void)bindingSuccess:(UIButton *)button {
    
    UIView *maskBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskBackView.backgroundColor = [UIColor blackColor];
    maskBackView.alpha = 0.8f;
    [backView addSubview:maskBackView];
    
    UIImageView *successImg = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*130/375)/2, ScreenWidth*145/375+20, ScreenWidth*130/375, ScreenWidth*130/375)];
    successImg.image = [UIImage imageNamed:@"登录成功"];
    [maskBackView addSubview:successImg];
    
    UILabel *successLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(successImg.frame)+ScreenWidth*20/375, ScreenWidth, 20)];
    successLab.text = @"绑定成功";
    successLab.textColor = [UIColor whiteColor];
    successLab.font = [UIFont systemFontOfSize:22.f];
    successLab.textAlignment = NSTextAlignmentCenter;
    [maskBackView addSubview:successLab];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
    
}

#pragma mark 返回选择绑定界面
- (void)backViewAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
    
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
