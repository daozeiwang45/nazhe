//
//  NZAddressListModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/20.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZAddressListModel.h"

@implementation NZAddressListModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"addressInfo":[NZAddressModel class]};
}

@end

@implementation NZAddressModel

@end
