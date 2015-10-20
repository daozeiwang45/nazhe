//
//  NZSettleViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZSettleGoodsViewModel.h"

@interface NZSettleViewCell : UITableViewCell

@property (nonatomic, strong) NZSettleGoodsViewModel *settleGoodsVM;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;

@end
