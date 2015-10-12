//
//  NZSelectBindingViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZSelectBindingViewController.h"
#import "NZRegistFirstViewController.h"
#import "NZBindingViewController.h"

@interface NZSelectBindingViewController ()

@end

@implementation NZSelectBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self initInterface]; // 初始化登录界面
}

#pragma mark 初始化注册界面
- (void)initInterface {
    // 背景底图
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    // 登录关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(ScreenWidth*30/375, 20+ScreenWidth*20/375, ScreenWidth*21/375, ScreenWidth*21/375)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"登录叉号"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backToLastView:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
    
    // 亲～
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(closeBtn.frame)+ScreenWidth*130/375, ScreenWidth, 15)];
    label1.text = @"亲～";
    label1.textColor = [UIColor grayColor];
    label1.font = [UIFont systemFontOfSize:17.f];
    label1.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label1];
    
    // 为了给您提供更多优质服务，
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+ScreenWidth*20/375, ScreenWidth, 15)];
    label2.text = @"为了给您提供更多优质服务，";
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:17.f];
    label2.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label2];
    
    // 您需要绑定一个拿着账号，
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+ScreenWidth*20/375, ScreenWidth, 15)];
    label3.text = @"您需要绑定一个拿着账号，";
    label3.textColor = [UIColor grayColor];
    label3.font = [UIFont systemFontOfSize:17.f];
    label3.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label3];
    
    // 您可以：
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label3.frame)+ScreenWidth*20/375, ScreenWidth, 15)];
    label4.text = @"您可以：";
    label4.textColor = [UIColor grayColor];
    label4.font = [UIFont systemFontOfSize:17.f];
    label4.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label4];
    
    // 绑定新的拿着账号，领取奖品
    UIButton *bindingBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*50/375, CGRectGetMaxY(label4.frame)+ScreenWidth*30/375, ScreenWidth-ScreenWidth*100/375, ScreenWidth*40/375)];
    bindingBtn1.backgroundColor = darkRedColor;
    [bindingBtn1 setTitle:@"绑定新的拿着账号，领取奖品" forState:UIControlStateNormal];
    [bindingBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bindingBtn1.titleLabel.font = [UIFont systemFontOfSize:17.f];
    bindingBtn1.layer.cornerRadius = 1.f;
    bindingBtn1.layer.masksToBounds = YES;
    [bindingBtn1 addTarget:self action:@selector(registJumpAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:bindingBtn1];
    
    // 绑定已有的拿着账号
    UIButton *bindingBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*50/375, CGRectGetMaxY(bindingBtn1.frame)+ScreenWidth*25/375, ScreenWidth-ScreenWidth*100/375, ScreenWidth*40/375)];
    bindingBtn2.backgroundColor = [UIColor whiteColor];
    [bindingBtn2 setTitle:@"绑定已有的拿着账号" forState:UIControlStateNormal];
    [bindingBtn2 setTitleColor:darkRedColor forState:UIControlStateNormal];
    bindingBtn2.titleLabel.font = [UIFont systemFontOfSize:17.f];
    bindingBtn2.layer.cornerRadius = 1.f;
    bindingBtn2.layer.masksToBounds = YES;
    bindingBtn2.layer.borderWidth = 0.5f;
    bindingBtn2.layer.borderColor = darkRedColor.CGColor;
    [bindingBtn2 addTarget:self action:@selector(bindingJumpAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:bindingBtn2];
}

#pragma mark 跳转注册界面
- (void)registJumpAction:(UIButton *)button {
    NZRegistFirstViewController *registVCTR = [[NZRegistFirstViewController alloc] init];
    
    [self.navigationController pushViewController:registVCTR animated:YES];
}

#pragma mark 跳转绑定界面
- (void)bindingJumpAction:(UIButton *)button {
    NZBindingViewController *bindingVCTR = [[NZBindingViewController alloc] init];
    bindingVCTR.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:bindingVCTR animated:YES];
}

#pragma mark 返回登录界面
- (void)backToLastView:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark navigationBar收缩自如
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = NO;
}

@end
