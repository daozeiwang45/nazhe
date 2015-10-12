//
//  LoveModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "LoveModel.h"

@implementation LoveModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"activityList":[BrandModel class],
             @"limitTime":[LimitedTimeGrabModel class],
             @"coupon":[CouponModel class],
             @"starImgList":[StarModel class]
             };
}

@end

@implementation BrandModel

@end

@implementation LimitedTimeGrabModel

@end

@implementation NewGoodsModel

@end

@implementation CouponModel

@end

@implementation StarModel

@end

