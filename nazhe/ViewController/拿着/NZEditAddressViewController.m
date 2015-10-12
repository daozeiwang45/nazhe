//
//  NZEditAddressViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/22.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZEditAddressViewController.h"
#import "MyDeliveryAddressModel.h"

@interface NZEditAddressViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    UITextField *consigneeField; // 收货人姓名
    UITextField *phoneField; // 手机号码
    UIButton *areaBtn; // 所在地区
    UITextField *postcodeField; // 手机号码
    UITextField *addressField; // 详细地址
    
    UIView *pickViewBackView; // pickview的透明背景view，防止点击其它控件
    UIPickerView *areaPicker; // 地区选择器

    NSArray *provinecesArray; // 省份数组，从plist文件获取
}

@end

@implementation NZEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initInterface];
    
    if (self.addressType == enumtAddressType_Add) {
        [self createNavigationItemTitleViewWithTitle:@"添加收货地址"];
    } else {
        [self createNavigationItemTitleViewWithTitle:@"修改收货地址"];
        [self requestDetailAddress];
    }
    [self leftButtonTitle:nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    provinecesArray = [NSArray arrayWithContentsOfFile:path];
    
    NSLog(@"id = %d",self.addressID);
}

#pragma mark 初始化界面
- (void)initInterface {
    
    /***********************   收货人姓名  ***************************/
    UILabel *consigneeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*35/375, 64 + ScreenWidth*50/375, 90, 20)];
    consigneeLab.text = @"收货人姓名";
    consigneeLab.textColor = [UIColor grayColor];
    consigneeLab.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:consigneeLab];
    
    consigneeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(consigneeLab.frame), consigneeLab.origin.y, (ScreenWidth-ScreenWidth*70/375)-consigneeLab.frame.size.width, 20)];
    consigneeField.font = [UIFont fontWithName:@"Arial" size:17.f];
    consigneeField.returnKeyType = UIReturnKeyDone;
    [consigneeField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    consigneeField.delegate = self;
    [self.view addSubview:consigneeField];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(consigneeField.origin.x, CGRectGetMaxY(consigneeField.frame)+3, consigneeField.frame.size.width, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    /***********************   手机号码  ***************************/
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*35/375, CGRectGetMaxY(consigneeLab.frame)+ScreenWidth*20/375, 80, 20)];
    phoneLab.text = @"手机号码";
    phoneLab.textColor = [UIColor grayColor];
    phoneLab.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:phoneLab];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLab.frame), phoneLab.origin.y, (ScreenWidth-ScreenWidth*70/375)-phoneLab.frame.size.width, 20)];
    phoneField.font = [UIFont fontWithName:@"Arial" size:17.f];
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.returnKeyType = UIReturnKeyDone;
    [phoneField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    phoneField.delegate = self;
    [self.view addSubview:phoneField];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(phoneField.origin.x, CGRectGetMaxY(phoneField.frame)+3, phoneField.frame.size.width, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    
    /***********************   所在地区  ***************************/
    UILabel *areaLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*35/375, CGRectGetMaxY(phoneLab.frame)+ScreenWidth*20/375, 80, 20)];
    areaLab.text = @"所在地区";
    areaLab.textColor = [UIColor grayColor];
    areaLab.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:areaLab];
    
    areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(areaLab.frame), areaLab.origin.y, (ScreenWidth-ScreenWidth*70/375)-areaLab.frame.size.width, 20)];
    [areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    areaBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:17.f];
    areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [areaBtn addTarget:self action:@selector(areaPickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaBtn];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(areaBtn.frame)-6, areaBtn.origin.y+4.5, 6, 11)];
    rightArrow.image = [UIImage imageNamed:@"注册右键"];
    [self.view addSubview:rightArrow];
    [self.view sendSubviewToBack:rightArrow];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(areaBtn.origin.x, CGRectGetMaxY(areaBtn.frame)+3, areaBtn.frame.size.width, 0.5)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line3];
    
    /***********************   邮政编码  ***************************/
    UILabel *postcodeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*35/375, CGRectGetMaxY(areaLab.frame)+ScreenWidth*20/375, 80, 20)];
    postcodeLab.text = @"邮政编码";
    postcodeLab.textColor = [UIColor grayColor];
    postcodeLab.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:postcodeLab];
    
    postcodeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(postcodeLab.frame), postcodeLab.origin.y, (ScreenWidth-ScreenWidth*70/375)-postcodeLab.frame.size.width, 20)];
    postcodeField.font = [UIFont fontWithName:@"Arial" size:17.f];
    postcodeField.keyboardType = UIKeyboardTypeNumberPad;
    postcodeField.returnKeyType = UIReturnKeyDone;
    [postcodeField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    postcodeField.delegate = self;
    [self.view addSubview:postcodeField];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(postcodeField.origin.x, CGRectGetMaxY(postcodeField.frame)+3, postcodeField.frame.size.width, 0.5)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line4];
    
    /***********************   详细地址  ***************************/
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*35/375, CGRectGetMaxY(postcodeLab.frame)+ScreenWidth*20/375, 80, 20)];
    addressLab.text = @"详细地址";
    addressLab.textColor = [UIColor grayColor];
    addressLab.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:addressLab];
    
    addressField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressLab.frame), addressLab.origin.y, (ScreenWidth-ScreenWidth*70/375)-addressLab.frame.size.width, 20)];
    addressField.font = [UIFont fontWithName:@"Arial" size:17.f];
    addressField.keyboardType = UIKeyboardTypeASCIICapable;
    addressField.returnKeyType = UIReturnKeyDone;
    [addressField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    addressField.delegate = self;
    [self.view addSubview:addressField];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(addressField.origin.x, CGRectGetMaxY(addressField.frame)+3, addressField.frame.size.width, 0.5)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line5];
    
    /*************************  取消和保存  ********************************/
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-1)/2, CGRectGetMaxY(line5.frame)+ScreenWidth*40/375, 1, ScreenWidth*15/375)];
    centerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:centerView];
    
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(centerView.origin.x-ScreenWidth*70/375, centerView.origin.y, ScreenWidth*70/375, ScreenWidth*15/375)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    // 保存按钮
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(centerView.frame), centerView.origin.y, ScreenWidth*70/375, ScreenWidth*15/375)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:tintOrangeColor forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}

#pragma mark 选择地区
- (void)areaPickerView {
    pickViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]; // 先初始化
    pickViewBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pickViewBackView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-44, ScreenWidth, 44)];
    toolBar.tag = 103;
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar setBackgroundColor:[UIColor blueColor]];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
    
    UIBarButtonItem *centerBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    
    NSArray *items = @[leftBtn, centerBtn, rightBtn];
    [toolBar setItems:items animated:YES];
    [pickViewBackView addSubview:toolBar];
    
    areaPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight-216, ScreenWidth, 216)];
    areaPicker.backgroundColor = toolBarColor;
    areaPicker.dataSource = self;
    areaPicker.delegate = self;
    [pickViewBackView addSubview:areaPicker];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder]; // 关闭键盘
    return YES;
}

#pragma mark --UIPickerViewDataSource

// returns the number of 'columns' to display.

//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..

//返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [provinecesArray count];
    }else
    {
        NSInteger firstRow= [pickerView selectedRowInComponent:0];
        NSDictionary *dic = [provinecesArray objectAtIndex:firstRow];
        NSArray *cities = [dic objectForKey:@"cities"];
        
        return  [cities count];
    }
}

#pragma mark --UIPickerViewDelegate

//返回列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    if (component == 0) {
        return ScreenWidth/2;
    }else
    {
        return ScreenWidth/2;
    }
}
//返回行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

//返回列行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary *dic = [provinecesArray objectAtIndex:row];
        return  [dic objectForKey:@"ProvinceName"];
    }else
    {
        NSInteger firstRow= [pickerView selectedRowInComponent:0];
        NSDictionary *dic = [provinecesArray objectAtIndex:firstRow];
        NSArray *cities = [dic objectForKey:@"cities"];
        NSDictionary *cityDic = [cities objectAtIndex:row];
        NSString *cityName = [cityDic objectForKey:@"CityName"];
        
        return cityName;
    }
}

//选择事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        //        _shengRow = row;
    }//else {
    // _cityRow = row;
    //}
}

#pragma mark -ToolBarButtonAction

- (void)leftBtnAction
{
    
    [pickViewBackView removeFromSuperview];
    areaPicker = nil;
    pickViewBackView = nil;
    
}

- (void)rightBtnAction
{
    NSInteger firstRow = [areaPicker selectedRowInComponent:0];
    NSDictionary *dic = [provinecesArray objectAtIndex:firstRow];
    NSString *content1 = [dic objectForKey:@"ProvinceName"];
        
    NSArray *citiesArray = [dic objectForKey:@"cities"];
    NSInteger secondRow = [areaPicker selectedRowInComponent:1];
    NSDictionary *cityDic = [citiesArray objectAtIndex:secondRow];
    NSString *content2 = cityDic[@"CityName"];
        
    NSString *content = [NSString stringWithFormat:@"中国-%@-%@", content1, content2];
    [areaBtn setTitle:content forState:UIControlStateNormal];
        
    [pickViewBackView removeFromSuperview];
    areaPicker = nil;
    pickViewBackView = nil;
    
}

#pragma mark 取消
- (void)cancelAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 保存
- (void)saveAction:(UIButton *)button {
    
    if (consigneeField.text.length == 0 || phoneField.text.length == 0 || areaBtn.titleLabel.text.length == 0 ||  addressField.text.length == 0) {
        [self.view makeToast:@"请将信息填写完整"];
    } else {
        if (postcodeField.text.length == 6) {
            
            __weak typeof(self)wSelf = self ;
            
            NZWebHandler *handler = [[NZWebHandler alloc] init] ;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.labelText = @"请稍候..." ;
            
            NZUser *user = [NZUserManager sharedObject].user ;
            
            NSArray *array = [areaBtn.titleLabel.text componentsSeparatedByString:@"-"];
            
            NSDictionary *parameters;
            
            
            if (self.addressType == enumtAddressType_Add) { // 添加收货地址
                
                parameters = @{
                               @"userId":user.userId,
                               @"name":consigneeField.text,
                               @"phone":phoneField.text,
                               @"province":array[1],
                               @"city":array[2],
                               @"zipCode":postcodeField.text,
                               @"address":addressField.text
                               } ;
                
                [handler postURLStr:webAddAddress postDic:parameters
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
                         [self.view makeToast:@"添加成功"];
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     else
                     {
                         [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
                     }
                 }] ;
                
            } else { // 修改收货地址
                
                parameters = @{
                               @"userId":user.userId,
                               @"name":consigneeField.text,
                               @"phone":phoneField.text,
                               @"province":array[1],
                               @"city":array[2],
                               @"zipCode":postcodeField.text,
                               @"address":addressField.text,
                               @"id":[NSNumber numberWithInt:self.addressID]
                               } ;
                
                [handler postURLStr:webEditAddress postDic:parameters
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
                         [self.view makeToast:@"修改成功"];
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     else
                     {
                         [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
                     }
                 }] ;
                
            }
            
        } else {
            [self.view makeToast:@"请输入正确的邮政编码"];
        }
        
    }
    
    
}

#pragma mark 修改地址时，要请求详细地址，并填入输入框
- (void)requestDetailAddress {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"id":[NSString stringWithFormat:@"%d",self.addressID]
                                 } ;
    
    [handler postURLStr:webDetailAddress postDic:parameters
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
             MyDeliveryAddressInfoModel *detailAddress = [[MyDeliveryAddressInfoModel alloc] init];
             
             detailAddress = [MyDeliveryAddressInfoModel objectWithKeyValues:retInfo[@"detail"]];
                              
             consigneeField.text = detailAddress.name;
             
             phoneField.text = detailAddress.phone;
             
             NSString *areaStr = [NSString stringWithFormat:@"中国-%@-%@",detailAddress.province,detailAddress.city];
             [areaBtn setTitle:areaStr forState:UIControlStateNormal];
             
             postcodeField.text = detailAddress.zipCode;
             
             addressField.text = detailAddress.address;
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

@end
