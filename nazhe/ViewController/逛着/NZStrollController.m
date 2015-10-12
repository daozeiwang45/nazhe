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
    [self initActivitiesInterface];        // 初始化优惠活动界面
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
- (void)initActivitiesInterface {
    _acType = enumtActivitiesType_Grab; // 首先展示限时抢活动界面
    
    _activityTableView.dataSource = self;
    _activityTableView.delegate = self;
    _activityTableView.backgroundColor = UIDefaultBackgroundColor;
    _activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _activityTableView.showsVerticalScrollIndicator = NO;
    _activityTableView.bounces = NO;
    
    UIView *tableHeaderView = [[UIView alloc] init];
    /****************************   广告轮播   *******************************/
    NSArray *imagesURL = @[
                           @"http://chuantu.biz/t2/13/1441784045x-954498858.png",
                           @"http://img4.duitang.com/uploads/item/201410/19/20141019231747_e4aGC.jpeg",
                           @"http://img2.3lian.com/2014/c8/41/42.jpg",
                           @"http://cdn.duitang.com/uploads/item/201408/24/20140824111544_sBnvy.png",
                           @"http://img4.duitang.com/uploads/item/201308/04/20130804050930_F8TnA.thumb.600_0.jpeg",
                           @"http://img2.3lian.com/2014/c8/41/d/43.jpg"
                           ];
    
    AdView *adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 225/375)  \
                                      imageLinkURL:imagesURL\
                               placeHoderImageName:@"placeHoder.jpg" \
                              pageControlShowStyle:UIPageControlShowStyleNone];
    
    // 是否需要支持定时循环滚动，默认为YES
    adView.isNeedCycleRoll = NO;
    
    adView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
    };
    [tableHeaderView addSubview:adView];

    /*************************     四大活动按钮    ***********************/
    UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adView.frame), ScreenWidth, 75)];
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
    
    [tableHeaderView addSubview:classView];
    
    tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(classView.frame));
    _activityTableView.tableHeaderView = tableHeaderView;
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
    // 提示正在抢
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*2/5, 0, ScreenWidth/5, 50)];
    redView.backgroundColor = darkRedColor;
    [timeView addSubview:redView];
    
    UIView *time1V = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/5, 50)];
    time1V.backgroundColor = [UIColor clearColor];
    UILabel *time1Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
    time1Lab.text = @"09:00";
    time1Lab.textColor = [UIColor whiteColor];
    time1Lab.font = [UIFont systemFontOfSize:16.f];
    time1Lab.textAlignment = NSTextAlignmentCenter;
    [time1V addSubview:time1Lab];
    UILabel *time1Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
    time1Icon.text = @"已抢完";
    time1Icon.textColor = [UIColor whiteColor];
    time1Icon.font = [UIFont systemFontOfSize:16.f];
    time1Icon.textAlignment = NSTextAlignmentCenter;
    [time1V addSubview:time1Icon];
    [timeView addSubview:time1V];
    
    UIView *time2V = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/5, 0, ScreenWidth/5, 50)];
    time2V.backgroundColor = [UIColor clearColor];
    UILabel *time2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
    time2Lab.text = @"11:00";
    time2Lab.textColor = [UIColor whiteColor];
    time2Lab.font = [UIFont systemFontOfSize:16.f];
    time2Lab.textAlignment = NSTextAlignmentCenter;
    [time2V addSubview:time2Lab];
    UILabel *time2Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
    time2Icon.text = @"已抢完";
    time2Icon.textColor = [UIColor whiteColor];
    time2Icon.font = [UIFont systemFontOfSize:16.f];
    time2Icon.textAlignment = NSTextAlignmentCenter;
    [time2V addSubview:time2Icon];
    [timeView addSubview:time2V];
    
    UIView *time3V = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*2/5, 0, ScreenWidth/5, 50)];
    time3V.backgroundColor = [UIColor clearColor];
    UILabel *time3Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
    time3Lab.text = @"13:00";
    time3Lab.textColor = [UIColor whiteColor];
    time3Lab.font = [UIFont systemFontOfSize:16.f];
    time3Lab.textAlignment = NSTextAlignmentCenter;
    [time3V addSubview:time3Lab];
    UILabel *time3Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
    time3Icon.text = @"正在抢";
    time3Icon.textColor = [UIColor whiteColor];
    time3Icon.font = [UIFont systemFontOfSize:16.f];
    time3Icon.textAlignment = NSTextAlignmentCenter;
    [time3V addSubview:time3Icon];
    [timeView addSubview:time3V];
    
    UIView *time4V = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*3/5, 0, ScreenWidth/5, 50)];
    time4V.backgroundColor = [UIColor clearColor];
    UILabel *time4Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
    time4Lab.text = @"15:00";
    time4Lab.textColor = [UIColor whiteColor];
    time4Lab.font = [UIFont systemFontOfSize:16.f];
    time4Lab.textAlignment = NSTextAlignmentCenter;
    [time4V addSubview:time4Lab];
    UILabel *time4Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
    time4Icon.text = @"已抢完";
    time4Icon.textColor = [UIColor whiteColor];
    time4Icon.font = [UIFont systemFontOfSize:16.f];
    time4Icon.textAlignment = NSTextAlignmentCenter;
    [time4V addSubview:time4Icon];
    [timeView addSubview:time4V];
    
    UIView *time5V = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*4/5, 0, ScreenWidth/5, 50)];
    time5V.backgroundColor = [UIColor clearColor];
    UILabel *time5Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth/5, 20)];
    time5Lab.text = @"17:00";
    time5Lab.textColor = [UIColor whiteColor];
    time5Lab.font = [UIFont systemFontOfSize:16.f];
    time5Lab.textAlignment = NSTextAlignmentCenter;
    [time5V addSubview:time5Lab];
    UILabel *time5Icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth/5, 20)];
    time5Icon.text = @"已抢完";
    time5Icon.textColor = [UIColor whiteColor];
    time5Icon.font = [UIFont systemFontOfSize:16.f];
    time5Icon.textAlignment = NSTextAlignmentCenter;
    [time5V addSubview:time5Icon];
    [timeView addSubview:time5V];
    
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
    brandImageV1.image = [UIImage imageNamed:@"品牌图1"];
    [headerView addSubview:brandImageV1];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:brandImageV1.frame];
    btn1.tag = 1001;
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn1];
    
    UIImageView *brandImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-5)/2 + 5, CGRectGetMaxY(adImageView.frame)+5, (ScreenWidth-5)/2, ScreenWidth*125/375)];
    brandImageV2.image = [UIImage imageNamed:@"品牌图2"];
    [headerView addSubview:brandImageV2];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:brandImageV2.frame];
    btn2.tag = 1002;
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn2];
    
    UIImageView *brandImageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(brandImageV1.frame)+5, (ScreenWidth-5)/2, ScreenWidth*125/375)];
    brandImageV3.image = [UIImage imageNamed:@"品牌图3"];
    [headerView addSubview:brandImageV3];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:brandImageV3.frame];
    btn3.tag = 1003;
    btn3.backgroundColor = [UIColor clearColor];
    [btn3 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn3];
    
    UIImageView *brandImageV4 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-5)/2 + 5, CGRectGetMaxY(brandImageV1.frame)+5, (ScreenWidth-5)/2, ScreenWidth*125/375)];
    brandImageV4.image = [UIImage imageNamed:@"品牌图4"];
    [headerView addSubview:brandImageV4];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:brandImageV4.frame];
    btn4.tag = 1004;
    btn4.backgroundColor = [UIColor clearColor];
    [btn4 addTarget:self action:@selector(brandDetailJump:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn4];
    
    UIImageView *brandImageV5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(brandImageV3.frame)+5, ScreenWidth, ScreenWidth*125/375)];
    brandImageV5.image = [UIImage imageNamed:@"品牌图5"];
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
                return 3;
                
            case enumtActivitiesType_newProduct: // 新品汇
                return 3;
                
            case enumtActivitiesType_Coupons: // 优享券
                return 4;
                
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
    } else { // 优惠活动
        
        if (_acType == enumtActivitiesType_Grab) {
            NZGrabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZGrabActivityCellIdentify];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NZGrabViewCell" owner:self options:nil] lastObject] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.productImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"活动图%d",(int)indexPath.row+1]];
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
            
            cell.newOrBuy = enumtNewClubOrBuyNow_NewClub;
            
            return cell;
        } else if (_acType == enumtActivitiesType_Coupons) {
            NZCouponsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZCouponsActivityCellIdentify];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NZCouponsViewCell" owner:self options:nil] lastObject] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"couponBack%d",(int)((int)indexPath.row)%4]];
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
        
    }
    
}

#pragma mark 请求材质数据
- (void)requestMaterialData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
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

#pragma mark 其它点击事件
- (void)classClick:(UIButton *)button { // 优惠活动四个活动按钮事件
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
            [_activityTableView reloadData];
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
            [_activityTableView reloadData];
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
            [_activityTableView reloadData];
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
            [_activityTableView reloadData];
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
    
    _indicateArrowLeftConstraint.constant = rightFloat;
    _tableView.hidden = YES;
    _activityTableView.hidden = NO;
//    _acType = enumtActivitiesType_Grab;
    [_activityTableView reloadData];
}

@end
