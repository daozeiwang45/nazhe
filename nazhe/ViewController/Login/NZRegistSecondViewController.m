//
//  NZRegistSecondViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/15.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZRegistSecondViewController.h"
#import "NZRegistFinalViewController.h"
#import "NJImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "QRadioButton.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface NZRegistSecondViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, NJImageCropperDelegate, QRadioButtonDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    
    UIScrollView *scrollView;
    
    UIImageView *headImgView; // 头像
    
    UIImageView *nickNameHook; // 昵称可用
    UILabel *nickNameForkLab;  // 昵称已注册
    
    UIButton *birthDayBtn; // 生气选择按钮
    UIButton *areaBtn; // 地区选择按钮
    UIButton *hometownBtn; // 故乡选择按钮
    UITextField *trueNameField; // 真实姓名输入框
    UITextField *deliAddressField; // 收货地址输入框
    
    UITextField *nickNameField; // 姓名输入框
    
    UIButton *nextBtn; // 下一步按钮
    
    NSArray *provinecesArray; // 省份数组，从plist文件获取
    
    enumtPickerViewType pickerViewType; // 当前是哪种pickerview
    UIView *pickViewBackView; // pickview的透明背景view，防止点击其它控件
    UIDatePicker *datePicker; // 日期选择器
    NSDate *selectedDate; // 已选择过的生日
    
    UIPickerView *areaPicker; // 地区选择器
    UIPickerView *hometownPicker; // 故乡选择器
    
    BOOL isSelectedHeadImg; // 是否修改过头像
    BOOL isMan; // 男女性别
    BOOL nickName; // 昵称是否可用
   
    BOOL canNext; // 是否可以到下一步
}

@end

@implementation NZRegistSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSelectedHeadImg = NO;
    isMan = YES;
    nickName = NO;
    canNext = NO;
    
    [self createNavigationItemTitleViewWithTitle:@"注册"];
    [self leftButtonTitle:nil];
    
    [self initInterface]; // 初始化注册界面
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    provinecesArray = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark 初始化注册界面
- (void)initInterface {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    // 注册步骤
    UIImageView *registStepTwo = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*296/375)/2, 10, ScreenWidth*296/375, ScreenWidth*74/375)];
    registStepTwo.image = [UIImage imageNamed:@"注册条2"];
    [scrollView addSubview:registStepTwo];
    
    /***********************   头像   ***************************/
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*100/375)/2, CGRectGetMaxY(registStepTwo.frame)+ScreenWidth*25/375, ScreenWidth*100/375, ScreenWidth*100/375)];
    headImgView.image = [UIImage imageNamed:@"头像男"];
    [headImgView.layer setCornerRadius:(headImgView.frame.size.height/2)];
    [headImgView.layer setMasksToBounds:YES];
    [headImgView setContentMode:UIViewContentModeScaleAspectFill];
    [headImgView setClipsToBounds:YES];
    headImgView.userInteractionEnabled = YES;
    headImgView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [headImgView addGestureRecognizer:portraitTap];
    [scrollView addSubview:headImgView];
    
    UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgView.frame)+ScreenWidth*10/375, ScreenWidth, 15)];
    headLab.text = @"修改头像";
    headLab.textColor = [UIColor grayColor];
    headLab.font = [UIFont systemFontOfSize:13.f];
    headLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:headLab];
    
    /***********************   昵称   ***************************/
    // 图标
    UILabel *nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(headLab.frame)+ScreenWidth*20/375, 35, 20)];
    nickNameLab.text = @"昵称";
    nickNameLab.textColor = [UIColor grayColor];
    nickNameLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:nickNameLab];

    // 输入框
    nickNameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLab.frame)+10, nickNameLab.origin.y, ScreenWidth-ScreenWidth*80/375-35-10, 20)];
    nickNameField.font = [UIFont fontWithName:@"Arial" size:17.f];
    nickNameField.placeholder = @"（一次修改机会）";
    nickNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nickNameField.returnKeyType = UIReturnKeyDone;
    [nickNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    nickNameField.delegate = self;
    [scrollView addSubview:nickNameField];
    
    // 昵称可用
    nickNameHook = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-ScreenWidth*20/375, nickNameField.origin.y+ScreenWidth*3/375, ScreenWidth*20/375, ScreenWidth*14/375)];
    nickNameHook.image = [UIImage imageNamed:@"勾号"];
    nickNameHook.hidden = YES;
    [scrollView addSubview:nickNameHook];
    // 昵称已注册
    nickNameForkLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-70, nickNameField.origin.y, 70, ScreenWidth*20/375)];
    nickNameForkLab.text = @"昵称已注册";
    nickNameForkLab.textColor = darkRedColor;
    nickNameForkLab.font = [UIFont systemFontOfSize:13.f];
    nickNameForkLab.textAlignment = NSTextAlignmentRight;
    nickNameForkLab.hidden = YES;
    [scrollView addSubview:nickNameForkLab];
    
    // 输入框底线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(nickNameField.origin.x, CGRectGetMaxY(nickNameField.frame)+3, nickNameField.frame.size.width, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line1];
    
    /***********************   性别单选框  ***************************/
    QRadioButton *radio1 = [[QRadioButton alloc]initWithDelegate:self groupId:@"sex"];
    radio1.delegate = self;
    [scrollView addSubview:radio1];
    [radio1 setTitle:@"先生" forState:UIControlStateNormal];
    [radio1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [radio1.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    radio1.frame = CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(nickNameLab.frame)+15, (ScreenWidth-ScreenWidth*80/375)/4, 20);
    [radio1 setChecked:YES];
    
    QRadioButton *radio2 = [[QRadioButton alloc]initWithDelegate:self groupId:@"sex"];
    radio2.delegate = self;
    [scrollView addSubview:radio2];
    [radio2 setTitle:@"女士" forState:UIControlStateNormal];
    [radio2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [radio2.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    radio2.frame = CGRectMake(CGRectGetMaxX(radio1.frame), radio1.origin.y, radio1.frame.size.width, 20);

    UILabel *birthDayLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(radio2.frame), radio2.origin.y, 35, 20)];
    birthDayLab.text = @"生日";
    birthDayLab.textColor = [UIColor grayColor];
    birthDayLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:birthDayLab];
    
    birthDayBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(birthDayLab.frame), birthDayLab.origin.y, (ScreenWidth-ScreenWidth*80/375)/2-birthDayLab.frame.size.width, 20)];
    [birthDayBtn setTitle:@"（不可修改）" forState:UIControlStateNormal];
    [birthDayBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    birthDayBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    birthDayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [birthDayBtn addTarget:self action:@selector(datePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:birthDayBtn];
    
    UIImageView *rightArrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(birthDayBtn.frame)-6, birthDayBtn.origin.y+4.5, 6, 11)];
    rightArrow1.image = [UIImage imageNamed:@"注册右键"];
    [scrollView addSubview:rightArrow1];
    [scrollView sendSubviewToBack:rightArrow1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(birthDayBtn.origin.x, CGRectGetMaxY(birthDayBtn.frame)+3, birthDayBtn.frame.size.width, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line2];
    
    /***********************   所在地区  ***************************/
    UILabel *areaLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(radio1.frame)+15, 70, 20)];
    areaLab.text = @"所在地区";
    areaLab.textColor = [UIColor grayColor];
    areaLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:areaLab];
    
    areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(areaLab.frame), areaLab.origin.y, (ScreenWidth-ScreenWidth*80/375)-areaLab.frame.size.width, 20)];
    [areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    areaBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [areaBtn addTarget:self action:@selector(areaPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:areaBtn];
    
    UIImageView *rightArrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(areaBtn.frame)-6, areaBtn.origin.y+4.5, 6, 11)];
    rightArrow2.image = [UIImage imageNamed:@"注册右键"];
    [scrollView addSubview:rightArrow2];
    [scrollView sendSubviewToBack:rightArrow2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(areaBtn.origin.x, CGRectGetMaxY(areaBtn.frame)+3, areaBtn.frame.size.width, 0.5)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line3];
    
    /***********************   故乡  ***************************/
    UILabel *hometownLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(areaLab.frame)+15, 35, 20)];
    hometownLab.text = @"故乡";
    hometownLab.textColor = [UIColor grayColor];
    hometownLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:hometownLab];
    
    hometownBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hometownLab.frame), hometownLab.origin.y, (ScreenWidth-ScreenWidth*80/375)-hometownLab.frame.size.width, 20)];
    [hometownBtn setTitle:@"（不可修改）" forState:UIControlStateNormal];
    [hometownBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    hometownBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    hometownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [hometownBtn addTarget:self action:@selector(hometownPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:hometownBtn];
    
    UIImageView *rightArrow3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hometownBtn.frame)-6, hometownBtn.origin.y+4.5, 6, 11)];
    rightArrow3.image = [UIImage imageNamed:@"注册右键"];
    [scrollView addSubview:rightArrow3];
    [scrollView sendSubviewToBack:rightArrow3];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(hometownBtn.origin.x, CGRectGetMaxY(hometownBtn.frame)+3, hometownBtn.frame.size.width, 0.5)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line4];
    
    /***********************   职业  ***************************/
    UILabel *occupationLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(hometownLab.frame)+15, 35, 20)];
    occupationLab.text = @"职业";
    occupationLab.textColor = [UIColor grayColor];
    occupationLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:occupationLab];
    
    UIButton *occupationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(occupationLab.frame), occupationLab.origin.y, (ScreenWidth-ScreenWidth*80/375)-occupationLab.frame.size.width, 20)];
    [occupationBtn addTarget:self action:@selector(jobPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:occupationBtn];
    
    UIImageView *rightArrow4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(occupationBtn.frame)-6, occupationBtn.origin.y+4.5, 6, 11)];
    rightArrow4.image = [UIImage imageNamed:@"注册右键"];
    [scrollView addSubview:rightArrow4];
    [scrollView sendSubviewToBack:rightArrow4];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(occupationBtn.origin.x, CGRectGetMaxY(occupationBtn.frame)+3, occupationBtn.frame.size.width, 0.5)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line5];
    
    /***********************   真实姓名  ***************************/
    UILabel *trueNameLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(occupationLab.frame)+15, 70, 20)];
    trueNameLab.text = @"真实姓名";
    trueNameLab.textColor = [UIColor grayColor];
    trueNameLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:trueNameLab];
    
    trueNameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(trueNameLab.frame), trueNameLab.origin.y, (ScreenWidth-ScreenWidth*80/375)-trueNameLab.frame.size.width, 20)];
    trueNameField.font = [UIFont fontWithName:@"Arial" size:17.f];
    trueNameField.placeholder = @"（不可修改）";
    trueNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    trueNameField.returnKeyType = UIReturnKeyDone;
    [trueNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    trueNameField.delegate = self;
    [scrollView addSubview:trueNameField];
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(trueNameField.origin.x, CGRectGetMaxY(trueNameField.frame)+3, trueNameField.frame.size.width, 0.5)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line6];
    
    /***********************   收货地址  ***************************/
    UILabel *deliAddressLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(trueNameLab.frame)+15, 70, 20)];
    deliAddressLab.text = @"收货地址";
    deliAddressLab.textColor = [UIColor grayColor];
    deliAddressLab.font = [UIFont systemFontOfSize:17.f];
    [scrollView addSubview:deliAddressLab];
    
    deliAddressField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(deliAddressLab.frame), deliAddressLab.origin.y, (ScreenWidth-ScreenWidth*80/375)-deliAddressLab.frame.size.width, 20)];
    deliAddressField.font = [UIFont fontWithName:@"Arial" size:17.f];
    deliAddressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    deliAddressField.returnKeyType = UIReturnKeyDone;
    [deliAddressField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // 关闭首字母大写
    deliAddressField.delegate = self;
    [scrollView addSubview:deliAddressField];
    
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(deliAddressField.origin.x, CGRectGetMaxY(deliAddressField.frame)+3, deliAddressField.frame.size.width, 0.5)];
    line7.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line7];
    
    /***********************   下一步   ***************************/
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*175/375)/2, CGRectGetMaxY(deliAddressLab.frame)+ScreenWidth*30/375, ScreenWidth*175/375, ScreenWidth*40/375)];
    nextBtn.backgroundColor = [UIColor lightGrayColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    nextBtn.layer.cornerRadius = 2.f;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(finalStep:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextBtn];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(nextBtn.frame)+ScreenWidth*100/375);
}

#pragma mark QRadioButtonDelegate
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([radio.titleLabel.text isEqualToString:@"先生"]) {
        isMan = YES;
        if (!isSelectedHeadImg) {
            headImgView.image = [UIImage imageNamed:@"头像男"];
        }
    }
    if ([radio.titleLabel.text isEqualToString:@"女士"]) {
        isMan = NO;
        if (!isSelectedHeadImg) {
            headImgView.image = [UIImage imageNamed:@"头像女"];
        }
    }
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder]; // 关闭键盘
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if ([textField isEqual:nickNameField]) {
        nickNameForkLab.hidden = YES;
        nickNameHook.hidden = YES;
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
    if ([textField isEqual:nickNameField]) {
        
        if (nickNameField.text.length == 0) {
            nickName = NO;
        } else {
            __weak typeof(self)wSelf = self ;
            
            NZWebHandler *handler = [[NZWebHandler alloc] init] ;
            
            NSDictionary *parameters = @{
                                         @"nickName":nickNameField.text
                                         } ;
            
            [handler postURLStr:webIsExistNickName postDic:parameters
                          block:^(NSDictionary *retInfo, NSError *error)
             {
                 
                 if( error )
                 {
                     [wSelf.view makeToast:@"网络错误"];
                     nickName = NO;
                     return ;
                 }
                 if( retInfo == nil )
                 {
                     [wSelf.view makeToast:@"网络错误"];
                     nickName = NO;
                     return ;
                 }
                 
                 BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
                 
                 if( state )
                 {
                     if ([retInfo[@"isExist"] boolValue]) {
                         nickNameForkLab.hidden = NO;
                         nickName = NO;
                     } else { // 号码正确且可注册
                         nickNameHook.hidden = NO;
                         nickName = YES;
                     }
                     
                 }
                 else
                 {
                     [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
                     nickName = NO;
                 }
             }] ;
        }
        
    }
    
    if (nickName) {
        if (birthDayBtn.titleLabel.text.length  == 0 || areaBtn.titleLabel.text.length == 0 || hometownBtn.titleLabel.text.length == 0 || trueNameField.text.length == 0 || deliAddressField.text.length == 0) {
            canNext = NO;
            nextBtn.backgroundColor = [UIColor lightGrayColor];
        } else {
            canNext = YES;
            nextBtn.backgroundColor = darkRedColor;
        }
    } else {
        canNext = NO;
        nextBtn.backgroundColor = [UIColor lightGrayColor];
    }
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


#pragma mark 选择生日
- (void)datePickerView:(UIButton *)button {
    pickerViewType = enumtPickerViewType_Date; // 日期选择器
    
    pickViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]; // 先初始化
    pickViewBackView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:pickViewBackView];
    
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
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenHeight-216, ScreenWidth, 216)];
    datePicker.backgroundColor = toolBarColor;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    if (selectedDate) {
        [datePicker setDate:selectedDate];
    } else {
        [datePicker setDate:[NSDate date]];
    }
    
    NSString *minDateString = @"1900-01-01";
    NSString *maxDateString = @"2020-12-31";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-DD"];
    
    NSDate *minDate = [dateFormater dateFromString:minDateString];
    NSDate *maxDate = [dateFormater dateFromString:maxDateString];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    
    [pickViewBackView addSubview:datePicker];

}

#pragma mark 选择地区
- (void)areaPickerView:(UIButton *)button {
    pickerViewType = enumtPickerViewType_Area; // 地区选择器
    
    pickViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]; // 先初始化
    pickViewBackView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:pickViewBackView];
    
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

#pragma mark 选择故乡
- (void)hometownPickerView:(UIButton *)button {
    pickerViewType = enumtPickerViewType_Hometown; // 故乡选择器
    
    pickViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]; // 先初始化
    pickViewBackView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:pickViewBackView];
    
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
    
    hometownPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight-216, ScreenWidth, 216)];
    hometownPicker.backgroundColor = toolBarColor;
    hometownPicker.dataSource = self;
    hometownPicker.delegate = self;
    [pickViewBackView addSubview:hometownPicker];
}

#pragma mark 选择地区
- (void)jobPickerView:(UIButton *)button {
    [self.view makeToast:@"职业选择功能暂未开放"];
}

#pragma mark -ToolBarButtonAction

- (void)leftBtnAction
{
    if (pickerViewType == enumtPickerViewType_Date) { // 日期选择器
        [pickViewBackView removeFromSuperview];
        datePicker = nil;
        pickViewBackView = nil;
    } else if (pickerViewType == enumtPickerViewType_Area || pickerViewType == enumtPickerViewType_Hometown) { // 地区或故乡选择器
        [pickViewBackView removeFromSuperview];
        areaPicker = nil;
        pickViewBackView = nil;
    }
}

- (void)rightBtnAction
{
    if (pickerViewType == enumtPickerViewType_Date) { // 日期选择器
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
        
        selectedDate = datePicker.date;
        
        [birthDayBtn setTitle:strDate forState:UIControlStateNormal];
        [birthDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        birthDayBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        
        [pickViewBackView removeFromSuperview];
        datePicker = nil;
        pickViewBackView = nil;
    } else if (pickerViewType == enumtPickerViewType_Area) { // 地区选择器
        
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
    } else if (pickerViewType == enumtPickerViewType_Hometown) { // 故乡选择器
        
        NSInteger firstRow = [hometownPicker selectedRowInComponent:0];
        NSDictionary *dic = [provinecesArray objectAtIndex:firstRow];
        NSString *content1 = [dic objectForKey:@"ProvinceName"];
        
        NSArray *citiesArray = [dic objectForKey:@"cities"];
        NSInteger secondRow = [hometownPicker selectedRowInComponent:1];
        NSDictionary *cityDic = [citiesArray objectAtIndex:secondRow];
        NSString *content2 = cityDic[@"CityName"];
        
        NSString *content = [NSString stringWithFormat:@"中国-%@-%@", content1, content2];
        [hometownBtn setTitle:content forState:UIControlStateNormal];
        [hometownBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        hometownBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        
        [pickViewBackView removeFromSuperview];
        hometownPicker = nil;
        pickViewBackView = nil;

    }

}

#pragma mark 跳转到最后一步
- (void)finalStep:(UIButton *)button {
    
//    NZRegistFinalViewController *registVCTR = [[NZRegistFinalViewController alloc] init];
//    [self.navigationController pushViewController:registVCTR animated:YES];

    
    if (canNext) {
        NZRegistInformation *registInfo = [NZUserManager sharedObject].registInfo;
        
        registInfo.nickName = nickNameField.text;
        if (isMan) {
            registInfo.sex = @"男";
        } else {
            registInfo.sex = @"女";
        }
        
        registInfo.birthday = birthDayBtn.titleLabel.text;
        
        NSString *areaStr = areaBtn.titleLabel.text;
        NSArray *areaArray = [areaStr componentsSeparatedByString:@"-"];
        registInfo.province = areaArray[1];
        registInfo.city = areaArray[2];
        
        NSString *homeStr = hometownBtn.titleLabel.text;
        NSArray *homeArray = [homeStr componentsSeparatedByString:@"-"];
        NSString *hometownStr = [NSString stringWithFormat:@"%@%@%@",homeArray[0],homeArray[1],homeArray[2]];
        registInfo.hometown = hometownStr;
        
        registInfo.name = trueNameField.text;
        
        registInfo.address = deliAddressField.text;
        
        NZRegistFinalViewController *registVCTR = [[NZRegistFinalViewController alloc] init];
        [self.navigationController pushViewController:registVCTR animated:YES];
    }

    
}

#pragma mark 下面全是修改头像的，不是我写的，先暂时不看，能用就好
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(NJImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    headImgView.image = editedImage;
    isSelectedHeadImg = YES;
    // 压缩图片
    UIImage *scaleImage = [NZGlobal scaleFromImage:editedImage toSize:CGSizeMake(120.0f, 120.0f)];
    NSData *imageData = UIImageJPEGRepresentation(scaleImage, 0.6);
    
    // 保存头像字节流
    NZRegistInformation *registInformation = [NZUserManager sharedObject].registInfo;
    registInformation.headImg = imageData;
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(NJImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        NJImageCropperViewController *imgEditorVC = [[NJImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
