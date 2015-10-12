//
//  NZTakeContentView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/31.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZTakeContentView.h"

@interface NZTakeContentView () {
    
}

@property (nonatomic, strong) UIImageView *purseImgV; // 钱袋
@property (nonatomic, strong) UIView *leftLine; // 左线
@property (nonatomic, strong) UIView *rightLine; // 右线
@property (nonatomic, strong) UILabel *totalLab; // 总收益label
@property (nonatomic, strong) UILabel *inPurseLab; // 进入钱包
@property (nonatomic, strong) UILabel *rewardLab; // 领取奖励
@property (nonatomic, strong) UIImageView *rewardIcon; // 奖励图标

/*********  进入钱包Btn约束  ***********/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *walletLeftConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *walletTopConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *walletWidthConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *walletHeightConstraints;


@end

@implementation NZTakeContentView

- (void)layoutSubviews {
    // 头像
    if (_headImageView) {
        _headImageView.frame = CGRectMake(ScreenWidth*25/375, ScreenWidth*15/375, ScreenWidth*135/375, ScreenWidth*135/375);
    } else {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, ScreenWidth*15/375, ScreenWidth*135/375, ScreenWidth*135/375)];
        _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"头像男"];
        [self addSubview:_headImageView];
    }
    
    // 钱袋
    if (_purseImgV) {
        _purseImgV.frame = CGRectMake((ScreenWidth-ScreenWidth*180/375-ScreenWidth*22/375)/2+ScreenWidth*160/375, ScreenWidth*30/375+25, ScreenWidth*22/375, ScreenWidth*23/375);
    } else {
        _purseImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ScreenWidth*180/375-ScreenWidth*22/375)/2+ScreenWidth*160/375, ScreenWidth*30/375+25, ScreenWidth*22/375, ScreenWidth*23/375)];
        _purseImgV.image = [UIImage imageNamed:@"钱袋"];
        [self addSubview:_purseImgV];
    }
    
    // 钱袋左右两条线
    if (_leftLine) {
        _leftLine.frame = CGRectMake(_purseImgV.origin.x - ScreenWidth*50/375, _purseImgV.origin.y+ScreenWidth*11/375, ScreenWidth*40/375, 1);
    } else {
        _leftLine = [[UIView alloc] initWithFrame:CGRectMake(_purseImgV.origin.x - ScreenWidth*50/375, _purseImgV.origin.y+ScreenWidth*11/375, ScreenWidth*40/375, 1)];
        _leftLine.backgroundColor = darkGoldColor;
        [self addSubview:_leftLine];
    }
    
    if (_rightLine) {
        _rightLine.frame = CGRectMake(CGRectGetMaxX(_purseImgV.frame) + ScreenWidth*10/375, _purseImgV.origin.y+ScreenWidth*11/375, ScreenWidth*40/375, 1);
    } else {
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_purseImgV.frame) + ScreenWidth*10/375, _purseImgV.origin.y+ScreenWidth*11/375, ScreenWidth*40/375, 1)];
        _rightLine.backgroundColor = darkGoldColor;
        [self addSubview:_rightLine];
    }
    
    // 总收益label
    if (_totalLab) {
        _totalLab.frame = CGRectMake(ScreenWidth*160/375, CGRectGetMaxY(_purseImgV.frame)+2, ScreenWidth-ScreenWidth*180/375, 20);
    } else {
        _totalLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*160/375, CGRectGetMaxY(_purseImgV.frame)+2, ScreenWidth-ScreenWidth*180/375, 20)];
        _totalLab.text = @"总收益（元）";
        _totalLab.textColor = darkGoldColor;
        _totalLab.font = [UIFont systemFontOfSize:17.f];
        _totalLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_totalLab];
    }
    
    // 进入钱包
    if (_inPurseLab) {
        _inPurseLab.frame = CGRectMake(_totalLab.origin.x, CGRectGetMaxY(_totalLab.frame)+ScreenWidth*3/375, ScreenWidth-ScreenWidth*180/375, 15);
    } else {
        _inPurseLab = [[UILabel alloc] initWithFrame:CGRectMake(_totalLab.origin.x, CGRectGetMaxY(_totalLab.frame)+ScreenWidth*3/375, ScreenWidth-ScreenWidth*180/375, 15)];
        _inPurseLab.text = @"进入钱包";
        _inPurseLab.textColor = darkGoldColor;
        _inPurseLab.font = [UIFont systemFontOfSize:13.f];
        _inPurseLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_inPurseLab];
    }
    
    // 进入钱包button
    _walletLeftConstraints.constant = _leftLine.origin.x;
    _walletTopConstraints.constant = _purseImgV.origin.y;
    _walletWidthConstraints.constant = CGRectGetMaxX(_rightLine.frame)-_leftLine.origin.x;
    _walletHeightConstraints.constant = CGRectGetMaxY(_inPurseLab.frame)-_purseImgV.origin.y;
//    _intoWalletBtn.frame = CGRectMake(_leftLine.origin.x, _purseImgV.origin.y, CGRectGetMaxX(_rightLine.frame)-_leftLine.origin.x, CGRectGetMaxY(_inPurseLab.frame)-_purseImgV.origin.y);
    
    // 领取奖励
    if (_rewardLab) {
        _rewardLab.frame = CGRectMake(ScreenWidth-ScreenWidth*20/375-65, CGRectGetMaxY(_inPurseLab.frame)+ScreenWidth*7/375, 65, 20);
    } else {
        _rewardLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*20/375-65, CGRectGetMaxY(_inPurseLab.frame)+ScreenWidth*7/375, 65, 20)];
        _rewardLab.text = @"领取奖励";
        _rewardLab.textColor = darkRedColor;
        _rewardLab.font = [UIFont systemFontOfSize:14.f];
        _rewardLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rewardLab];
    }
    
    // 奖励图标
    if (_rewardIcon) {
        _rewardIcon.frame = CGRectMake(_rewardLab.origin.x-ScreenWidth*16/375, _rewardLab.centerY-ScreenWidth*7/375, ScreenWidth*16/375, ScreenWidth*15/375);
    } else {
        _rewardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_rewardLab.origin.x-ScreenWidth*16/375, _rewardLab.centerY-ScreenWidth*7/375, ScreenWidth*16/375, ScreenWidth*15/375)];
        _rewardIcon.image = [UIImage imageNamed:@"礼盒"];
        [self addSubview:_rewardIcon];
    }
    
    // 连续签到天数
    if (_signDaysLab) {
        _signDaysLab.frame = CGRectMake(ScreenWidth*145/375, _rewardLab.origin.y, _rewardIcon.origin.x-ScreenWidth*155/375, 20);
    } else {
        _signDaysLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*145/375, _rewardLab.origin.y, _rewardIcon.origin.x-ScreenWidth*155/375, 20)];
        _signDaysLab.text = @"连续登录0天";
        _signDaysLab.textColor = [UIColor grayColor];
        _signDaysLab.font = [UIFont systemFontOfSize:15.f];
        _signDaysLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_signDaysLab];
    }
    
    // 昵称
    if (_nickNameLab) {
        
    } else {
        _nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+ScreenWidth*15/375, ScreenWidth*125/375, 20)];
        _nickNameLab.font = [UIFont systemFontOfSize:20.f];
        _nickNameLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_nickNameLab];
    }
    
    // 积分
    if (_integralLab) {
        _integralLab.frame = CGRectMake(CGRectGetMaxX(_nickNameLab.frame), _nickNameLab.origin.y+5, ScreenWidth*105/375, 15);
    } else {
        _integralLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameLab.frame), _nickNameLab.origin.y+5, ScreenWidth*105/375, 15)];
        _integralLab.font = [UIFont systemFontOfSize:16.f];
        _integralLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_integralLab];
    }
    
    // 星星条
    if (_starBar) {
        _starBar.frame = CGRectMake(CGRectGetMaxX(_integralLab.frame)+3, _integralLab.origin.y+2, ScreenWidth*72/375, ScreenWidth*11/375);
    } else {
        _starBar = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_integralLab.frame)+3, _integralLab.origin.y+2, ScreenWidth*72/375, ScreenWidth*11/375)];
        [self addSubview:_starBar];
    }
    
    // 九宫格的高度
    _friendsTop.constant = CGRectGetMaxY(_starBar.frame) + ScreenWidth*15/375;
}

@end
