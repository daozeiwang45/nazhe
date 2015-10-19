//
//  GoodSpecificationsModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "GoodSpecificationsModel.h"

@implementation GoodSpecificationsModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"weightList":[BagParametersModel class],
             @"sizeList":[BagParametersModel class],
             @"gradeList":[BagParametersModel class],
             @"colorList":[BagParametersModel class],
             @"hardnessList":[BagParametersModel class],
             @"fillInList":[BagParametersModel class],
             @"accessoriesList":[BagParametersModel class],};
}

@end

@implementation BagParametersModel

@end
