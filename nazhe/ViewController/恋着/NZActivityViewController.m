//
//  NZActivityViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/30.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZActivityViewController.h"
#import "ActivityDetailModel.h"
#import "NZActivityReviewController.h"

@interface NZActivityViewController () {
    ActivityDetailModel *activityDetailModel; // 活动详情页数据模型
    
    UIScrollView *scrollView; // 所有内容放到这里面去
    
    /**************************  活动图区域  ****************************/
    UIImageView *activityImgV; // 活动图
    UILabel *activityTitleLab; // 活动标题
    UILabel *activityThemeLab; // 活动主题
    UILabel *acContentLab; // 活动内容
    
    UIView *goodView; // 商品信息存放载体，可重复利用
}

@end

@implementation NZActivityViewController

// 初始化数据
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationItemTitleViewWithTitle:@"活动详情"];
    [self leftButtonTitle:nil];
    
    [self initInterface]; // 初始化活动详情界面
    [self requestActivityDetailData]; // 请求活动详情页数据
}

- (void)initInterface {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    /**************************  活动图区域  ****************************/
    activityImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*225/375)];
    [scrollView addSubview:activityImgV];
    
    activityTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, ScreenWidth*150/375, ScreenWidth-ScreenWidth*50/375, 20)];
    activityTitleLab.textColor = [UIColor whiteColor];
    activityTitleLab.font = [UIFont systemFontOfSize:21.f];
    [scrollView addSubview:activityTitleLab];
    
    activityThemeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, CGRectGetMaxY(activityTitleLab.frame)+ScreenWidth*8/375, ScreenWidth-ScreenWidth*50/375, 15)];
    activityThemeLab.textColor = [UIColor whiteColor];
    activityThemeLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:activityThemeLab];
    
    acContentLab = [[UILabel alloc] init];
    acContentLab.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:acContentLab];
}

- (void)requestActivityDetailData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NSDictionary *parameters = @{
                                 @"id":[NSNumber numberWithInt:self.activityID]
                                 } ;
    
    [handler postURLStr:webActivityDetail postDic:parameters
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
             activityDetailModel = [ActivityDetailModel objectWithKeyValues:retInfo];
             
             ActivityModel *activityModel = activityDetailModel.activity;
             [activityImgV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:activityModel.img]] placeholderImage:defaultImage];
             activityTitleLab.text = activityModel.title;
             activityThemeLab.text = activityModel.theme;
             
             UIFont *contentFont = [UIFont systemFontOfSize:15.f];
             NSDictionary *attribute = @{NSFontAttributeName:contentFont};
             CGSize limitSize = CGSizeMake(ScreenWidth-ScreenWidth*50/375, MAXFLOAT);
             // 计算尺寸
             CGSize contentSize = [activityModel.content boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
             acContentLab.frame = CGRectMake(ScreenWidth*25/375, CGRectGetMaxY(activityImgV.frame)+ScreenWidth*15/375, limitSize.width, contentSize.height);
             acContentLab.text = activityModel.content;
             
             float startY;
             for (int i=0; i<activityDetailModel.list.count; i++) {
                 AcGoodModel *acGoodModel = activityDetailModel.list[i];
                 acGoodModel.goodID = [retInfo[@"list"][i][@"id"] intValue];
                 
                 if (i == 0) {
                     startY = CGRectGetMaxY(acContentLab.frame) + ScreenWidth*30/375;
                 } else {
                     startY = CGRectGetMaxY(goodView.frame) + ScreenWidth*30/375;
                 }
                 
                 goodView = [[UIView alloc] init];
                 
                 UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*30/375, 40)];
                 numberLab.text = [NSString stringWithFormat:@"%d",i+1];
                 numberLab.textColor = [UIColor grayColor];
                 numberLab.font = [UIFont systemFontOfSize:40.f];
                 [goodView addSubview:numberLab];
                 
                 UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberLab.frame), 0, ScreenWidth-ScreenWidth*80/375, 25)];
                 nameLab.text = acGoodModel.name;
                 nameLab.font = [UIFont systemFontOfSize:21.f];
                 [goodView addSubview:nameLab];
                 
                 UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberLab.frame), 25, ScreenWidth-ScreenWidth*80/375, 15)];
                 priceLab.text = [NSString stringWithFormat:@"¥%.f元",acGoodModel.marketPrice];
                 priceLab.textColor = darkRedColor;
                 priceLab.font = [UIFont systemFontOfSize:13.f];
                 [goodView addSubview:priceLab];
                 
                 UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(numberLab.frame)+ScreenWidth*10/375, ScreenWidth-ScreenWidth*50/375, 1)];
                 line.image = [UIImage imageNamed:@"收货地址虚线"];
                 [goodView addSubview:line];
                 
                 // 计算尺寸
                 CGSize descriptSize = [acGoodModel.descript boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                 UILabel *descriptLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+ScreenWidth*10/375, limitSize.width, descriptSize.height)];
                 descriptLab.text = acGoodModel.descript;
                 descriptLab.font = [UIFont systemFontOfSize:15.f];
                 [goodView addSubview:descriptLab];
                 
                 UIImageView *goodImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descriptLab.frame)+ScreenWidth*10/375, ScreenWidth-ScreenWidth*50/375, ScreenWidth*175/375)];
                 [goodImgView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:acGoodModel.img]] placeholderImage:defaultImage];
                 [goodView addSubview:goodImgView];
                 
                 UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(goodImgView.frame)+ScreenWidth*10/375, ScreenWidth-ScreenWidth*110/375, ScreenWidth*18/375)];
                 hotLabel.text = [NSString stringWithFormat:@"喜欢%d    /    收藏%d    /    销量%d", acGoodModel.totalLike, acGoodModel.totalCollection, acGoodModel.sales];
                 hotLabel.textColor = [UIColor grayColor];
                 hotLabel.font = [UIFont systemFontOfSize:13.f];
                 [goodView addSubview:hotLabel];
                 
                 UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hotLabel.frame), hotLabel.origin.y, ScreenWidth*60/375, ScreenWidth*18/375)];
                 [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
                 [detailBtn setTitleColor:coffeeColor forState:UIControlStateNormal];
                 detailBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
                 detailBtn.layer.cornerRadius = 2.f;
                 detailBtn.layer.masksToBounds = YES;
                 detailBtn.layer.borderWidth = 1.f;
                 detailBtn.layer.borderColor = coffeeColor.CGColor;
                 [goodView addSubview:detailBtn];
                 
                 goodView.frame = CGRectMake(ScreenWidth*25/375, startY, ScreenWidth-ScreenWidth*50/375, CGRectGetMaxY(hotLabel.frame));
                 [scrollView addSubview:goodView];
             }
             
             /*********************   活动评论  ************************/
             UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*50/375)/2, CGRectGetMaxY(goodView.frame)+ScreenWidth*30/375, ScreenWidth*50/375, ScreenWidth*50/375)];
             [commentBtn setBackgroundImage:[UIImage imageNamed:@"活动评论"] forState:UIControlStateNormal];
             [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
             [scrollView addSubview:commentBtn];
             
             UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*100/375)/2, CGRectGetMaxY(commentBtn.frame)+5, ScreenWidth*100/375, 15.f)];
             commentLab.text = [NSString stringWithFormat:@"%d条 评论", activityModel.countComment];
             commentLab.textColor = [UIColor grayColor];
             commentLab.font = [UIFont systemFontOfSize:13.f];
             commentLab.textAlignment = NSTextAlignmentCenter;
             [scrollView addSubview:commentLab];
             
             /*********************   活动点赞  ************************/
             UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentBtn.origin.x-ScreenWidth*100/375, commentBtn.origin.y, ScreenWidth*50/375, ScreenWidth*50/375)];
             [likeBtn setBackgroundImage:[UIImage imageNamed:@"活动赞"] forState:UIControlStateNormal];
             [likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
             [scrollView addSubview:likeBtn];
             
             UILabel *likeLab = [[UILabel alloc] initWithFrame:CGRectMake(commentLab.origin.x-ScreenWidth*100/375, CGRectGetMaxY(likeBtn.frame)+5, ScreenWidth*100/375, 15.f)];
             likeLab.text = [NSString stringWithFormat:@"%d 赞", activityModel.countPraise];
             likeLab.textColor = [UIColor grayColor];
             likeLab.font = [UIFont systemFontOfSize:13.f];
             likeLab.textAlignment = NSTextAlignmentCenter;
             [scrollView addSubview:likeLab];
             
             /*********************   活动分享  ************************/
             UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame)+ScreenWidth*50/375, commentBtn.origin.y, ScreenWidth*50/375, ScreenWidth*50/375)];
             [shareBtn setBackgroundImage:[UIImage imageNamed:@"活动分享"] forState:UIControlStateNormal];
             [scrollView addSubview:shareBtn];
             
             UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentLab.frame), CGRectGetMaxY(shareBtn.frame)+5, ScreenWidth*100/375, 15.f)];
             shareLab.text = [NSString stringWithFormat:@"%d次 分享", activityModel.countShare];
             shareLab.textColor = [UIColor grayColor];
             shareLab.font = [UIFont systemFontOfSize:13.f];
             shareLab.textAlignment = NSTextAlignmentCenter;
             [scrollView addSubview:shareLab];
             
             scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(commentLab.frame)+ScreenWidth*25/375);
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 点赞或取消
- (void)likeClick:(UIButton *)button {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 @"userId":user.userId,
                                 @"id":user.userId
                                 } ;
    
    [handler postURLStr:webActivityLike postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
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
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 进入活动评论界面
- (void)commentClick:(UIButton *)button {
    NZActivityReviewController *acReviewVCTR = [[NZActivityReviewController alloc] init];
    acReviewVCTR.activityID = self.activityID;
    [self.navigationController pushViewController:acReviewVCTR animated:YES];
}

@end
