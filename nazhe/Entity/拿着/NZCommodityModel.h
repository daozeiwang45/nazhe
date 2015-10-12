//
//  NZCommodityModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/11.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZCommodityModel : NSObject

@property (nonatomic, assign)int index; // 第几行cell

@property(strong,nonatomic)NSString *imageURL;//商品图片

@property(strong,nonatomic)NSString *commodityTitle;//商品标题

@property(strong,nonatomic)NSString *commodityPrice;//商品单价

@property(assign,nonatomic)BOOL selectState;//是否选中状态

@property(assign,nonatomic)int commodityNum;//商品个数

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
