//
//  NZShopBagViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/11.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCommodityModel.h"

@protocol NZShopBagDelegate <NSObject>

- (void)selectClick:(int)index andState:(BOOL)selectState andPrice:(double)price andNumber:(int)number;
- (void)deleteClick:(UITableViewCell *)cell;
- (void)editClick:(int)index;

@end

@interface NZShopBagViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIImageView *selectImg;
@property (strong, nonatomic) IBOutlet UIView *topLine;
@property (strong, nonatomic) IBOutlet UIView *bottonLine;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *specificationsLab;
@property (strong, nonatomic) IBOutlet UILabel *numLab;


@property (nonatomic, strong) NZCommodityModel *commodityModel;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) int number;
@property (nonatomic ,assign) BOOL selectState;
@property (assign, nonatomic) id<NZShopBagDelegate> delegate;

@end
