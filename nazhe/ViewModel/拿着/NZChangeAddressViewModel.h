//
//  NZChangeAddressViewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/20.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyDeliveryAddressModel.h"

@interface NZChangeAddressViewModel : NSObject

@property (nonatomic, strong) MyDeliveryAddressInfoModel *myAddressInfoModel;

// 收货人姓名尺寸
@property (nonatomic, assign) CGRect nameLabFrame;

// 收货人号码尺寸
@property (nonatomic, assign) CGRect phoneLabFrame;

// 详细地址尺寸
@property (nonatomic, assign) CGRect detailAddressFrame;

// 虚线尺寸
@property (nonatomic, assign) CGRect lineFrame;

@end
