//
//  NZMajorSuitViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZMajorSuitViewController.h"
#import "NZNewProductViewCell.h"

#define labelFont [UIFont systemFontOfSize:10.f]
#define labelTextColor [UIColor colorWithRed:161/255.f green:105/255.f blue:68/255.f alpha:1.0]

@interface NZMajorSuitViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation NZMajorSuitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"大牌档"];
    [self leftButtonTitle:nil];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIDefaultBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    
    // 大牌档头部广告标识
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*225/375)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *brandImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*150/375)];
    brandImgView.image = [UIImage imageNamed:@"大牌档品牌图"];
    [tableHeaderView addSubview:brandImgView];
    
    // 大牌档工具条
    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(brandImgView.frame), ScreenWidth-40, ScreenWidth*75/375)];
    toolBarView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:toolBarView];
    
    CGFloat width = toolBarView.frame.size.width / 4;
    CGFloat height = toolBarView.frame.size.height;
    CGFloat imgWidth = ScreenWidth * 26 /375;
    
    /*************************    热度     **************************/
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [toolBarView addSubview:hotView];
    
    UIImageView *hotImg = [[UIImageView alloc] initWithFrame:CGRectMake((width-imgWidth)/2, (height-imgWidth-20)/2, imgWidth, imgWidth)];
    hotImg.image = [UIImage imageNamed:@"热度"];
    [hotView addSubview:hotImg];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotImg.frame), width, 20)];
    hotLabel.text = @"热度 112";
    hotLabel.textColor = labelTextColor;
    hotLabel.font = labelFont;
    hotLabel.textAlignment = NSTextAlignmentCenter;
    [hotView addSubview:hotLabel];
    
    /*************************    话题     **************************/
    UIView *topicView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [toolBarView addSubview:topicView];
    
    UIImageView *topicImg = [[UIImageView alloc] initWithFrame:CGRectMake((width-imgWidth)/2, (height-imgWidth-20)/2, imgWidth, imgWidth)];
    topicImg.image = [UIImage imageNamed:@"话题"];
    [topicView addSubview:topicImg];
    
    UILabel *topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotImg.frame), width, 20)];
    topicLabel.text = @"话题 204";
    topicLabel.textColor = labelTextColor;
    topicLabel.font = labelFont;
    topicLabel.textAlignment = NSTextAlignmentCenter;
    [topicView addSubview:topicLabel];
    
    /*************************    SHOW     **************************/
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
    [toolBarView addSubview:showView];
    
    UIImageView *showImg = [[UIImageView alloc] initWithFrame:CGRectMake((width-imgWidth)/2, (height-imgWidth-20)/2, imgWidth, imgWidth)];
    showImg.image = [UIImage imageNamed:@"SHOW"];
    [showView addSubview:showImg];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotImg.frame), width, 20)];
    showLabel.text = @"SHOW 25";
    showLabel.textColor = labelTextColor;
    showLabel.font = labelFont;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [showView addSubview:showLabel];
    
    /*************************    分享     **************************/
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(width * 3, 0, width, height)];
    [toolBarView addSubview:shareView];
    
    UIImageView *shareImg = [[UIImageView alloc] initWithFrame:CGRectMake((width-imgWidth)/2, (height-imgWidth-20)/2, imgWidth, imgWidth)];
    shareImg.image = [UIImage imageNamed:@"分享"];
    [shareView addSubview:shareImg];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotImg.frame), width, 20)];
    shareLabel.text = @"分享 15";
    shareLabel.textColor = labelTextColor;
    shareLabel.font = labelFont;
    shareLabel.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:shareLabel];
    
    _tableView.tableHeaderView = tableHeaderView;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZNewProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMajorSuitCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NZNewProductViewCell" owner:self options:nil] lastObject] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    cell.leftGrabIcon.image = [UIImage imageNamed:@"立即抢购"];
//    cell.rightGrabIcon.image = [UIImage imageNamed:@"立即抢购"];

    cell.newOrBuy = enumtNewClubOrBuyNow_BuyNow;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth * 237.5/375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


@end
