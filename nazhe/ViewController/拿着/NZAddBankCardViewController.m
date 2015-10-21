//
//  NZAddBankCardViewController.m
//  nazhe
//
//  Created by WSGG on 15/10/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZAddBankCardViewController.h"

@interface NZAddBankCardViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation NZAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.bankOperateType == enumtBankOperateType_Add) {
        
        [self createNavigationItemTitleViewWithTitle:@"添加银行卡"];
    }else if (self.bankOperateType == enumtBankOperateType_Modify){
        
        [self createNavigationItemTitleViewWithTitle:@"修改银行卡"];
        
    }else if (self.bankOperateType == enumtBankOperateType_Look){
        
        [self createNavigationItemTitleViewWithTitle:@"银行卡信息"];
    }
    
    [self leftButtonTitle:nil];
    [self initView];
}

-(void)initView{
    
    self.isEdit = NO;
    self.editLab.textColor = darkRedColor;
    self.myBankStr = @"没选择";
    self.myBankTypeStr = @"没选择";
    self.userBankNumField.keyboardType = UIKeyboardTypeNumberPad;
    self.userBankNumComfirField.keyboardType = UIKeyboardTypeNumberPad;
    
    if (self.bankOperateType == enumtBankOperateType_Add) {

        [self setViewDifferent111];
        
    }else if (self.bankOperateType == enumtBankOperateType_Modify){
        
        
        
    }else if (self.bankOperateType == enumtBankOperateType_Look){
        
        //设置不能输入
        [self setViewDifferent];
        
    }
    
}

-(void)initViewValue{

    self.myBankTypeStr = [self.myBankCardDict objectForKey:@"category"];
    if ([self.myBankTypeStr isEqualToString:@"储蓄卡"]) {
       
        self.myBankTypeStr = @"储蓄卡";
        [self.bankCardType1 setBackgroundImage:[UIImage imageNamed:@"红圈"] forState:UIControlStateNormal];
        [self.bankCardType2 setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
        
    }else if ([self.myBankTypeStr isEqualToString:@"信用卡"]){
        
        self.myBankTypeStr = @"信用卡";
        [self.bankCardType2 setBackgroundImage:[UIImage imageNamed:@"红圈"] forState:UIControlStateNormal];
        [self.bankCardType1 setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
        
    }
    
    self.userNameField.text = [self.myBankCardDict objectForKey:@"name"];
    self.bankNameLab.text = [self.myBankCardDict objectForKey:@"bankName"];
    self.myBankStr = [self.myBankCardDict objectForKey:@"bankName"];
    self.userBankBeachField.text = [self.myBankCardDict objectForKey:@"bankBranch"];
    self.userBankNumField.text = [self.myBankCardDict objectForKey:@"cardNumber"];
    self.userBankNumComfirField.text = [self.myBankCardDict objectForKey:@"cardNumber"];
}


- (IBAction)selectBankAction:(id)sender {
    
    if (self.bankOperateType == enumtBankOperateType_Add || self.bankOperateType == enumtBankOperateType_Modify) {
        
        [self.userNameField resignFirstResponder];
        [self.userBankBeachField resignFirstResponder];
        [self.userBankNumField resignFirstResponder];
        [self.userBankNumComfirField resignFirstResponder];
        
        _pickViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]; // 先初始化
        _pickViewBackView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_pickViewBackView];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-44, ScreenWidth, 44)];
        toolBar.tag = 103;
        toolBar.barStyle = UIBarStyleDefault;
        [toolBar setBackgroundColor:[UIColor blueColor]];
        
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
        
        UIBarButtonItem *centerBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
        
        NSArray *items = @[leftBtn, centerBtn, rightBtn];
        [toolBar setItems:items animated:YES];
        [_pickViewBackView addSubview:toolBar];
        
        _bankPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight-216, ScreenWidth, 216)];
        _bankPicker.backgroundColor = toolBarColor;
        _bankPicker.dataSource = self;
        _bankPicker.delegate = self;
        [_pickViewBackView addSubview:_bankPicker];
    }
    
}

- (IBAction)modifyButtonAction:(UIButton *)sender {
    
    if (self.bankOperateType == enumtBankOperateType_Look || self.bankOperateType == enumtBankOperateType_Modify) {

        self.isEdit = !self.isEdit;
        if (self.isEdit) {
            
            [self createNavigationItemTitleViewWithTitle:@"修改银行卡"];
            
            self.bankOperateType = enumtBankOperateType_Modify;
            self.editImgView.image = [UIImage imageNamed:@"编辑-灰"];
            self.editLab.hidden = YES;
            [self setViewDifferent111];
            
        }else{
            
            [self createNavigationItemTitleViewWithTitle:@"银行卡信息"];
            
            self.bankOperateType = enumtBankOperateType_Look;
            self.editImgView.image = [UIImage imageNamed:@"编辑"];
            self.editLab.hidden = NO;
            [self setViewDifferent];
        }

    
    }
}

- (IBAction)selectCardAction:(UIButton *)sender {
    
    if (self.bankOperateType == enumtBankOperateType_Add || self.bankOperateType == enumtBankOperateType_Modify) {
    
        if (sender.tag == 100) {
            
            self.myBankTypeStr = @"储蓄卡";
            [self.bankCardType1 setBackgroundImage:[UIImage imageNamed:@"红圈"] forState:UIControlStateNormal];
            [self.bankCardType2 setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
            
        }else if(sender.tag == 200){
            
            self.myBankTypeStr = @"信用卡";
            [self.bankCardType2 setBackgroundImage:[UIImage imageNamed:@"红圈"] forState:UIControlStateNormal];
            [self.bankCardType1 setBackgroundImage:[UIImage imageNamed:@"灰圈"] forState:UIControlStateNormal];
            
        }

    
    }
        
}

- (IBAction)saveButtonAction:(id)sender {
    
    
    if ([self checkCommit]) {
        
        if (self.bankOperateType == enumtBankOperateType_Add) {
            
            [self saveBankData];
            [self setViewDifferent];
            self.bankOperateType = enumtBankOperateType_Success;

        }else if (self.bankOperateType == enumtBankOperateType_Modify){
            
            [self modifyBankData];
            [self setViewDifferent];
        }
        
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    
    if (self.bankOperateType == enumtBankOperateType_Modify) {
        
        [self createNavigationItemTitleViewWithTitle:@"银行卡信息"];
         self.bankOperateType = enumtBankOperateType_Look;
        self.editImgView.image = [UIImage imageNamed:@"编辑"];
        self.editLab.hidden = NO;
        [self setViewDifferent];

    }
    
}

-(void)setViewDifferent{
    
    self.userNameField.userInteractionEnabled = NO;
    self.userBankBeachField.userInteractionEnabled = NO;
    self.userBankNumField.userInteractionEnabled = NO;
    self.userBankNumComfirField.userInteractionEnabled = NO;
    
    self.operateView.hidden = YES;
    
}

-(void)setViewDifferent111{
    
    self.userNameField.userInteractionEnabled = YES;
    self.userBankBeachField.userInteractionEnabled = YES;
    self.userBankNumField.userInteractionEnabled = YES;
    self.userBankNumComfirField.userInteractionEnabled = YES;
    
    self.operateView.hidden = NO;
    

}


#pragma mark ----检查要提交的内容项--------
-(BOOL)checkCommit{
    
    NSString *info;
    if ([self.myBankTypeStr isEqualToString:@"没选择"]) {
        
        info = @"请选择银行卡类型！";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertV show];
        return NO;
    }
    if ([self.userNameField.text isEqualToString:@""]) {
        
        info = @"开户人姓名不能为空不能为空！";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertV show];
        return NO;

    }
    if ([self.myBankStr isEqualToString:@"没选择"]) {
        
        info = @"请选择开户银行！";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertV show];
        return NO;

    }
    if ( [self.userBankBeachField.text isEqualToString:@""]) {
        
        info = @"开户支行不能为空不能为空！";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertV show];
        return NO;
    }
    if ([self.userBankNumField.text isEqualToString:@""]) {
        
        info = @"银行卡号不能为空不能为空！";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertV show];
        return NO;

    }
    if ([self.userBankNumComfirField.text isEqualToString:@""]) {
        
        info = @"确认银行卡号不能为空不能为空！";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertV show];
        return NO;
        
    }
    NSString *str1 = self.userBankNumField.text;
    NSString *str2 = self.userBankNumComfirField.text;
    if ([str1 isEqualToString:str2]==NO) {
        
        info = @"确认银行卡号与银行卡号不一致！";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertV show];
        return NO;

    }

    
    return YES;
}



#pragma mark --UIPickerViewDataSource

// returns the number of 'columns' to display.

//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..

//返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  
    return self.bankArry.count;
}


#pragma mark --UIPickerViewDelegate

//返回列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{

    return ScreenWidth;
}
//返回行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//返回列行的内容
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSInteger firstRow= [pickerView selectedRowInComponent:0];
//    NSDictionary *dic = [self.bankArry objectAtIndex:firstRow];
//    NSArray *jobs = [dic objectForKey:@"job"];
//    NSString *jobName = [jobs objectAtIndex:row];
//    
//    return jobName;
//    
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    myView.backgroundColor = toolBarColor;
    
    //---------图片
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-140/2, 5, 40, 30)];
    //图片地址
    NSString *imgStr =[NZGlobal GetImgBaseURL:[[self.bankArry objectAtIndex:row] objectForKey:@"bankIcon"]];
    NSLog(@"---%@",imgStr);
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [imgV sd_setImageWithURL:imgURL placeholderImage:defaultImage];
    
    //---------文字
    UILabel *bankLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+20, 5, 90, 30)];
    bankLab.text = [[self.bankArry objectAtIndex:row]objectForKey:@"bankName"];
    
    [myView addSubview:imgV];
    [myView addSubview:bankLab];
    return myView;
}

//选择事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (component == 0) {
//        [pickerView reloadComponent:1];
//        [pickerView selectRow:0 inComponent:1 animated:YES];
//        //        _shengRow = row;
//    }//else {
//    // _cityRow = row;
//    //}
}



#pragma mark -ToolBarButtonAction

- (void)leftBtnAction
{

    [_pickViewBackView removeFromSuperview];
    _pickViewBackView = nil;
    _bankPicker = nil;
}


- (void)rightBtnAction
{

    NSInteger firstRow = [_bankPicker selectedRowInComponent:0];
    self.myBankStr = [[self.bankArry objectAtIndex:firstRow]objectForKey:@"bankName"];
    NSLog(@"--------%@",self.myBankStr);
    self.bankNameLab.text = self.myBankStr;
    [_pickViewBackView removeFromSuperview];
    _pickViewBackView = nil;
    _bankPicker = nil;

    
}

-(void)modifyBankData{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"token":@"",
                                 @"category":self.myBankTypeStr,
                                 @"id":[NSNumber numberWithInt:self.bankCardId],
                                 @"bankName":self.myBankStr,
                                 @"bankBranch":self.userBankBeachField.text,
                                 @"cardNumber":self.userBankNumField.text,
                                 @"name":self.userNameField.text
                                 };
    NSString *webGoodParameters = @"bankCard/update";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
             [self createNavigationItemTitleViewWithTitle:@"银行卡信息"];
             self.editLab.hidden = YES;
             self.editImgView.hidden = YES;
             self.bankOperateType = enumtBankOperateType_Success;
             
             UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你，修改银行卡成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
             
             [alertV show];
             
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
   
}


-(void)saveBankData{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"category":self.myBankTypeStr,
                                 @"bankName":self.myBankStr,
                                 @"bankBranch":self.userBankBeachField.text,
                                 @"cardNumber":self.userBankNumField.text,
                                 @"name":self.userNameField.text
                                 };
    NSString *webGoodParameters = @"bankCard/Add";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
             UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你，添加银行卡成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
             
             [alertV show];

             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;

    
}

-(void)loadData{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"type":[NSNumber numberWithInt:1]
                                 
                                 };
    NSString *webGoodParameters = @"bankCard/GetBankList";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
             self.bankArry = [NSMutableArray new];
             NSArray *infoArry = [retInfo objectForKey:@"list"];
             [self.bankArry addObjectsFromArray:infoArry];
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;

}

-(void)loadMyBankCardData{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"id":[NSNumber numberWithInt:self.bankCardId],
                                 @"token":@""
                                 };
    NSString *webGoodParameters = @"bankCard/detail";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
             self.myBankCardDict = [NSDictionary new];
             self.myBankCardDict = [retInfo objectForKey:@"detail"];
             
             //给页面赋值
             [self initViewValue];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    //加载数据
    [self loadData];
    if (self.bankOperateType == enumtBankOperateType_Look) {
        
        //加载银行卡信息
        [self loadMyBankCardData];
    }else if (self.bankOperateType == enumtBankOperateType_Add){
        
        self.editLab.hidden = YES;
        self.editImgView.hidden = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
