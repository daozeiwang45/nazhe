//
//  StyleListModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "StyleListModel.h"

@implementation StyleListModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"styleList":[StyleModel class]
             };
}

@end

@implementation StyleModel

@end
