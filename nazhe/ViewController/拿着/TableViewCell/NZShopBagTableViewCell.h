//
//  NZShopBagTableViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZShopBagViewModel.h"

@protocol NZShopBagDelegate <NSObject>

- (void)selectClickWithSection:(int)section andRow:(int)row andState:(BOOL)selectState andPrice:(double)price andNumber:(int)number andExpressPrice:(float)expressPrice;
- (void)deleteClickWithSection:(int)section andRow:(int)row andState:(BOOL)selectState andPrice:(double)price andNumber:(int)number;
- (void)editClickWithSection:(int)section andRow:(int)row;

@end

@interface NZShopBagTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) NZShopBagViewModel *shopBagViewModel;
@property (nonatomic, assign) int section;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) int number;
@property (nonatomic ,assign) BOOL selectState;
@property (assign, nonatomic) id<NZShopBagDelegate> delegate;

@end
