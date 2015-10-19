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
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)editAction:(UIButton *)sender;
- (IBAction)selectAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;


@end

@implementation NZShopBagViewCell

- (void)awakeFromNib {
    
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
    
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2;
    self.imgView.layer.masksToBounds = YES;
    
    self.editBtn.layer.cornerRadius = 2.f;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.editBtn.layer.borderWidth = 0.5f;
    
}

- (void)setShopBagGoodModel:(ShopBagGoodModel *)shopBagGoodModel {
    _shopBagGoodModel = shopBagGoodModel;
    
    self.numLab.text = [NSString stringWithFormat:@"x %d",shopBagGoodModel.count];
    self.number = shopBagGoodModel.count;
    
    self.price = shopBagGoodModel.totalPrice/shopBagGoodModel.count;
    self.totalPrice = shopBagGoodModel.totalPrice;
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
