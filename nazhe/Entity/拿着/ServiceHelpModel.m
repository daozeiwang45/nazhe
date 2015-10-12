//
//  ServiceHelpModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "ServiceHelpModel.h"

@implementation ServiceHelpModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"list":[ServiceHelpInfoModel class]};
}

@end

@implementation ServiceHelpInfoModel

@end