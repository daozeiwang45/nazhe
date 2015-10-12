//
//  GoodParametersModel.m
//  nazhe
//
//  Created by WSGG on 15/9/29.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "GoodParametersModel.h"

@implementation GoodParametersModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             
             @"goodsInfo":[ParametersModel class],
             @"colorList":[ColorListModel class],
             @"accessoriesList":[AccessoriesListModel class],
             @"weightList":[WeightListModel class],
             @"sizeList":[SizeListModel class],
             @"gradeList":[GradeListModel class],
             @"hardnessList":[HardnessListModel class],
             @"fillInList":[FillInListModel class]
             
             };
}

@end


@implementation  ParametersModel

@end
@implementation  ColorListModel

@end
@implementation  AccessoriesListModel

@end
@implementation  WeightListModel

@end
@implementation  SizeListModel

@end
@implementation  GradeListModel

@end
@implementation  HardnessListModel

@end
@implementation  FillInListModel

@end

