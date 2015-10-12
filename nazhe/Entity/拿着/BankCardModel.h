//
//  BankCardModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/18.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardModel : NSObject

/**
 *  银行卡数组(BankCardInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface BankCardInfoModel : NSObject

/**
 *  银行卡名称
 */
@property (nonatomic, copy) NSString *bankName;
/**
 *  银行卡图标
 */
@property (nonatomic, copy) NSString *bankIcon;
/**
 *  卡id
 */
@property (nonatomic, assign) int ID;
/**
 *  卡号
 */
@property (nonatomic, copy) NSString *cardNumber;
/**
 *  所在支行
 */
@property (nonatomic, copy) NSString *bankBranch;
/**
 *  真实姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  是否为默认
 */
@property (nonatomic, assign) BOOL isDefault;

@end
