//
//  NZPersonalViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/18.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZPersonalViewController.h"
#import "NJImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MyProfileModel.h"
#import "FileDetail.h"
#import "SDPhotoBrowser.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface NZPersonalViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, NJImageCropperDelegate, SDPhotoBrowserDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    UIScrollView *scrollView;
    
    UIView *headView;
    UIImageView *headImgView; // 头像
    UIView *maskView;
    UILabel *headLab;
    
    UILabel *editLab; // 编辑label
    UIImageView *editImgV; // 编辑icon
    UIButton *editBtn; // 编辑按钮
    BOOL edit;
    
    UILabel *phoneLab; // 手机绑定
    UILabel *nickNameLab; // 昵称
    UIButton *addBtn; // 添加推荐人按钮
    UITextField *recommendTextF; // 推荐人昵称输入框
    
    UILabel *myLvLab; // 等级
    UILabel *myIDLab; // ID号
    UILabel *myRealNameLab; // 真实姓名
    UILabel *mySexLab; // 性别
    UIButton *areaBtn; // 所在地区
    UILabel *myHometownLab; // 故乡
    
    UIButton *occupationBtn; // 职业
    UILabel *myBirthDayLab; // 生日
    UILabel *myConstellationLab; // 星座
    UITextField *mailboxField; // 邮箱
    UITextField *signatureField; // 个性签名
    
    UIView *centerView;
    UIButton *cancelBtn;
    UIButton *saveBtn;
    
    // 底线
    UIView *bottomLine;
    UIView *bottomLine1;
    UIView *bottomLine2;
    UIView *bottomLine3;
    UIView *bottomLine4;
    // 右箭头
    UIImageView *rightArrow1;
    UIImageView *rightArrow2;
    
    MyProfileModel *myProfileModel; // 个人资料模型
    
    NSArray *provinecesArray; // 省份城市数组数据
    NSArray *jobsArray; // 职业数组数据
    enumtPickerViewType pickerViewType; // 当前是哪种pickerview
    UIView *pickViewBackView; // pickview的透明背景view，防止点击其它控件
    UIPickerView *areaPicker; // 地区选择器
    UIPickerView *jobPicker; // 职业选择器
    
//    UIActionSheet *choiceSheet; // 查看大图或修改头像
//    UIActionSheet *editStyleSheet; // 选择修改头像方式sheet
}

@end

@implementation NZPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    edit = NO;
    
    [self createNavigationItemTitleViewWithTitle:@"个人资料"];
    [self leftButtonTitle:nil];
    
    [self initInterface]; // 初始化个人资料界面
    [self requestMyProfile]; // 请求个人资料
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    provinecesArray = [NSArray arrayWithContentsOfFile:path1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"job" ofType:@"plist"];
    jobsArray = [NSArray arrayWithContentsOfFile:path2];
}

#pragma mark 初始化个人资料界面
- (void)initInterface {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    /*************************  编辑  ********************************/
    // 编辑icon
    editImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*59/375, ScreenWidth*20/375, ScreenWidth*19/375, ScreenWidth*18/375)];
    editImgV.image = [UIImage imageNamed:@"编辑"];
    [scrollView addSubview:editImgV];
    
    // 编辑label
    editLab = [[UILabel alloc] initWithFrame:CGRectMake(editImgV.origin.x-30-ScreenWidth*5/375, editImgV.origin.y, 30, editImgV.frame.size.height)];
    editLab.text = @"编辑";
    editLab.textColor = darkRedColor;
    editLab.font = [UIFont systemFontOfSize:11.f];
    editLab.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:editLab];
    
    editBtn = [[UIButton alloc] initWithFrame:CGRectMake(editLab.origin.x, editLab.origin.y, 30+ScreenWidth*24/375, editImgV.frame.size.height)];
    [editBtn addTarget:self action:@selector(editPersonalAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:editBtn];
    
    /*************************  头像  ********************************/
    headView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, ScreenWidth*20/375, ScreenWidth*100/375, ScreenWidth*100/375)];
    headView.backgroundColor = [UIColor whiteColor];
    [headView.layer setCornerRadius:(headView.frame.size.height/2)];
    [headView.layer setMasksToBounds:YES];
    [headView setContentMode:UIViewContentModeScaleAspectFill];
    [headView setClipsToBounds:YES];
    [scrollView addSubview:headView];
    
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*100/375, ScreenWidth*100/375)];
    headImgView.image = [UIImage imageNamed:@"头像男"];
    headImgView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [headImgView addGestureRecognizer:portraitTap];
    headImgView.userInteractionEnabled = YES;
    [headView addSubview:headImgView];
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*75/375, ScreenWidth*100/375, ScreenWidth*25/375)];
    maskView.backgroundColor = [UIColor grayColor];
    maskView.alpha = 0.4f;
    maskView.hidden = YES;
    [headView addSubview:maskView];
    
    headLab = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*75/375, ScreenWidth*100/375, ScreenWidth*20/375)];
    headLab.text = @"修改头像";
    headLab.textColor = [UIColor whiteColor];
    headLab.font = [UIFont systemFontOfSize:12.f];
    headLab.textAlignment = NSTextAlignmentCenter;
    headLab.userInteractionEnabled = YES;
    headLab.hidden = YES;
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [headImgView addGestureRecognizer:labTap];
    [headView addSubview:headLab];
    
    /*************************  电话号码  ********************************/
    phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+ScreenWidth*15/375, ScreenWidth*70/375-7.5, ScreenWidth-ScreenWidth*155/375, 15)];
    phoneLab.textColor = [UIColor grayColor];
    phoneLab.font = [UIFont systemFontOfSize:13.f];
    [scrollView addSubview:phoneLab];
    
    /*************************  昵称  ********************************/
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+ScreenWidth*15/375, phoneLab.origin.y-ScreenWidth*5/375-15, 30, 15)];
    nickLab.text = @"昵称";
    nickLab.textColor = [UIColor grayColor];
    nickLab.font = [UIFont systemFontOfSize:13.f];
    [scrollView addSubview:nickLab];
    
    nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickLab.frame)+5, phoneLab.origin.y-ScreenWidth*5/375-20, ScreenWidth-ScreenWidth*155/375-30, 20)];
    nickNameLab.font = [UIFont systemFontOfSize:20.f];
    [scrollView addSubview:nickNameLab];
    
    /*************************  推荐人  ********************************/
    UILabel *recommendedLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+ScreenWidth*15/375, CGRectGetMaxY(phoneLab.frame)+ScreenWidth*5/375, ScreenWidth-ScreenWidth*155/375, 15)];
    recommendedLab.text = @"推荐人";
    recommendedLab.textColor = [UIColor grayColor];
    recommendedLab.font = [UIFont systemFontOfSize:13.f];
    [scrollView addSubview:recommendedLab];
    
    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(recommendedLab.origin.x+50, recommendedLab.origin.y, ScreenWidth-ScreenWidth*195/375-50, 15)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:darkRedColor forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    addBtn.userInteractionEnabled = NO;
    [addBtn addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addBtn];
    
    recommendTextF = [[UITextField alloc] initWithFrame:addBtn.frame];
    recommendTextF.placeholder = @"请输入推荐人昵称";
    recommendTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    recommendTextF.font = [UIFont boldSystemFontOfSize:13];
    recommendTextF.backgroundColor = [UIColor clearColor];
    recommendTextF.hidden = YES;
    [scrollView addSubview:recommendTextF];
    
    // 输入框底线
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(recommendTextF.origin.x, CGRectGetMaxY(recommendTextF.frame)+3, recommendTextF.frame.size.width, 0.5)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    bottomLine.hidden = YES;
    [scrollView addSubview:bottomLine];
    
    // 虚线
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(headView.frame)+ScreenWidth*20/375, ScreenWidth-ScreenWidth*80/375, 1)];
    line1.image = [UIImage imageNamed:@"收货地址虚线"];
    [scrollView addSubview:line1];
    
    /*************************  等级  ********************************/
    UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(line1.frame)+ScreenWidth*15/375, 80, 15)];
    levelLab.text = @"等       级";
    levelLab.textColor = [UIColor grayColor];
    levelLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:levelLab];
    
    myLvLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(levelLab.frame), levelLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    myLvLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:myLvLab];
    
    /*************************  ID号  ********************************/
    UILabel *IDLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(levelLab.frame)+ScreenWidth*13/375, 80, 15)];
    IDLab.text = @"ID       号";
    IDLab.textColor = [UIColor grayColor];
    IDLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:IDLab];
    
    myIDLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(IDLab.frame), IDLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    myIDLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:myIDLab];
    
    /*************************  真实姓名  ********************************/
    UILabel *realNameLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(IDLab.frame)+ScreenWidth*13/375, 80, 15)];
    realNameLab.text = @"真实姓名";
    realNameLab.textColor = [UIColor grayColor];
    realNameLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:realNameLab];
    
    myRealNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(realNameLab.frame), realNameLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    myRealNameLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:myRealNameLab];
    
    /*************************  性别  ********************************/
    UILabel *sexLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(realNameLab.frame)+ScreenWidth*13/375, 80, 15)];
    sexLab.text = @"性       别";
    sexLab.textColor = [UIColor grayColor];
    sexLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:sexLab];
    
    mySexLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sexLab.frame), sexLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    mySexLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:mySexLab];
    
    /*************************  所在地区  ********************************/
    UILabel *areaLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(sexLab.frame)+ScreenWidth*13/375, 80, 15)];
    areaLab.text = @"所在地区";
    areaLab.textColor = [UIColor grayColor];
    areaLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:areaLab];
    
    areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(areaLab.frame), areaLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    [areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    areaBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [areaBtn addTarget:self action:@selector(areaPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:areaBtn];
    
    // 输入框底线
    bottomLine1 = [[UIView alloc] initWithFrame:CGRectMake(areaBtn.origin.x, CGRectGetMaxY(areaBtn.frame)+3, areaBtn.frame.size.width, 0.5)];
    bottomLine1.backgroundColor = [UIColor lightGrayColor];
    bottomLine1.hidden = YES;
    [scrollView addSubview:bottomLine1];
    
    rightArrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(areaBtn.frame)-6, areaBtn.origin.y, 8, 15)];
    rightArrow1.image = [UIImage imageNamed:@"注册右键"];
    rightArrow1.hidden = YES;
    [scrollView addSubview:rightArrow1];
    [scrollView sendSubviewToBack:rightArrow1];
    
    /*************************  故乡  ********************************/
    UILabel *hometownLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(areaLab.frame)+ScreenWidth*13/375, 80, 15)];
    hometownLab.text = @"故       乡";
    hometownLab.textColor = [UIColor grayColor];
    hometownLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:hometownLab];
    
    myHometownLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hometownLab.frame), hometownLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    myHometownLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:myHometownLab];
    
    /*************************  职业  ********************************/
    UILabel *occupationLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(hometownLab.frame)+ScreenWidth*35/375, 80, 15)];
    occupationLab.text = @"职      业";
    occupationLab.textColor = [UIColor grayColor];
    occupationLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:occupationLab];
    
    occupationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(occupationLab.frame), occupationLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    [occupationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    occupationBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    occupationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    occupationBtn.userInteractionEnabled = NO;
    [occupationBtn addTarget:self action:@selector(jobPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:occupationBtn];
    
    // 输入框底线
    bottomLine2 = [[UIView alloc] initWithFrame:CGRectMake(occupationBtn.origin.x, CGRectGetMaxY(occupationBtn.frame)+3, occupationBtn.frame.size.width, 0.5)];
    bottomLine2.backgroundColor = [UIColor lightGrayColor];
    bottomLine2.hidden = YES;
    [scrollView addSubview:bottomLine2];
    
    rightArrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(occupationBtn.frame)-6, occupationBtn.origin.y, 8, 15)];
    rightArrow2.image = [UIImage imageNamed:@"注册右键"];
    rightArrow2.hidden = YES;
    [scrollView addSubview:rightArrow2];
    [scrollView sendSubviewToBack:rightArrow2];
    
    /*************************  生日  ********************************/
    UILabel *birthDayLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(occupationLab.frame)+ScreenWidth*13/375, 80, 15)];
    birthDayLab.text = @"生       日";
    birthDayLab.textColor = [UIColor grayColor];
    birthDayLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:birthDayLab];
    
    myBirthDayLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(birthDayLab.frame), birthDayLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    myBirthDayLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:myBirthDayLab];
    
    /*************************  星座  ********************************/
    UILabel *constellationLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(birthDayLab.frame)+ScreenWidth*13/375, 80, 15)];
    constellationLab.text = @"星       座";
    constellationLab.textColor = [UIColor grayColor];
    constellationLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:constellationLab];
    
    myConstellationLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(constellationLab.frame), constellationLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    myConstellationLab.font = [UIFont systemFontOfSize:16.f];
    [scrollView addSubview:myConstellationLab];
    
    /*************************  邮箱  ********************************/
    UILabel *mailboxLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(constellationLab.frame)+ScreenWidth*13/375, 80, 15)];
    mailboxLab.text = @"邮       箱";
    mailboxLab.textColor = [UIColor grayColor];
    mailboxLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:mailboxLab];
    
    mailboxField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mailboxLab.frame), mailboxLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    mailboxField.font = [UIFont systemFontOfSize:15.f];
    mailboxField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mailboxField.returnKeyType =UIReturnKeyNext;
    mailboxField.userInteractionEnabled = NO;
    [scrollView addSubview:mailboxField];
    
    // 输入框底线
    bottomLine3 = [[UIView alloc] initWithFrame:CGRectMake(mailboxField.origin.x, CGRectGetMaxY(mailboxField.frame)+3, mailboxField.frame.size.width, 0.5)];
    bottomLine3.backgroundColor = [UIColor lightGrayColor];
    bottomLine3.hidden = YES;
    [scrollView addSubview:bottomLine3];
    
    /*************************  个性签名  ********************************/
    UILabel *signatureLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*40/375, CGRectGetMaxY(mailboxLab.frame)+ScreenWidth*35/375, 80, 15)];
    signatureLab.text = @"个性签名";
    signatureLab.textColor = [UIColor grayColor];
    signatureLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:signatureLab];
    
    signatureField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(signatureLab.frame), signatureLab.origin.y, ScreenWidth-ScreenWidth*80/375-80, 15)];
    signatureField.font = [UIFont systemFontOfSize:15.f];
    signatureField.clearButtonMode = UITextFieldViewModeWhileEditing;
    signatureField.returnKeyType =UIReturnKeyNext;
    signatureField.userInteractionEnabled = NO;
    [scrollView addSubview:signatureField];
    
    // 输入框底线
    bottomLine4 = [[UIView alloc] initWithFrame:CGRectMake(signatureField.origin.x, CGRectGetMaxY(signatureField.frame)+3, signatureField.frame.size.width, 0.5)];
    bottomLine4.backgroundColor = [UIColor lightGrayColor];
    bottomLine4.hidden = YES;
    [scrollView addSubview:bottomLine4];
    
    /*************************  取消和保存  ********************************/
    centerView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-1)/2, CGRectGetMaxY(bottomLine4.frame)+ScreenWidth*40/375, 1, ScreenWidth*15/375)];
    centerView.backgroundColor = [UIColor blackColor];
    centerView.hidden = YES;
    [scrollView addSubview:centerView];
    
    // 取消按钮
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(centerView.origin.x-ScreenWidth*70/375, centerView.origin.y, ScreenWidth*70/375, ScreenWidth*15/375)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    cancelBtn.hidden = YES;
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cancelBtn];
    
    // 保存按钮
    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(centerView.frame), centerView.origin.y, ScreenWidth*70/375, ScreenWidth*15/375)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:tintOrangeColor forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    saveBtn.hidden = YES;
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:saveBtn];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(centerView.frame)+ScreenWidth*40/375);
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
    if (pickerViewType == enumtPickerViewType_Area) {
        if (component == 0) {
            return [provinecesArray count];
        }else
        {
            NSInteger firstRow= [pickerView selectedRowInComponent:0];
            NSDictionary *dic = [provinecesArray objectAtIndex:firstRow];
            NSArray *cities = [dic objectForKey:@"cities"];
            
            return  [cities count];
        }
    } else {
        if (component == 0) {
            return [jobsArray count];
        }else
        {
            NSInteger firstRow= [pickerView selectedRowInComponent:0];
            NSDictionary *dic = [jobsArray objectAtIndex:firstRow];
            NSArray *jobs = [dic objectForKey:@"job"];
            
            return  [jobs count];
        }
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
    if (pickerViewType == enumtPickerViewType_Area) {
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
    } else {
        if (component == 0) {
            NSDictionary *dic = [jobsArray objectAtIndex:row];
            return  [dic objectForKey:@"Industry"];
        }else
        {
            NSInteger firstRow= [pickerView selectedRowInComponent:0];
            NSDictionary *dic = [jobsArray objectAtIndex:firstRow];
            NSArray *jobs = [dic objectForKey:@"job"];
            NSString *jobName = [jobs objectAtIndex:row];
            
            return jobName;
        }
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

#pragma mark 选择地区
- (void)areaPickerView:(UIButton *)button {
    pickerViewType = enumtPickerViewType_Area; // 地区选择器
         
    pickViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]; // 先初始化
    pickViewBackView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:pickViewBackView];
         
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-44-64, ScreenWidth, 44)];
    toolBar.tag = 103;
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar setBackgroundColor:[UIColor blueColor]];
         
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
         
    UIBarButtonItem *centerBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
         
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
         
    NSArray *items = @[leftBtn, centerBtn, rightBtn];
    [toolBar setItems:items animated:YES];
    [pickViewBackView addSubview:toolBar];
         
    areaPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-64, ScreenWidth, 216)];
    areaPicker.backgroundColor = toolBarColor;
    areaPicker.dataSource = self;
    areaPicker.delegate = self;
    [pickViewBackView addSubview:areaPicker];
}

#pragma mark 选择职业
- (void)jobPickerView:(UIButton *)button {
    pickerViewType = enumtPickerViewType_Job; // 职业选择器
    
    pickViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]; // 先初始化
    pickViewBackView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:pickViewBackView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-44-64, ScreenWidth, 44)];
    toolBar.tag = 103;
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar setBackgroundColor:[UIColor blueColor]];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
    
    UIBarButtonItem *centerBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    
    NSArray *items = @[leftBtn, centerBtn, rightBtn];
    [toolBar setItems:items animated:YES];
    [pickViewBackView addSubview:toolBar];
    
    jobPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-64, ScreenWidth, 216)];
    jobPicker.backgroundColor = toolBarColor;
    jobPicker.dataSource = self;
    jobPicker.delegate = self;
    [pickViewBackView addSubview:jobPicker];
}

#pragma mark -ToolBarButtonAction

- (void)leftBtnAction
{
    if (pickerViewType == enumtPickerViewType_Area) { // 地区选择器
        [pickViewBackView removeFromSuperview];
        areaPicker = nil;
        pickViewBackView = nil;
    } else if (pickerViewType == enumtPickerViewType_Job) { // 职业选择器
        [pickViewBackView removeFromSuperview];
        jobPicker = nil;
        pickViewBackView = nil;
    }
}

- (void)rightBtnAction
{
    if (pickerViewType == enumtPickerViewType_Area) { // 地区选择器
        
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
    } else if (pickerViewType == enumtPickerViewType_Job) { // 职业选择器
        
        NSInteger firstRow = [jobPicker selectedRowInComponent:0];
        NSDictionary *dic = [jobsArray objectAtIndex:firstRow];
        NSString *content1 = [dic objectForKey:@"Industry"];
        
        NSArray *citiesArray = [dic objectForKey:@"job"];
        NSInteger secondRow = [jobPicker selectedRowInComponent:1];
        NSString *content2 = [citiesArray objectAtIndex:secondRow];
        
        NSString *content = [NSString stringWithFormat:@"%@-%@", content1, content2];
        [occupationBtn setTitle:content forState:UIControlStateNormal];
        
        [pickViewBackView removeFromSuperview];
        jobPicker = nil;
        pickViewBackView = nil;
    }
    
}

#pragma mark 修改个人资料
- (void)editPersonalAction:(UIButton *)button {
    if (edit) {
        return;
    }
    edit = YES;
    
    editLab.hidden = YES;
    editImgV.image = [UIImage imageNamed:@"编辑-灰"];
    
    maskView.hidden = NO;
    headLab.hidden = NO;
    
    if ([myProfileModel.recommendMan isEqualToString:@""]) {
        addBtn.userInteractionEnabled = YES;
    } else {
        addBtn.userInteractionEnabled = NO;
    }
    occupationBtn.userInteractionEnabled = YES;
    
    bottomLine1.hidden = NO;
    bottomLine2.hidden = NO;
    bottomLine3.hidden = NO;
    bottomLine4.hidden = NO;
    
    rightArrow1.hidden = NO;
    rightArrow2.hidden = NO;
    
    mailboxField.userInteractionEnabled = YES;
    signatureField.userInteractionEnabled = YES;

    centerView.hidden = NO;
    cancelBtn.hidden = NO;
    saveBtn.hidden = NO;
}

#pragma mark 添加推荐人
- (void)recommendAction:(UIButton *)button {
    addBtn.hidden = YES;
    recommendTextF.hidden = NO;
    bottomLine.hidden = NO;
    
    [recommendTextF becomeFirstResponder];
}

#pragma mark 取消
- (void)cancelAction:(UIButton *)button {
    edit = NO;
    
    editLab.hidden = NO;
    editImgV.image = [UIImage imageNamed:@"编辑"];
    
    maskView.hidden = YES;
    headLab.hidden = YES;
    
    addBtn.hidden = NO;
    addBtn.userInteractionEnabled = NO;
    recommendTextF.hidden = YES;
    bottomLine.hidden = YES;
    
    occupationBtn.userInteractionEnabled = NO;
    
    bottomLine1.hidden = YES;
    bottomLine2.hidden = YES;
    bottomLine3.hidden = YES;
    bottomLine4.hidden = YES;
    
    rightArrow1.hidden = YES;
    rightArrow2.hidden = YES;
    
    mailboxField.userInteractionEnabled = NO;
    signatureField.userInteractionEnabled = NO;
    
    centerView.hidden = YES;
    cancelBtn.hidden = YES;
    saveBtn.hidden = YES;
    
    recommendTextF.text = @"";
    areaBtn.titleLabel.text = myProfileModel.province;
    occupationBtn.titleLabel.text = myProfileModel.job;
    mailboxField.text = myProfileModel.email;
    signatureField.text = myProfileModel.signature;
}

#pragma mark 保存
- (void)saveAction:(UIButton *)button {
    edit = NO;
    
    editLab.hidden = NO;
    editImgV.image = [UIImage imageNamed:@"编辑"];
    
    maskView.hidden = YES;
    headLab.hidden = YES;
    
    addBtn.hidden = NO;
    addBtn.userInteractionEnabled = NO;
    recommendTextF.hidden = YES;
    bottomLine.hidden = YES;
    
    occupationBtn.userInteractionEnabled = NO;
    
    bottomLine1.hidden = YES;
    bottomLine2.hidden = YES;
    bottomLine3.hidden = YES;
    bottomLine4.hidden = YES;
    
    rightArrow1.hidden = YES;
    rightArrow2.hidden = YES;
    
    mailboxField.userInteractionEnabled = NO;
    signatureField.userInteractionEnabled = NO;
    
    centerView.hidden = YES;
    cancelBtn.hidden = YES;
    saveBtn.hidden = YES;
    
    [self editMyProfile]; // 修改个人资料
}

#pragma mark 请求个人资料
- (void)requestMyProfile {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webMyProfile postDic:parameters
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
             myProfileModel = [MyProfileModel objectWithKeyValues:retInfo[@"detail"]]; // 字典转模型
             
             // 设置头像
             if ([[myProfileModel.headImg trim] isNotEqualsToString:emptyString]) {
                 myProfileModel.headImg = [handler GetImgBaseURL:myProfileModel.headImg];
                 if ([myProfileModel.sex isEqualToString:@"女"]) {
                     [headImgView sd_setImageWithURL:[NSURL URLWithString:myProfileModel.headImg] placeholderImage:[UIImage imageNamed:@"头像女"]];
                 } else {
                     [headImgView sd_setImageWithURL:[NSURL URLWithString:myProfileModel.headImg] placeholderImage:[UIImage imageNamed:@"头像男"]];
                 }
             } else {
                 if ([myProfileModel.sex isEqualToString:@"女"]) {
                     headImgView.image = [UIImage imageNamed:@"头像女"];
                 } else {
                     headImgView.image = [UIImage imageNamed:@"头像男"];
                 }
             }
             
             // 电话号码
             if ([[myProfileModel.phone trim] isNotEqualsToString:emptyString]) {
                 phoneLab.text = [NSString stringWithFormat:@"手机绑定  %@",myProfileModel.phone];
             } else {
                 phoneLab.text = @"手机绑定";
             }
             
             // 推荐人
             
             if ([myProfileModel.recommendMan isEqualToString:@""]) {
                 [addBtn setTitle:@"添加" forState:UIControlStateNormal];
                 [addBtn setTitleColor:darkRedColor forState:UIControlStateNormal];
             } else {
                 [addBtn setTitle:myProfileModel.recommendMan forState:UIControlStateNormal];
                 [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                 
             }
             
             // 昵称
             nickNameLab.text = myProfileModel.nickName;
             
             // 星级
             if ([[myProfileModel.star trim] isNotEqualsToString:emptyString]) {
                 myLvLab.text = [NSString stringWithFormat:@"%@星级",myProfileModel.star];
             }
             
             // ID号
             myIDLab.text = myProfileModel.idNum;
             
             // 真实姓名
             myRealNameLab.text = myProfileModel.name;
             
             // 性别
             mySexLab.text = myProfileModel.sex;
             
             // 所在地区
             [areaBtn setTitle:myProfileModel.province forState:UIControlStateNormal];
             
             // 故乡
             myHometownLab.text = myProfileModel.hometown;
             
             // 职业
             [occupationBtn setTitle:myProfileModel.job forState:UIControlStateNormal];
             
             // 生日
             myBirthDayLab.text = myProfileModel.birthday;
             
             // 星座
             myConstellationLab.text = myProfileModel.constellation;
             
             // 邮箱
             mailboxField.text = myProfileModel.email;
             
             // 个性签名
             signatureField.text = myProfileModel.signature;
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 修改个人资料
- (void)editMyProfile {
    
    if ([addBtn.titleLabel.text isEqualToString:myProfileModel.recommendMan] && [areaBtn.titleLabel.text isEqualToString:myProfileModel.province] && [occupationBtn.titleLabel.text isEqualToString:myProfileModel
        .job] && [mailboxField.text isEqualToString:myProfileModel.email] && [signatureField.text isEqualToString:myProfileModel.signature]) {
        return;
    }
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters;
    if ([recommendTextF.text isEqualToString:@""]) {
        parameters = @{
                       @"userId":userId,
                       @"hometown":areaBtn.titleLabel.text,
                       @"job":occupationBtn.titleLabel.text,
                       @"email":mailboxField.text,
                       @"signature":signatureField.text
                       } ;
    } else {
        parameters = @{
                       @"userId":userId,
                       @"recommendMan":recommendTextF.text,
                       @"hometown":areaBtn.titleLabel.text,
                       @"job":occupationBtn.titleLabel.text,
                       @"email":mailboxField.text,
                       @"signature":signatureField.text
                       } ;
    }
    
    [handler postURLStr:webMyProfileEdit postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
         
         if( error )
         {
             [wSelf.view makeToast:@"网络错误"];
             recommendTextF.text = @"";
             areaBtn.titleLabel.text = myProfileModel.province;
             occupationBtn.titleLabel.text = myProfileModel.job;
             mailboxField.text = myProfileModel.email;
             signatureField.text = myProfileModel.signature;
             return ;
         }
         if( retInfo == nil )
         {
             [wSelf.view makeToast:@"网络错误"];
             recommendTextF.text = @"";
             areaBtn.titleLabel.text = myProfileModel.province;
             occupationBtn.titleLabel.text = myProfileModel.job;
             mailboxField.text = myProfileModel.email;
             signatureField.text = myProfileModel.signature;
             return ;
         }
         
         BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
         
         if( state )
         {
             [self requestMyProfile];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
             recommendTextF.text = @"";
             areaBtn.titleLabel.text = myProfileModel.province;
             occupationBtn.titleLabel.text = myProfileModel.job;
             mailboxField.text = myProfileModel.email;
             signatureField.text = myProfileModel.signature;
         }
     }] ;
}

#pragma mark 下面全是修改头像的，不是我写的，先暂时不看，能用就好
- (void)editPortrait {
    if (edit) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
    } else {
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = headView; // 原图的父控件
        browser.imageCount = 1; // 图片总数
        browser.currentImageIndex = 0;
        browser.delegate = self;
        [browser show];
    }
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(NJImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    headImgView.image = editedImage;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f.png", a];
    
    // 压缩图片
    UIImage *scaleImage = [NZGlobal scaleFromImage:editedImage toSize:CGSizeMake(150.0f, 150.0f)];
    NSData *imageData = UIImageJPEGRepresentation(scaleImage, 1.0);
    
    FileDetail *file = [FileDetail fileWithName:timeString data:imageData];
    
    NSDictionary *params = @{
                             @"userId":user.userId,
                             @"headImg":file
                             } ;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *result = [NZWebHandler upload:[NSString stringWithFormat:@"http://10.0.0.177:8000/app/client/HeadImgEdit"] widthParams:params];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (nil == result) {
                [self.view makeToast:@"头像上传失败"];
                return;
            } else if ([result[@"isSuccess"] boolValue]) {
                [self.view makeToast:@"头像上传成功"];
                return;
            } else {
                [self.view makeToast:result[@"msg"]];
                return;
            }
            
        });
        
    });
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(NJImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return headImgView.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:myProfileModel.headImg];
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if ([actionSheet isEqual:choiceSheet]) {
//        if (buttonIndex == 0) {
//            
//            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//            browser.sourceImagesContainerView = headView; // 原图的父控件
//            browser.imageCount = 1; // 图片总数
//            browser.currentImageIndex = 0;
//            browser.delegate = self;
//            [browser show];
//            
//        } else if (buttonIndex == 1) {
//            [choiceSheet removeFromSuperview];
//            choiceSheet = nil;
//            
//            editStyleSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                         delegate:self
//                                                cancelButtonTitle:@"取消"
//                                           destructiveButtonTitle:nil
//                                                otherButtonTitles:@"拍照", @"从相册中选取", nil];
//            [editStyleSheet showInView:self.view];
//        }
//    } else {
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
//    }
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
