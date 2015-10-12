//
//  NZMessageViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/5.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZMessageViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *dynamicTypeLab;

@end
