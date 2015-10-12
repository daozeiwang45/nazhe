//
//  NZCouponsViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZCouponsViewCell.h"

@implementation NZCouponsViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    _couponLabel.layer.cornerRadius = 2.f;
    _couponLabel.layer.masksToBounds = YES;
}

@end
