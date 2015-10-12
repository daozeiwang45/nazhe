//
//  NZCommodityListCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/27.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZCommodityListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *commodityImageView;

@property (strong, nonatomic) IBOutlet UIView *rightMaskView;
@property (strong, nonatomic) IBOutlet UIView *leftMaskView;
@property (strong, nonatomic) IBOutlet UIView *rightLabelView;
@property (strong, nonatomic) IBOutlet UIView *leftLabelView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLabelConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLabelConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightMaskConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftMaskConstraints;

/****************  左边  ******************/
@property (strong, nonatomic) IBOutlet UIImageView *leftLogoImgV;
@property (strong, nonatomic) IBOutlet UILabel *leftBrandName;
@property (strong, nonatomic) IBOutlet UILabel *leftEnglishName;
@property (strong, nonatomic) IBOutlet UILabel *leftGoodName;
@property (strong, nonatomic) IBOutlet UILabel *leftVerticalLab;

/****************  右边  ******************/
@property (strong, nonatomic) IBOutlet UIImageView *rightLogoImgV;
@property (strong, nonatomic) IBOutlet UILabel *rightBrandName;
@property (strong, nonatomic) IBOutlet UILabel *rightEnglishName;
@property (strong, nonatomic) IBOutlet UILabel *rightGoodName;
@property (strong, nonatomic) IBOutlet UILabel *rightVerticalLab;

@end
