//
//  NZShopBagViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/11.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZShopBagViewCell.h"

@interface NZShopBagViewCell () {
    
}

@property (strong, nonatomic) IBOutlet UIView *imageBackground;

- (IBAction)editAction:(UIButton *)sender;
- (IBAction)selectAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;


@end

@implementation NZShopBagViewCell

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
    
    self.editBtn.layer.cornerRadius = 2.f;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.editBtn.layer.borderWidth = 0.5f;
    
    
}

- (void)setCommodityModel:(NZCommodityModel *)commodityModel {
    self.index = commodityModel.index;
    
    if (commodityModel.selectState) {
        self.selectImg.image = [UIImage imageNamed:@"圆-已选"];
    } else {
        self.selectImg.image = [UIImage imageNamed:@"圆-未选"];
    }
    self.selectState = commodityModel.selectState;
    
    self.numLab.text = [NSString stringWithFormat:@"x %d",commodityModel.commodityNum];
    self.number = commodityModel.commodityNum;
    
    self.price = [commodityModel.commodityPrice doubleValue];
    self.totalPrice = self.price * self.number;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
}

- (IBAction)editAction:(UIButton *)sender {
    [self.delegate editClick:self.index];
}

- (IBAction)selectAction:(UIButton *)sender {
    self.selectState = !self.selectState;
    
    if (self.selectState) {
        self.selectImg.image = [UIImage imageNamed:@"圆-已选"];
    } else {
        self.selectImg.image = [UIImage imageNamed:@"圆-未选"];
    }
    
    [self.delegate selectClick:self.index andState:self.selectState andPrice:self.price andNumber:self.number];
}

- (IBAction)deleteAction:(UIButton *)sender {
    [self.delegate deleteClick:self];
}
@end
