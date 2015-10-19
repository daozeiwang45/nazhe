//
//  NZShopBagExpendViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/11.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZShopBagExpendViewCell.h"

@interface NZShopBagExpendViewCell () {
    
}
@property (strong, nonatomic) IBOutlet UIView *imageBackground;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UIButton *commitBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UIImageView *selectImg;
@property (strong, nonatomic) IBOutlet UILabel *numLab;

- (IBAction)addNumberAction:(UIButton *)sender;
- (IBAction)reduceAction:(UIButton *)sender;
- (IBAction)commoitAction:(UIButton *)sender;
- (IBAction)cancelAction:(UIButton *)sender;

@end

@implementation NZShopBagExpendViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    self.imageBackground.layer.cornerRadius = self.imageBackground.frame.size.width / 2;
    self.imageBackground.layer.masksToBounds = YES;
    self.imageBackground.layer.borderWidth = 0.5f;
    self.imageBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2;
    self.imgView.layer.masksToBounds = YES;
    
    self.commitBtn.layer.cornerRadius = 2.f;
    self.commitBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 2.f;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.cancelBtn.layer.borderWidth = 0.5f;
}

- (void)setShopBagGoodModel:(ShopBagGoodModel *)shopBagGoodModel {
    _shopBagGoodModel = shopBagGoodModel;
    
    self.numLab.text = [NSString stringWithFormat:@"x %d",shopBagGoodModel.count];
    self.number = shopBagGoodModel.count;
    
    self.price = shopBagGoodModel.totalPrice/shopBagGoodModel.count;
    self.totalPrice = shopBagGoodModel.totalPrice;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    
}

- (IBAction)addNumberAction:(UIButton *)sender {
    
    self.number += 1;
    self.numLab.text = [NSString stringWithFormat:@"%d",self.number];
    
    self.totalPrice = self.price * self.number;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    
    [self.delegate addSelectState:self.selectState andSinglePrice:self.price];
}

- (IBAction)reduceAction:(UIButton *)sender {
    
    if (self.number > 1) {
        self.number -= 1;
        self.numLab.text = [NSString stringWithFormat:@"%d",self.number];
        
        self.totalPrice = self.price * self.number;
        self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
        
        [self.delegate reduceSelectState:self.selectState andSinglePrice:self.price];
    }
}

- (IBAction)commoitAction:(UIButton *)sender {
    [self.delegate commitIndex:self.index andNumber:self.number andSinglePrice:self.price];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self.delegate cancelIndex:self.index andNumber:self.number andSinglePrice:self.price];
}

@end
