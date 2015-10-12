//
//  MyAddressModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "MyDeliveryAddressModel.h"

@implementation MyDeliveryAddressModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型 这个东西坑了我一下午
+ (NSDictionary *)objectClassInArray {
    
    return @{@"list":[MyDeliveryAddressInfoModel class]};
}

@end

@implementation MyDeliveryAddressInfoModel

@end
