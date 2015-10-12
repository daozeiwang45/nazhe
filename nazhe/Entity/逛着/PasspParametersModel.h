//
//  PasspParametersModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/25.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasspParametersModel : NSObject

/**
 *  材质入口或者款式入口进来
 */
@property (nonatomic, assign) enumtMaterialOrStyleType type;
/**
 *  材质编号
 */
@property (nonatomic, assign) int materialID;
/**
 *  款式编号
 */
@property (nonatomic, assign) int styleID;
/**
 *  品种或品牌编号
 */
@property (nonatomic, assign) int varOrBrandID;
/**
 *  排序编号
 */
@property (nonatomic, assign) int sortID;

@end
