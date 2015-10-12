//
//  NZMyCouponCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZMyCouponCell.h"

@implementation NZMyCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*110/375)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        // 背景
        UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, ScreenWidth*5/375, ScreenWidth-ScreenWidth*50/375, ScreenWidth*100/375)];
        backImgV.image = [UIImage imageNamed:@"色块"];
        [backView addSubview:backImgV];
        
        // 左边的品牌icon
        UIImageView *brandIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*33/375, ScreenWidth*13/375, ScreenWidth*84/375, ScreenWidth*84/375)];
        brandIcon.image = [UIImage imageNamed:@"图标8"];
        [backView addSubview:brandIcon];
        
        // centerLine
        _centerLine = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-1)/2, ScreenWidth*8/375, 1, ScreenWidth*94/375)];
        _centerLine.image = [UIImage imageNamed:@"竖虚线"];
        [backView addSubview:_centerLine];
        
        // 还剩几天
        _daysLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(brandIcon.frame)+ScreenWidth*3/375, (backView.frame.size.height-10)/2, 50, 15)];
        _daysLab.textColor = [UIColor darkGrayColor];
        _daysLab.font = [UIFont systemFontOfSize:11.f];
        [backView addSubview:_daysLab];
        
        // 使用时间
        _useTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(_daysLab.origin.x, _daysLab.origin.y-15, 50, 15)];
        _useTimeLab.text = @"使用时间";
        _useTimeLab.textColor = [UIColor darkGrayColor];
        _useTimeLab.font = [UIFont systemFontOfSize:11.f];
        [backView addSubview:_useTimeLab];
        
        // 还剩多久
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(_daysLab.origin.x, CGRectGetMaxY(_daysLab.frame)+3, 45, 12)];
        _timeLab.backgroundColor = darkRedColor;
        _timeLab.text = @"00:00:00";
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.font = [UIFont systemFontOfSize:11.f];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.layer.cornerRadius = 1.f;
        _timeLab.layer.masksToBounds = YES;
        [backView addSubview:_timeLab];
        
        // 已使用标志
        _usedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(brandIcon.frame)+ScreenWidth*20/375, ScreenWidth*47/375/2, ScreenWidth*63/375, ScreenWidth*63/375)];
        _usedIcon.image = [UIImage imageNamed:@"已使用"];
        _usedIcon.hidden = YES;
        [backView addSubview:_usedIcon];
        
        _useLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*45/375-18, (ScreenWidth*110/375-70)/2, 18, 70)];
        _useLab.backgroundColor = [UIColor whiteColor];
        _useLab.text = @"品牌专场";
        _useLab.textColor = darkRedColor;
        _useLab.font = [UIFont systemFontOfSize:13.f];
        _useLab.textAlignment = NSTextAlignmentCenter;
        _useLab.numberOfLines = 0;
        _useLab.layer.cornerRadius = 2.f;
        _useLab.layer.masksToBounds = YES;
        _useLab.layer.borderWidth = 0.5f;
        _useLab.layer.borderColor = darkRedColor.CGColor;
        [backView addSubview:_useLab];
        
        NSString *moneyStr = @"500";
        UIFont *contentFont = [UIFont systemFontOfSize:40.f];
        NSDictionary *attribute = @{NSFontAttributeName:contentFont};
        CGSize limitSize = CGSizeMake(MAXFLOAT, 35);
        // 计算尺寸
        CGSize contentSize = [moneyStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        // 优惠券价值
        _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake((_useLab.origin.x-CGRectGetMaxX(_centerLine.frame)-contentSize.width)/2+CGRectGetMaxX(_centerLine.frame), ScreenWidth*25/375, contentSize.width, contentSize.height)];
        _moneyLab.text = moneyStr;
        _moneyLab.textColor = darkRedColor;
        _moneyLab.font = contentFont;
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:_moneyLab];
        
        _moneyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_moneyLab.frame)-9.5, ScreenWidth*25/375+8, 19, 19)];
        _moneyIcon.center = CGPointMake(_moneyIcon.centerX, _moneyLab.centerY);
        _moneyIcon.image = [UIImage imageNamed:@"人民币-红"];
        [backView addSubview:_moneyIcon];
        
        // 使用条件
        _conditionLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_centerLine.frame), ScreenWidth*85/375-15, _useLab.origin.x-CGRectGetMaxX(_centerLine.frame), 15)];
        _conditionLab.textColor = [UIColor darkGrayColor];
        _conditionLab.font = [UIFont systemFontOfSize:13.f];
        _conditionLab.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:_conditionLab];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
}

- (void)setCouponInfoModel:(MyCouponInfoModel *)couponInfoModel {
    _couponInfoModel = couponInfoModel;
    
    if (couponInfoModel.state == 0) { // 未使用
        
        _useTimeLab.hidden = NO;
        _timeLab.hidden = NO;
        _daysLab.hidden = NO;
        _usedIcon.hidden = YES;
        
        _daysLab.text = [NSString stringWithFormat:@"%d天",couponInfoModel.expiredDays];
        
        NSString *moneyStr = [NSString stringWithFormat:@"%1.f",couponInfoModel.money];
        UIFont *contentFont = [UIFont systemFontOfSize:40.f];
        NSDictionary *attribute = @{NSFontAttributeName:contentFont};
        CGSize limitSize = CGSizeMake(MAXFLOAT, 35);
        // 计算尺寸
        CGSize contentSize = [moneyStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        // 优惠券价值
        _moneyLab.frame = CGRectMake((_useLab.origin.x-CGRectGetMaxX(_centerLine.frame)-contentSize.width)/2+CGRectGetMaxX(_centerLine.frame), ScreenWidth*25/375, contentSize.width, contentSize.height);
        _moneyLab.text = moneyStr;
        _moneyLab.textColor = darkRedColor;
        
        _moneyIcon.frame = CGRectMake(CGRectGetMaxX(_moneyLab.frame)-9.5, ScreenWidth*25/375+8, 19, 19);
        _moneyIcon.center = CGPointMake(_moneyIcon.centerX, _moneyLab.centerY);
        
        _conditionLab.text = [NSString stringWithFormat:@"满%1.f使用",couponInfoModel.fullMoney];
        
        _useLab.text = couponInfoModel.type;
        _useLab.textColor = darkRedColor;
        _useLab.layer.borderColor = darkRedColor.CGColor;
        
    } else { // 已使用
        
        _useTimeLab.hidden = YES;
        _timeLab.hidden = YES;
        _daysLab.hidden = YES;
        _usedIcon.hidden = NO;
        
        NSString *moneyStr = [NSString stringWithFormat:@"%1.f",couponInfoModel.money];
        UIFont *contentFont = [UIFont systemFontOfSize:40.f];
        NSDictionary *attribute = @{NSFontAttributeName:contentFont};
        CGSize limitSize = CGSizeMake(MAXFLOAT, 35);
        // 计算尺寸
        CGSize contentSize = [moneyStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        // 优惠券价值
        _moneyLab.frame = CGRectMake((_useLab.origin.x-CGRectGetMaxX(_centerLine.frame)-contentSize.width)/2+CGRectGetMaxX(_centerLine.frame), ScreenWidth*25/375, contentSize.width, contentSize.height);
        _moneyLab.text = moneyStr;
        _moneyLab.textColor = [UIColor darkGrayColor];
        
        _moneyIcon.image = [UIImage imageNamed:@"人民币-灰"];
        _moneyIcon.frame = CGRectMake(CGRectGetMaxX(_moneyLab.frame)-9.5, ScreenWidth*25/375+8, 19, 19);
        _moneyIcon.center = CGPointMake(_moneyIcon.centerX, _moneyLab.centerY);
        
        _conditionLab.text = [NSString stringWithFormat:@"满%1.f使用",couponInfoModel.fullMoney];
        
        _useLab.text = couponInfoModel.type;
        _useLab.textColor = [UIColor darkGrayColor];
        _useLab.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
}

@end
