//
//  NZActivityViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/30.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZActivityViewController.h"
#import "ActivityDetailModel.h"

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
                                 @"id":[NSNumber numberWithInt:1]
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
                     startY = CGRectGetMaxY(goodView.frame) + ScreenWidth*25/375;
                 }
                 
                 goodView = [[UIView alloc] init];
                 
                 UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*30/375, 40)];
                 numberLab.text = [NSString stringWithFormat:@"%d",i];
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
                 
                 UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, CGRectGetMaxY(numberLab.frame)+ScreenWidth*10/375, ScreenWidth-ScreenWidth*50/375, 1)];
                 line.image = [UIImage imageNamed:@"收货地址虚线"];
                 [goodView addSubview:line];
                 
                 // 计算尺寸
                 CGSize contentSize = [activityModel.content boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                 acContentLab.frame = CGRectMake(ScreenWidth*25/375, CGRectGetMaxY(activityImgV.frame)+ScreenWidth*15/375, limitSize.width, contentSize.height);
                 acContentLab.text = activityModel.content;
                 
             }
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

@end
