//
//  NZStrollController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZStrollController.h"
#import "NZCommodityListViewController.h"
#import "NZDownArrowView.h"
#import "NZRightArrowView.h"
#import "NZUpTriangleArrowView.h"
#import "AdView.h"
#import "MZTimerLabel.h"
#import "NZGrabViewCell.h"
#import "NZNewProductViewCell.h"
#import "NZCouponsViewCell.h"
#import "NZMajorSuitViewController.h"
#import "MaterialListModel.h"
#import "StyleListModel.h"
#import "PasspParametersModel.h"
#import "NZCommodityDetailController.h"

#define styleButtonTag 100
#define varietyButtonTag 1000
#define selectColor [UIColor colorWithRed:242/255.f green:151/255.f blue:0/255.f alpha:1.0]

@interface NZStrollController ()<UITableViewDataSource, UITableViewDelegate> {
    
    CGFloat leftFloat;
    CGFloat centerFloat;
    CGFloat rightFloat;
    
    BOOL expand;
    int selectIndex;
    NSIndexPath *selectIndexPath;
    
    // 款式和品种
    NSDictionary *styleDic;
    NSArray *styleArray;
    // 材质和品牌
    NSDictionary *materialDic;
    NSArray *materialArray;
    NSArray *brandArray;
    
    UIScrollView *styleScroll;
    UIScrollView *varietyScroll;
    
    BOOL selectedStyle;
    BOOL selectedVariety;
    int currentStyle; // 当前选中款式或材质位置
    int currentVariety; // 当前选中品种或品牌位置
    int styleID; // 当前选中款式或材质ID
    int varietyID; // 当前选中品种或品牌ID
    int cellID; // 材质、款式的cell

    // 优惠活动scrollview内容视图
    UIButton *classBtn;
    UIImageView *grabImgV;
    UILabel *grabLab;
    UIImageView *nProductImgV;
    UILabel *nProductLab;
    UIImageView *couponsImgV;
    UILabel *couponsLab;
    UIImageView *majorImgV;
    UILabel *majorLab;
    
    // 材质列表数据
    MaterialListModel *materialListModel;
    // 款式列表数据
    StyleListModel *styleListModel;
    int requestCount; // 请求次数，只请求一次
}

@property (strong, nonatomic) IBOutlet NZDownArrowView *indicateArrow;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicateArrowLeftConstraint;
@property (nonatomic, assign) enumtMaterialOrStyleType indicateType;  // 材质或款式

@property (strong, nonatomic) IBOutlet UITableView *activityTableView;
@property (nonatomic, assign) enumtActivitiesType acType; // 活动类型


- (IBAction)materialAction:(UIButton *)sender;
- (IBAction)styleAction:(UIButton *)sender;
- (IBAction)activitiesAction:(UIButton *)sender;

@end

@implementation NZStrollController

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"逛着"];
    [self createLeftAndRightNavigationItemButton];
    
    leftFloat = (ScreenWidth - 2) / 6 - 5;
    centerFloat = ScreenWidth / 2 - 5;
    rightFloat = (ScreenWidth - 2) / 6 * 5 + 2 - 5;
    _indicateArrowLeftConstraint.constant = leftFloat;
    
    
    [self requestMaterialData];
    
    [self initMaterialAndStyleInterface];  // 初始化材质、款式tableview
    [self initActivitiesAllInterface];        // 初始化优惠活动界面
    _activityTableView.hidden = YES;
}

#pragma mark 初始化材质、款式tableview
- (void)initMaterialAndStyleInterface {
    expand = NO;
    selectIndex = -1;
    selectedStyle = NO;
    selectedVariety = NO;
    requestCount = 0;
    _indicateType = enumtMaterialOrStyleType_Material;  // // 首先展示材质选择界面
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIDefaultBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
}

#pragma mark 初始化优惠活动tableview
- (void)initActivitiesAllInterface {
    
    _timeIndex = 0;
    self.imagesURLInActivitiesArry = [NSMutableArray new];
    self.activitiesTimeDetailInfoArry = [NSMutableArray new];
    self.imagesOtherURLInActivitiesArry = [NSMutableArray new];
    self.activitiesNewDetailInfoArry = [NSMutableArray new];
    self.activitiesCouponsDetailInfoArry = [NSMutableArray new];
    self.activitiesMajorSuitDetailInfoArry = [NSMutableArray new];
    
    
    _acType = enumtActivitiesType_Grab; // 首先展示限时抢活动界面
    
    _activityTableView.dataSource = self;
    _activityTableView.delegate = self;
    _activityTableView.backgroundColor = UIDefaultBackgroundColor;
    _activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _activityTableView.showsVerticalScrollIndicator = NO;
    _activityTableView.bounces = NO;
    
    _tableHeaderView = [[UIView alloc] init];
//    /****************************   广告轮播   *******************************/
    _adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 225/375)  \
                               imageLinkURL:nil\
                        placeHoderImageName:@"默认图片" \
                       pageControlShowStyle:UIPageControlShowStyleNone];
    
    // 是否需要支持定时循环滚动，默认为YES
    _adView.isNeedCycleRoll = NO;
    
    _adView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
    };
    [_tableHeaderView addSubview:_adView];
    
    /*************************     四大活动按钮    ***********************/
    UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_adView.frame), ScreenWidth, 75)];
    CGFloat imgW = 42;
    CGFloat imgH = 36;
    // 限时抢
    UIView *grabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/4, 75)];
    grabImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/4 - imgW)/2, 10, imgW, imgH)];
    grabImgV.image = [UIImage imageNamed:@"限时抢-红"];
    [grabView addSubview:grabImgV];
    
    grabLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth/4, 15)];
    grabLab.text = @"限时抢";
    grabLab.textColor = darkRedColor;
    grabLab.font = [UIFont systemFontOfSize:12.f];
    grabLab.textAlignment = NSTextAlignmentCenter;
    [grabView addSubview:grabLab];
    [classView addSubview:grabView];
    
    classBtn = [[UIButton alloc] initWithFrame:grabView.frame];
    classBtn.tag = 101;
    [classBtn addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:classBtn];
    
    // 新品汇
    UIView *nProductView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/4, 0, ScreenWidth/4, 75)];
    nProductImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/4 - imgW)/2, 10, imgW, imgH)];
    nProductImgV.image = [UIImage imageNamed:@"新品汇-灰"];
    [nProductView addSubview:nProductImgV];
    
    nProductLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth/4, 15)];
    nProductLab.text = @"新品汇";
    nProductLab.textColor = [UIColor grayColor];
    nProductLab.font = [UIFont systemFontOfSize:12.f];
    nProductLab.textAlignment = NSTextAlignmentCenter;
    [nProductView addSubview:nProductLab];
    [classView addSubview:nProductView];
    
    classBtn = [[UIButton alloc] initWithFrame:nProductView.frame];
    classBtn.tag = 102;
    [classBtn addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:classBtn];
    
    // 优享券
    UIView *couponsView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/4, 75)];
    couponsImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/4 - imgW)/2, 10, imgW, imgH)];
    couponsImgV.image = [UIImage imageNamed:@"优惠券-灰"];
    [couponsView addSubview:couponsImgV];
    
    couponsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth/4, 15)];
    couponsLab.text = @"优享券";
    couponsLab.textColor = [UIColor grayColor];
    couponsLab.font = [UIFont systemFontOfSize:12.f];
    couponsLab.textAlignment = NSTextAlignmentCenter;
    [couponsView addSubview:couponsLab];
    [classView addSubview:couponsView];
    
    classBtn = [[UIButton alloc] initWithFrame:couponsView.frame];
    classBtn.tag = 103;
    [classBtn addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:classBtn];
    
    // 大牌档
    UIView *majorView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*3/4, 0, ScreenWidth/4, 75)];
    majorImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/4 - 42)/2, 10, 42, 36)];
    majorImgV.image = [UIImage imageNamed:@"大牌档-灰"];
    [majorView addSubview:majorImgV];
    
    majorLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth/4, 15)];
    majorLab.text = @"大牌档";
    majorLab.textColor = [UIColor grayColor];
    majorLab.font = [UIFont systemFontOfSize:12.f];
    majorLab.textAlignment = NSTextAlignmentCenter;
    [majorView addSubview:majorLab];
    [classView addSubview:majorView];
    
    classBtn = [[UIButton alloc] initWithFrame:majorView.frame];
    classBtn.tag = 104;
    [classBtn addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:classBtn];
    
    [_tableHeaderView addSubview:classView];
    
    _tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(classView.frame));
    _activityTableView.tableHeaderView = _tableHeaderView;
    
}
#pragma mark 初始化优惠活动tableview
- (void)initActivitiesInterface:(NSMutableArray *)arry {

    /****************************   广告轮播   *******************************/
    
    _adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 225/375)  \
                                      imageLinkURL:arry\
                               placeHoderImageName:@"默认图片" \
                              pageControlShowStyle:UIPageControlShowStyleNone];
    
    // 是否需要支持定时循环滚动，默认为YES
    _adView.isNeedCycleRoll = NO;
    _adView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
    };
    [_tableHeaderView addSubview:_adView];

    _activityTableView.tableHeaderView = _tableHeaderView;
}

#pragma mark 限时抢头部视图
- (UIView *)createGrabHeaderView {
    
    UIView *grabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    grabHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    timeView.backgroundColor = goldColor;
    [grabHeaderView addSubview:timeView];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    backImgView.image = [UIImage imageNamed:@"优惠活动-色块"];
    [timeView addSubview:backImgView];
    
    // 分割线
    UIView *divisionLine1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/5, 10, 1, 30)];
    divisionLine1.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:divisionLine1];
    
    UIView *divisionLine2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*2/5, 10, 1, 30)];
    divisionLine2.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:divisionLine2];
    
    UIView *divisionLine3 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*3/5, 10, 1, 30)];
    divisionLine3.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:divisionLine3];
    
    UIView *divisionLine4 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*4/5, 10, 1, 30)];
    divisionLine4.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:divisionLine4];
    
    
    //下面为网络请求获取时间段
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NSDictionary *parameters = @{
                                 
                                 @"page_no":[NSNumber numberWithInt:1]
                                 
                                 };
    [handler postURLStr:webGetLimitedList postDic:parameters
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
             self.activitiesTimeDetailTimeArry = [NSMutableArray new];
             NSArray *infoArry = [retInfo objectForKey:@"periodOfTime"];
             [self.activitiesTimeDetailTimeArry addObjectsFromArray:infoArry];
             
             
             // ---------5个时间结点----------------
             
             //index  来判断看哪个时间结点正在抢
             int myTimeIndex = 0;
             //----获取现在的时间-----
             NSDate * senddate=[NSDate date];
             NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
             
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
             NSString *dateString = [dateformatter stringFromDate:senddate];

             for (int i= 0 ;i<=3;i++ ) {
                 
                 NSString *timeStr = [self.activitiesTimeDetailTimeArry[i]objectForKey:@"timeValue"];
                 NSString *timeStr1 = [self.activitiesTimeDetailTimeArry[i+1]objectForKey:@"timeValue"];
                 
                 NSString *grabTime1 = [NSString stringWithFormat:@"%@ %@",dateString,timeStr];
                  NSString *grabTime2 = [NSString stringWithFormat:@"%@ %@",dateString,timeStr1];
                 [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 NSDate *grabTime11 = [dateformatter dateFromString:grabTime1];
                 NSDate *grabTime22 = [dateformatter dateFromString:grabTime2];
                 
                 BOOL result11 = [grabTime11 isEarlizerThanDate:senddate];
                 BOOL result22 = [grabTime22 isLaterThanDate:senddate];
                 if (result11 == YES && result22 == YES) {
                     myTimeIndex = i+1;
                 }
             }
             if (myTimeIndex == 0) {
                 myTimeIndex =5;
             }
             
             UIButton *time1Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/5, 50)];
             //time1Button.backgroundColor = darkRedColor;
             time1Button.tag = 201;
             [time1Button addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
             
             UILabel *time1Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
             time1Lab.text = [[self.activitiesTimeDetailTimeArry objectAtIndex:0]objectForKey:@"timeValue"];
             time1Lab.textColor = [UIColor whiteColor];
             time1Lab.font = [UIFont systemFontOfSize:16.f];
             time1Lab.textAlignment = NSTextAlignmentCenter;
             [time1Button addSubview:time1Lab];
             UILabel *time1Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
             time1Icon.text = @"正在抢";
             time1Icon.textColor = [UIColor whiteColor];
             time1Icon.font = [UIFont systemFontOfSize:16.f];
             time1Icon.textAlignment = NSTextAlignmentCenter;
             [time1Button addSubview:time1Icon];
             [timeView addSubview:time1Button];
             if (myTimeIndex == 1) {
                 time1Button.backgroundColor = darkRedColor;
             }
             if (self.activitiesTimeDetailInfoArry.count == 0) {
                 //time1Icon.text = @"已抢完";
             }else{
             
                 time1Icon.text = @"正在抢";
             }
             
             UIButton *time2Button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/5, 0, ScreenWidth/5, 50)];
            //time2Button.backgroundColor = [UIColor clearColor];
             time2Button.tag = 202;
             [time2Button addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
             
             UILabel *time2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
              time2Lab.text = [[self.activitiesTimeDetailTimeArry objectAtIndex:1]objectForKey:@"timeValue"];
             time2Lab.textColor = [UIColor whiteColor];
             time2Lab.font = [UIFont systemFontOfSize:16.f];
             time2Lab.textAlignment = NSTextAlignmentCenter;
             [time2Button addSubview:time2Lab];
             UILabel *time2Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
             time2Icon.text = @"正在抢";
             time2Icon.textColor = [UIColor whiteColor];
             time2Icon.font = [UIFont systemFontOfSize:16.f];
             time2Icon.textAlignment = NSTextAlignmentCenter;
             [time2Button addSubview:time2Icon];
             [timeView addSubview:time2Button];
             if (myTimeIndex == 2) {
                 time2Button.backgroundColor = darkRedColor;
             }
             if (self.activitiesTimeDetailInfoArry.count == 0) {
                 //time2Icon.text = @"已抢完";
             }else{
                 
                 time2Icon.text = @"正在抢";
             }

             
             UIButton *time3Button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*2/5, 0, ScreenWidth/5, 50)];
             time3Button.backgroundColor = [UIColor clearColor];
             time3Button.tag = 203;
             [time3Button addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
             
             UILabel *time3Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
             time3Lab.text = [[self.activitiesTimeDetailTimeArry objectAtIndex:2]objectForKey:@"timeValue"];
             time3Lab.textColor = [UIColor whiteColor];
             time3Lab.font = [UIFont systemFontOfSize:16.f];
             time3Lab.textAlignment = NSTextAlignmentCenter;
             [time3Button addSubview:time3Lab];
             UILabel *time3Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
             time3Icon.text = @"正在抢";
             time3Icon.textColor = [UIColor whiteColor];
             time3Icon.font = [UIFont systemFontOfSize:16.f];
             time3Icon.textAlignment = NSTextAlignmentCenter;
             [time3Button addSubview:time3Icon];
             [timeView addSubview:time3Button];
             if (myTimeIndex == 3) {
                 time3Button.backgroundColor = darkRedColor;
             }
             if (self.activitiesTimeDetailInfoArry.count == 0) {
                 //time3Icon.text = @"已抢完";
             }else{
                 
                 time3Icon.text = @"正在抢";
             }

             
             UIButton *time4Button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*3/5, 0, ScreenWidth/5, 50)];
             time4Button.backgroundColor = [UIColor clearColor];
             time4Button.tag = 204;
             [time4Button addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
             
             UILabel *time4Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
             time4Lab.text = [[self.activitiesTimeDetailTimeArry objectAtIndex:3]objectForKey:@"timeValue"];
             time4Lab.textColor = [UIColor whiteColor];
             time4Lab.font = [UIFont systemFontOfSize:16.f];
             time4Lab.textAlignment = NSTextAlignmentCenter;
             [time4Button addSubview:time4Lab];
             UILabel *time4Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
             time4Icon.text = @"正在抢";
             time4Icon.textColor = [UIColor whiteColor];
             time4Icon.font = [UIFont systemFontOfSize:16.f];
             time4Icon.textAlignment = NSTextAlignmentCenter;
             [time4Button addSubview:time4Icon];
             [timeView addSubview:time4Button];
             if (myTimeIndex == 4) {
                 time4Button.backgroundColor = darkRedColor;
             }
             if (self.activitiesTimeDetailInfoArry.count == 0) {
                 time4Icon.text = @"已抢完";
             }else{
                 
                 time4Icon.text = @"正在抢";
             }

             
             UIButton *time5Button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*4/5, 0, ScreenWidth/5, 50)];
             time5Button.backgroundColor = [UIColor clearColor];
             time5Button.tag = 205;
             [time5Button addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
             
             UILabel *time5Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
             time5Lab.text = [[self.activitiesTimeDetailTimeArry objectAtIndex:4]objectForKey:@"timeValue"];
             time5Lab.textColor = [UIColor whiteColor];
             time5Lab.font = [UIFont systemFontOfSize:16.f];
             time5Lab.textAlignment = NSTextAlignmentCenter;
             [time5Button addSubview:time5Lab];
             UILabel *time5Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
             time5Icon.text = @"正在抢";
             time5Icon.textColor = [UIColor whiteColor];
             time5Icon.font = [UIFont systemFontOfSize:16.f];
             time5Icon.textAlignment = NSTextAlignmentCenter;
             [time5Button addSubview:time5Icon];
             [timeView addSubview:time5Button];
             if (myTimeIndex == 5) {
                 time5Button.backgroundColor = darkRedColor;
             }
             if (self.activitiesTimeDetailInfoArry.count == 0) {
                 time5Icon.text = @"已抢完";
             }else{
                 
                 time5Icon.text = @"正在抢";
             }

             
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
    
    

    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth/2+12, 25)];
    tipLab.text = @"距离本场活动结束  ";
    tipLab.textColor = [UIColor blackColor];
    tipLab.font = [UIFont systemFontOfSize:12.f];
    tipLab.textAlignment = NSTextAlignmentRight;
    [grabHeaderView addSubview:tipLab];
    
    UILabel *tipTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+18, 50, ScreenWidth/2-18, 25)];
    tipTimeLab.text = @"00:00:00";
    tipTimeLab.textColor = [UIColor blackColor];
    tipTimeLab.font = [UIFont systemFontOfSize:12.f];
    tipTimeLab.textAlignment = NSTextAlignmentLeft;
    /*******************************************
     *      计时器
     ********************************************/
    MZTimerLabel *countDownTimer = [[MZTimerLabel alloc] initWithLabel:tipTimeLab andTimerType:MZTimerLabelTypeTimer];
    [countDownTimer setCountDownTime:01*3600 + 20*60 + 15]; //** Or you can use [timer3 setCountDownToDate:aDate];
    [countDownTimer start];
    [grabHeaderView addSubview:tipTimeLab];

    return grabHeaderView;
}

#pragma mark 新品汇头部视图
- (UIView *)createNewProductHeaderView {
    UIView *nProductView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*228/375)];
    nProductView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*200/375)];
    backView.image = [UIImage imageNamed:@"活动图4"];
    [nProductView addSubview:backView];
    
    UIImageView *weekView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-(ScreenWidth*75/375), 0, ScreenWidth*50/375, ScreenWidth*50/375)];
    weekView.image = [UIImage imageNamed:@"每周首发"];
    [nProductView addSubview:weekView];
    
    UIImageView *shelvesView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-175)/2, backView.frame.size.height - ScreenWidth*27.5/375, ScreenWidth*175/375, ScreenWidth*55/375)];
    shelvesView.image = [UIImage imageNamed:@"新品上架"];
    [nProductView addSubview:shelvesView];
    
    return nProductView;
}

#pragma mark 优享券头部视图
- (UIView *)createCouponsHeaderView {
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*136/375)];
    backImgView.image = [UIImage imageNamed:@"活动图5"];
    
    
    return backImgView;
}

#pragma mark 大牌档头部视图
- (UIView *)createMajorSuitHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*175/375)];
    adImageView.image = [UIImage imageNamed:@"活动图6"];
    [headerView addSubview:adImageView];
    
    UIImageView *brandImageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adImageView.frame)+5, (ScreenWidth-5)/2, ScreenWidth*125/375)];
    //图片地址
    NSString *imgStr1 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:0] objectForKey:@"bgImg"]];
    NSURL *imgURL1 = [NSURL URLWithString:imgStr1];
    [brandImageV1 sd_setImageWithURL:imgURL1 placeholderImage:defaultImage];

    UIImageView *logoImageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(brandImageV1.frame)-45,ScreenWidth*125/375/2-30 , 90, 60)];
    //图片地址
    NSString *imgStr11 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:0] objectForKey:@"logo"]];
    NSURL *imgURL11 = [NSURL URLWithString:imgStr11];
    [logoImageV1 sd_setImageWithURL:imgURL11 placeholderImage:defaultImage];

    [brandImageV1 addSubview:logoImageV1];
    [headerView addSubview:brandImageV1];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:brandImageV1.frame];
    btn1.tag = 1001;
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn1];
    
    
    UIImageView *brandImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-5)/2 + 5, CGRectGetMaxY(adImageView.frame)+5, (ScreenWidth-5)/2, ScreenWidth*125/375)];
    //图片地址
    NSString *imgStr2 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:1] objectForKey:@"bgImg"]];
    NSURL *imgURL2 = [NSURL URLWithString:imgStr2];
    [brandImageV2 sd_setImageWithURL:imgURL2 placeholderImage:defaultImage];
    UIImageView *logoImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(brandImageV1.frame)-45,ScreenWidth*125/375/2-30 , 90, 60)];
    
    //图片地址
    NSString *imgStr22 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:1] objectForKey:@"logo"]];
    NSURL *imgURL22 = [NSURL URLWithString:imgStr22];
    [logoImageV2 sd_setImageWithURL:imgURL22 placeholderImage:defaultImage];

    [brandImageV2 addSubview:logoImageV2];
    [headerView addSubview:brandImageV2];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:brandImageV2.frame];
    btn2.tag = 1002;
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn2];
    
    UIImageView *brandImageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(brandImageV1.frame)+5, (ScreenWidth-5)/2, ScreenWidth*125/375)];
    //图片地址
    NSString *imgStr3 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:2] objectForKey:@"bgImg"]];
    NSURL *imgURL3 = [NSURL URLWithString:imgStr3];
    [brandImageV3 sd_setImageWithURL:imgURL3 placeholderImage:defaultImage];
    UIImageView *logoImageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(brandImageV3.frame)-45,ScreenWidth*125/375/2-30 , 90, 60)];
    //图片地址
    NSString *imgStr33 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:2] objectForKey:@"logo"]];
    NSURL *imgURL33 = [NSURL URLWithString:imgStr33];
    [logoImageV3 sd_setImageWithURL:imgURL33 placeholderImage:defaultImage];

    [brandImageV3 addSubview:logoImageV3];
    [headerView addSubview:brandImageV3];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:brandImageV3.frame];
    btn3.tag = 1003;
    btn3.backgroundColor = [UIColor clearColor];
    [btn3 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn3];
    
    UIImageView *brandImageV4 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-5)/2 + 5, CGRectGetMaxY(brandImageV1.frame)+5, (ScreenWidth-5)/2, ScreenWidth*125/375)];
    //图片地址
    NSString *imgStr4 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:3] objectForKey:@"bgImg"]];
    NSURL *imgURL4 = [NSURL URLWithString:imgStr4];
    [brandImageV4 sd_setImageWithURL:imgURL4 placeholderImage:defaultImage];
    UIImageView *logoImageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(brandImageV1.frame)-45,ScreenWidth*125/375/2-30 , 90, 60)];
    //图片地址
    NSString *imgStr44 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:3] objectForKey:@"logo"]];
    NSURL *imgURL44 = [NSURL URLWithString:imgStr44];
    [logoImageV4 sd_setImageWithURL:imgURL44 placeholderImage:defaultImage];

    [brandImageV4 addSubview:logoImageV4];
    [headerView addSubview:brandImageV4];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:brandImageV4.frame];
    btn4.tag = 1004;
    btn4.backgroundColor = [UIColor clearColor];
    [btn4 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn4];
    
    UIImageView *brandImageV5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(brandImageV3.frame)+5, ScreenWidth, ScreenWidth*125/375)];
    //图片地址
    NSString *imgStr5 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:4] objectForKey:@"bgImg"]];
    NSURL *imgURL5 = [NSURL URLWithString:imgStr5];
    [brandImageV5 sd_setImageWithURL:imgURL5 placeholderImage:defaultImage];
    UIImageView *logoImageV5 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(brandImageV5.frame)-45,ScreenWidth*125/375/2-30 , 90, 60)];
    //图片地址
    NSString *imgStr55 =[NZGlobal GetImgBaseURL:[[self.activitiesMajorSuitDetailInfoArry objectAtIndex:4] objectForKey:@"logo"]];
    NSURL *imgURL55 = [NSURL URLWithString:imgStr55];
    [logoImageV5 sd_setImageWithURL:imgURL55 placeholderImage:defaultImage];

    [brandImageV5 addSubview:logoImageV5];
    [headerView addSubview:brandImageV5];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:brandImageV5.frame];
    btn5.tag = 1005;
    btn5.backgroundColor = [UIColor clearColor];
    [btn5 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn5];
    
    return headerView;
}


#pragma mark UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (_acType) {
        case enumtActivitiesType_Grab: // 限时抢
            return [self createGrabHeaderView];
        case enumtActivitiesType_newProduct: // 新品汇
            return [self createNewProductHeaderView];
        case enumtActivitiesType_Coupons: // 优享券
            return [self createCouponsHeaderView];
        case enumtActivitiesType_MajorSuit: // 大牌档
            return [self createMajorSuitHeaderView];
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        NSArray *array;
        if (_indicateType == enumtMaterialOrStyleType_Material) {
            array = styleDic[@"icon"];
        } else {
            array = materialDic[@"icon"];
        }
        return array.count;
    } else { // 优惠活动
        switch (_acType) {
            case enumtActivitiesType_Grab: // 限时抢
                return self.activitiesTimeDetailInfoArry.count;
                
            case enumtActivitiesType_newProduct: // 新品汇
                //return self.activitiesNewDetailInfoArry.count;
                //因为是每行限时俩个-----计算行数要除以  2
                if (self.activitiesNewDetailInfoArry.count % 2 == 1) {
                    
                    return self.activitiesNewDetailInfoArry.count/2+1;
                }else {
                    
                    return self.activitiesNewDetailInfoArry.count/2;
                }
            case enumtActivitiesType_Coupons: // 优享券
                
                return self.activitiesCouponsDetailInfoArry.count;
            case enumtActivitiesType_MajorSuit: // 大牌档
                return 0;
                
            default:
                return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        if ((int)indexPath.row == selectIndex) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMaterialOrStyleExpandCellIdentify];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZMaterialOrStyleExpandCellIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            /**************          主展示view             ******************/
            UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*111/375)];
            
            UIImageView *backView = [[UIImageView alloc] initWithFrame:mainView.frame];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                [backView sd_setImageWithURL:[NSURL URLWithString:[styleDic objectForKey:@"backImg"][indexPath.row]] placeholderImage:defaultImage];
            } else {
                [backView sd_setImageWithURL:[NSURL URLWithString:[materialDic objectForKey:@"backImg"][indexPath.row]] placeholderImage:defaultImage];
            }
            
            [mainView addSubview:backView];
            
            UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*67.5/375, mainView.frame.size.height)];
            maskView.backgroundColor = [UIColor blackColor];
            maskView.alpha = 0.4f;
            [mainView addSubview:maskView];
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*13.75/375, ScreenWidth*50/375, ScreenWidth*40/375, ScreenWidth*40/375)];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                [iconView sd_setImageWithURL:[NSURL URLWithString:[styleDic objectForKey:@"icon"][indexPath.row]] placeholderImage:defaultImage];
            } else {
                [iconView sd_setImageWithURL:[NSURL URLWithString:[materialDic objectForKey:@"icon"][indexPath.row]] placeholderImage:defaultImage];
            }
            
            [mainView addSubview:iconView];
            
            [cell.contentView addSubview:mainView];
            /**************          主展示view 里面的内容            ******************/
            UILabel *chineseNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskView.frame) + 10, (ScreenWidth*110/375 - 20)/2, ScreenWidth - maskView.frame.size.width - 10, 20)];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                chineseNameLab.text = [styleDic objectForKey:@"chineseName"][indexPath.row];
            } else {
                chineseNameLab.text = [materialDic objectForKey:@"chineseName"][indexPath.row];
            }
            
            chineseNameLab.textColor = [UIColor whiteColor];
            chineseNameLab.font = [UIFont boldSystemFontOfSize:19];
            chineseNameLab.backgroundColor = [UIColor clearColor];
            [mainView addSubview:chineseNameLab];
            
            UILabel *englishNameLab = [[UILabel alloc] initWithFrame:CGRectMake(chineseNameLab.frame.origin.x, CGRectGetMaxY(chineseNameLab.frame)+5, chineseNameLab.frame.size.width, 20)];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                englishNameLab.text = [styleDic objectForKey:@"englishName"][indexPath.row];
            } else {
                englishNameLab.text = [materialDic objectForKey:@"englishName"][indexPath.row];
            }
            
            englishNameLab.textColor = [UIColor whiteColor];
            englishNameLab.font = [UIFont systemFontOfSize:19];
            englishNameLab.backgroundColor = [UIColor clearColor];
            [mainView addSubview:englishNameLab];
            
            /**************          扩展view (款式)            ******************/
            UIImageView *bottomBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, mainView.frame.size.height, ScreenWidth, ScreenWidth*110.5/375)];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                [bottomBackImg sd_setImageWithURL:[NSURL URLWithString:[styleDic objectForKey:@"backImg"][indexPath.row]] placeholderImage:defaultImage];
            } else {
                [bottomBackImg sd_setImageWithURL:[NSURL URLWithString:[materialDic objectForKey:@"backImg"][indexPath.row]] placeholderImage:defaultImage];
            }
            
            [self flipViewTransformPIWith:bottomBackImg];
            [cell.contentView addSubview:bottomBackImg];
            
            // 系统自带的毛玻璃效果
            UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            visualEfView.frame = CGRectMake(0, 0, bottomBackImg.frame.size.width, bottomBackImg.frame.size.height);
            visualEfView.alpha = 1.0;
            [bottomBackImg addSubview:visualEfView];
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, mainView.frame.size.height, ScreenWidth, ScreenWidth*55/375)];
            view1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:view1];
            
            UILabel *styleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*70/375, ScreenWidth*55/375)];
            styleLab.backgroundColor = [UIColor clearColor];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                styleLab.text = @"款式";
            } else {
                styleLab.text = @"材质";
            }
            
            styleLab.textColor = [UIColor whiteColor];
            styleLab.textAlignment = NSTextAlignmentCenter;
            styleLab.font = [UIFont systemFontOfSize:17];
            [view1 addSubview:styleLab];
            
            NZRightArrowView *rightArrow1 = [[NZRightArrowView alloc] initWithFrame:CGRectMake(ScreenWidth*60/375, (styleLab.frame.size.height-ScreenWidth*10/375)/2, ScreenWidth*5/375, ScreenWidth*10/375)];
            [styleLab addSubview:rightArrow1];
            // 遮罩按钮，防止cell点击事件发生
            UIButton *maskBtn1 = [[UIButton alloc] initWithFrame:styleLab.frame];
            maskBtn1.backgroundColor = [UIColor clearColor];
            [view1 addSubview:maskBtn1];
            
            // 款式选择scrollview
            styleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(styleLab.frame.size.width, 0, ScreenWidth - styleLab.frame.size.width, styleLab.frame.size.height)];
            styleScroll.backgroundColor = [UIColor clearColor];
            styleScroll.showsHorizontalScrollIndicator = NO;
            styleScroll.bounces = NO;
            int i = 0;
            CGFloat startX = 0.f;
            
            NSArray *array1;
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                array1 = styleArray;
            } else {
                array1 = materialArray;
            }
            for (i = 0; i < (int)array1.count; i++) {
                NSString *styleName = array1[i][@"name"];
                
                UIFont *labelFont = [UIFont systemFontOfSize:17.f];
                CGSize limitSize = CGSizeMake(MAXFLOAT, styleLab.frame.size.height);
                
                NSDictionary *attribute = @{NSFontAttributeName:labelFont};
                // 根据获取到的字符串以及字体计算label需要的size
                CGSize labSize = [styleName boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(startX, 0, labSize.width+30, limitSize.height)];
                button.tag = styleButtonTag + i;
                [button setTitle:styleName forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = labelFont;
                button.backgroundColor = [UIColor clearColor];
                [button addTarget:self action:@selector(selectStyle:) forControlEvents:UIControlEventTouchUpInside];
                objc_setAssociatedObject(button, "id", array1[i][@"id"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [styleScroll addSubview:button];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width-1, (limitSize.height-ScreenWidth*15/375)/2, 1, ScreenWidth*15/375)];
                line.backgroundColor = [UIColor whiteColor];
                [button addSubview:line];
                
                startX += labSize.width + 30.f;
            }
            
            styleScroll.contentSize = CGSizeMake(startX-1, ScreenWidth*55/375);
            [view1 addSubview:styleScroll];
            
            /**************          分割线            ******************/
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*165/375, ScreenWidth, 0.5)];
            line.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
            [cell.contentView addSubview:line];
            
            /**************          扩展view (品种)            ******************/
            UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), ScreenWidth, ScreenWidth*55/375)];
            view2.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:view2];
            
            UILabel *varietyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*70/375, ScreenWidth*55/375)];
            varietyLab.backgroundColor = [UIColor clearColor];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                varietyLab.text = @"品种";
            } else {
                varietyLab.text = @"品牌";
            }
            
            varietyLab.textColor = [UIColor whiteColor];
            varietyLab.textAlignment = NSTextAlignmentCenter;
            varietyLab.font = [UIFont systemFontOfSize:17];
            [view2 addSubview:varietyLab];
            
            NZRightArrowView *rightArrow2 = [[NZRightArrowView alloc] initWithFrame:CGRectMake(ScreenWidth*60/375, (varietyLab.frame.size.height-ScreenWidth*10/375)/2, ScreenWidth*5/375, ScreenWidth*10/375)];
            [varietyLab addSubview:rightArrow2];
            // 遮罩按钮，防止cell点击事件发生
            UIButton *maskBtn2 = [[UIButton alloc] initWithFrame:varietyLab.frame];
            maskBtn2.backgroundColor = [UIColor clearColor];
            [view2 addSubview:maskBtn2];
            
            // 品种选择scrollview
            varietyScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(varietyLab.frame.size.width, 0, ScreenWidth - varietyLab.frame.size.width, varietyLab.frame.size.height)];
            varietyScroll.backgroundColor = [UIColor clearColor];
            varietyScroll.showsHorizontalScrollIndicator = NO;
            varietyScroll.bounces = NO;
            startX = 0.f;
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                MaterialModel *materialModel = materialListModel.list[indexPath.row];
                for (i = 0; i < (int)materialModel.variety.count; i++) {
                    VarietyModel *varietyModel = materialModel.variety[i];
                    NSString *styleName = varietyModel.name;
                    
                    UIFont *labelFont = [UIFont systemFontOfSize:17.f];
                    CGSize limitSize = CGSizeMake(MAXFLOAT, styleLab.frame.size.height);
                    
                    NSDictionary *attribute = @{NSFontAttributeName:labelFont};
                    // 根据获取到的字符串以及字体计算label需要的size
                    CGSize labSize = [styleName boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                    
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(startX, 0, labSize.width+30, limitSize.height)];
                    button.tag = varietyButtonTag + i;
                    [button setTitle:styleName forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.titleLabel.font = labelFont;
                    button.backgroundColor = [UIColor clearColor];
                    [button addTarget:self action:@selector(selectVariety:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(button, "id", [NSNumber numberWithInt:varietyModel.varietyID], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [varietyScroll addSubview:button];
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width-1, (limitSize.height-ScreenWidth*15/375)/2, 1, ScreenWidth*15/375)];
                    line.backgroundColor = [UIColor whiteColor];
                    [button addSubview:line];
                    
                    startX += labSize.width + 30.f;
                }
                varietyScroll.contentSize = CGSizeMake(startX-1, ScreenWidth*55/375);
                [view2 addSubview:varietyScroll];
            } else {
                
                for (i = 0; i < (int)brandArray.count; i++) {
                    NSString *styleName = brandArray[i][@"name"];
                    
                    UIFont *labelFont = [UIFont systemFontOfSize:17.f];
                    CGSize limitSize = CGSizeMake(MAXFLOAT, styleLab.frame.size.height);
                    
                    NSDictionary *attribute = @{NSFontAttributeName:labelFont};
                    // 根据获取到的字符串以及字体计算label需要的size
                    CGSize labSize = [styleName boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                    
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(startX, 0, labSize.width+30, limitSize.height)];
                    button.tag = varietyButtonTag + i;
                    [button setTitle:styleName forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.titleLabel.font = labelFont;
                    button.backgroundColor = [UIColor clearColor];
                    [button addTarget:self action:@selector(selectVariety:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(button, "id", brandArray[i][@"shopId"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [varietyScroll addSubview:button];
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width-1, (limitSize.height-ScreenWidth*15/375)/2, 1, ScreenWidth*15/375)];
                    line.backgroundColor = [UIColor whiteColor];
                    [button addSubview:line];
                    
                    startX += labSize.width + 30.f;
                }
                varietyScroll.contentSize = CGSizeMake(startX-1, ScreenWidth*55/375);
                [view2 addSubview:varietyScroll];
            }
            
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMaterialOrStyleCellIdentify];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZMaterialOrStyleCellIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            /**************          主展示view             ******************/
            UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*111/375)];
            
            UIImageView *backView = [[UIImageView alloc] initWithFrame:mainView.frame];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                [backView sd_setImageWithURL:[NSURL URLWithString:[styleDic objectForKey:@"backImg"][indexPath.row]] placeholderImage:defaultImage];
            } else {
                [backView sd_setImageWithURL:[NSURL URLWithString:[materialDic objectForKey:@"backImg"][indexPath.row]] placeholderImage:defaultImage];
            }
            
            [mainView addSubview:backView];
            
            UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*67.5/375, mainView.frame.size.height)];
            maskView.backgroundColor = [UIColor blackColor];
            maskView.alpha = 0.4f;
            [mainView addSubview:maskView];
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*13.75/375, ScreenWidth*50/375, ScreenWidth*40/375, ScreenWidth*40/375)];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                [iconView sd_setImageWithURL:[NSURL URLWithString:[styleDic objectForKey:@"icon"][indexPath.row]] placeholderImage:defaultImage];
            } else {
                [iconView sd_setImageWithURL:[NSURL URLWithString:[materialDic objectForKey:@"icon"][indexPath.row]] placeholderImage:defaultImage];
            }
            
            [mainView addSubview:iconView];
            
            [cell.contentView addSubview:mainView];
            /**************          主展示view 里面的内容            ******************/
            UILabel *chineseNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskView.frame) + 10, (ScreenWidth*110/375 - 20)/2, ScreenWidth - maskView.frame.size.width - 10, 20)];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                chineseNameLab.text = [styleDic objectForKey:@"chineseName"][indexPath.row];
            } else {
                chineseNameLab.text = [materialDic objectForKey:@"chineseName"][indexPath.row];
            }
            
            chineseNameLab.textColor = [UIColor whiteColor];
            chineseNameLab.font = [UIFont boldSystemFontOfSize:19];
            chineseNameLab.backgroundColor = [UIColor clearColor];
            [mainView addSubview:chineseNameLab];
            
            UILabel *englishNameLab = [[UILabel alloc] initWithFrame:CGRectMake(chineseNameLab.frame.origin.x, CGRectGetMaxY(chineseNameLab.frame)+5, chineseNameLab.frame.size.width, 20)];
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                englishNameLab.text = [styleDic objectForKey:@"englishName"][indexPath.row];
            } else {
                englishNameLab.text = [materialDic objectForKey:@"englishName"][indexPath.row];
            }
            
            englishNameLab.textColor = [UIColor whiteColor];
            englishNameLab.font = [UIFont systemFontOfSize:19];
            englishNameLab.backgroundColor = [UIColor clearColor];
            [mainView addSubview:englishNameLab];
            
            return cell;
        }
    #pragma mark 优惠活动  ----cell赋值
    } else { // 优惠活动
        
        if (_acType == enumtActivitiesType_Grab) {
            NZGrabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZGrabActivityCellIdentify];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NZGrabViewCell" owner:self options:nil] lastObject] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // 给马上抢添加点击方法 ---------------
            NSNumber *num = [[self.activitiesTimeDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"goodsId"];
            cell.quicklyButton.tag = 900+[num integerValue];
            [cell.quicklyButton addTarget:self action:@selector(quicklyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //图片地址
            NSString *smallImg =[NZGlobal GetImgBaseURL:[[self.activitiesTimeDetailInfoArry objectAtIndex:indexPath.row] objectForKey:@"listImg"]];
            NSURL *imgURL = [NSURL URLWithString:smallImg];
            [cell.productImageV sd_setImageWithURL:imgURL placeholderImage:defaultImage];
            cell.grabTittleLab.text = [NSString stringWithFormat:@"【限时抢】%@",[[self.activitiesTimeDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"title"]];
            cell.marketPriceLab.text = [NSString stringWithFormat:@"原价￥%@",[[self.activitiesTimeDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"marketPrice"]];
            cell.nowPriceLab.text = [NSString stringWithFormat:@"￥%@",[[self.activitiesTimeDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"priceNow"]];
            cell.leftNumLab.text = [NSString stringWithFormat:@"还剩%@件",[[self.activitiesTimeDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"count"]];
            
            return cell;
        } else if (_acType == enumtActivitiesType_newProduct) {
            NZNewProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZNewProductActivityCellIdentify];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NZNewProductViewCell" owner:self options:nil] lastObject] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
#warning 无效代码
//            cell.leftIcon.image = [UIImage imageNamed:@"新品CLUB"];
//            cell.rightIcon.image = [UIImage imageNamed:@"新品CLUB"];
            
            //对新品汇cell进行赋值
            
            //---------左边--------
            cell.leftButton.tag = [[[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2]objectForKey:@"goodsId"] integerValue];
            [cell.leftButton addTarget:self action:@selector(goToBuyAction:) forControlEvents:UIControlEventTouchUpInside];
            //图片地址
            NSString *smallImg =[NZGlobal GetImgBaseURL:[[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2] objectForKey:@"smallNewsImg"]];
            
            NSURL *imgURL = [NSURL URLWithString:smallImg];
            [cell.leftImageView sd_setImageWithURL:imgURL placeholderImage:defaultImage];
            cell.leftNameLabel.text = [[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2]objectForKey:@"name"];
            NSLog(@"$$$$$$$$$------%@",[[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2]objectForKey:@"name"]);
            cell.leftPriceLabel.text = [NSString stringWithFormat:@"首发价￥%@",[[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2]objectForKey:@"marketPrice"]];
            //---------右边-----------
            //右边的一个没有值
            if (indexPath.row*2+1+1 > self.activitiesNewDetailInfoArry.count) {
                cell.rightView.hidden = YES;
            }else{
                cell.rightButton.tag = [[[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2+1]objectForKey:@"goodsId"] integerValue];
                [cell.rightButton addTarget:self action:@selector(goToBuyAction:) forControlEvents:UIControlEventTouchUpInside];
                //图片地址
                NSString *smallImg1 =[NZGlobal GetImgBaseURL:[[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2+1] objectForKey:@"smallNewsImg"]];
                NSURL *imgURL1 = [NSURL URLWithString:smallImg1];
                [cell.rightImageView sd_setImageWithURL:imgURL1 placeholderImage:defaultImage];
                cell.rightNameLabel.text = [[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2+1]objectForKey:@"name"];
                cell.rightPriceLabel.text = [NSString stringWithFormat:@"首发价￥%@",[[self.activitiesNewDetailInfoArry objectAtIndex:indexPath.row*2+1]objectForKey:@"marketPrice"]];
            }
            
            
            cell.newOrBuy = enumtNewClubOrBuyNow_NewClub;
            
            return cell;
        } else if (_acType == enumtActivitiesType_Coupons) {
            NZCouponsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZCouponsActivityCellIdentify];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NZCouponsViewCell" owner:self options:nil] lastObject] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            //看是否已经领取----当type=0时，state=0表示未领取，state=1表示已领取
            //-----当type=1时，state=0表示未兑换，state=1表示已兑换
            int state = [[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"state"]intValue];
            //看时领取还是兑换---类型（0:代金券,1:兑换）
            int type = [[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"type"]intValue];
            
            if (type == 0) {
                
                cell.remainLabel.text = [NSString stringWithFormat:@"仅剩%@",[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"counts"]];

                if (state == 0) {
                    
                    cell.haveLable.text = @"立即领取";
                    cell.haveButton.tag = [[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"cId"]integerValue];
                    [cell.haveButton addTarget:self action:@selector(requestActivitiesWithHaveCoupons:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else if(state == 1){
                    
                    cell.haveLable.text = @"已领取";
                    
                }else if (state == 3){
                    
                    cell.haveLable.text = @"立即领取";
                    cell.haveButton.tag = [[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"cId"]integerValue];
                    [cell.haveButton addTarget:self action:@selector(requestActivitiesWithHaveCoupons:) forControlEvents:UIControlEventTouchUpInside];

                }
                

            //兑换类型
            }else if (type == 1){
                cell.remainLabel.text = [NSString stringWithFormat:@"积分%@/仅剩%@",[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"score"],[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"counts"]];

                if (state == 0) {
                    
                    cell.haveLable.text = @"立即兑换";
                    cell.haveButton.tag = [[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"cId"]integerValue];
                    [cell.haveButton addTarget:self action:@selector(requestActivitiesWithHaveCoupons:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else if(state == 1){
                    
                    cell.haveLable.text = @"已兑换";
                    
                }else if (state == 3){
                    
                    cell.haveLable.text = @"立即兑换";
                    cell.haveButton.tag = [[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"cId"]integerValue];
                    [cell.haveButton addTarget:self action:@selector(requestActivitiesWithHaveCoupons:) forControlEvents:UIControlEventTouchUpInside];

                }

                
            }
                
            cell.backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"couponBack%d",(int)((int)indexPath.row)%4]];
            //图片地址
            NSString *smallImg2 =[NZGlobal GetImgBaseURL:[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row] objectForKey:@"img"]];
            NSURL *imgURL2 = [NSURL URLWithString:smallImg2];
            [cell.couponImgView sd_setImageWithURL:imgURL2 placeholderImage:defaultImage];
            cell.couponTittleLable.text = [[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"name"];
            cell.couponLabel.text = [NSString stringWithFormat:@"现金卷￥%@",[[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"money"]];
            
            return cell;
        } else {
            
            
            return nil;
        }
    }
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_activityTableView]) {
        switch (_acType) {
            case enumtActivitiesType_Grab: // 限时抢
                return 75.f;
            case enumtActivitiesType_newProduct: // 新品汇
                return ScreenWidth*228/375;
            case enumtActivitiesType_Coupons: // 优享券
                return ScreenWidth*136/375;
            case enumtActivitiesType_MajorSuit: // 大牌档
                return ScreenWidth*580/375;
            default:
                return 0.f;
        }
    } else {
        return 0.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView]) {
        if ((int)indexPath.row == selectIndex) {
            return ScreenWidth*220.5/375.f;
        } else {
            return ScreenWidth*110/375.f;
        }
    } else { // 优惠活动
        switch (_acType) {
            case enumtActivitiesType_Grab: // 限时抢
                return ScreenWidth * 200/375;
                
            case enumtActivitiesType_newProduct: // 新品汇
                return ScreenWidth * 237.5/375;
                
            case enumtActivitiesType_Coupons: // 优享券
                return ScreenWidth * 185/375;
                
            case enumtActivitiesType_MajorSuit: // 大牌档
                return 0;
                
            default:
                return 0;
                
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_tableView]) {
        selectedStyle = NO;
        selectedVariety = NO;
        currentStyle = -1;
        currentVariety = -1;

        if (expand) {
/***** 销毁按钮  *****/
//            int i;
//            for (i = 0; i < styleArray.count; i++) {
//                UIButton *btn = (UIButton *)[_tableView viewWithTag:(i + varietyButtonTag)];
//                btn = nil;
//            }
            
            if (selectIndex == (int)indexPath.row) {
                selectIndex = -1;
                selectIndexPath = nil;
                expand = NO;
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                return;
            } else {
                selectIndex = (int)indexPath.row;
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                selectIndexPath = indexPath;
                if (_indicateType == enumtMaterialOrStyleType_Material) {
                    cellID = [[styleDic objectForKey:@"id"][indexPath.row] intValue];
                } else {
                    cellID = [[materialDic objectForKey:@"id"][indexPath.row] intValue];
                }
                return;
            }
        } else {
            selectIndex = (int)indexPath.row;
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            selectIndexPath = indexPath;
            if (_indicateType == enumtMaterialOrStyleType_Material) {
                cellID = [[styleDic objectForKey:@"id"][indexPath.row] intValue];
            } else {
                cellID = [[materialDic objectForKey:@"id"][indexPath.row] intValue];
            }
            expand = YES;
        }
    } else { // 优惠活动
//        
//        if (_acType == enumtActivitiesType_Coupons) {
//            
//            NSNumber *cardId = [[self.activitiesCouponsDetailInfoArry objectAtIndex:indexPath.row]objectForKey:@"cId"];
//            [self requestActivitiesWithHaveCoupons:cardId];
//        }
//        if (_acType == enumtActivitiesType_newProduct) {
//            
//            NSLog(@"&&&&&&&&&&--------5555");
//        }

        
    }
    
}

#pragma mark 请求材质数据
- (void)requestMaterialData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NSDictionary *parameters = @{
                                 
                                 @"userId":[NSNumber numberWithInt:6]
                                 
                                 };
    NSString *webGoodParameters = @"Goods/BuyNow";
    [handler postURLStr:webStrollFirstPage postDic:nil
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
             materialListModel = [MaterialListModel objectWithKeyValues:retInfo];
             
             // 转款式id
             
             NSMutableArray *cnAry = [NSMutableArray array];
             NSMutableArray *enAry = [NSMutableArray array];
             NSMutableArray *iconAry = [NSMutableArray array];
             NSMutableArray *backAry = [NSMutableArray array];
             NSMutableArray *idAry = [NSMutableArray array];
             
             for (int i=0; i<materialListModel.list.count; i++) {
                 MaterialModel *materialModel = materialListModel.list[i];
                 materialModel.materialID = [retInfo[@"list"][i][@"id"] intValue];
                 [cnAry addObject:materialModel.name];
                 [enAry addObject:materialModel.englishName];
                 [iconAry addObject:[NZGlobal GetImgBaseURL:materialModel.icon]];
                 [backAry addObject:[NZGlobal GetImgBaseURL:materialModel.img]];
                 [idAry addObject:[NSNumber numberWithInt:materialModel.materialID]];
                 for (int j=0; j<materialModel.variety.count; j++) {
                     VarietyModel *varietModel = materialModel.variety[j];
                     varietModel.varietyID = [retInfo[@"list"][i][@"variety"][j][@"id"] intValue];
                 }
             }
             
             styleDic = [NSDictionary dictionaryWithObjectsAndKeys:cnAry,@"chineseName",enAry,@"englishName",iconAry,@"icon",backAry,@"backImg",idAry,@"id", nil];
             
             styleArray = retInfo[@"styleList"];
             
             [_tableView reloadData];
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 请求款式数据
- (void)requestStyleData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    [handler postURLStr:webGetStyleList postDic:nil
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
             styleListModel = [StyleListModel objectWithKeyValues:retInfo];
             
             // 转款式id
             
             NSMutableArray *cnAry = [NSMutableArray array];
             NSMutableArray *enAry = [NSMutableArray array];
             NSMutableArray *iconAry = [NSMutableArray array];
             NSMutableArray *backAry = [NSMutableArray array];
             NSMutableArray *idAry = [NSMutableArray array];
             
             for (int i=0; i<styleListModel.styleList.count; i++) {
                 StyleModel *styleModel = styleListModel.styleList[i];
                 styleModel.styleID = [retInfo[@"styleList"][i][@"id"] intValue];
                 [cnAry addObject:styleModel.name];
                 [enAry addObject:styleModel.englishName];
                 [iconAry addObject:[NZGlobal GetImgBaseURL:styleModel.icon]];
                 [backAry addObject:[NZGlobal GetImgBaseURL:styleModel.img]];
                 [idAry addObject:[NSNumber numberWithInt:styleModel.styleID]];
             }
             
             materialDic = [NSDictionary dictionaryWithObjectsAndKeys:cnAry,@"chineseName",enAry,@"englishName",iconAry,@"icon",backAry,@"backImg",idAry,@"id", nil];
             
             materialArray = retInfo[@"categoryList"];
             
             brandArray = retInfo[@"shopList"];
             
             [_tableView reloadData];
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 请求优惠活动---限时抢---时间阶段
- (void)requestActivitiesWithLimitTime{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NSDictionary *parameters = @{
                                 
                                 @"page_no":[NSNumber numberWithInt:1]
                                     
                                     };
    [handler postURLStr:webGetLimitedList postDic:parameters
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
             self.activitiesTimeDetailTimeArry = [NSMutableArray new];
             NSArray *infoArry = [retInfo objectForKey:@"periodOfTime"];
              [self.activitiesTimeDetailTimeArry addObjectsFromArray:infoArry];
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}


#pragma mark 请求优惠活动---限时抢---数据
- (void)requestActivitiesWithLimitTimeData{
    
    self.pageNo +=1;
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NSString *timeStr = [[self.activitiesTimeDetailTimeArry objectAtIndex:_timeIndex]objectForKey:@"timeValue"];
    
    NSDictionary *parameters = @{
                                 
                                 @"page_no":[NSNumber numberWithInt:self.pageNo],
                                 @"timeValue":timeStr
                                 
                                 };
    [handler postURLStr:webGetLimitedList postDic:parameters
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
             [_activityTableView.footer endRefreshing];
             NSArray *infoArry = [[retInfo objectForKey:@"result"]objectForKey:@"detailInfo"];
             //给图片轮播图片赋值
             for (NSDictionary *imgDict in [retInfo objectForKey:@"brandAdvert"]) {
                 
                 [self.imagesURLInActivitiesArry addObject:[NZGlobal GetImgBaseURL:[imgDict objectForKey:@"imgUrl"]]];
             }
             //信息初始化
             [self initActivitiesInterface:self.imagesURLInActivitiesArry];
             
             if (infoArry.count > 0) {
  
                 //把基本信息self.activitiesDetailInfoArry
                 [self.activitiesTimeDetailInfoArry addObjectsFromArray:infoArry];

             }else{
                 //结束上拉刷新
                 _activityTableView.footer.hidden = YES;
                 
             }
             
             [_activityTableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}
#pragma mark 请求优惠活动---新品汇---数据
- (void)requestActivitiesWithNewData{
    
    self.pageNo +=1;
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    NSDictionary *parameters = @{
                                 
                                 @"page_no":[NSNumber numberWithInt:self.pageNo]
                                 
                                 };
    [handler postURLStr:webGetNewList postDic:parameters
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
             //结束上拉刷新
             [_activityTableView.footer endRefreshing];
             NSArray *infoArry = [[retInfo objectForKey:@"result"]objectForKey:@"detailInfo"];
             if (infoArry.count > 0) {
                 
                 //给图片轮播图片赋值
                 for (NSDictionary *imgDict in [retInfo objectForKey:@"brandAdvert"]) {
                     
                     [self.imagesOtherURLInActivitiesArry addObject:[NZGlobal GetImgBaseURL:[imgDict objectForKey:@"imgUrl"]]];
                 }
                 [self.imagesOtherURLInActivitiesArry insertObject:@"http://10.0.0.177:8000///FileUploadImage/Coupons/_201509121538144531344.png" atIndex:0];
                 [self.imagesOtherURLInActivitiesArry addObject:@"http://10.0.0.177:8000///FileUploadImage/Coupons/_201509121538144531344.png"];
                 //刷新图片轮播
                 [self initActivitiesInterface:self.imagesOtherURLInActivitiesArry];
                 
                 //把基本信息self.activitiesDetailInfoArry
                 [self.activitiesNewDetailInfoArry addObjectsFromArray:infoArry];
                 
                 [_activityTableView reloadData];
                 
                 
             }else{
                 
                 _activityTableView.footer.hidden = YES;
             }
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}


#pragma mark 请求优惠活动---有享卷---数据
- (void)requestActivitiesWithCouponsData{
    
    self.pageNo +=1;
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    NSDictionary *parameters = @{
                                 
                                 @"page_no":[NSNumber numberWithInt:self.pageNo],
                                 @"userId" :[NSNumber numberWithInt:6]
                                 };
    [handler postURLStr:webGetCouponsList postDic:parameters
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
             //结束上拉刷新
             [_activityTableView.footer endRefreshing];
             NSArray *infoArry = [[retInfo objectForKey:@"result"]objectForKey:@"couponsList"];

             if (infoArry.count > 0) {
                 
                 //给图片轮播图片赋值
                 for (NSDictionary *imgDict in [retInfo objectForKey:@"brandAdvert"]) {
                     
                     [self.imagesOtherURLInActivitiesArry addObject:[NZGlobal GetImgBaseURL:[imgDict objectForKey:@"imgUrl"]]];
                 }
                 [self.imagesOtherURLInActivitiesArry insertObject:@"http://10.0.0.177:8000///FileUploadImage/Coupons/_201509121538144531344.png" atIndex:1];
                 
                 //刷新图片轮播
                 [self initActivitiesInterface:self.imagesOtherURLInActivitiesArry];
                 
                 //把基本信息self.activitiesDetailInfoArry
                 [self.activitiesCouponsDetailInfoArry addObjectsFromArray:infoArry];
                 
                 [_activityTableView reloadData];

                 
             }else{
                 
                 _activityTableView.footer.hidden = YES;
             }
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}
#pragma mark 请求优惠活动---领取优享卷---------
- (void)requestActivitiesWithHaveCoupons:(UIButton *)sender{
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    NSDictionary *parameters = @{
                                 
                                 @"userId" :[NSNumber numberWithInt:6],
                                 @"cId":[NSNumber numberWithInt:(int)sender.tag]
                                 
                                 };
    [handler postURLStr:webReceiveCoupons postDic:parameters
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
             if ([[retInfo objectForKey:@"isSuccess"]boolValue]) {
                 
                 NSString *info = @"领取优享卷成功！";
                 UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alertV show];
             }else{
                 
                 NSString *info = @"领取优享卷失败！";
                 UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alertV show];
             }
             [_activityTableView reloadData];
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}
#pragma mark 请求优惠活动---大牌档---数据
- (void)requestActivitiesWithMajorSuitData{
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
   
    [handler postURLStr:webGetMajorSuit postDic:nil
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
             //给图片轮播图片赋值
             [self.imagesOtherURLInActivitiesArry removeAllObjects];
             for (NSDictionary *imgDict in [retInfo objectForKey:@"brandAdvert"]) {
                 
                 [self.imagesOtherURLInActivitiesArry addObject:[NZGlobal GetImgBaseURL:[imgDict objectForKey:@"imgUrl"]]];
             }
             [self.imagesOtherURLInActivitiesArry insertObject:@"http://10.0.0.177:8000///FileUploadImage/Coupons/_201509121538144531344.png" atIndex:2];
             
             //刷新图片轮播
             [self initActivitiesInterface:self.imagesOtherURLInActivitiesArry];
             
             //把基本信息self.activitiesDetailInfoArry
             self.activitiesMajorSuitDetailInfoArry = [retInfo objectForKey:@"shopList"];
             
             [_activityTableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}


#pragma mark 倒影翻转
- (void)flipViewTransformPIWith:(UIView *)view
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    [view.layer setTransform:transform];
}

#pragma mark 材质款式选择按钮
- (void)selectStyle:(UIButton *)button {
    int btnID = [objc_getAssociatedObject(button, "id") intValue];
    
    if (!selectedStyle) {
        int arrowPosition = (int)button.tag - styleButtonTag;
        
        [button setTitleColor:selectColor forState:UIControlStateNormal];
        
        currentStyle = arrowPosition;
        styleID = btnID;
        selectedStyle = YES;
    } else {
        int arrowPosition = (int)button.tag - styleButtonTag;
        if (arrowPosition == currentStyle) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            currentStyle = -1;
            selectedStyle = NO;
        } else {
            UIButton *lastBtn = (UIButton *)[_tableView viewWithTag:(currentStyle + styleButtonTag)];
            [lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:selectColor forState:UIControlStateNormal];
            currentStyle = arrowPosition;
            styleID = btnID;
        }
    }
    if (selectedStyle && selectedVariety) {
        NZCommodityListViewController *commodityListViewCtr = [[NZCommodityListViewController alloc] initWithNibName:@"NZCommodityListViewController" bundle:nil];
        
        PasspParametersModel *parameters = [[PasspParametersModel alloc] init];
        parameters.type = _indicateType;
        if (_indicateType == enumtMaterialOrStyleType_Material) {
            parameters.materialID = cellID;
            parameters.styleID = styleID;
        } else {
            parameters.materialID = styleID;
            parameters.styleID = cellID;
        }
        parameters.varOrBrandID = varietyID;
        parameters.sortID = 0;
        
        commodityListViewCtr.parameters = parameters; // 传递商品列表参数
        commodityListViewCtr.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commodityListViewCtr animated:YES];
    }
}

- (void)selectVariety:(UIButton *)button {
    int btnID = [objc_getAssociatedObject(button, "id") intValue];
    
    if (!selectedVariety) {
        int arrowPosition = (int)button.tag - varietyButtonTag;
        
        [button setTitleColor:selectColor forState:UIControlStateNormal];
        
        currentVariety = arrowPosition;
        varietyID = btnID;
        selectedVariety = YES;
    } else {
        int arrowPosition = (int)button.tag - varietyButtonTag;
        if (arrowPosition == currentVariety) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            currentVariety = -1;
            selectedVariety = NO;
        } else {
            UIButton *lastBtn = (UIButton *)[_tableView viewWithTag:(currentVariety + varietyButtonTag)];
            [lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:selectColor forState:UIControlStateNormal];
            currentVariety = arrowPosition;
            varietyID = btnID;
        }
    }
    if (selectedStyle && selectedVariety) {
        NZCommodityListViewController *commodityListViewCtr = [[NZCommodityListViewController alloc] initWithNibName:@"NZCommodityListViewController" bundle:nil];
        
        PasspParametersModel *parameters = [[PasspParametersModel alloc] init];
        parameters.type = _indicateType;
        if (_indicateType == enumtMaterialOrStyleType_Material) {
            parameters.materialID = cellID;
            parameters.styleID = styleID;
        } else {
            parameters.materialID = styleID;
            parameters.styleID = cellID;
        }
        parameters.varOrBrandID = varietyID;
        parameters.sortID = 0;
        
        commodityListViewCtr.parameters = parameters; // 传递商品列表参数
        commodityListViewCtr.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commodityListViewCtr animated:YES];
    }
}
#pragma mark 时间结点点击事件
- (void)timeButtonAction:(UIButton *)sender {
    
    [self.imagesURLInActivitiesArry removeAllObjects];;
    [self.activitiesTimeDetailInfoArry removeAllObjects];
    self.pageNo = 0;
    _timeIndex = (int)sender.tag-200-1;
    
    grabImgV.image = [UIImage imageNamed:@"限时抢-红"];
    nProductImgV.image = [UIImage imageNamed:@"新品汇-灰"];
    couponsImgV.image = [UIImage imageNamed:@"优惠券-灰"];
    majorImgV.image = [UIImage imageNamed:@"大牌档-灰"];
    grabLab.textColor = darkRedColor;
    nProductLab.textColor = [UIColor grayColor];
    couponsLab.textColor = [UIColor grayColor];
    majorLab.textColor = [UIColor grayColor];
    // 刷新限时抢
    _acType = enumtActivitiesType_Grab;
    
    //加载限时抢数据
    _activityTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestActivitiesWithLimitTimeData)];
    // 马上进入刷新状态
    [_activityTableView.footer beginRefreshing];
    
}
#pragma mark 其它点击事件
- (void)classClick:(UIButton *)button { // 优惠活动四个活动按钮事件
    self.pageNo = 0;
    [self.imagesURLInActivitiesArry removeAllObjects];;
    [self.activitiesTimeDetailInfoArry removeAllObjects];
    [self.imagesOtherURLInActivitiesArry removeAllObjects];
    [self.activitiesNewDetailInfoArry removeAllObjects];
    [self.activitiesCouponsDetailInfoArry removeAllObjects];
    [self.activitiesMajorSuitDetailInfoArry  removeAllObjects];
    
    int btnTag = (int)button.tag;
    switch (btnTag) {
        case 101:
            grabImgV.image = [UIImage imageNamed:@"限时抢-红"];
            nProductImgV.image = [UIImage imageNamed:@"新品汇-灰"];
            couponsImgV.image = [UIImage imageNamed:@"优惠券-灰"];
            majorImgV.image = [UIImage imageNamed:@"大牌档-灰"];
            grabLab.textColor = darkRedColor;
            nProductLab.textColor = [UIColor grayColor];
            couponsLab.textColor = [UIColor grayColor];
            majorLab.textColor = [UIColor grayColor];
            // 刷新限时抢
            _acType = enumtActivitiesType_Grab;
            
           //加载限时抢数据
            _activityTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestActivitiesWithLimitTimeData)];
            // 马上进入刷新状态
            [_activityTableView.footer beginRefreshing];
            //[self requestActivitiesWithLimitTimeData];
            
            break;
        case 102:
            grabImgV.image = [UIImage imageNamed:@"限时抢-灰"];
            nProductImgV.image = [UIImage imageNamed:@"新品汇-红"];
            couponsImgV.image = [UIImage imageNamed:@"优惠券-灰"];
            majorImgV.image = [UIImage imageNamed:@"大牌档-灰"];
            grabLab.textColor = [UIColor grayColor];
            nProductLab.textColor = darkRedColor;
            couponsLab.textColor = [UIColor grayColor];
            majorLab.textColor = [UIColor grayColor];
            // 刷新新品汇
            _acType = enumtActivitiesType_newProduct;
            //加载新品汇数据
            _activityTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestActivitiesWithNewData)];
            // 马上进入刷新状态
            [_activityTableView.footer beginRefreshing];
            //[self requestActivitiesWithNewData];
            
            break;
        case 103:
            grabImgV.image = [UIImage imageNamed:@"限时抢-灰"];
            nProductImgV.image = [UIImage imageNamed:@"新品汇-灰"];
            couponsImgV.image = [UIImage imageNamed:@"优惠券-红"];
            majorImgV.image = [UIImage imageNamed:@"大牌档-灰"];
            grabLab.textColor = [UIColor grayColor];
            nProductLab.textColor = [UIColor grayColor];
            couponsLab.textColor = darkRedColor;
            majorLab.textColor = [UIColor grayColor];
            // 刷新优享券
            _acType = enumtActivitiesType_Coupons;
            
            _activityTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestActivitiesWithCouponsData)];
            // 马上进入刷新状态
            [_activityTableView.footer beginRefreshing];

            //[self requestActivitiesWithCouponsData];
            break;
        case 104:
            grabImgV.image = [UIImage imageNamed:@"限时抢-灰"];
            nProductImgV.image = [UIImage imageNamed:@"新品汇-灰"];
            couponsImgV.image = [UIImage imageNamed:@"优惠券-灰"];
            majorImgV.image = [UIImage imageNamed:@"大牌档-红"];
            grabLab.textColor = [UIColor grayColor];
            nProductLab.textColor = [UIColor grayColor];
            couponsLab.textColor = [UIColor grayColor];
            majorLab.textColor = darkRedColor;
            // 刷新大牌档
            _acType = enumtActivitiesType_MajorSuit;
            
            [self requestActivitiesWithMajorSuitData];
            break;
        default:
            break;
    }
    
}

#pragma mark 界面跳转都在这
- (void)brandDetailJump:(UIButton *)button {
    NZMajorSuitViewController *majorSuitVCTR = [[NZMajorSuitViewController alloc] init];
    majorSuitVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:majorSuitVCTR animated:YES];
}

#pragma mark 四个主视图的tabBar收缩自如
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

#pragma mark   点击马上抢跳转方法
-(void)quicklyButtonAction:(UIButton *)sender{

    // 跳转商品详情页面
    NZCommodityDetailController *commodityDetailVCTR = [[NZCommodityDetailController alloc] init];
    commodityDetailVCTR.goodID = (int)sender.tag-900;
    commodityDetailVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityDetailVCTR animated:YES];
}
#pragma mark   点击新品--跳转方法
-(void)goToBuyAction:(UIButton *)sender{
    
    // 跳转商品详情页面
    NZCommodityDetailController *commodityDetailVCTR = [[NZCommodityDetailController alloc] init];
    commodityDetailVCTR.goodID = (int)sender.tag;
    commodityDetailVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityDetailVCTR animated:YES];

}


#pragma mark 指示器点击事件
// 选择材质
- (IBAction)materialAction:(UIButton *)sender {
    
    _indicateArrowLeftConstraint.constant = leftFloat;
    _tableView.hidden = NO;
    _activityTableView.hidden = YES;
    
    expand = NO;
    selectIndex = -1;
    selectedStyle = NO;
    selectedVariety = NO;
    _indicateType = enumtMaterialOrStyleType_Material;
    [_tableView reloadData];
}
// 选择款式
- (IBAction)styleAction:(UIButton *)sender {
    
    _indicateArrowLeftConstraint.constant = centerFloat;
    _tableView.hidden = NO;
    _activityTableView.hidden = YES;
    
    expand = NO;
    selectIndex = -1;
    selectedStyle = NO;
    selectedVariety = NO;
    _indicateType = enumtMaterialOrStyleType_Style;
    
    if (requestCount == 0) {
        [self requestStyleData];
        requestCount ++;
    } else {
        [_tableView reloadData];
    }
    
}
// 选择优惠活动
- (IBAction)activitiesAction:(UIButton *)sender {
    
    self.pageNo = 0;
    _indicateArrowLeftConstraint.constant = rightFloat;
    _tableView.hidden = YES;
    _activityTableView.hidden = NO;
    
    grabImgV.image = [UIImage imageNamed:@"限时抢-红"];
    nProductImgV.image = [UIImage imageNamed:@"新品汇-灰"];
    couponsImgV.image = [UIImage imageNamed:@"优惠券-灰"];
    majorImgV.image = [UIImage imageNamed:@"大牌档-灰"];
    grabLab.textColor = darkRedColor;
    nProductLab.textColor = [UIColor grayColor];
    couponsLab.textColor = [UIColor grayColor];
    majorLab.textColor = [UIColor grayColor];

    _acType = enumtActivitiesType_Grab;
    
    [self.imagesURLInActivitiesArry removeAllObjects];;
    [self.activitiesTimeDetailInfoArry removeAllObjects];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    //_activityTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _activityTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestActivitiesWithLimitTimeData)];
    // 马上进入刷新状态
    [_activityTableView.footer beginRefreshing];

    //-----获取优惠活动限时抢数据
    //[self requestActivitiesWithLimitTimeData];
    
}


@end
