//
//  NZCommodityModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/11.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZCommodityModel.h"

@implementation NZCommodityModel

-(instancetype)initWithDict:(NSDictionary *)dict

{
    
    if (self = [super init])
        
    {
        self.index = [dict[@"index"] intValue];
        
        self.imageURL = dict[@"imageURL"];
        
        self.commodityTitle = dict[@"commodityTitle"];
        
        self.commodityPrice = dict[@"commodityPrice"];
        
        self.commodityNum = [dict[@"commodityNum"]intValue];
        
        self.selectState = [dict[@"selectState"]boolValue];
        
    }
    
    return self;
    
}

@end
