//
//  NZBillingViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZBillingViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;

@property (strong, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UILabel *moneyLab;
@property (strong, nonatomic) IBOutlet UILabel *fromLab;

@end
