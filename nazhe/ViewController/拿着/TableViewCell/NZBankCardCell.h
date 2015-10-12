//
//  NZBankCardCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/18.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZBankCardCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *bankImgV;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLab;
@property (strong, nonatomic) IBOutlet UILabel *numberLab;
@property (strong, nonatomic) IBOutlet UILabel *subLab;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@end
