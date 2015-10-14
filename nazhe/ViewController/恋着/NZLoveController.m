//
//  NZLoveController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZLoveController.h"
#import "NZLoveContentView.h"
#import "AdView.h"
#import "MZTimerLabel.h"
#import "NZCardsCarouselView.h"
#import "NZConstellationScrollView.h"
#import "NZRegistFirstViewController.h"
#import "NZLoginViewController.h"
#import "LoveModel.h"
#import "NZActivityViewController.h"

#define imgWidth ScreenWidth * 200/375
#define shortWidth ScreenWidth * 80/375
#define imgMargin 10.f
#define maskWidth (ScreenWidth - imgWidth - 2*imgMargin) / 2
#define gradientOriginY ScreenWidth*315/375 - imgWidth / 2
#define centerSet imgWidth + imgMargin + imgWidth - (ScreenWidth - imgWidth - 2*imgMargin) / 2

@interface NZLoveController ()<UIScrollViewDelegate, NZConstellationScrollViewDelegate> {
    
    NZLoveContentView *contentView;
    
    MZTimerLabel *countDownTimer;
    
    
    UIImageView *iconView;
    /***********   新品汇图片view   **********/
    UIImageView *leftOneImageView;
    UIImageView *leftTwoImageView;
    UIImageView *centerImageView;
    UIImageView *rightOneImageView;
    UIImageView *rightTwoImageView;
    /***********   新品汇图片标号   **********/
    int last2Index;
    int lastIndex;
    int currentIndex;
    int nextIndex;
    int next2Index;
    /***********   新品汇价格Label   **********/
    UILabel *leftOnePriceLab;
    UILabel *leftTwoPriceLab;
    UILabel *centerPriceLab;
    UILabel *rightOnePriceLab;
    UILabel *rightTwoPriceLab;
    /***********   新品汇名称Label   **********/
    UILabel *leftOneNameLab;
    UILabel *leftTwoNameLab;
    UILabel *centerNameLab;
    UILabel *rightOneNameLab;
    UILabel *rightTwoNameLab;

    /***********   幸运星辰数据   ************/
    NSMutableArray *constellationArray;
    NSMutableArray *dateArray;
    UIImageView *iconImageV;
    
    // 首页数据模型
    LoveModel *loveModel;
    AdView *adView;
    
    /***********   新品汇数据   ************/
    NSMutableArray *imageURL;
    NSMutableArray *goodNameArray;
    NSMutableArray *goodPriceArray;
    
    // 幸运星辰图片数据
    NZCardsCarouselView *cardCarouseView;
    NSMutableDictionary *starImgDic;
}

@property (strong, nonatomic) IBOutlet UIScrollView *homepageScrollView;



@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation NZLoveController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    _isAnimation = NO;
    
    [self createNavigationItemTitleViewWithTitle:@"恋着"];
    [self createLeftAndRightNavigationItemButton];
    self.navigationController.navigationBarHidden = YES;
    
    [self initInterface];
    [self createCardsCarouselView];       // 卡片切换界面
    [self createConstellationSelection];  // 星座选择器
    [self addJumpAction];                 // 给按钮增加跳转事件
    
    [self requestFirstPageData]; // 请求首页数据
}

#pragma mark 初始化界面
- (void)initInterface {
    /***************************   设置scrollView与其contentView的边缘约束    ****************/
    self.homepageScrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.homepageScrollView.delegate = self;
    self.homepageScrollView.bounces = NO;
    
    contentView = [[[NSBundle mainBundle] loadNibNamed:@"NZLoveContentView" owner:self options:nil] lastObject];
    [self.homepageScrollView addSubview:contentView];
    
    [self.homepageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    // 适配首页高度
    contentView.registViewTop.constant = ScreenWidth*290/375;
    contentView.shadowHeight.constant = ScreenWidth*100/375;
    contentView.npHeight.constant = ScreenWidth*175/375;
    contentView.scrollHeight.constant = ScreenWidth*325/375;
    contentView.couponsHeight.constant = ScreenWidth*175/375;
    contentView.starHeight.constant = ScreenWidth*325/375;
    contentView.dateTop.constant = ScreenWidth*235/375;
    contentView.starBarTop.constant = ScreenWidth*290/375;
    
    // 解决新品汇和优惠券的icon超出问题
    contentView.labBottom1.constant = ScreenWidth*10/375;
    contentView.iconBottom1.constant = ScreenWidth*5/375;
    contentView.labTop1.constant = ScreenWidth*20/375;
    contentView.labBottom2.constant = ScreenWidth*10/375;
    contentView.iconBottom2.constant = ScreenWidth*5/375;
    contentView.labTop2.constant = ScreenWidth*20/375;
    
    /***************************   广告轮播    **********************/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255.f green:255.f blue:255.f alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    
    // 放到网络请求之后放进去
    
    
    
    /*******************************************
     *      计时器
     ********************************************/
    contentView.timeLabel.layer.cornerRadius = 3.f;
    contentView.timeLabel.layer.masksToBounds = YES;
    countDownTimer = [[MZTimerLabel alloc] initWithLabel:contentView.timeLabel andTimerType:MZTimerLabelTypeTimer];
    
    /***************************   新品汇轮播图    **********************/
    
    contentView.npScrollView.delegate = self;
    contentView.npScrollView.scrollEnabled = NO;
    
    /***************************     左一图     **************************/
    leftOneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, ScreenWidth*315/375)];
    
    [contentView.npScrollView addSubview:leftOneImageView];
    
    UIImageView *gradientMask1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, gradientOriginY, imgWidth, imgWidth / 2)];
    gradientMask1.image = [UIImage imageNamed:@"黑色渐变"];
    [contentView.npScrollView addSubview:gradientMask1];
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth - 45)/2, ScreenWidth*225/375, ScreenWidth*45/375, ScreenWidth*45/375)];
    iconView.image = [UIImage imageNamed:@"新品CLUB"];
    [contentView.npScrollView addSubview:iconView];
    
    leftOneNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*275/375, imgWidth, 15)];
    
    leftOneNameLab.textColor = [UIColor whiteColor];
    leftOneNameLab.font = [UIFont systemFontOfSize:11.f];
    leftOneNameLab.textAlignment = NSTextAlignmentCenter;
    [contentView.npScrollView addSubview:leftOneNameLab];
    
    leftOnePriceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*288/375, imgWidth, 15)];
    
    leftOnePriceLab.textColor = [UIColor whiteColor];
    leftOnePriceLab.font = [UIFont systemFontOfSize:11.f];
    leftOnePriceLab.textAlignment = NSTextAlignmentCenter ;
    [contentView.npScrollView addSubview:leftOnePriceLab];
    
    /***************************     左二图     **************************/
    leftTwoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth + imgMargin, 0, imgWidth, ScreenWidth*315/375)];
    
    [contentView.npScrollView addSubview:leftTwoImageView];
    
    UIImageView *gradientMask2 = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth + imgMargin, gradientOriginY, imgWidth, imgWidth / 2)];
    gradientMask2.image = [UIImage imageNamed:@"黑色渐变"];
    [contentView.npScrollView addSubview:gradientMask2];
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth - 45)/2 + imgWidth + imgMargin, ScreenWidth*225/375, ScreenWidth*45/375, ScreenWidth*45/375)];
    iconView.image = [UIImage imageNamed:@"新品CLUB"];
    [contentView.npScrollView addSubview:iconView];
    
    leftTwoNameLab = [[UILabel alloc] initWithFrame:CGRectMake(imgWidth + imgMargin, ScreenWidth*275/375, imgWidth, 15)];

    leftTwoNameLab.textColor = [UIColor whiteColor];
    leftTwoNameLab.font = [UIFont systemFontOfSize:11.f];
    leftTwoNameLab.textAlignment = NSTextAlignmentCenter;
    [contentView.npScrollView addSubview:leftTwoNameLab];
    
    leftTwoPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(imgWidth + imgMargin, ScreenWidth*288/375, imgWidth, 15)];
    
    leftTwoPriceLab.textColor = [UIColor whiteColor];
    leftTwoPriceLab.font = [UIFont systemFontOfSize:11.f];
    leftTwoPriceLab.textAlignment = NSTextAlignmentCenter ;
    [contentView.npScrollView addSubview:leftTwoPriceLab];
    
    /***************************     中间图     **************************/
    centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 2, 0, imgWidth, ScreenWidth*315/375)];
    
    [contentView.npScrollView addSubview:centerImageView];
    
    UIImageView *gradientMask3 = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 2, gradientOriginY, imgWidth, imgWidth / 2)];
    gradientMask3.image = [UIImage imageNamed:@"黑色渐变"];
    [contentView.npScrollView addSubview:gradientMask3];
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth - 45)/2 + (imgWidth + imgMargin) * 2, ScreenWidth*225/375, ScreenWidth*45/375, ScreenWidth*45/375)];
    iconView.image = [UIImage imageNamed:@"新品CLUB"];
    [contentView.npScrollView addSubview:iconView];
    
    centerNameLab = [[UILabel alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 2, ScreenWidth*275/375, imgWidth, 15)];
    
    centerNameLab.textColor = [UIColor whiteColor];
    centerNameLab.font = [UIFont systemFontOfSize:11.f];
    centerNameLab.textAlignment = NSTextAlignmentCenter;
    [contentView.npScrollView addSubview:centerNameLab];
    
    centerPriceLab = [[UILabel alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 2, ScreenWidth*288/375, imgWidth, 15)];
    
    centerPriceLab.textColor = [UIColor whiteColor];
    centerPriceLab.font = [UIFont systemFontOfSize:11.f];
    centerPriceLab.textAlignment = NSTextAlignmentCenter ;
    [contentView.npScrollView addSubview:centerPriceLab];
    
    
    /***************************     右一图     **************************/
    rightOneImageView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 3, 0, imgWidth, ScreenWidth*315/375)];
    
    [contentView.npScrollView addSubview:rightOneImageView];
    
    UIImageView *gradientMask4 = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 3, gradientOriginY, imgWidth, imgWidth / 2)];
    gradientMask4.image = [UIImage imageNamed:@"黑色渐变"];
    [contentView.npScrollView addSubview:gradientMask4];
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth - 45)/2 + (imgWidth + imgMargin) * 3, ScreenWidth*225/375, ScreenWidth*45/375, ScreenWidth*45/375)];
    iconView.image = [UIImage imageNamed:@"新品CLUB"];
    [contentView.npScrollView addSubview:iconView];
    
    rightOneNameLab = [[UILabel alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 3, ScreenWidth*275/375, imgWidth, 15)];
    
    rightOneNameLab.textColor = [UIColor whiteColor];
    rightOneNameLab.font = [UIFont systemFontOfSize:11.f];
    rightOneNameLab.textAlignment = NSTextAlignmentCenter;
    [contentView.npScrollView addSubview:rightOneNameLab];
    
    rightOnePriceLab = [[UILabel alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 3, ScreenWidth*288/375, imgWidth, 15)];
    rightOnePriceLab.text = @"￥8900";
    rightOnePriceLab.textColor = [UIColor whiteColor];
    rightOnePriceLab.font = [UIFont systemFontOfSize:11.f];
    rightOnePriceLab.textAlignment = NSTextAlignmentCenter ;
    [contentView.npScrollView addSubview:rightOnePriceLab];
    
    /***************************     右二图     **************************/
    rightTwoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 4, 0, imgWidth, ScreenWidth*315/375)];
    
    [contentView.npScrollView addSubview:rightTwoImageView];
    
    UIImageView *gradientMask5 = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 4, gradientOriginY, imgWidth, imgWidth / 2)];
    gradientMask5.image = [UIImage imageNamed:@"黑色渐变"];
    [contentView.npScrollView addSubview:gradientMask5];
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth - 45)/2 + (imgWidth + imgMargin) * 4, ScreenWidth*225/375, ScreenWidth*45/375, ScreenWidth*45/375)];
    iconView.image = [UIImage imageNamed:@"新品CLUB"];
    [contentView.npScrollView addSubview:iconView];
    
    rightTwoNameLab = [[UILabel alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 4, ScreenWidth*275/375, imgWidth, 15)];
    
    rightTwoNameLab.textColor = [UIColor whiteColor];
    rightTwoNameLab.font = [UIFont systemFontOfSize:11.f];
    rightTwoNameLab.textAlignment = NSTextAlignmentCenter;
    [contentView.npScrollView addSubview:rightTwoNameLab];
    
    rightTwoPriceLab = [[UILabel alloc] initWithFrame:CGRectMake((imgWidth + imgMargin) * 4, ScreenWidth*288/375, imgWidth, 15)];
    
    rightTwoPriceLab.textColor = [UIColor whiteColor];
    rightTwoPriceLab.font = [UIFont systemFontOfSize:11.f];
    rightTwoPriceLab.textAlignment = NSTextAlignmentCenter ;
    [contentView.npScrollView addSubview:rightTwoPriceLab];
    
    // 左右两边白色透明遮罩
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*465/375+125, ScreenWidth, ScreenWidth*325/375)];
    maskView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:maskView];
    
    UIView *leftMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maskWidth, ScreenWidth*315/375)];
    leftMaskView.backgroundColor = [UIColor whiteColor];
    leftMaskView.alpha = 0.4f;
    [maskView addSubview:leftMaskView];
    
    UIView *rightMaskView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - maskWidth, 0, maskWidth, ScreenWidth*315/375)];
    rightMaskView.backgroundColor = [UIColor whiteColor];
    rightMaskView.alpha = 0.4f;
    [maskView addSubview:rightMaskView];
    
    contentView.npScrollView.contentSize = CGSizeMake((imgWidth + imgMargin) * 4 + imgWidth, 325);
    
    contentView.npScrollView.contentOffset = CGPointMake(centerSet, 0);
    
    /*************   添加滑动手势 执行图片切换效果   ****************/
    UISwipeGestureRecognizer *previousSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToPrevious:)];
    [previousSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [maskView addGestureRecognizer:previousSwipe];
    UISwipeGestureRecognizer *nextSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToNext:)];
    [nextSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [maskView addGestureRecognizer:nextSwipe];
    
    /********************   现金券Label圆角    *********************/
    contentView.cashCouponLabel.layer.cornerRadius = 3.f;
    contentView.cashCouponLabel.layer.masksToBounds = YES;
}

#pragma mark 界面跳转
- (void)addJumpAction {
    [contentView.registBtn addTarget:self action:@selector(registJump:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)registJump:(UIButton *)button {
//    NZRegistFirstViewController *registVCTR = [[NZRegistFirstViewController alloc] init];
//    registVCTR.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:registVCTR animated:YES];
    NZActivityViewController *activityVCTR = [[NZActivityViewController alloc] init];
    activityVCTR.activityID = 1;
    activityVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityVCTR animated:YES];
}

#pragma mark 幸运星辰界面布局
- (void)createCardsCarouselView {
//    NZCardsCarouselView *cardCarouseView = [[NZCardsCarouselView alloc] initWithFrame:CGRectMake((ScreenWidth - 260)/2, 10, 260, 250)];
    cardCarouseView = [[NZCardsCarouselView alloc] initWithFrame:CGRectMake(ScreenWidth*20/375, ScreenWidth*10/375, ScreenWidth - ScreenWidth*40/375, ScreenWidth*215/375)];
    cardCarouseView.backgroundColor = [UIColor clearColor];
    [contentView.luckyView addSubview:cardCarouseView];
}

- (void)createConstellationSelection {
    constellationArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"白羊"], [UIImage imageNamed:@"金牛"], [UIImage imageNamed:@"双子"], [UIImage imageNamed:@"巨蟹"], [UIImage imageNamed:@"狮子"], [UIImage imageNamed:@"处女"], [UIImage imageNamed:@"天秤"], [UIImage imageNamed:@"天蝎"], [UIImage imageNamed:@"射手"], [UIImage imageNamed:@"摩羯"], [UIImage imageNamed:@"水瓶"], [UIImage imageNamed:@"双鱼"], nil];
    
    dateArray = [NSMutableArray arrayWithObjects:@"3月21日－4月19日", @"4月20日－ 5月20日", @"5月21日－6月21日", @"6月22日－7月22日", @"7月23日－8月22日", @"8月23日－9月22日", @"9月23日－10月23日", @"10月24日－11月22日", @"11月23日－12月21日", @"12月22日－1月19日", @"1月20日－2月18日", @"2月19日－3月20日",  nil];
    
    NZConstellationScrollView *constellationScrollView = [[NZConstellationScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*20/375, ScreenWidth*250/375, ScreenWidth - ScreenWidth*40/375, ScreenWidth*40/375)];
    constellationScrollView.delegate = self;
    [contentView.luckyView addSubview:constellationScrollView];

    iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - ScreenWidth*37/375) / 2, ScreenWidth*175/375, ScreenWidth*37/375, ScreenWidth*37/375)];
    iconImageV.image = [UIImage imageNamed:@"处女"];
    [contentView.luckyView addSubview:iconImageV];
}

#pragma mark NZConstellationScrollViewDelegate
- (void)switchWitchConstellation:(int)index {
    iconImageV.image = constellationArray[index];
    contentView.dateLabel.text = dateArray[index];
    
    cardCarouseView.starList = starImgDic[[NSString stringWithFormat:@"%d",index]];
}

#pragma mark 新品汇切换手势事件
- (void)didSwipeToPrevious:(UISwipeGestureRecognizer *)sender {
    [contentView.npScrollView setContentOffset:CGPointMake(centerSet - imgMargin - imgWidth, 0) animated:YES];
    /*******************************    图片转换      ******************************/
    if (currentIndex == 2) {
        --currentIndex;
        last2Index = (int)imageURL.count - 1;
        lastIndex = 0;
        nextIndex = 2;
        next2Index = 3;
    } else if (currentIndex == 1) {
        --currentIndex;
        last2Index = (int)imageURL.count - 2;
        lastIndex = (int)imageURL.count - 1;
        nextIndex = 1;
        next2Index = 2;
    } else if (currentIndex == 0) {
        currentIndex = (int)imageURL.count - 1;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = 0;
        next2Index = 1;
    } else if (currentIndex == (int)imageURL.count - 1) {
        --currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = 0;
    } else {
        --currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = currentIndex + 2;
    }
}

- (void)didSwipeToNext:(UISwipeGestureRecognizer *)sender {
    [contentView.npScrollView setContentOffset:CGPointMake(centerSet + imgMargin + imgWidth, 0) animated:YES];
    /*******************************    图片转换      ******************************/
    if (currentIndex == (int)imageURL.count - 3) {
        ++currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = 0;
    } else if (currentIndex == (int)imageURL.count - 2) {
        ++currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = 0;
        next2Index = 1;
    } else if (currentIndex == (int)imageURL.count - 1) {
        currentIndex = 0;
        last2Index = (int)imageURL.count - 2;
        lastIndex = (int)imageURL.count - 1;
        nextIndex = 1;
        next2Index = 2;
    } else if (currentIndex == 0) {
        ++currentIndex;
        last2Index = (int)imageURL.count - 1;
        lastIndex = 0;
        nextIndex = 2;
        next2Index = 3;
    } else if (currentIndex == 1) {
        ++currentIndex;
        last2Index = 0;
        lastIndex = 1;
        nextIndex = 3;
        next2Index = 4;
    } else {
        ++currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = currentIndex + 2;
    }
}

#pragma mark UIScrollViewDelegate
//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时  新品汇的
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    if ([scrollView isEqual:contentView.npScrollView]) {
        [leftOneImageView sd_setImageWithURL:imageURL[last2Index] placeholderImage:defaultImage];
        leftOneNameLab.text = goodNameArray[last2Index];
        leftOnePriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[last2Index] intValue]];
        
        [leftTwoImageView sd_setImageWithURL:imageURL[lastIndex] placeholderImage:defaultImage];
        leftTwoNameLab.text = goodNameArray[lastIndex];
        leftTwoPriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[lastIndex] intValue]];
        
        [centerImageView sd_setImageWithURL:imageURL[currentIndex] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            contentView.npScrollView.contentOffset = CGPointMake(centerSet, 0);
        }];
        centerNameLab.text = goodNameArray[currentIndex];
        centerPriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[currentIndex] intValue]];
        
        [rightOneImageView sd_setImageWithURL:imageURL[nextIndex] placeholderImage:defaultImage];
        rightOneNameLab.text = goodNameArray[nextIndex];
        rightOnePriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[nextIndex] intValue]];
        
        [rightTwoImageView sd_setImageWithURL:imageURL[next2Index] placeholderImage:defaultImage];
        rightTwoNameLab.text = goodNameArray[next2Index];
        rightTwoPriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[next2Index] intValue]];
        
    }
    
}

//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if ([scrollView isEqual:_homepageScrollView]) {
        float curOffY = scrollView.contentOffset.y;
        if (curOffY > 44.f && self.navigationController.navigationBarHidden) {
            [self showNavigationBar];
        } else if (curOffY < 44.f && !self.navigationController.navigationBarHidden) {
            [self hideNavigationBar];
        }
    }
}

#pragma mark 弹出NavigationBar
- (void)showNavigationBar {
    CATransition *animation1 = [CATransition animation];
    animation1.duration = 0.4f;
    animation1.type = kCATransitionMoveIn;
    animation1.subtype = kCATransitionFromBottom;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar.layer addAnimation:animation1 forKey:@"animation1"];
}

#pragma mark 隐藏NavigationBar
- (void)hideNavigationBar {
    CATransition *animation1 = [CATransition animation];
    animation1.timingFunction=UIViewAnimationCurveEaseInOut;
    animation1.duration = 0.4f;
    animation1.delegate =self;
    animation1.type = kCATransitionReveal;
    animation1.subtype = kCATransitionFromTop;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar.layer addAnimation:animation1 forKey:@"animation0"];
}

/*
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDragging");
}
//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    NSLog(@"scrollViewDidEndDragging");
}
//将开始降速时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDecelerating");
}

//减速停止了时执行，手触摸时执行执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewDidEndDecelerating");
}
 */


#pragma mark 请求首页数据
- (void)requestFirstPageData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    [handler postURLStr:webLoveFirstPage postDic:nil
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
             loveModel = [LoveModel objectWithKeyValues:retInfo];
             
             // 轮播活动id手动添 然后把轮播图片数组取出来
             NSMutableArray *imagesURL = [NSMutableArray array];
             NSMutableArray *idArray = [NSMutableArray array];
             for (int i=0; i<loveModel.activityList.count; i++) {
                 BrandModel *brandModel = loveModel.activityList[i];
                 brandModel.brandID = [retInfo[@"activityList"][i][@"id"] intValue];
                 [imagesURL addObject:[NZGlobal GetImgBaseURL:brandModel.bgImg]];
                 [idArray addObject:[NSNumber numberWithInt:brandModel.brandID]];
             }
             
             // 新品汇数据因为凯哥参数new开头的原因，手动转，花费时间15分钟
             NSArray *goodsArray = retInfo[@"newGoodsList"];
             NSMutableArray *goodsList = [NSMutableArray array];
             for (int i=0; i<goodsArray.count; i++) {
                 NSDictionary *goddDic = goodsArray[i];
                 NewGoodsModel *goodModel = [NewGoodsModel objectWithKeyValues:goddDic];
                 [goodsList addObject:goodModel];
             }
             loveModel.nGoodsList = goodsList;
             
             // 星座图片ID手动转 根据星座分类
             NSMutableArray *starAry1 = [NSMutableArray array];
             NSMutableArray *starAry2 = [NSMutableArray array];
             NSMutableArray *starAry3 = [NSMutableArray array];
             NSMutableArray *starAry4 = [NSMutableArray array];
             NSMutableArray *starAry5 = [NSMutableArray array];
             NSMutableArray *starAry6 = [NSMutableArray array];
             NSMutableArray *starAry7 = [NSMutableArray array];
             NSMutableArray *starAry8 = [NSMutableArray array];
             NSMutableArray *starAry9 = [NSMutableArray array];
             NSMutableArray *starAry10 = [NSMutableArray array];
             NSMutableArray *starAry11 = [NSMutableArray array];
             NSMutableArray *starAry12 = [NSMutableArray array];

             for (int i=0; i<loveModel.starImgList.count; i++) {
                 StarModel *starModel = loveModel.starImgList[i];
                 starModel.starImgID = [retInfo[@"starImgList"][i][@"id"] intValue];
                 
                 switch (starModel.starNo) {
                     case 1:
                         [starAry1 addObject:starModel];
                         break;
                     case 2:
                         [starAry2 addObject:starModel];
                         break;
                     case 3:
                         [starAry3 addObject:starModel];
                         break;
                     case 4:
                         [starAry4 addObject:starModel];
                         break;
                     case 5:
                         [starAry5 addObject:starModel];
                         break;
                     case 6:
                         [starAry6 addObject:starModel];
                         break;
                     case 7:
                         [starAry7 addObject:starModel];
                         break;
                     case 8:
                         [starAry8 addObject:starModel];
                         break;
                     case 9:
                         [starAry9 addObject:starModel];
                         break;
                     case 10:
                         [starAry10 addObject:starModel];
                         break;
                     case 11:
                         [starAry11 addObject:starModel];
                         break;
                     case 12:
                         [starAry12 addObject:starModel];
                         break;
                     default:
                         break;
                 }
             }
             
             starImgDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:starAry1,@"0",starAry2,@"1",starAry3,@"2",starAry4,@"3",starAry5,@"4",starAry6,@"5",starAry7,@"6",starAry8,@"7",starAry9,@"8",starAry10,@"9",starAry11,@"10",starAry12,@"11", nil];
             
             /***************************   广告轮播    **********************/
             adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*290/375)  \
                                       imageLinkURL:imagesURL\
                                placeHoderImageName:@"默认图片" \
                               pageControlShowStyle:UIPageControlShowStyleNone];
             
             // 是否需要支持定时循环滚动，默认为YES
             adView.isNeedCycleRoll = NO;
             
             __weak typeof(self)wSelf = self;
             adView.callBack = ^(NSInteger index,NSString * imageURL)
             {
//                 NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
                 NZActivityViewController *activityVCTR = [[NZActivityViewController alloc] init];
                 activityVCTR.activityID = [idArray[index] intValue];
                 activityVCTR.hidesBottomBarWhenPushed = YES;
                 [wSelf.navigationController pushViewController:activityVCTR animated:YES];
             };
             [contentView addSubview:adView];
             [contentView sendSubviewToBack:adView];
             
             /***************************   限时抢    **********************/
             LimitedTimeGrabModel *grabModel = loveModel.limitTime[0];
             
             NSString *countDownStr = [NZGlobal intervalSinceNow:grabModel.endTime];
             NSArray *timeArrayNow = [countDownStr componentsSeparatedByString:@":"];
             int hour = [[timeArrayNow objectAtIndex:0] intValue];
             int min = [[timeArrayNow objectAtIndex:1] intValue];
             int sec = [[timeArrayNow objectAtIndex:2] intValue];
             [countDownTimer setCountDownTime:hour*3600 + min*60 + sec]; //** Or you can use [timer3 setCountDownToDate:aDate];
             [countDownTimer start];
             
//             [contentView.limitTimeBackImgV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:grabModel.img]] placeholderImage:defaultImage];
             
             NSString *moneyAndCountStr = [NSString stringWithFormat:@"￥%d / 仅剩%d件",grabModel.marketPrice, grabModel.count];
             contentView.moneyAndCountLab.text = moneyAndCountStr;
             
             /***************************   新品汇轮播图    **********************/
             NSMutableArray *nGoodImgArray = [NSMutableArray array];
             NSMutableArray *nGoodNameArray = [NSMutableArray array];
             NSMutableArray *nGoodPriceArray = [NSMutableArray array];
             for (int i=0; i<loveModel.nGoodsList.count; i++) {
                 NewGoodsModel *goodModel = loveModel.nGoodsList[i];
                 [nGoodImgArray addObject:[NZGlobal GetImgBaseURL:goodModel.img]];
                 [nGoodNameArray addObject:goodModel.name];
                 [nGoodPriceArray addObject:[NSNumber numberWithInt:goodModel.marketPrice]];
             }
             imageURL = nGoodImgArray;
             goodNameArray = nGoodNameArray;
             goodPriceArray = nGoodPriceArray;
             
             last2Index = (int)imageURL.count - 2;
             lastIndex = (int)imageURL.count - 1;
             currentIndex = 0;
             nextIndex = 1;
             next2Index = 2;
             
             [leftOneImageView sd_setImageWithURL:imageURL[last2Index] placeholderImage:defaultImage];
             leftOneNameLab.text = goodNameArray[last2Index];
             leftOnePriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[last2Index] intValue]];
             
             [leftTwoImageView sd_setImageWithURL:imageURL[lastIndex] placeholderImage:defaultImage];
             leftTwoNameLab.text = goodNameArray[lastIndex];
             leftTwoPriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[lastIndex] intValue]];
             
             [centerImageView sd_setImageWithURL:imageURL[currentIndex] placeholderImage:defaultImage];
             centerNameLab.text = goodNameArray[currentIndex];
             centerPriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[currentIndex] intValue]];
             
             [rightOneImageView sd_setImageWithURL:imageURL[nextIndex] placeholderImage:defaultImage];
             rightOneNameLab.text = goodNameArray[nextIndex];
             rightOnePriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[nextIndex] intValue]];
             
             [rightTwoImageView sd_setImageWithURL:imageURL[next2Index] placeholderImage:defaultImage];
             rightTwoNameLab.text = goodNameArray[next2Index];
             rightTwoPriceLab.text = [NSString stringWithFormat:@"￥%d",[goodPriceArray[next2Index] intValue]];
             
             /***************************   优惠券    **********************/
             CouponModel *couponModel = loveModel.coupon[0];
             
             NSString *couponStr = [NSString stringWithFormat:@"现金券￥%d",couponModel.money];
             contentView.cashCouponLabel.text = couponStr;
             
             NSString *scoreAndCountStr = [NSString stringWithFormat:@"积分%d/仅剩%d张",couponModel.score, couponModel.count];
             contentView.scroeAndCountLab.text = scoreAndCountStr;
             
             [contentView.couponIcon sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:couponModel.logo]] placeholderImage:defaultImage];
             
             [contentView.couponBackV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:couponModel.img]] placeholderImage:defaultImage];
             
             /***************************   幸运星辰    *************************/
             cardCarouseView.starList = starImgDic[@"5"];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}


#pragma mark contentView约束
- (void)viewDidLayoutSubviews {
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:ScreenWidth]);
        make.height.equalTo([NSNumber numberWithFloat:contentView.bottom.origin.y + contentView.bottom.frame.size.height]);

    }];
    
    [super viewDidLayoutSubviews];
}






// 动画中不能进行屏幕的切换
- (void)isAnimation:(BOOL)isAnimation {
    _isAnimation = isAnimation;
}

#pragma mark 四个主视图的tabBar收缩自如
- (void)viewWillAppear:(BOOL)animated {
    if (_homepageScrollView.contentOffset.y < 44.f) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

@end
