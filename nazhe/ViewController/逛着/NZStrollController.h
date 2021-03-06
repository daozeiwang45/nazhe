//
//  NZStrollController.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZViewController.h"
#import <Accelerate/Accelerate.h>
@class AdView;

@interface NZStrollController : NZViewController


@property (nonatomic,strong)AdView *adView;
@property (nonatomic,strong)UIView *tableHeaderView;
//关于优惠活动从服务器获取的一些参数
@property (nonatomic,strong)NSMutableArray *imagesURLInActivitiesArry;
@property (nonatomic,strong)NSMutableArray *imagesOtherURLInActivitiesArry;//除了限时抢其他轮播图片数组

//优惠活动具体信息数组

@property (nonatomic,strong)NSMutableArray *activitiesTimeDetailTimeArry;
@property (nonatomic,strong)NSMutableArray *activitiesTimeDetailInfoArry;
@property (nonatomic,strong)NSMutableArray *activitiesNewDetailInfoArry;
@property (nonatomic,strong)NSMutableArray *activitiesCouponsDetailInfoArry;
@property (nonatomic,strong)NSMutableArray *activitiesMajorSuitDetailInfoArry;

//显示的页数
@property (nonatomic,assign)int pageNo;
//哪个时间结点的索引
@property (nonatomic,assign)int timeIndex;

@end
