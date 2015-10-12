//
//  MaterialListModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "MaterialListModel.h"

@implementation MaterialListModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"list":[MaterialModel class]
             };
}

@end

@implementation MaterialModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"variety":[VarietyModel class]
             };
}

@end

@implementation VarietyModel

@end
