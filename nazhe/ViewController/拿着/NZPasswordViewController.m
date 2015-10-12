//
//  NZPasswordViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZPasswordViewController.h"

@interface NZPasswordViewController ()<UITextFieldDelegate> {
    BOOL expendView1;
    BOOL expendView2;
    
    NSTimer *timer; // 验证码倒计时
    int seconds; // 账号密码
}
// 账号密码
@property (strong, nonatomic) IBOutlet UITextField *oldAccPassword;
@property (strong, nonatomic) IBOutlet UITextField *accCode;
@property (strong, nonatomic) IBOutlet UITextField *nAccPassword;
@property (strong, nonatomic) IBOutlet UITextField *againAccpassword;
@property (strong, nonatomic) IBOutlet UIButton *accCodeBtn;
// 交易密码
@property (strong, nonatomic) IBOutlet UITextField *oldTradingPass;
@property (strong, nonatomic) IBOutlet UITextField *tradingCode;
@property (strong, nonatomic) IBOutlet UITextField *nTradingPass;
@property (strong, nonatomic) IBOutlet UITextField *againTradingPass;
@property (strong, nonatomic) IBOutlet UIButton *tradingCodeBtn;

@property (strong, nonatomic) IBOutlet UIView *moveView1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moveConstraint1;
@property (strong, nonatomic) IBOutlet UIView *moveView2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moveConstraint2;

- (IBAction)showView1:(UIButton *)sender;
- (IBAction)showView2:(UIButton *)sender;

- (IBAction)hideView1:(UIButton *)sender;
- (IBAction)hideView2:(UIButton *)sender;
- (IBAction)editView1:(UIButton *)sender;
- (IBAction)editView2:(UIButton *)sender;

@end

@implementation NZPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    expendView1 = NO;
    expendView2 = NO;
    seconds = 60;
    
    [self createNavigationItemTitleViewWithTitle:@"密码设置"];
    [self leftButtonTitle:nil];
    
    _oldAccPassword.delegate = self;
    _accCode.delegate = self;
    _nAccPassword.delegate = self;
    _againAccpassword.delegate = self;
    
    _oldTradingPass.delegate = self;
    _tradingCode.delegate = self;
    _nTradingPass.delegate = self;
    _againTradingPass.delegate = self;
    
    _accCodeBtn.layer.cornerRadius = 1.f;
    _accCodeBtn.layer.masksToBounds = YES;
    [_accCodeBtn addTarget:self action:@selector(codeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _tradingCodeBtn.layer.cornerRadius = 1.f;
    _tradingCodeBtn.layer.masksToBounds = YES;
    [_tradingCodeBtn addTarget:self action:@selector(codeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder]; // 关闭键盘
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}

#pragma mark 验证码点击事件
- (void)codeBtnAction:(UIButton *)sender {
    
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
        __weak typeof(self)wSelf = self ;
        
        NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    NZUser *user = [NZUserManager sharedObject].user;
        
        NSDictionary *parameters = @{
                                     @"phone":user.phone
                                     } ;
        
        [handler postURLStr:webGetCode postDic:parameters
                      block:^(NSDictionary *retInfo, NSError *error)
         {
             
             if( error )
             {
                 [wSelf.view makeToast:@"验证码发送失败"];
                 return ;
             }
             if( retInfo == nil )
             {
                 [wSelf.view makeToast:@"验证码发送失败"];
                 return ;
             }
             
             BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
             
             if( state )
             {
                 [wSelf.view makeToast:@"验证码已发出至您的手机"];
                 
             }
             else
             {
                 [wSelf.view makeToast:@"验证码发送失败"] ;
             }
         }] ;
    
}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        [_accCodeBtn setTitle:@"再次获取" forState: UIControlStateNormal];
        _accCodeBtn.backgroundColor = darkRedColor;
        [_accCodeBtn setEnabled:YES];
        
        [_tradingCodeBtn setTitle:@"再次获取" forState: UIControlStateNormal];
        _tradingCodeBtn.backgroundColor = darkRedColor;
        [_tradingCodeBtn setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"已发送 %d",seconds];
        _accCodeBtn.backgroundColor = [UIColor lightGrayColor];
        [_accCodeBtn setEnabled:NO];
        [_accCodeBtn setTitle:title forState:UIControlStateNormal];
        
        _tradingCodeBtn.backgroundColor = [UIColor lightGrayColor];
        [_tradingCodeBtn setEnabled:NO];
        [_tradingCodeBtn setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark 展开和收起两种密码修改界面
- (IBAction)showView1:(UIButton *)sender {
    if (expendView1) {
        return;
    } else {
        expendView1 = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            _moveView1.center = CGPointMake(ScreenWidth/2, (ScreenHeight-135)/2+321);
            if (expendView2) {
                _moveView2.center = CGPointMake(ScreenWidth/2, (ScreenHeight-206)/2+71);
            }
        } completion:^(BOOL finished) {
            _moveConstraint1.constant = 186.f;
            if (expendView2) {
                expendView2 = NO;
                _moveConstraint2.constant = 0.f;
            }
        }];
    }
    
}

- (IBAction)showView2:(UIButton *)sender {
    if (expendView2) {
        return;
    } else {
        expendView2 = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (expendView1) {
                _moveView1.center = CGPointMake(ScreenWidth/2, (ScreenHeight-135)/2+135);
            }
            _moveView2.center = CGPointMake(ScreenWidth/2, (ScreenHeight-206)/2+257);
        } completion:^(BOOL finished) {
            
            if (expendView1) {
                expendView1 = NO;
                _moveConstraint1.constant = 0.f;
            }
            _moveConstraint2.constant = 186.f;
        }];
    }
    
}

- (IBAction)hideView1:(UIButton *)sender {
    expendView1 = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _moveView1.center = CGPointMake(ScreenWidth/2, (ScreenHeight-135)/2+135);
    } completion:^(BOOL finished) {
        _moveConstraint1.constant = 0.f;
    }];
    
    _oldAccPassword.text = emptyString;
    _accCode.text = emptyString;
    _nAccPassword.text = emptyString;
    _againAccpassword.text = emptyString;
}

- (IBAction)hideView2:(UIButton *)sender {
    expendView2 = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _moveView2.center = CGPointMake(ScreenWidth/2, (ScreenHeight-206)/2+71);
    } completion:^(BOOL finished) {
        _moveConstraint2.constant = 0.f;
    }];
    
    _oldTradingPass.text = emptyString;
    _tradingCode.text = emptyString;
    _nTradingPass.text = emptyString;
    _againTradingPass.text = emptyString;
}

- (IBAction)editView1:(UIButton *)sender {
    
    if (_oldAccPassword.text.length != 0 && _nAccPassword.text.length>5 && _nAccPassword.text.length<17) {
        if ([_againAccpassword.text isEqualToString:_nAccPassword.text]) {
            
            if (_accCode.text.length == 6) {
                
                __weak typeof(self)wSelf = self ;
                
                NZWebHandler *handler = [[NZWebHandler alloc] init] ;
                
                NZUser *user = [NZUserManager sharedObject].user;
                
                NSDictionary *parameters = @{
                                             @"userId":user.userId,
                                             @"token":user.token,
                                             @"phone":user.phone,
                                             @"oldPassword":_oldAccPassword.text,
                                             @"newPassword":_nAccPassword.text,
                                             @"code":_accCode.text
                                             } ;
                
                [handler postURLStr:webEditAccountPassword postDic:parameters
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
                         [wSelf.view makeToast:@"密码修改成功"];
                         
                         expendView1 = NO;
                         [UIView animateWithDuration:0.2 animations:^{
                             _moveView1.center = CGPointMake(ScreenWidth/2, (ScreenHeight-135)/2+135);
                         } completion:^(BOOL finished) {
                             _moveConstraint1.constant = 0.f;
                         }];
                         
                         _oldAccPassword.text = emptyString;
                         _accCode.text = emptyString;
                         _nAccPassword.text = emptyString;
                         _againAccpassword.text = emptyString;
                     }
                     else
                     {
                         [wSelf.view makeToast:@"密码修改失败"] ;
                     }
                 }] ;
                
            } else {
                [self.view makeToast:@"请输入正确的验证码"];
            }
            
        } else {
            [self.view makeToast:@"重复密码输入有误"];
        }
        
    } else {
        [self.view makeToast:@"请输入6-16位字母或数字组合的密码"];
    }
}

- (IBAction)editView2:(UIButton *)sender {
    
    if (_oldTradingPass.text.length != 0 && _nTradingPass.text.length>5 && _nTradingPass.text.length<17) {
        if ([_againTradingPass.text isEqualToString:_nTradingPass.text]) {
            
            if (_tradingCode.text.length == 6) {
                
                __weak typeof(self)wSelf = self ;
                
                NZWebHandler *handler = [[NZWebHandler alloc] init] ;
                
                NZUser *user = [NZUserManager sharedObject].user;
                
                NSDictionary *parameters = @{
                                             @"userId":user.userId,
                                             @"token":user.token,
                                             @"phone":user.phone,
                                             @"oldPassword":_oldTradingPass.text,
                                             @"newPassword":_nTradingPass.text,
                                             @"code":_tradingCode.text
                                             } ;
                
                [handler postURLStr:webEditTradingPassword postDic:parameters
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
                         [wSelf.view makeToast:@"密码修改成功"];
                         
                         expendView2 = NO;
                         [UIView animateWithDuration:0.2 animations:^{
                             _moveView2.center = CGPointMake(ScreenWidth/2, (ScreenHeight-206)/2+71);
                         } completion:^(BOOL finished) {
                             _moveConstraint2.constant = 0.f;
                         }];
                         
                         _oldTradingPass.text = emptyString;
                         _tradingCode.text = emptyString;
                         _nTradingPass.text = emptyString;
                         _againTradingPass.text = emptyString;
                     }
                     else
                     {
                         [wSelf.view makeToast:@"密码修改失败"] ;
                     }
                 }] ;
                
            } else {
                [self.view makeToast:@"请输入正确的验证码"];
            }
            
        } else {
            [self.view makeToast:@"重复密码输入有误"];
        }
        
    } else {
        [self.view makeToast:@"请输入6-16位字母或数字组合的密码"];
    }
}

@end
