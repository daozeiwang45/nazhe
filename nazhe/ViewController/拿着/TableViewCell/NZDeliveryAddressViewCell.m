//
//  NZDeliveryAddressViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZDeliveryAddressViewCell.h"

@interface NZDeliveryAddressViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabWidth;

- (IBAction)editAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;

@end

@implementation NZDeliveryAddressViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressInfoModel:(MyDeliveryAddressInfoModel *)addressInfoModel {
    
    _addressInfoModel = addressInfoModel;
    
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize limitSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    // 计算姓名的尺寸
    CGSize size = [addressInfoModel.name boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _nameLabWidth.constant = size.width;
    
    self.addressID = addressInfoModel.addressID;
    
    self.nameLab.text = addressInfoModel.name;
    
    self.phoneLab.text = addressInfoModel.phone;
    
    self.addressLab.text = addressInfoModel.address;
    
    if (addressInfoModel.isDefault) {
        self.defaultLab.hidden = NO;
        self.defaultMark.image = [UIImage imageNamed:@"选择圆"];
    } else {
        self.defaultLab.hidden = YES;
        self.defaultMark.image = [UIImage imageNamed:@"未选择圆"];
    }
    
}

- (IBAction)setDefaultAddress:(UIButton *)sender {
    [self.delegate setDefaultAddressWithIndex:self.addressID];
}

- (IBAction)editAction:(UIButton *)sender {
    [self.delegate editAddressWithIndex:self.addressID];
}

- (IBAction)deleteAction:(UIButton *)sender {
    [self.delegate deleteAddressWithAddID:self.addressID];
}

@end
