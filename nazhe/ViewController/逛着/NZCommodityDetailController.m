//
//  NZCommodityDetailController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZCommodityDetailController.h"
#import "AdView.h"
#import "GoodDetailModel.h"
#import "NZLoginViewController.h"
#import "NZOrderSelectedViewController.h"

#define topHeight ScreenWidth*75/375
#define secondHeight ScreenWidth*50/375
#define scrollViewHeight ScreenHeight-64-ScreenWidth*(33+125+40)/375
#define btnViewHeight ScreenWidth*125/375
#define mainViewHeight topHeight + secondHeight + scrollViewHeight + btnViewHeight + 50.f
#define contentFont [UIFont systemFontOfSize:13.f]

@interface NZCommodityDetailController ()<UIScrollViewDelegate> {
    UIView *mainView; // 可以拖拽的视图就是这个
    UIScrollView *myScrollV;
    
    BOOL isAinimation; // 动画中
    BOOL isTop; // 是否在上面
    BOOL canPan; // 动画已经进行后 不松手就不能动
    
    GoodDetailModel *goodDetailModel; // 商品详情数据模型
    
    AdView *adView;
    
    // 商品名称
    UILabel *nameLab;
    UILabel *nameLabel; // scrollview里面的商品名称
    
    UIButton *likeBtn; // 喜欢按钮
    UILabel *likeLab; // 喜欢数
    UIButton *collectionBtn; // 收藏按钮
    UILabel *collectionLab; // 收藏数
    
    UILabel *priceLab; // 会员价
    UILabel *mPriceLab; // 市场价
    
    // 品牌
    UILabel *brandLab;
    // 编号
    UILabel *IDLab;
    // 虚线4
    UIImageView *dotLine4;
    // 销量
    UILabel *saleLab;
    // 评价总数
    UILabel *evaluationLab;
    
    /*****************  第一条评价  ********************/
    UIImageView *starLvIcon1;
    UILabel *contentLab1;
    UILabel *time1;
    UILabel *source1;
    /*****************  第二条评价  ********************/
    UIImageView *starLvIcon2;
    UILabel *contentLab2;
    UILabel *time2;
    UILabel *source2;
    /*****************  第三条评价  ********************/
    UIImageView *starLvIcon3;
    UILabel *contentLab3;
    UILabel *time3;
    UILabel *source3;
}


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (strong, nonatomic) IBOutlet UILabel *lastGoodNameLab;
@property (strong, nonatomic) IBOutlet UILabel *nextGoodNameLab;
- (IBAction)lastGoodAction:(UIButton *)sender;
- (IBAction)nextGoodAction:(UIButton *)sender;

@end

@implementation NZCommodityDetailController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isAinimation = NO;
        isTop = NO;
        canPan = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftButtonTitle:nil];
    
    [self initPanScrollView]; //初始化拖拽视图
    
    
}

#pragma mark 初始化商品图片轮播
- (void)initInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /***************************   商品展示图   ***************************/
    DetailModel *detailModel = goodDetailModel.goodsDetail;
    
    if (detailModel.DetailImg) {
        NSArray *imgArray =[detailModel.DetailImg componentsSeparatedByString:@","];
        NSMutableArray *imagesURL = [NSMutableArray array];
        for (int i=0; i<imgArray.count; i++) {
            NSString *imgURL = [NZGlobal GetImgBaseURL:imgArray[i]];
            [imagesURL addObject:imgURL];
        }
        [adView removeFromSuperview];
        adView = nil;
        
        adView = [AdView adScrollViewWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)  \
                                          imageLinkURL:imagesURL\
                                   placeHoderImageName:@"默认图片" \
                                  pageControlShowStyle:UIPageControlShowStyleNone];
        
        // 是否需要支持定时循环滚动，默认为YES
        adView.isNeedCycleRoll = NO;
        
        adView.callBack = ^(NSInteger index,NSString * imageURL)
        {
            NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
        };
        [self.view addSubview:adView];
        [self.view sendSubviewToBack:adView];
    }
}

#pragma mark 初始化拖拽视图
- (void)initPanScrollView {
    
    // 底部视图的高度
    _bottomViewHeight.constant = ScreenWidth * 40/375;
    
    // 主要的承载所有自控件的父视图
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-topHeight-secondHeight+10, ScreenWidth, mainViewHeight)];
    [self.view addSubview:mainView];
    [self.view sendSubviewToBack:mainView];
    
    [self initScrollViewInMainView];
    
    // 添加拖动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [mainView addGestureRecognizer:panGestureRecognizer];
    
    UIImageView *topImgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topHeight+secondHeight)];
    topImgBack.image = [UIImage imageNamed:@"白色底块"];
    [mainView addSubview:topImgBack];
    [mainView sendSubviewToBack:topImgBack];
    
    /*****************  topview布局    ******************/
    // 向上的圈
    CGFloat imgWidth = ScreenWidth * 42 / 375;
    UIImageView *upImageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-imgWidth)/2, ScreenWidth*3/375, imgWidth, imgWidth)];
    upImageV.image = [UIImage imageNamed:@"向上圈"];
    [mainView addSubview:upImageV];
    
    // 商品名称
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, topHeight-20, ScreenWidth/2, 20)];
    nameLab.text = @"时尚飘花手镯";
    nameLab.font = [UIFont systemFontOfSize:20.f];
    [mainView addSubview:nameLab];
    
    // topView 的 7
    CGFloat iconWidth = ScreenWidth * 19 / 375;
    UIImageView *sevenImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-iconWidth, topHeight-iconWidth, iconWidth, iconWidth)];
    sevenImgV.image = [UIImage imageNamed:@"7"];
    [mainView addSubview:sevenImgV];
    // topView 的 正
    UIImageView *tureView = [[UIImageView alloc] initWithFrame:CGRectMake(sevenImgV.origin.x-5-iconWidth, topHeight-iconWidth, iconWidth, iconWidth)];
    tureView.image = [UIImage imageNamed:@"正"];
    [mainView addSubview:tureView];
    // topView 的 A
    UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(tureView.origin.x-5-iconWidth, topHeight-iconWidth, iconWidth, iconWidth)];
    aView.image = [UIImage imageNamed:@"A"];
    [mainView addSubview:aView];
    
    // 向下的圈
    UIImageView *downImageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-imgWidth)/2, topHeight, imgWidth, imgWidth)];
    downImageV.image = [UIImage imageNamed:@"向下圈"];
    [mainView addSubview:downImageV];
    
    /************************   添加购买按钮的view  ************************/
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, topHeight+secondHeight+scrollViewHeight, ScreenWidth, btnViewHeight)];
    [mainView addSubview:btnView];
    
    UIView *btnMaskView = [[UIView alloc] initWithFrame:btnView.frame];
    btnMaskView.backgroundColor = [UIColor whiteColor];
    btnMaskView.alpha = 0.9;
    [mainView addSubview:btnMaskView];
    [mainView sendSubviewToBack:btnMaskView];
    
    // 空白手势事件，覆盖之前的拖拽手势
    UIPanGestureRecognizer *maskGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(maskAction:)];
    [btnView addGestureRecognizer:maskGesture];
    
    // 立即拿着
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*75/375)/2, ScreenWidth*10/375, ScreenWidth*75/375, ScreenWidth*75/375)];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"立即拿着"] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchDown];
    [btnView addSubview:buyBtn];
    
    
    UILabel *buyLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*100/375)/2, ScreenWidth*90/375, 100, 15)];
    buyLab.text = @"立即拿着";
    buyLab.textColor = [UIColor darkGrayColor];
    buyLab.font = [UIFont systemFontOfSize:13.f];
    buyLab.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:buyLab];
    
    // 喜欢
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(buyBtn.origin.x-ScreenWidth*86/375, ScreenWidth*22/375, ScreenWidth*56/375, ScreenWidth*56/375)];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:likeBtn];
    
    likeLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*100/375)/2, ScreenWidth*92/375, 100, 15)];
    likeLab.text = @"107喜欢";
    likeLab.textColor = [UIColor darkGrayColor];
    likeLab.font = [UIFont systemFontOfSize:13.f];
    likeLab.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:likeLab];
    likeLab.center = CGPointMake(likeBtn.centerX, CGRectGetMaxY(likeBtn.frame)+ScreenWidth*12.5/375);
    
    // 收藏
    collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buyBtn.frame)+ScreenWidth*30/375, ScreenWidth*22/375, ScreenWidth*56/375, ScreenWidth*56/375)];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [collectionBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:collectionBtn];
    
    collectionLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*100/375)/2, ScreenWidth*92/375, 100, 15)];
    collectionLab.text = @"25收藏";
    collectionLab.textColor = [UIColor darkGrayColor];
    collectionLab.font = [UIFont systemFontOfSize:13.f];
    collectionLab.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:collectionLab];
    collectionLab.center = CGPointMake(collectionBtn.centerX, CGRectGetMaxY(collectionBtn.frame)+ScreenWidth*12.5/375);
}

#pragma mark 初始化mainview中的scrollview
- (void)initScrollViewInMainView {
    // 添加scrollview
    myScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topHeight+secondHeight, ScreenWidth, scrollViewHeight)];
    myScrollV.delegate = self;
    myScrollV.backgroundColor = [UIColor clearColor];
    myScrollV.bounces = NO;
    [mainView addSubview:myScrollV];
    
    UIView *scrollMaskView = [[UIView alloc] initWithFrame:myScrollV.frame];
    scrollMaskView.backgroundColor = [UIColor whiteColor];
    scrollMaskView.alpha = 0.9;
    [mainView addSubview:scrollMaskView];
    [mainView sendSubviewToBack:scrollMaskView];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 20)];
    nameLabel.text = @"时尚飘花手镯";
    nameLabel.font = [UIFont systemFontOfSize:20.f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:nameLabel];
    
    CGFloat iconWidth = ScreenWidth * 19 / 375;
    // myScrollV 的 正
    UIImageView *tureView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-iconWidth)/2, CGRectGetMaxY(nameLabel.frame)+20, iconWidth, iconWidth)];
    tureView.image = [UIImage imageNamed:@"正"];
    [myScrollV addSubview:tureView];
    // myScrollV 的 A
    UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(tureView.origin.x-5-iconWidth, tureView.origin.y, iconWidth, iconWidth)];
    aView.image = [UIImage imageNamed:@"A"];
    [myScrollV addSubview:aView];
    // myScrollV 的 7
    UIImageView *sevenImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tureView.frame)+5, tureView.origin.y, iconWidth, iconWidth)];
    sevenImgV.image = [UIImage imageNamed:@"7"];
    [myScrollV addSubview:sevenImgV];
    
    // 虚线
    UIImageView *dotLine1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(tureView.frame)+20, ScreenWidth*200/375, 1)];
    dotLine1.image = [UIImage imageNamed:@"虚线"];
    [myScrollV addSubview:dotLine1];
    
    // 会员价
    NSString *priceStr = @"30000";
    CGSize limitSzie = CGSizeMake(MAXFLOAT, 20.f);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
    // 根据获取到的字符串以及字体计算label需要的size
    CGSize priceSize = [priceStr boundingRectWithSize:limitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    priceLab = [[UILabel alloc] init];
    priceLab.text = priceStr;
    priceLab.textColor = darkRedColor;
    priceLab.font = [UIFont systemFontOfSize:22.f];
    [myScrollV addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dotLine1.mas_bottom).with.offset(12);
        make.height.mas_equalTo(priceSize.height);
        make.left.equalTo(myScrollV.mas_left).with.offset((ScreenWidth-priceSize.width+5-55)/2+55);
        make.width.mas_equalTo(priceSize.width+5);
    }];
    UILabel *VIP = [[UILabel alloc] init];
    VIP.text = @"会员价￥";
    VIP.font = contentFont;
    VIP.textAlignment = NSTextAlignmentRight;
    VIP.textColor = darkRedColor;
    [myScrollV addSubview:VIP];
    [VIP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dotLine1.mas_bottom).with.offset(20);
        make.height.mas_equalTo(15);
        make.right.equalTo(priceLab.mas_left);
        make.width.mas_equalTo(55);
    }];
    
    // 市场价
    NSString *maketStr = @"市场价￥65000";
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:maketStr];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [maketStr length])];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0x999999, 1) range:NSMakeRange(2, length-2)];
    
    mPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dotLine1.frame)+45, ScreenWidth, 15)];
    [mPriceLab setAttributedText:attri];
    mPriceLab.textColor = [UIColor darkGrayColor];
    mPriceLab.font = contentFont;
    mPriceLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:mPriceLab];
    
    // 虚线2
    UIImageView *dotLine2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(mPriceLab.frame)+20, ScreenWidth*200/375, 1)];
    dotLine2.image = [UIImage imageNamed:@"虚线"];
    [myScrollV addSubview:dotLine2];
    
    // 品牌
    brandLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dotLine2.frame)+20, ScreenWidth, 15)];
    brandLab.text = @"品牌：玉根国脉";
    brandLab.textColor = [UIColor darkGrayColor];
    brandLab.font = contentFont;
    brandLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:brandLab];
    
    // 编号
    IDLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(brandLab.frame)+15, ScreenWidth, 15)];
    IDLab.text = @"编号：YZ302222";
    IDLab.textColor = [UIColor darkGrayColor];
    IDLab.font = contentFont;
    IDLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:IDLab];
    
    // 虚线3
    UIImageView *dotLine3 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(IDLab.frame)+20, ScreenWidth*200/375, 1)];
    dotLine3.image = [UIImage imageNamed:@"虚线"];
    [myScrollV addSubview:dotLine3];
    
    // 尺寸
    UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dotLine3.frame)+20, ScreenWidth, 15)];
    sizeLab.text = @"尺寸：直径55MM/高14.48MM";
    sizeLab.textColor = [UIColor darkGrayColor];
    sizeLab.font = contentFont;
    sizeLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:sizeLab];
    
    // 重量
    UILabel *weightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sizeLab.frame)+15, ScreenWidth, 15)];
    weightLab.text = @"重量：42.4g";
    weightLab.textColor = [UIColor darkGrayColor];
    weightLab.font = contentFont;
    weightLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:weightLab];
    
    // 材质品种
    UILabel *materialLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weightLab.frame)+15, ScreenWidth, 15)];
    materialLab.text = @"材质品种：岫玉冰种";
    materialLab.textColor = [UIColor darkGrayColor];
    materialLab.font = contentFont;
    materialLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:materialLab];
    
    // 颜色
    UILabel *colorLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(materialLab.frame)+15, ScreenWidth, 15)];
    colorLab.text = @"颜色：火青石";
    colorLab.textColor = [UIColor darkGrayColor];
    colorLab.font = contentFont;
    colorLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:colorLab];
    
    // 硬度
    UILabel *hardnessLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(colorLab.frame)+15, ScreenWidth, 15)];
    hardnessLab.text = @"硬度：5.5";
    hardnessLab.textColor = [UIColor darkGrayColor];
    hardnessLab.font = contentFont;
    hardnessLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:hardnessLab];
    
    // 编号
    UILabel *setLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hardnessLab.frame)+15, ScreenWidth, 15)];
    setLab.text = @"镶嵌/配饰：无";
    setLab.textColor = [UIColor darkGrayColor];
    setLab.font = contentFont;
    setLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:setLab];
    
    // 虚线4
    dotLine4 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(setLab.frame)+20, ScreenWidth*200/375, 1)];
    dotLine4.image = [UIImage imageNamed:@"虚线"];
    [myScrollV addSubview:dotLine4];
    
    // 销量
    NSString *saleStr = @"128";
    CGSize saleLimitSzie = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSDictionary *saleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:30.f]};
    // 根据获取到的字符串以及字体计算label需要的size
    CGSize saleSize = [saleStr boundingRectWithSize:saleLimitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:saleAttribute context:nil].size;
    saleLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-saleSize.width)/2 - 5, CGRectGetMaxY(dotLine4.frame)+15, saleSize.width, saleSize.height)];
    saleLab.text = saleStr;
    saleLab.textColor = darkRedColor;
    saleLab.font = [UIFont systemFontOfSize:30.f];
    [myScrollV addSubview:saleLab];

    // 红色向上箭头
    UIImageView *redArrow = [[UIImageView alloc] init];
//    redArrow.backgroundColor = [UIColor redColor];
    [myScrollV addSubview:redArrow];
    [redArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dotLine4.mas_bottom).with.offset(15);
        make.height.mas_equalTo(22);
        make.left.equalTo(saleLab.mas_right).with.offset(5);
        make.width.mas_equalTo(9);
    }];
    redArrow.image = [UIImage imageNamed:@"向上红箭头"];
    
    // 销量图标
    UIImageView *saleIcon = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-27)/2, CGRectGetMaxY(saleLab.frame), 27, 19)];
    saleIcon.image = [UIImage imageNamed:@"销量图标"];
    [myScrollV addSubview:saleIcon];
    
    // 两条线
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(saleIcon.origin.x-45, CGRectGetMaxY(saleLab.frame)+9, 40, 0.5)];
    leftLine.backgroundColor = [UIColor darkGrayColor];
    [myScrollV addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(saleIcon.origin.x+saleIcon.frame.size.width+5, CGRectGetMaxY(saleLab.frame)+9, 40, 0.5)];
    rightLine.backgroundColor = [UIColor darkGrayColor];
    [myScrollV addSubview:rightLine];
    
    // 销量label
    UILabel *saleNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(saleIcon.frame)+5, ScreenWidth, 15)];
    saleNumLab.text = @"30天销量";
    saleNumLab.textColor = [UIColor darkGrayColor];
    saleNumLab.font = contentFont;
    saleNumLab.textAlignment = NSTextAlignmentCenter;
    [myScrollV addSubview:saleNumLab];
    
    // 虚线5
    UIImageView *dotLine5 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(saleNumLab.frame)+20, ScreenWidth*200/375, 1)];
    dotLine5.image = [UIImage imageNamed:@"虚线"];
    [myScrollV addSubview:dotLine5];
    
    /*****************  评价  ********************/
    // 评价总数
    UIImageView *evaluationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-38, CGRectGetMaxY(dotLine5.frame)+22, 15, 11)];
    evaluationIcon.image = [UIImage imageNamed:@"评论"];
    [myScrollV addSubview:evaluationIcon];
    
    evaluationLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-18, CGRectGetMaxY(dotLine5.frame)+20, 120, 15)];
    evaluationLab.text = @"评价39条";
    evaluationLab.textColor = [UIColor darkGrayColor];
    evaluationLab.font = contentFont;
    evaluationLab.textAlignment = NSTextAlignmentLeft;
    [myScrollV addSubview:evaluationLab];
    
    /*****************  第一条评价  ********************/
    starLvIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(evaluationLab.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375)];
    starLvIcon1.image = [UIImage imageNamed:@"五星"];
    [myScrollV addSubview:starLvIcon1];
    
    NSString *contentStr1 = @"不错，很时尚，好搭衣服";
    CGSize limitSzie1 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
    NSDictionary *contentAttribute1 = @{NSFontAttributeName:contentFont};
    // 根据获取到的字符串以及字体计算label需要的size
    CGSize contentSize1 = [contentStr1 boundingRectWithSize:limitSzie1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute1 context:nil].size;
    contentLab1 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-contentSize1.width)/2, CGRectGetMaxY(starLvIcon1.frame)+5, contentSize1.width, contentSize1.height)];
    contentLab1.text = contentStr1;
    contentLab1.textColor = [UIColor darkGrayColor];
    contentLab1.font = contentFont;
    [myScrollV addSubview:contentLab1];
    
    time1 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab1.frame)+3, ScreenWidth*200/375, 10)];
    time1.text = @"2小时前";
    time1.textColor = [UIColor darkGrayColor];
    time1.textAlignment = NSTextAlignmentCenter;
    time1.font = [UIFont systemFontOfSize:11.f];
    [myScrollV addSubview:time1];
    
    source1 = [[UILabel alloc] initWithFrame:CGRectMake(time1.frame.origin.x, CGRectGetMaxY(time1.frame)+5, ScreenWidth*200/375, 10)];
    source1.text = @"来自 紫色胡萝卜";
    source1.textColor = [UIColor darkGrayColor];
    source1.textAlignment = NSTextAlignmentCenter;
    source1.font = [UIFont systemFontOfSize:11.f];
    [myScrollV addSubview:source1];
    
    /*****************  第二条评价  ********************/
    starLvIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source1.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375)];
    starLvIcon2.image = [UIImage imageNamed:@"五星"];
    [myScrollV addSubview:starLvIcon2];
    
    NSString *contentStr2 = @"挺好的，颜色喜欢";
    // 根据获取到的字符串以及字体计算label需要的size
    CGSize contentSize2 = [contentStr2 boundingRectWithSize:limitSzie1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute1 context:nil].size;
    contentLab2 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-contentSize2.width)/2, CGRectGetMaxY(starLvIcon2.frame)+5, contentSize2.width, contentSize2.height)];
    contentLab2.text = contentStr2;
    contentLab2.textColor = [UIColor darkGrayColor];
    contentLab2.font = contentFont;
    [myScrollV addSubview:contentLab2];
    
    time2 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab2.frame)+3, ScreenWidth*200/375, 10)];
    time2.text = @"2小时前";
    time2.textColor = [UIColor darkGrayColor];
    time2.textAlignment = NSTextAlignmentCenter;
    time2.font = [UIFont systemFontOfSize:11.f];
    [myScrollV addSubview:time2];
    
    source2 = [[UILabel alloc] initWithFrame:CGRectMake(time2.frame.origin.x, CGRectGetMaxY(time2.frame)+5, ScreenWidth*200/375, 10)];
    source2.text = @"来自 紫色胡萝卜";
    source2.textColor = [UIColor darkGrayColor];
    source2.textAlignment = NSTextAlignmentCenter;
    source2.font = [UIFont systemFontOfSize:11.f];
    [myScrollV addSubview:source2];
    
    /*****************  第三条评价  ********************/
    starLvIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source2.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375)];
    starLvIcon3.image = [UIImage imageNamed:@"五星"];
    [myScrollV addSubview:starLvIcon3];
    
    NSString *contentStr3 = @"第二次购买，服务很满意";
    // 根据获取到的字符串以及字体计算label需要的size
    CGSize contentSize3 = [contentStr3 boundingRectWithSize:limitSzie1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute1 context:nil].size;
    contentLab3 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-contentSize3.width)/2, CGRectGetMaxY(starLvIcon3.frame)+5, contentSize3.width, contentSize3.height)];
    contentLab3.text = contentStr3;
    contentLab3.textColor = [UIColor darkGrayColor];
    contentLab3.font = contentFont;
    [myScrollV addSubview:contentLab3];
    
    time3 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab3.frame)+3, ScreenWidth*200/375, 10)];
    time3.text = @"2小时前";
    time3.textColor = [UIColor darkGrayColor];
    time3.textAlignment = NSTextAlignmentCenter;
    time3.font = [UIFont systemFontOfSize:11.f];
    [myScrollV addSubview:time3];
    
    source3 = [[UILabel alloc] initWithFrame:CGRectMake(time3.frame.origin.x, CGRectGetMaxY(time3.frame)+5, ScreenWidth*200/375, 10)];
    source3.text = @"来自 紫色胡萝卜";
    source3.textColor = [UIColor darkGrayColor];
    source3.textAlignment = NSTextAlignmentCenter;
    source3.font = [UIFont systemFontOfSize:11.f];
    [myScrollV addSubview:source3];
    
    myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source3.frame)+ScreenWidth*10/375);
    
    //    UIView *scrollMaskV = [[UIView alloc] initWithFrame:myScrollV.frame];
    //    [mainView addSubview:scrollMaskV];
    //
    //    scrollPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollPan:)];
    //    [scrollMaskV addGestureRecognizer:scrollPan];
}
                        
#pragma mark UIScrollViewDelegate

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y == 0.f) {
//        [scrollView addGestureRecognizer:panGestureRecognizer];
//    }
}


#pragma mark 拖拽手势事件
- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded ) { // 松手
        
        if (canPan) {
            if (isTop) {
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    recognizer.view.frame = CGRectMake(0, 64-ScreenWidth*89/375, ScreenWidth, mainViewHeight);
                } completion:^(BOOL finished) {
                    
                    isTop = YES;
                    
                }];
                return;
            }
            
            if (!isTop) {
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    recognizer.view.frame = CGRectMake(0, ScreenHeight-topHeight-secondHeight+10, ScreenWidth, mainViewHeight);
                } completion:^(BOOL finished) {
                    
                    isTop = NO;
                    
                }];
                return;
            }
        } else {
            canPan = YES;
            return;
        }

    }
    
    if (!canPan) {
        return;
    }
    
        /***************   没松手，又能滑   ***************/
        if (!isTop && recognizer.view.origin.y < ScreenHeight-topHeight-secondHeight+10-ScreenWidth*150/375) {
            
            canPan = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                recognizer.view.frame = CGRectMake(0, 64-ScreenWidth*89/375, ScreenWidth, mainViewHeight);
            } completion:^(BOOL finished) {
                
                isTop = YES;
                
            }];
            return;
        }
        if (isTop && recognizer.view.origin.y > 64-ScreenWidth*89/375 + ScreenWidth*150/375) {
            
            canPan = NO;

            [UIView animateWithDuration:0.2 animations:^{
                recognizer.view.frame = CGRectMake(0, ScreenHeight-topHeight-secondHeight+10, ScreenWidth, mainViewHeight);
            } completion:^(BOOL finished) {
               
                isTop = NO;
                
            }];
            return;
        }
    
        recognizer.view.center = CGPointMake(ScreenWidth/2, recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
    
    
}

//- (void)scrollPan:(UIPanGestureRecognizer *)sender {
//    CGPoint translation = [sender translationInView:self.view];
//    if (translation.y < 0) {
//        myScrollV.contentOffset = CGPointMake(0, myScrollV.contentOffset.y-translation.y);
//        [sender setTranslation:CGPointZero inView:self.view];
//        NSLog(@"%f",myScrollV.contentOffset.y);
//        return;
//    }
//    
//    if (myScrollV.contentOffset.y == 0.f) {
//        NSLog(@"到顶了，干别的事");
//    } else {
//        
//        myScrollV.contentOffset = CGPointMake(0, myScrollV.contentOffset.y-translation.y);
//        [sender setTranslation:CGPointZero inView:self.view];
//    }
//    NSLog(@"%f",myScrollV.contentOffset.y);
//}

#pragma mark 空白手势
- (void)maskAction:(UIPanGestureRecognizer *)sender {
    
}

#pragma mark 请求商品数据
- (void)setGoodID:(int)goodID {
    _goodID = goodID;
    
    [self requestGoodDetailData];
}

- (void)requestGoodDetailData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters;
    
    if(user.userId && [[user.userId trim] isNotEqualsToString:emptyString] )
    {
        parameters = @{
                       @"userId":user.userId,
                       @"goodsId":[NSNumber numberWithInt:self.goodID]
                      };
    } else {
        parameters = @{
                       @"userId":[NSNumber numberWithInt:0],
                       @"goodsId":[NSNumber numberWithInt:self.goodID]
                       };
    }
    
    [handler postURLStr:webGoodsDetail postDic:parameters
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
             goodDetailModel = [GoodDetailModel objectWithKeyValues:retInfo];
             
             DetailModel *detailModel = goodDetailModel.goodsDetail;
             detailModel.goodID = [retInfo[@"goodsDetail"][@"Id"] intValue];
             
             [self createNavigationItemTitleViewWithTitle:detailModel.goodsName];
             
             [self initInterface];     //初始化商品图片轮播
             
             LastGoodModel *lastGood = goodDetailModel.lastOne;
             _lastGoodNameLab.text = [NSString stringWithFormat:@"上一个 %@",lastGood.lastOneName];
             
             NextGoodModel *nextGood = goodDetailModel.nextOne;
             _nextGoodNameLab.text = [NSString stringWithFormat:@"%@ 下一个",nextGood.nextOneName];
             
             nameLab.text = detailModel.goodsName;
             nameLabel.text = detailModel.goodsName;
             
             likeLab.text = [NSString stringWithFormat:@"%d喜欢",detailModel.TotalLike];
             collectionLab.text = [NSString stringWithFormat:@"%d收藏",detailModel.TotalCollection];
             
             // 会员价
             NSString *priceStr = [NSString stringWithFormat:@"%.f",detailModel.MarketPrice];
             CGSize limitSzie = CGSizeMake(MAXFLOAT, 20.f);
             NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
             // 根据获取到的字符串以及字体计算label需要的size
             CGSize priceSize = [priceStr boundingRectWithSize:limitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
             priceLab.text = priceStr;
             [priceLab mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(myScrollV.mas_left).with.offset((ScreenWidth-priceSize.width+5-55)/2+55);
                 make.width.mas_equalTo(priceSize.width+5);
             }];
             
             // 市场价
             NSString *maketStr = [NSString stringWithFormat:@"市场价￥%.f",detailModel.MarketPrice];
             NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:maketStr];
             [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [maketStr length])];
             [mPriceLab setAttributedText:attri];
             
             // 品牌
             brandLab.text = [NSString stringWithFormat:@"品牌：%@",detailModel.shopName];
             
             // 编号
             IDLab.text = [NSString stringWithFormat:@"编号：%@",detailModel.GoodsNumber];
             
             // 销量
             NSString *saleStr = [NSString stringWithFormat:@"%d",detailModel.Sales];
             CGSize saleLimitSzie = CGSizeMake(MAXFLOAT, MAXFLOAT);
             NSDictionary *saleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:30.f]};
             // 根据获取到的字符串以及字体计算label需要的size
             CGSize saleSize = [saleStr boundingRectWithSize:saleLimitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:saleAttribute context:nil].size;
             saleLab.frame = CGRectMake((ScreenWidth-saleSize.width)/2 - 5, CGRectGetMaxY(dotLine4.frame)+15, saleSize.width, saleSize.height);
             saleLab.text = saleStr;
             
             // 评价总数
             evaluationLab.text = [NSString stringWithFormat:@"评价%d条",goodDetailModel.evaluationCount];
             
             myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(evaluationLab.frame)+ScreenWidth*10/375);
             
             /*****************  第一条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count>0) {
                 EvaluationModel *evaluation1 = goodDetailModel.goodsEvaluation[0];
                 if (evaluation1.star == 1) {
                     starLvIcon1.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation1.star == 2) {
                     starLvIcon1.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation1.star == 3) {
                     starLvIcon1.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation1.star == 4) {
                     starLvIcon1.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation1.star == 5) {
                     starLvIcon1.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr1 = evaluation1.content;
                 CGSize limitSzie1 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute1 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize1 = [contentStr1 boundingRectWithSize:limitSzie1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute1 context:nil].size;
                 contentLab1.frame = CGRectMake((ScreenWidth-contentSize1.width)/2, CGRectGetMaxY(starLvIcon1.frame)+5, contentSize1.width, contentSize1.height);
                 contentLab1.text = contentStr1;
                 
                 time1.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab1.frame)+3, ScreenWidth*200/375, 10);
                 time1.text = evaluation1.CTDATE;
                 
                 source1.frame = CGRectMake(time1.frame.origin.x, CGRectGetMaxY(time1.frame)+5, ScreenWidth*200/375, 10);
                 source1.text = [NSString stringWithFormat:@"来自 %@",evaluation1.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source1.frame)+ScreenWidth*10/375);
             }
             
             /*****************  第二条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count>1) {
                 EvaluationModel *evaluation2 = goodDetailModel.goodsEvaluation[1];
                 starLvIcon2.frame = CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source1.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375);
                 if (evaluation2.star == 1) {
                     starLvIcon2.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation2.star == 2) {
                     starLvIcon2.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation2.star == 3) {
                     starLvIcon2.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation2.star == 4) {
                     starLvIcon2.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation2.star == 5) {
                     starLvIcon2.image = [UIImage imageNamed:@"五星"];
                 }

                 NSString *contentStr2 = evaluation2.content;
                 CGSize limitSzie2 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute2 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize2 = [contentStr2 boundingRectWithSize:limitSzie2 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute2 context:nil].size;
                 contentLab2.frame = CGRectMake((ScreenWidth-contentSize2.width)/2, CGRectGetMaxY(starLvIcon2.frame)+5, contentSize2.width, contentSize2.height);
                 contentLab2.text = contentStr2;
                 
                 time2.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab2.frame)+3, ScreenWidth*200/375, 10);
                 time2.text = evaluation2.CTDATE;
                 
                 source2.frame = CGRectMake(time2.frame.origin.x, CGRectGetMaxY(time2.frame)+5, ScreenWidth*200/375, 10);
                 source2.text = [NSString stringWithFormat:@"来自 %@",evaluation2.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source2.frame)+ScreenWidth*10/375);
             }
             
             /*****************  第三条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count == 3) {
                 EvaluationModel *evaluation3 = goodDetailModel.goodsEvaluation[2];
                 starLvIcon3.frame = CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source2.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375);
                 if (evaluation3.star == 1) {
                     starLvIcon3.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation3.star == 2) {
                     starLvIcon3.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation3.star == 3) {
                     starLvIcon3.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation3.star == 4) {
                     starLvIcon3.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation3.star == 5) {
                     starLvIcon3.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr3 = evaluation3.content;
                 CGSize limitSzie3 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute3 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize3 = [contentStr3 boundingRectWithSize:limitSzie3 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute3 context:nil].size;
                 contentLab3.frame = CGRectMake((ScreenWidth-contentSize3.width)/2, CGRectGetMaxY(starLvIcon3.frame)+5, contentSize3.width, contentSize3.height);
                 contentLab3.text = contentStr3;
                 
                 time3.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab3.frame)+3, ScreenWidth*200/375, 10);
                 time3.text = evaluation3.CTDATE;
                 
                 source3.frame = CGRectMake(time3.frame.origin.x, CGRectGetMaxY(time3.frame)+5, ScreenWidth*200/375, 10);
                 source3.text = [NSString stringWithFormat:@"来自 %@",evaluation3.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source3.frame)+ScreenWidth*10/375);
             }
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 喜欢
- (void)likeAction:(UIButton *)button {
    NZFastOperate *fastOpt = [NZFastOperate sharedObject];
    if (fastOpt.isLogin) {
        
        __weak typeof(self)wSelf = self ;
        
        NZWebHandler *handler = [[NZWebHandler alloc] init] ;
        
        NZUser *user = [NZUserManager sharedObject].user;
        
        NSDictionary *parameters;
        
        UserStateModel *userState = goodDetailModel.userState;
        
        if(userState.isLike)
        {
            parameters = @{
                           @"userId":user.userId,
                           @"goodsId":[NSNumber numberWithInt:self.goodID],
                           @"likeState":[NSNumber numberWithInt:0]
                           };
        } else {
            parameters = @{
                           @"userId":user.userId,
                           @"goodsId":[NSNumber numberWithInt:self.goodID],
                           @"likeState":[NSNumber numberWithInt:1]
                           };
        }
        
        [handler postURLStr:webGoodSetLike postDic:parameters
                      block:^(NSDictionary *retInfo, NSError *error)
         {
             likeBtn.enabled = NO;
             collectionBtn.enabled = NO;
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
                 likeBtn.enabled = YES;
                 collectionBtn.enabled = YES;
                 
                 DetailModel *detailModel = goodDetailModel.goodsDetail;
                 if(userState.isLike)
                 {
                     detailModel.TotalLike -= 1;
                     userState.isLike = 0;
                     [wSelf.view makeToast:@"取消喜欢"] ;
                 } else {
                     detailModel.TotalLike += 1;
                     userState.isLike = 1;
                     [wSelf.view makeToast:@"喜欢成功"] ;
                 }
                 likeLab.text = [NSString stringWithFormat:@"%d喜欢",detailModel.TotalLike];
             }
             else
             {
                 [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
             }
         }] ;
        
    } else {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"您未登录" message:@"是否现在登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alertview show];
    }
}

#pragma mark 收藏
- (void)collectAction:(UIButton *)button {
    NZFastOperate *fastOpt = [NZFastOperate sharedObject];
    if (fastOpt.isLogin) {
        
        __weak typeof(self)wSelf = self ;
        
        NZWebHandler *handler = [[NZWebHandler alloc] init] ;
        
        NZUser *user = [NZUserManager sharedObject].user;
        
        NSDictionary *parameters;
        
        UserStateModel *userState = goodDetailModel.userState;
        
        if(userState.isCollect)
        {
            parameters = @{
                           @"userId":user.userId,
                           @"goodsId":[NSNumber numberWithInt:self.goodID],
                           @"collectState":[NSNumber numberWithInt:0]
                           };
        } else {
            parameters = @{
                           @"userId":user.userId,
                           @"goodsId":[NSNumber numberWithInt:self.goodID],
                           @"collectState":[NSNumber numberWithInt:1]
                           };
        }
        
        [handler postURLStr:webGoodSetCollection postDic:parameters
                      block:^(NSDictionary *retInfo, NSError *error)
         {
             likeBtn.enabled = NO;
             collectionBtn.enabled = NO;
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
                 likeBtn.enabled = YES;
                 collectionBtn.enabled = YES;
                 
                 DetailModel *detailModel = goodDetailModel.goodsDetail;
                 if(userState.isCollect)
                 {
                     detailModel.TotalCollection -= 1;
                     userState.isCollect = 0;
                     [wSelf.view makeToast:@"取消收藏"] ;
                 } else {
                     detailModel.TotalCollection += 1;
                     userState.isCollect = 1;
                     [wSelf.view makeToast:@"收藏成功"] ;
                 }
                 collectionLab.text = [NSString stringWithFormat:@"%d收藏",detailModel.TotalCollection];
             }
             else
             {
                 [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
             }
         }] ;
        
    } else {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"您未登录" message:@"是否现在登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alertview show];
    }
}

#pragma mark 点击立即拿着方法--跳到选择商品参数页面----许景源
- (void)buyButtonAction:(UIGestureRecognizer *)gestureRecognizer {
    
    NZOrderSelectedViewController *orderSelectedViewCtr = [[NZOrderSelectedViewController alloc] initWithNibName:@"NZOrderSelectedViewController" bundle:nil];
    orderSelectedViewCtr.goodID = self.goodID;
    [self.navigationController pushViewController:orderSelectedViewCtr animated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        alertView = nil;
    } else {
        alertView = nil;
        NZLoginViewController *loginVCTR = [[NZLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVCTR animated:YES];
    }
    
}

- (IBAction)lastGoodAction:(UIButton *)sender {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    LastGoodModel *lastGood = goodDetailModel.lastOne;
    
    NSDictionary *parameters;
    
    if(user.userId && [[user.userId trim] isNotEqualsToString:emptyString] )
    {
        parameters = @{
                       @"userId":user.userId,
                       @"goodsId":[NSNumber numberWithInt:lastGood.lastId]
                       };
    } else {
        parameters = @{
                       @"userId":[NSNumber numberWithInt:0],
                       @"goodsId":[NSNumber numberWithInt:lastGood.lastId]
                       };
    }
    
    [handler postURLStr:webGoodsDetail postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
         myScrollV.contentOffset = CGPointMake(0, 0);
         mainView.frame = CGRectMake(0, ScreenHeight-topHeight-secondHeight+10, ScreenWidth, mainViewHeight);
         
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
             goodDetailModel = [GoodDetailModel objectWithKeyValues:retInfo];
             
             DetailModel *detailModel = goodDetailModel.goodsDetail;
             detailModel.goodID = [retInfo[@"goodsDetail"][@"Id"] intValue];
             
             [self createNavigationItemTitleViewWithTitle:detailModel.goodsName];
             
             [self initInterface];     //初始化商品图片轮播
             
             LastGoodModel *lastGood = goodDetailModel.lastOne;
             _lastGoodNameLab.text = [NSString stringWithFormat:@"上一个 %@",lastGood.lastOneName];
             
             NextGoodModel *nextGood = goodDetailModel.nextOne;
             _nextGoodNameLab.text = [NSString stringWithFormat:@"%@ 下一个",nextGood.nextOneName];
             
             nameLab.text = detailModel.goodsName;
             nameLabel.text = detailModel.goodsName;
             
             likeLab.text = [NSString stringWithFormat:@"%d喜欢",detailModel.TotalLike];
             collectionLab.text = [NSString stringWithFormat:@"%d收藏",detailModel.TotalCollection];
             
             // 会员价
             NSString *priceStr = [NSString stringWithFormat:@"%.f",detailModel.MarketPrice];
             CGSize limitSzie = CGSizeMake(MAXFLOAT, 20.f);
             NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
             // 根据获取到的字符串以及字体计算label需要的size
             CGSize priceSize = [priceStr boundingRectWithSize:limitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
             priceLab.text = priceStr;
             [priceLab mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(myScrollV.mas_left).with.offset((ScreenWidth-priceSize.width+5-55)/2+55);
                 make.width.mas_equalTo(priceSize.width+5);
             }];
             
             // 市场价
             NSString *maketStr = [NSString stringWithFormat:@"市场价￥%.f",detailModel.MarketPrice];
             NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:maketStr];
             [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [maketStr length])];
             [mPriceLab setAttributedText:attri];
             
             // 品牌
             brandLab.text = [NSString stringWithFormat:@"品牌：%@",detailModel.shopName];
             
             // 编号
             IDLab.text = [NSString stringWithFormat:@"编号：%@",detailModel.GoodsNumber];
             
             // 销量
             NSString *saleStr = [NSString stringWithFormat:@"%d",detailModel.Sales];
             CGSize saleLimitSzie = CGSizeMake(MAXFLOAT, MAXFLOAT);
             NSDictionary *saleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:30.f]};
             // 根据获取到的字符串以及字体计算label需要的size
             CGSize saleSize = [saleStr boundingRectWithSize:saleLimitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:saleAttribute context:nil].size;
             saleLab.frame = CGRectMake((ScreenWidth-saleSize.width)/2 - 5, CGRectGetMaxY(dotLine4.frame)+15, saleSize.width, saleSize.height);
             saleLab.text = saleStr;
             
             // 评价总数
             evaluationLab.text = [NSString stringWithFormat:@"评价%d条",goodDetailModel.evaluationCount];
             
             myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(evaluationLab.frame)+ScreenWidth*10/375);
             
             /*****************  第一条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count>0) {
                 EvaluationModel *evaluation1 = goodDetailModel.goodsEvaluation[0];
                 if (evaluation1.star == 1) {
                     starLvIcon1.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation1.star == 2) {
                     starLvIcon1.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation1.star == 3) {
                     starLvIcon1.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation1.star == 4) {
                     starLvIcon1.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation1.star == 5) {
                     starLvIcon1.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr1 = evaluation1.content;
                 CGSize limitSzie1 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute1 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize1 = [contentStr1 boundingRectWithSize:limitSzie1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute1 context:nil].size;
                 contentLab1.frame = CGRectMake((ScreenWidth-contentSize1.width)/2, CGRectGetMaxY(starLvIcon1.frame)+5, contentSize1.width, contentSize1.height);
                 contentLab1.text = contentStr1;
                 
                 time1.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab1.frame)+3, ScreenWidth*200/375, 10);
                 time1.text = evaluation1.CTDATE;
                 
                 source1.frame = CGRectMake(time1.frame.origin.x, CGRectGetMaxY(time1.frame)+5, ScreenWidth*200/375, 10);
                 source1.text = [NSString stringWithFormat:@"来自 %@",evaluation1.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source1.frame)+ScreenWidth*10/375);
             }
             
             /*****************  第二条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count>1) {
                 EvaluationModel *evaluation2 = goodDetailModel.goodsEvaluation[1];
                 starLvIcon2.frame = CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source1.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375);
                 if (evaluation2.star == 1) {
                     starLvIcon2.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation2.star == 2) {
                     starLvIcon2.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation2.star == 3) {
                     starLvIcon2.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation2.star == 4) {
                     starLvIcon2.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation2.star == 5) {
                     starLvIcon2.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr2 = evaluation2.content;
                 CGSize limitSzie2 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute2 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize2 = [contentStr2 boundingRectWithSize:limitSzie2 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute2 context:nil].size;
                 contentLab2.frame = CGRectMake((ScreenWidth-contentSize2.width)/2, CGRectGetMaxY(starLvIcon2.frame)+5, contentSize2.width, contentSize2.height);
                 contentLab2.text = contentStr2;
                 
                 time2.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab2.frame)+3, ScreenWidth*200/375, 10);
                 time2.text = evaluation2.CTDATE;
                 
                 source2.frame = CGRectMake(time2.frame.origin.x, CGRectGetMaxY(time2.frame)+5, ScreenWidth*200/375, 10);
                 source2.text = [NSString stringWithFormat:@"来自 %@",evaluation2.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source2.frame)+ScreenWidth*10/375);
             }
             
             /*****************  第三条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count == 3) {
                 EvaluationModel *evaluation3 = goodDetailModel.goodsEvaluation[2];
                 starLvIcon3.frame = CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source2.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375);
                 if (evaluation3.star == 1) {
                     starLvIcon3.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation3.star == 2) {
                     starLvIcon3.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation3.star == 3) {
                     starLvIcon3.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation3.star == 4) {
                     starLvIcon3.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation3.star == 5) {
                     starLvIcon3.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr3 = evaluation3.content;
                 CGSize limitSzie3 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute3 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize3 = [contentStr3 boundingRectWithSize:limitSzie3 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute3 context:nil].size;
                 contentLab3.frame = CGRectMake((ScreenWidth-contentSize3.width)/2, CGRectGetMaxY(starLvIcon3.frame)+5, contentSize3.width, contentSize3.height);
                 contentLab3.text = contentStr3;
                 
                 time3.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab3.frame)+3, ScreenWidth*200/375, 10);
                 time3.text = evaluation3.CTDATE;
                 
                 source3.frame = CGRectMake(time3.frame.origin.x, CGRectGetMaxY(time3.frame)+5, ScreenWidth*200/375, 10);
                 source3.text = [NSString stringWithFormat:@"来自 %@",evaluation3.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source3.frame)+ScreenWidth*10/375);
             }
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

- (IBAction)nextGoodAction:(UIButton *)sender {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NextGoodModel *nextGood = goodDetailModel.nextOne;
    
    NSDictionary *parameters;
    
    if(user.userId && [[user.userId trim] isNotEqualsToString:emptyString] )
    {
        parameters = @{
                       @"userId":user.userId,
                       @"goodsId":[NSNumber numberWithInt:nextGood.nextId]
                       };
    } else {
        parameters = @{
                       @"userId":[NSNumber numberWithInt:0],
                       @"goodsId":[NSNumber numberWithInt:nextGood.nextId]
                       };
    }
    
    [handler postURLStr:webGoodsDetail postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
         myScrollV.contentOffset = CGPointMake(0, 0);
         mainView.frame = CGRectMake(0, ScreenHeight-topHeight-secondHeight+10, ScreenWidth, mainViewHeight);
         
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
             goodDetailModel = [GoodDetailModel objectWithKeyValues:retInfo];
             
             DetailModel *detailModel = goodDetailModel.goodsDetail;
             detailModel.goodID = [retInfo[@"goodsDetail"][@"Id"] intValue];
             
             [self createNavigationItemTitleViewWithTitle:detailModel.goodsName];
             
             [self initInterface];     //初始化商品图片轮播
             
             LastGoodModel *lastGood = goodDetailModel.lastOne;
             _lastGoodNameLab.text = [NSString stringWithFormat:@"上一个 %@",lastGood.lastOneName];
             
             NextGoodModel *nextGood = goodDetailModel.nextOne;
             _nextGoodNameLab.text = [NSString stringWithFormat:@"%@ 下一个",nextGood.nextOneName];
             
             nameLab.text = detailModel.goodsName;
             nameLabel.text = detailModel.goodsName;
             
             likeLab.text = [NSString stringWithFormat:@"%d喜欢",detailModel.TotalLike];
             collectionLab.text = [NSString stringWithFormat:@"%d收藏",detailModel.TotalCollection];
             
             // 会员价
             NSString *priceStr = [NSString stringWithFormat:@"%.f",detailModel.MarketPrice];
             CGSize limitSzie = CGSizeMake(MAXFLOAT, 20.f);
             NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
             // 根据获取到的字符串以及字体计算label需要的size
             CGSize priceSize = [priceStr boundingRectWithSize:limitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
             priceLab.text = priceStr;
             [priceLab mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(myScrollV.mas_left).with.offset((ScreenWidth-priceSize.width+5-55)/2+55);
                 make.width.mas_equalTo(priceSize.width+5);
             }];
             
             // 市场价
             NSString *maketStr = [NSString stringWithFormat:@"市场价￥%.f",detailModel.MarketPrice];
             NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:maketStr];
             [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [maketStr length])];
             [mPriceLab setAttributedText:attri];
             
             // 品牌
             brandLab.text = [NSString stringWithFormat:@"品牌：%@",detailModel.shopName];
             
             // 编号
             IDLab.text = [NSString stringWithFormat:@"编号：%@",detailModel.GoodsNumber];
             
             // 销量
             NSString *saleStr = [NSString stringWithFormat:@"%d",detailModel.Sales];
             CGSize saleLimitSzie = CGSizeMake(MAXFLOAT, MAXFLOAT);
             NSDictionary *saleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:30.f]};
             // 根据获取到的字符串以及字体计算label需要的size
             CGSize saleSize = [saleStr boundingRectWithSize:saleLimitSzie options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:saleAttribute context:nil].size;
             saleLab.frame = CGRectMake((ScreenWidth-saleSize.width)/2 - 5, CGRectGetMaxY(dotLine4.frame)+15, saleSize.width, saleSize.height);
             saleLab.text = saleStr;
             
             // 评价总数
             evaluationLab.text = [NSString stringWithFormat:@"评价%d条",goodDetailModel.evaluationCount];
             
             myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(evaluationLab.frame)+ScreenWidth*10/375);
             
             /*****************  第一条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count>0) {
                 EvaluationModel *evaluation1 = goodDetailModel.goodsEvaluation[0];
                 if (evaluation1.star == 1) {
                     starLvIcon1.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation1.star == 2) {
                     starLvIcon1.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation1.star == 3) {
                     starLvIcon1.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation1.star == 4) {
                     starLvIcon1.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation1.star == 5) {
                     starLvIcon1.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr1 = evaluation1.content;
                 CGSize limitSzie1 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute1 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize1 = [contentStr1 boundingRectWithSize:limitSzie1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute1 context:nil].size;
                 contentLab1.frame = CGRectMake((ScreenWidth-contentSize1.width)/2, CGRectGetMaxY(starLvIcon1.frame)+5, contentSize1.width, contentSize1.height);
                 contentLab1.text = contentStr1;
                 
                 time1.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab1.frame)+3, ScreenWidth*200/375, 10);
                 time1.text = evaluation1.CTDATE;
                 
                 source1.frame = CGRectMake(time1.frame.origin.x, CGRectGetMaxY(time1.frame)+5, ScreenWidth*200/375, 10);
                 source1.text = [NSString stringWithFormat:@"来自 %@",evaluation1.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source1.frame)+ScreenWidth*10/375);
             }
             
             /*****************  第二条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count>1) {
                 EvaluationModel *evaluation2 = goodDetailModel.goodsEvaluation[1];
                 starLvIcon2.frame = CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source1.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375);
                 if (evaluation2.star == 1) {
                     starLvIcon2.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation2.star == 2) {
                     starLvIcon2.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation2.star == 3) {
                     starLvIcon2.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation2.star == 4) {
                     starLvIcon2.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation2.star == 5) {
                     starLvIcon2.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr2 = evaluation2.content;
                 CGSize limitSzie2 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute2 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize2 = [contentStr2 boundingRectWithSize:limitSzie2 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute2 context:nil].size;
                 contentLab2.frame = CGRectMake((ScreenWidth-contentSize2.width)/2, CGRectGetMaxY(starLvIcon2.frame)+5, contentSize2.width, contentSize2.height);
                 contentLab2.text = contentStr2;
                 
                 time2.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab2.frame)+3, ScreenWidth*200/375, 10);
                 time2.text = evaluation2.CTDATE;
                 
                 source2.frame = CGRectMake(time2.frame.origin.x, CGRectGetMaxY(time2.frame)+5, ScreenWidth*200/375, 10);
                 source2.text = [NSString stringWithFormat:@"来自 %@",evaluation2.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source2.frame)+ScreenWidth*10/375);
             }
             
             /*****************  第三条评价  ********************/
             if (goodDetailModel.goodsEvaluation.count == 3) {
                 EvaluationModel *evaluation3 = goodDetailModel.goodsEvaluation[2];
                 starLvIcon3.frame = CGRectMake((ScreenWidth-ScreenWidth*72/375)/2, CGRectGetMaxY(source2.frame)+20, ScreenWidth*72/375, ScreenWidth*11/375);
                 if (evaluation3.star == 1) {
                     starLvIcon3.image = [UIImage imageNamed:@"一星"];
                 } else if (evaluation3.star == 2) {
                     starLvIcon3.image = [UIImage imageNamed:@"二星"];
                 } else if (evaluation3.star == 3) {
                     starLvIcon3.image = [UIImage imageNamed:@"三星"];
                 } else if (evaluation3.star == 4) {
                     starLvIcon3.image = [UIImage imageNamed:@"四星"];
                 } else if (evaluation3.star == 5) {
                     starLvIcon3.image = [UIImage imageNamed:@"五星"];
                 }
                 
                 NSString *contentStr3 = evaluation3.content;
                 CGSize limitSzie3 = CGSizeMake(ScreenWidth*200/375, MAXFLOAT);
                 NSDictionary *contentAttribute3 = @{NSFontAttributeName:contentFont};
                 // 根据获取到的字符串以及字体计算label需要的size
                 CGSize contentSize3 = [contentStr3 boundingRectWithSize:limitSzie3 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute3 context:nil].size;
                 contentLab3.frame = CGRectMake((ScreenWidth-contentSize3.width)/2, CGRectGetMaxY(starLvIcon3.frame)+5, contentSize3.width, contentSize3.height);
                 contentLab3.text = contentStr3;
                 
                 time3.frame = CGRectMake((ScreenWidth-ScreenWidth*200/375)/2, CGRectGetMaxY(contentLab3.frame)+3, ScreenWidth*200/375, 10);
                 time3.text = evaluation3.CTDATE;
                 
                 source3.frame = CGRectMake(time3.frame.origin.x, CGRectGetMaxY(time3.frame)+5, ScreenWidth*200/375, 10);
                 source3.text = [NSString stringWithFormat:@"来自 %@",evaluation3.userName];
                 
                 myScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(source3.frame)+ScreenWidth*10/375);
             }
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

@end
