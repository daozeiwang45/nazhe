//
//  OrderListModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/23.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"list":[OrderInfoModel class]};
}

@end

@implementation OrderInfoModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"goods":[GoodsInfoModel class]};
}

@end

@implementation GoodsInfoModel

@end
