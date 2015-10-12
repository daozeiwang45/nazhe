//
//  NZGrabViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZGrabViewCell.h"

@implementation NZGrabViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    _quicklyView.layer.cornerRadius = 3.f;
    _quicklyView.layer.masksToBounds = YES;
}

@end
