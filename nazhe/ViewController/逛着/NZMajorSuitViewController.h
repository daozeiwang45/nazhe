//
//  NZMajorSuitViewController.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZViewController.h"

@interface NZMajorSuitViewController : NZViewController


@property (nonatomic,strong)NSMutableDictionary *majorSuitDetailShopInfoDict;
@property (nonatomic,strong)NSMutableArray *majorSuitDetailInfoArry;

@property (nonatomic,strong)NSString *hotStr;
@property (nonatomic,strong)NSString *topicStr;
@property (nonatomic,strong)NSString *showStr;
@property (nonatomic,strong)NSString *shareStr;

//显示的页数
@property (nonatomic,assign)int pageNo;
@property (nonatomic,assign)int shopId;

@end
