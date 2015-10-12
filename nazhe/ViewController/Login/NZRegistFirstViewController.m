//
//  NZRegistFirstViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/15.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZRegistFirstViewController.h"
#import "NZRegistSecondViewController.h"
#import "NZProtocolViewController.h"

@interface NZRegistFirstViewController ()<UITextFieldDelegate> {
    UIScrollView *scrollView;
    
    UITextField *phoneNumField;
    UIImageView *phoneHook; // 注册号码号码正确
    UILabel *phoneForkLab;  // 注册号码不正确
    
    UITextField *codeField;
    UIButton *codeBtn; // 验证码按钮
    UIImageView *codeHook; // 验证码正确
    UIImageView *codeFork; // 验证码不正确
    
    UITextField *passwordField; // 密码输入框
    UIImageView *closeEyes; // 暗文密码
    UIImageView *openEyes; // 明文密码
    
    UITextField *recommendField;
    UIImageView *recommendHook; // 推荐人号码正确
    UILabel *recommendForkLab;  // 推荐人号码不正确
    
    UIImageView *selectImg; // 协议同意img
    
    UIButton *nextBtn; // 下一步按钮
    
    BOOL isOpenEye; // 明暗文密码
    BOOL isAgreeProtocol; // 同意协议
    /**
     *  只有当前3个都输入正确，并同意上面的协议，才能进入下一步
     */
    BOOL registPhone; // 注册号码
    BOOL code; // 验证码
    BOOL password; // 密码
    BOOL recommendPhone; // 推荐人号码
    
    BOOL canNext; // 能否到下一步
    
    NSTimer *timer; // 验证码倒计时
    int seconds;
}

@end

@implementation NZRegistFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isOpenEye = NO;
    isAgreeProtocol = YES;
    
    registPhone = NO;
    code = NO;
    password = NO;
    recommendPhone = YES;
    canNext = NO;
    
    seconds = 60;
    
    self.navigationController.navigationBarHidden = NO;
    
    [self createNavigationItemTitleViewWithTitle:@"注册"];
    [self leftButtonTitle:nil];
    
    [self initInterface]; // 初始化注册界面
}

#pragma mark 初始化注册界面
- (void)initInterface {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    // 注册步骤
    UIImageView *registStepOne = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*296/375)/2, 10, ScreenWidth*296/375, ScreenWidth*74/375)];
    registStepOne.image = [UIImage imageNamed:@"注册条1"];
    [scrollView addSubview:registStepOne];
    
    /***********************   注册手机号码   ***************************/
    // 图标
    UIImageView *phoneNumIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*50/375, CGRectGetMaxY(registStepOne.frame)+ScreenWidth*60/375, ScreenWidth*19/375, ScreenWidth*31/375)];
    phoneNumIcon.image = [UIImage imageNamed:@"注册手机"];
    [scrollView addSubview:phoneNumIcon];
    
    CGFloat textFieldWidth = ScreenWidth-ScreenWidth*130/375;
    CGFloat textFieldHeight = ScreenWidth*30/375;
    // 输入框
    phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneNumIcon.frame)+ScreenWidth*20/375, phoneNumIcon.origin.y+3, textFieldWidth-70, textFieldHeight)];
    phoneNumField.font = [UIFont fontWithName:@"Arial" size:17.f];
    phoneNumField.placeholder = @"注册手机号码";
//    phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.returnKeyType = UIReturnKeyDone;
    phoneNumField.delegate = self;
    [scrollView addSubview:phoneNumField];
    
    // 注册号码正确
    phoneHook = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-ScreenWidth*20/375, phoneNumField.origin.y+ScreenWidth*8/375, ScreenWidth*20/375, ScreenWidth*14/375)];
    phoneHook.image = [UIImage imageNamed:@"勾号"];
    phoneHook.hidden = YES;
    [scrollView addSubview:phoneHook];
    // 注册号码不正确
    phoneForkLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-70, phoneNumField.origin.y, 70, ScreenWidth*30/375)];
    phoneForkLab.text = @"号码不存在";
    phoneForkLab.textColor = darkRedColor;
    phoneForkLab.font = [UIFont systemFontOfSize:13.f];
    phoneForkLab.textAlignment = NSTextAlignmentRight;
    phoneForkLab.hidden = YES;
    [scrollView addSubview:phoneForkLab];
    
    // 输入框底线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(phoneNumField.origin.x-ScreenWidth*10/375, CGRectGetMaxY(phoneNumField.frame)+5, textFieldWidth+ScreenWidth*10/375, 0.5)];
    line1.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:line1];
    
    /***********************   验证码   ***************************/
    // 图标
    UIImageView *codeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*50/375, CGRectGetMaxY(phoneNumIcon.frame)+ScreenWidth*25/375, ScreenWidth*19/375, ScreenWidth*31/375)];
    codeIcon.image = [UIImage imageNamed:@"验证码"];
    [scrollView addSubview:codeIcon];
    
    // 输入框
    codeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneNumIcon.frame)+ScreenWidth*20/375, codeIcon.origin.y+3, ScreenWidth-ScreenWidth*265/375, textFieldHeight)];
    codeField.font = [UIFont fontWithName:@"Arial" size:17.f];
    codeField.placeholder = @"验证码";
//    codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.returnKeyType = UIReturnKeyNext;
    codeField.delegate = self;
    [scrollView addSubview:codeField];
    // 输入框底线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(codeField.origin.x-ScreenWidth*10/375, CGRectGetMaxY(codeField.frame)+5, codeField.frame.size.width+ScreenWidth*10/375, 0.5)];
    line2.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:line2];
    
    // 验证码按钮
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(CGRectGetMaxX(codeField.frame)+ScreenWidth*35/375, codeField.origin.y, ScreenWidth*100/375, textFieldHeight);
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.backgroundColor = darkRedColor;
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    codeBtn.layer.cornerRadius = 1.f;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn addTarget:self action:@selector(codeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:codeBtn];
    
    
    // 验证码正确
    codeHook = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeField.frame)-ScreenWidth*20/375, codeField.origin.y+ScreenWidth*8/375, ScreenWidth*20/375, ScreenWidth*14/375)];
    codeHook.image = [UIImage imageNamed:@"勾号"];
    codeHook.hidden = YES;
    [scrollView addSubview:codeHook];
    
    // 验证码错误
    codeFork = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeField.frame)-ScreenWidth*14/375, codeField.origin.y+ScreenWidth*8/375, ScreenWidth*14/375, ScreenWidth*14/375)];
    codeFork.image = [UIImage imageNamed:@"叉号"];
    codeFork.hidden = YES;
    [scrollView addSubview:codeFork];
    
    /***********************   登陆密码   ***************************/
    // 图标
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*50/375, CGRectGetMaxY(codeIcon.frame)+ScreenWidth*29/375, ScreenWidth*21/375, ScreenWidth*23/375)];
    passwordIcon.image = [UIImage imageNamed:@"登录密码"];
    [scrollView addSubview:passwordIcon];
    
    // 输入框
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordIcon.frame)+ScreenWidth*18/375, passwordIcon.origin.y-ScreenWidth*2/375+3, textFieldWidth+ScreenWidth*2/375-ScreenWidth*18/375, textFieldHeight)];
    passwordField.font = [UIFont fontWithName:@"Arial" size:17.f];
    passwordField.placeholder = @"登录密码";
    passwordField.secureTextEntry = YES;
//    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.keyboardType = UIKeyboardTypeAlphabet;
    passwordField.returnKeyType = UIReturnKeyDone;
    [passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    passwordField.delegate = self;
    [scrollView addSubview:passwordField];
    // 输入框底线
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(passwordField.origin.x-ScreenWidth*10/375, CGRectGetMaxY(passwordField.frame)+5, textFieldWidth+ScreenWidth*12/375, 0.5)];
    line3.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:line3];
    
    // 暗文标记
    closeEyes = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-ScreenWidth*18/375, passwordField.origin.y+ScreenWidth*6.5/375, ScreenWidth*18/375, ScreenWidth*17/375)];
    closeEyes.image = [UIImage imageNamed:@"闭眼"];
    [scrollView addSubview:closeEyes];
    
    // 明文标记
    openEyes = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-ScreenWidth*18/375, passwordField.origin.y+ScreenWidth*10/375, ScreenWidth*18/375, ScreenWidth*10/375)];
    openEyes.image = [UIImage imageNamed:@"开眼"];
    openEyes.hidden = YES;
    [scrollView addSubview:openEyes];
    
    UIButton *eyesBtn = [[UIButton alloc] initWithFrame:closeEyes.frame];
    [eyesBtn addTarget:self action:@selector(passwordOpenOrClose) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:eyesBtn];
    
    /***********************   推荐人手机号码   ***************************/
    // 图标
    UIImageView *recommendNumIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*50/375, CGRectGetMaxY(passwordIcon.frame)+ScreenWidth*29/375, ScreenWidth*19/375, ScreenWidth*31/375)];
    recommendNumIcon.image = [UIImage imageNamed:@"推荐人"];
    [scrollView addSubview:recommendNumIcon];
    
    // 输入框
    recommendField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recommendNumIcon.frame)+ScreenWidth*20/375, recommendNumIcon.origin.y+3, textFieldWidth, textFieldHeight)];
    recommendField.font = [UIFont fontWithName:@"Arial" size:17.f];
    recommendField.placeholder = @"推荐人手机号码(可不填)";
    recommendField.clearButtonMode = UITextFieldViewModeWhileEditing;
    recommendField.keyboardType = UIKeyboardTypeNumberPad;
    recommendField.returnKeyType =UIReturnKeyNext;
    recommendField.delegate = self;
    [scrollView addSubview:recommendField];
    // 输入框底线
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(recommendField.origin.x-ScreenWidth*10/375, CGRectGetMaxY(recommendField.frame)+5, recommendField.frame.size.width+ScreenWidth*10/375, 0.5)];
    line4.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:line4];
    
    // 推荐人号码正确
    recommendHook = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recommendField.frame)-ScreenWidth*20/375, recommendField.origin.y+ScreenWidth*8/375, ScreenWidth*20/375, ScreenWidth*14/375)];
    recommendHook.image = [UIImage imageNamed:@"勾号"];
    recommendHook.hidden = YES;
    [scrollView addSubview:recommendHook];
    // 推荐人号码不正确
    recommendForkLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recommendField.frame)-70, recommendField.origin.y, 70, ScreenWidth*30/375)];
    recommendForkLab.text = @"号码不存在";
    recommendForkLab.textColor = darkRedColor;
    recommendForkLab.font = [UIFont systemFontOfSize:13.f];
    recommendForkLab.textAlignment = NSTextAlignmentRight;
    recommendForkLab.hidden = YES;
    [scrollView addSubview:recommendForkLab];
    
    /***********************   用户协议   ***************************/
    UILabel *protocolLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*45/375, CGRectGetMaxY(recommendNumIcon.frame)+ScreenWidth*30/375, 80, 20)];
    protocolLab.text = @"用户协议";
    protocolLab.textColor = [UIColor grayColor];
    protocolLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:protocolLab];
    
    selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(protocolLab.frame)+5, CGRectGetMaxY(protocolLab.frame)-13, 13, 13)];
    selectImg.image = [UIImage imageNamed:@"选择圆"];
    CGPoint point = CGPointMake(selectImg.centerX, protocolLab.centerY);
    selectImg.center = point;
    [scrollView addSubview:selectImg];
    
    UILabel *agreeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectImg.frame)+5, protocolLab.origin.y, 45, 20)];
    agreeLab.text = @"同意";
    agreeLab.textColor = [UIColor grayColor];
    agreeLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:agreeLab];
    
    UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(selectImg.origin.x, agreeLab.origin.y, CGRectGetMaxX(agreeLab.frame)-selectImg.origin.x, agreeLab.frame.size.height)];
    agreeBtn.backgroundColor = [UIColor clearColor];
    [agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:agreeBtn];
    
    UIButton *protocolBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreeLab.frame), CGRectGetMaxY(protocolLab.frame)-ScreenWidth*13/375, ScreenWidth*58/375, ScreenWidth*11/375)];
    [protocolBtn setImage:[UIImage imageNamed:@"协议"] forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(readProtocol) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:protocolBtn];
    
    /***********************   下一步   ***************************/
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*175/375)/2, CGRectGetMaxY(protocolLab.frame)+ScreenWidth*30/375, ScreenWidth*175/375, ScreenWidth*40/375)];
    nextBtn.backgroundColor = [UIColor lightGrayColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    nextBtn.layer.cornerRadius = 1.f;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextBtn];
    
//    scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(nextBtn.frame)+ScreenWidth*100/375);
}

#pragma mark 验证码点击事件
- (void)codeBtnAction:(UIButton *)sender {
    if (registPhone) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
        __weak typeof(self)wSelf = self ;
        
        NZWebHandler *handler = [[NZWebHandler alloc] init] ;
        
        NSDictionary *parameters = @{
                                     @"phone":phoneNumField.text
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
    
    } else {
        
    [self.view makeToast:@"请输入正确的手机号码"];
        
    }

}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        [codeBtn setTitle:@"再次获取" forState: UIControlStateNormal];
        codeBtn.backgroundColor = darkRedColor;
        [codeBtn setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"已发送 %d",seconds];
        codeBtn.backgroundColor = [UIColor lightGrayColor];
        [codeBtn setEnabled:NO];
        [codeBtn setTitle:title forState:UIControlStateNormal];
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

#pragma mark 同意协议
- (void)agreeAction {
    isAgreeProtocol = !isAgreeProtocol;
    if (isAgreeProtocol) {
        selectImg.image = [UIImage imageNamed:@"选择圆"];
    } else {
        selectImg.image = [UIImage imageNamed:@"未选择圆"];
    }
}

#pragma mark 阅读协议
- (void)readProtocol {
    NZProtocolViewController *protocolVCTR = [[NZProtocolViewController alloc] init];
    [self.navigationController pushViewController:protocolVCTR animated:YES];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder]; // 关闭键盘
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if ([textField isEqual:phoneNumField]) {
        phoneForkLab.hidden = YES;
        phoneHook.hidden = YES;
    } else if ([textField isEqual:recommendField]) {
        recommendForkLab.hidden = YES;
        recommendHook.hidden = YES;
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
            __weak typeof(self)wSelf = self ;
            
            NZWebHandler *handler = [[NZWebHandler alloc] init] ;
            
            NSDictionary *parameters = @{
                                         @"phone":textField.text
                                         } ;
            
            [handler postURLStr:webIsExistPhone postDic:parameters
                          block:^(NSDictionary *retInfo, NSError *error)
             {
                 
                 if( error )
                 {
                     [wSelf.view makeToast:@"网络错误"];
                     registPhone = NO;
                     return ;
                 }
                 if( retInfo == nil )
                 {
                     [wSelf.view makeToast:@"网络错误"];
                     registPhone = NO;
                     return ;
                 }
                 
                 BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
                 
                 if( state )
                 {
                     if ([retInfo[@"isExist"] boolValue]) {
                         phoneForkLab.text = @"已被注册";
                         phoneForkLab.hidden = NO;
                         registPhone = NO;
                     } else { // 号码正确且可注册
                         phoneHook.hidden = NO;
                         registPhone = YES;
                     }
                     
                 }
                 else
                 {
                     [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
                     registPhone = NO;
                 }
             }] ;
        } else {
            phoneForkLab.text = @"号码不正确";
            phoneForkLab.hidden = NO;
            registPhone = NO;
        }
    } else if ([textField isEqual:passwordField]) {
        if (passwordField.text.length>5 && passwordField.text.length<17) {
            password = YES;
        } else {
            password = NO;
            
        }
    } else if ([textField isEqual:recommendField]) {
        if ([NZGlobal isMobileNumber:textField.text]) {
            recommendHook.hidden = NO;
            recommendPhone = YES;
        } else if (textField.text.length == 0) {
            recommendPhone = YES;
        } else {
            recommendForkLab.text = @"号码不正确";
            recommendForkLab.hidden = NO;
            recommendPhone = NO;
        }
    }
    
    if (registPhone && password && recommendPhone && isAgreeProtocol && codeField.text.length == 6) {
        canNext = YES;
        nextBtn.backgroundColor = darkRedColor;
    } else {
        canNext = NO;
        nextBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark 跳转下一步
- (void)nextStep:(UIButton *)button {
    
//    NZRegistSecondViewController *registVCTR = [[NZRegistSecondViewController alloc] init];
//    [self.navigationController pushViewController:registVCTR animated:YES];
    
    if (canNext) {
        __weak typeof(self)wSelf = self ;
        
        NZWebHandler *handler = [[NZWebHandler alloc] init] ;
        
        NSDictionary *parameters = @{
                                     @"phone":phoneNumField.text,
                                     @"code":codeField.text
                                     } ;
        
        [handler postURLStr:webIsCodeRight postDic:parameters
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
                 
                 NZRegistInformation *registInfo = [NZUserManager sharedObject].registInfo;
                 
                 registInfo.phone = phoneNumField.text;
                 registInfo.password = passwordField.text;
                 registInfo.code = codeField.text;
                 if (recommendField.text.length != 0) {
                     registInfo.recommendPhone = recommendField.text;
                 }
                 
                 NZRegistSecondViewController *registVCTR = [[NZRegistSecondViewController alloc] init];
                 [self.navigationController pushViewController:registVCTR animated:YES];
             }
             else
             {
                 [wSelf.view makeToast:@"验证码不正确"] ;
                 code = NO;
             }
         }] ;
    }
    
    
    
    
    
    
}

@end
