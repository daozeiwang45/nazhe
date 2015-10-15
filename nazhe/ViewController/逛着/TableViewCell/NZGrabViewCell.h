//
//  NZGrabViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/9.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZGrabViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *productImageV;
@property (strong, nonatomic) IBOutlet UIView *quicklyView;
@property (weak, nonatomic) IBOutlet UIButton *quicklyButton;

@property (weak, nonatomic) IBOutlet UILabel *grabTittleLab;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *leftNumLab;

@end
