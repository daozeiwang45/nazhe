//
//  NZChangeAddressViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/20.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZChangeAddressViewCell.h"

@interface NZChangeAddressViewCell () {
    UILabel *nameLab; // 收货人姓名lab
    UILabel *phoneLab; // 收货人电话lab
    UILabel *defaultLab; // 默认收货地址lab
    UILabel *detailAddressLab; // 详细收货地址lab
    UIImageView *lineImgV; // 虚线
}

@end

@implementation NZChangeAddressViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initInterface];
    }
    return self;
}

- (void)initInterface {
    // 收货人姓名
    nameLab = [[UILabel alloc] init];
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont systemFontOfSize:19.f];
    [self.contentView addSubview:nameLab];
    
    // 收货人电话
    phoneLab = [[UILabel alloc] init];
    phoneLab.textColor = [UIColor grayColor];
    phoneLab.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:phoneLab];
    
    // 默认收货地址
    defaultLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*65/375-60, ScreenWidth*10/375+3, 60, 15)];
    defaultLab.text = @"默认地址";
    defaultLab.textColor = darkRedColor;
    defaultLab.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:defaultLab];
    
    // 详细收货地址
    detailAddressLab = [[UILabel alloc] init];
    detailAddressLab.textColor = [UIColor grayColor];
    detailAddressLab.font = [UIFont systemFontOfSize:13.f];
    detailAddressLab.numberOfLines = 0;
    [self.contentView addSubview:detailAddressLab];
    
    // 虚线
    lineImgV = [[UIImageView alloc] init];
    lineImgV.image = [UIImage imageNamed:@"收货地址虚线"];
    [self.contentView addSubview:lineImgV];
}

- (void)setChangeAddressVM:(NZChangeAddressViewModel *)changeAddressVM {
    
    nameLab.text = changeAddressVM.myAddressInfoModel.name;
    nameLab.frame = changeAddressVM.nameLabFrame;
    
    phoneLab.text = changeAddressVM.myAddressInfoModel.phone;
    phoneLab.frame = changeAddressVM.phoneLabFrame;
    
    if (changeAddressVM.myAddressInfoModel.isDefault) {
        defaultLab.hidden = NO;
    } else {
        defaultLab.hidden = YES;
    }
    
    detailAddressLab.text = changeAddressVM.myAddressInfoModel.address;
    detailAddressLab.frame = changeAddressVM.detailAddressFrame;
    
    lineImgV.frame = changeAddressVM.lineFrame;
}

@end
