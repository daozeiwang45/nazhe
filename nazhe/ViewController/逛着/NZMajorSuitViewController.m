//
//  NZMajorSuitViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZMajorSuitViewController.h"
#import "NZNewProductViewCell.h"
#import "NZCommodityDetailController.h"

#define labelFont [UIFont systemFontOfSize:10.f]
#define labelTextColor [UIColor colorWithRed:161/255.f green:105/255.f blue:68/255.f alpha:1.0]

@interface NZMajorSuitViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UIImageView *brandImgView;

@end

@implementation NZMajorSuitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"大牌档"];
    [self leftButtonTitle:nil];
    
    self.pageNo = 0;
    
    self.majorSuitDetailInfoArry = [NSMutableArray new];
    self.majorSuitDetailShopInfoDict = [NSMutableDictionary new];
    
    [self requestData];
    //加载大牌档数据
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    // 马上进入刷新状态
    [_tableView.footer beginRefreshing];
    
}

#pragma mark  请求数据
-(void) requestData{
    
    self.pageNo +=1;
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    NSDictionary *parameters = @{
                                 @"page_no":[NSNumber numberWithInt:self.pageNo],
                                 @"userId":[NSNumber numberWithInt:6],
                                 @"shopId":[NSNumber numberWithInt:3]
                                 
                                 };

    [handler postURLStr:webGetMajorSuitIndex postDic:parameters
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
             [_tableView.footer endRefreshing];
             NSArray *infoArry = [[retInfo objectForKey:@"result"]objectForKey:@"goodsList"];
             
             if (infoArry.count > 0) {
             
                 //把基本信息majorSuitDetailInfoArry
                 self.majorSuitDetailShopInfoDict = [retInfo objectForKey:@"shopInfo"];
                 [self.majorSuitDetailInfoArry addObjectsFromArray:infoArry];
                 
                 self.hotStr = [retInfo objectForKey:@"hotCount"];
                 self.topicStr = [retInfo objectForKey:@"topicCount"];
                 self.showStr = [retInfo objectForKey:@"showCount"];
                 self.shareStr = [retInfo objectForKey:@"shoreCount"];
                 
                 [self initInface];
                 [_tableView reloadData];

             }else{
                 
                 _tableView.footer.hidden = YES;
             }
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;

    
}

-(void)initInface{
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIDefaultBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;

    // 大牌档头部广告标识
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*225/375)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _brandImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*150/375)];
    //图片地址
    NSString *imgStr =[NZGlobal GetImgBaseURL:[self.majorSuitDetailShopInfoDict objectForKey:@"bgImg"]];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [_brandImgView sd_setImageWithURL:imgURL placeholderImage:defaultImage];
    
    [tableHeaderView addSubview:_brandImgView];
    
    // 大牌档工具条
    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_brandImgView.frame), ScreenWidth-40, ScreenWidth*75/375)];
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
    hotLabel.text = [NSString stringWithFormat:@"热度 %@",self.hotStr];
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
    topicLabel.text = [NSString stringWithFormat:@"话题 %@",self.topicStr] ;
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
    showLabel.text = [NSString stringWithFormat:@"SHOW %@",self.showStr
    ];
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
    shareLabel.text = [NSString stringWithFormat:@"分享 %@",self.shareStr];
    shareLabel.textColor = labelTextColor;
    shareLabel.font = labelFont;
    shareLabel.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:shareLabel];
    
    _tableView.tableHeaderView = tableHeaderView;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.majorSuitDetailInfoArry.count % 2 == 1) {
        
        return self.majorSuitDetailInfoArry.count/2+1;
    }else {
        
        return self.majorSuitDetailInfoArry.count/2;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZNewProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMajorSuitCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NZNewProductViewCell" owner:self options:nil] lastObject] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    cell.leftGrabIcon.image = [UIImage imageNamed:@"立即抢购"];
//    cell.rightGrabIcon.image = [UIImage imageNamed:@"立即抢购"];

    //---------左边--------
    cell.leftButton.tag = [[[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2]objectForKey:@"goodsId"] integerValue];
    [cell.leftButton addTarget:self action:@selector(goToBuyAction:) forControlEvents:UIControlEventTouchUpInside];

    //图片地址
    NSString *smallImg =[NZGlobal GetImgBaseURL:[[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2] objectForKey:@"img"]];
    
    NSURL *imgURL = [NSURL URLWithString:smallImg];
    [cell.leftImageView sd_setImageWithURL:imgURL placeholderImage:defaultImage];
    cell.leftNameLabel.text = [[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2]objectForKey:@"name"];
    cell.leftPriceLabel.text = [NSString stringWithFormat:@"价格￥%@",[[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2]objectForKey:@"marketPrice"]];
    //---------右边-----------
    //右边的一个没有值
    if (indexPath.row*2+1+1 > self.majorSuitDetailInfoArry.count) {
        cell.rightView.hidden = YES;
    }else{
        
        cell.rightButton.tag = [[[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2+1]objectForKey:@"goodsId"] integerValue];
        [cell.rightButton addTarget:self action:@selector(goToBuyAction:) forControlEvents:UIControlEventTouchUpInside];
        //图片地址
        NSString *smallImg1 =[NZGlobal GetImgBaseURL:[[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2+1] objectForKey:@"img"]];
        NSURL *imgURL1 = [NSURL URLWithString:smallImg1];
        [cell.rightImageView sd_setImageWithURL:imgURL1 placeholderImage:defaultImage];
        cell.rightNameLabel.text = [[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2+1]objectForKey:@"name"];
        cell.rightPriceLabel.text = [NSString stringWithFormat:@"价格￥%@",[[self.majorSuitDetailInfoArry objectAtIndex:indexPath.row*2+1]objectForKey:@"marketPrice"]];
    }
    

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


#pragma mark   点击大牌档产品--跳转方法
-(void)goToBuyAction:(UIButton *)sender{
    
    // 跳转商品详情页面
    NZCommodityDetailController *commodityDetailVCTR = [[NZCommodityDetailController alloc] init];
    commodityDetailVCTR.goodID = (int)sender.tag;
    commodityDetailVCTR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityDetailVCTR animated:YES];
    
}

@end
