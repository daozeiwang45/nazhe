//
//  BillingRecordModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "BillingRecordModel.h"

@implementation BillingCountModel

@end

@implementation BillingRecordModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"list":[BillingRecordInfoModel class]};
}

@end

@implementation BillingRecordInfoModel

@end
