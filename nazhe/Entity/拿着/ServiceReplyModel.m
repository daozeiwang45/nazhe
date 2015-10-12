//
//  ServiceReplyModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "ServiceReplyModel.h"

@implementation ServiceReplyModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"list":[ServiceReplyInfoModel class]};
}

@end

@implementation ServiceReplyInfoModel

@end