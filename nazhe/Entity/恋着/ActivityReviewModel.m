//
//  ActivityReviewModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "ActivityReviewModel.h"

@implementation ActivityReviewModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"list":[ReviewModel class]
             };
}

@end

@implementation ReviewModel

@end