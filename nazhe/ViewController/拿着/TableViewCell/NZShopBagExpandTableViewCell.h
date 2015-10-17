//
//  NZShopBagExpandTableViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZShopBagViewModel.h"

@protocol NZShopBagExpendDelegate <NSObject>

//- (void)specificationsWithSection:(int)section andRow:(int)row;
- (void)addSelectState:(BOOL)selectState andSinglePrice:(double)price;
- (void)reduceSelectState:(BOOL)selectState andSinglePrice:(double)price;
- (void)commitWithSection:(int)section andRow:(int)row andNumber:(int)number andSinglePrice:(double)price;
- (void)cancelWithSection:(int)section andRow:(int)row andNumber:(int)number andSinglePrice:(double)price;

@end

@interface NZShopBagExpandTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;

@property (nonatomic, strong) NZShopBagViewModel *shopBagViewModel;
@property (nonatomic, assign) int section;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) int number;
@property (nonatomic ,assign) BOOL selectState;
@property (assign, nonatomic) id<NZShopBagExpendDelegate> delegate;

@end
