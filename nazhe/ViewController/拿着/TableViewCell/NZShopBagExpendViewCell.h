//
//  NZShopBagExpendViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/11.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCommodityModel.h"

@protocol NZShopBagExpendDelegate <NSObject>

- (void)addSelectState:(BOOL)selectState andSinglePrice:(double)price;
- (void)reduceSelectState:(BOOL)selectState andSinglePrice:(double)price;
- (void)commitIndex:(int)index andNumber:(int)number andSinglePrice:(double)price;
- (void)cancelIndex:(int)index andNumber:(int)number andSinglePrice:(double)price;

@end

@interface NZShopBagExpendViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *topLine;

@property (nonatomic, strong) NZCommodityModel *commodityModel;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) int number;
@property (nonatomic ,assign) BOOL selectState;
@property (assign, nonatomic) id<NZShopBagExpendDelegate> delegate;

@end
