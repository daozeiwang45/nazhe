//
//  NZOrderViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/1.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderViewCell.h"

@interface NZOrderViewCell () {
    
}
@property (strong, nonatomic) IBOutlet UIView *imageBackground;
@property (strong, nonatomic) IBOutlet UIImageView *commodityImageVIew;

@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;

@end

@implementation NZOrderViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
        // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.imageBackground.layer.cornerRadius = self.imageBackground.frame.size.width / 2;
    self.imageBackground.layer.masksToBounds = YES;
    self.imageBackground.layer.borderWidth = 0.5f;
    self.imageBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.commodityImageVIew.layer.cornerRadius = self.commodityImageVIew.frame.size.width / 2 ;
    self.commodityImageVIew.layer.masksToBounds= YES ;
    
    self.rightBtn.layer.cornerRadius = 2.f;
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.rightBtn.layer.borderWidth = 0.5f;
    
    self.leftBtn.layer.cornerRadius = 2.f;
    self.leftBtn.layer.masksToBounds = YES;
    self.leftBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.leftBtn.layer.borderWidth = 0.5f;

}

@end
