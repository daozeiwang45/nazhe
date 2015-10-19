//
//  ShopBagModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/15.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "ShopBagModel.h"

@implementation ShopBagModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"list":[ShopBagBrandModel class]};
}

@end

@implementation ShopBagBrandModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"goodsList":[ShopBagGoodModel class]};
}

@end

@implementation ShopBagGoodModel

@end
