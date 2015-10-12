//
//  GoodDetailModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "GoodDetailModel.h"

@implementation GoodDetailModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"goodsEvaluation":[EvaluationModel class]
             };
}

@end

@implementation LastGoodModel

@end

@implementation NextGoodModel

@end

@implementation DetailModel

@end

@implementation EvaluationModel

@end

@implementation UserStateModel

@end
