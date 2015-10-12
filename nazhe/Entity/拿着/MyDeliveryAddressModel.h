//
//  MyAddressModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "APIResultEntity.h"

@interface MyDeliveryAddressModel : APIResultEntity<MJKeyValue>

/**
 *  总页数
 */
@property (nonatomic, assign) int total;
/**
 *  当前页
 */
@property (nonatomic, assign) int page_count;
/**
 *  地址数组(MyDeliveryAddressInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface MyDeliveryAddressInfoModel : NSObject
/**
 *  地址id
 */
@property (nonatomic, assign) int addressID;
/**
 *  收货人姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  详细地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  是否为默认地址
 */
@property (nonatomic, assign) BOOL isDefault;
/**
 *  用户手机
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  邮编
 */
@property (nonatomic, copy) NSString *zipCode;
/**
 *  省
 */
@property (nonatomic, copy) NSString *province;
/**
 *  市
 */
@property (nonatomic, copy) NSString *city;
/**
 *  区
 */
@property (nonatomic, copy) NSString *district;

@end
