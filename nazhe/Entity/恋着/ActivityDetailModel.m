//
//  ActivityDetailModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/30.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "ActivityDetailModel.h"

@implementation ActivityDetailModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"list":[AcGoodModel class]
             };
}

@end

@implementation ActivityModel

@end

@implementation AcGoodModel

@end
