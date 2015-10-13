//
//  NZNewProductViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZNewProductViewCell.h"

@implementation NZNewProductViewCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat width = _leftView.frame.size.width;
    
    _leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake((width-ScreenWidth*37.5/375)/2, width-ScreenWidth*37.5/375/2, ScreenWidth*37.5/375, ScreenWidth*37.5/375)];
    _leftIcon.image = [UIImage imageNamed:@"新品CLUB"];
    [_leftView addSubview:_leftIcon];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake((width-ScreenWidth*37.5/375)/2, width-ScreenWidth*37.5/375/2, ScreenWidth*37.5/375, ScreenWidth*37.5/375)];
    _rightIcon.image = [UIImage imageNamed:@"新品CLUB"];
    [_rightView addSubview:_rightIcon];
    
    //    _leftIcon.hidden = YES;
    //    _rightIcon.hidden = YES;
    
    _leftGrabIcon = [[UIImageView alloc] initWithFrame:CGRectMake((width-ScreenWidth*63/375)/2, width-ScreenWidth*17/375/2, ScreenWidth*63/375, ScreenWidth*17/375)];
    _leftGrabIcon.image = [UIImage imageNamed:@"立即抢购"];
    [_leftView addSubview:_leftGrabIcon];
    
    _rightGrabIcon = [[UIImageView alloc] initWithFrame:CGRectMake((width-ScreenWidth*63/375)/2, width-ScreenWidth*17/375/2, ScreenWidth*63/375, ScreenWidth*17/375)];
    _rightGrabIcon.image = [UIImage imageNamed:@"立即抢购"];
    [_rightView addSubview:_rightGrabIcon];
    
    // 左边
    _leftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_leftIcon.frame), width, ScreenWidth*20/375)];
    //_leftNameLabel.text = @"岫玉时尚飘花手镯";
    _leftNameLabel.textColor = [UIColor blackColor];
    _leftNameLabel.font = [UIFont systemFontOfSize:13.f];
    _leftNameLabel.textAlignment = NSTextAlignmentCenter;
    [_leftView addSubview:_leftNameLabel];
    
    _leftPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_leftNameLabel.frame), width, ScreenWidth*15/375)];
    //_leftPriceLabel.text = @"首发价￥8900";
    _leftPriceLabel.textColor = [UIColor darkGrayColor];
    _leftPriceLabel.font = [UIFont systemFontOfSize:13.f];
    _leftPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_leftView addSubview:_leftPriceLabel];
    
    // 右边
    _rightNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rightIcon.frame), width, ScreenWidth*20/375)];
    //_rightNameLabel.text = @"岫玉时尚飘花手镯";
    _rightNameLabel.textColor = [UIColor blackColor];
    _rightNameLabel.font = [UIFont systemFontOfSize:13.f];
    _rightNameLabel.textAlignment = NSTextAlignmentCenter;
    [_rightView addSubview:_rightNameLabel];
    
    _rightPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rightNameLabel.frame), width, ScreenWidth*15/375)];
    //_rightPriceLabel.text = @"首发价￥8900";
    _rightPriceLabel.textColor = [UIColor darkGrayColor];
    _rightPriceLabel.font = [UIFont systemFontOfSize:13.f];
    _rightPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_rightView addSubview:_rightPriceLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews {
    
}

- (void)setNewOrBuy:(enumtNewClubOrBuyNow)newOrBuy {
    if (newOrBuy == enumtNewClubOrBuyNow_NewClub) {
        _leftGrabIcon.hidden = YES;
        _rightGrabIcon.hidden = YES;
    } else if (newOrBuy == enumtNewClubOrBuyNow_BuyNow) {
        _leftIcon.hidden = YES;
        _rightIcon.hidden = YES;
    }
}

@end
