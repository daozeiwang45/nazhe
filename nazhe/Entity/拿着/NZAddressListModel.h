//
//  NZAddressListModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/20.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZAddressListModel : NSObject

/**
 *  收货地址数组(NZAddressModel)
 */
@property (nonatomic, strong) NSMutableArray *addressInfo;

@end

@interface NZAddressModel : NSObject

/**
 *  收货地址ID
 */
@property (nonatomic, assign) int addressId;
/**
 *  收货人姓名
 */
@property (nonatomic, strong) NSString *name;
/**
 *  收货人电话
 */
@property (nonatomic, strong) NSString *phone;
/**
 *  收货人详细地址
 */
@property (nonatomic, strong) NSString *addressDetail;

@end
