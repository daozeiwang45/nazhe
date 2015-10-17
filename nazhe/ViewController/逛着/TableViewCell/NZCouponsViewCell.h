//
//  NZCouponsViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZCouponsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *couponTittleLable;

@property (strong, nonatomic) IBOutlet UILabel *couponLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *couponImgView;
@property (weak, nonatomic) IBOutlet UIButton *haveButton;
@property (weak, nonatomic) IBOutlet UILabel *haveLable;

@end
