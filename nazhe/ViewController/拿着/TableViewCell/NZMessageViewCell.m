//
//  NZMessageViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/5.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZMessageViewCell.h"

@interface NZMessageViewCell () {
    
}

@end

@implementation NZMessageViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.iconView.layer.cornerRadius = self.iconView.frame.size.width / 2;
    self.iconView.layer.masksToBounds = YES;

}

@end
