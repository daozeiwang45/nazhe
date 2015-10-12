//
//  NZDeliveryAddressViewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDeliveryAddressModel.h"

@protocol NZDeliveryAddressDelegate <NSObject>

- (void)setDefaultAddressWithIndex:(int)addID;
- (void)editAddressWithIndex:(int)addID;
- (void)deleteAddressWithAddID:(int)addID;

@end

@interface NZDeliveryAddressViewCell : UITableViewCell

@property (nonatomic, assign) int addressID;
@property (nonatomic, strong) MyDeliveryAddressInfoModel *addressInfoModel;

@property (strong, nonatomic) IBOutlet UILabel *defaultLab;
@property (strong, nonatomic) IBOutlet UIImageView *defaultMark;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (assign, nonatomic) id<NZDeliveryAddressDelegate> delegate;

@end
