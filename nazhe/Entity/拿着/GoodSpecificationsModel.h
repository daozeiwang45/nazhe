//
//  GoodSpecificationsModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodSpecificationsModel : NSObject

/**
 *  重量列表数组(BagParametersModel)
 */
@property (nonatomic, strong) NSMutableArray *weightList;
/**
 *  规格列表数组(BagParametersModel)
 */
@property (nonatomic, strong) NSMutableArray *sizeList;
/**
 *  等级列表数组(BagParametersModel)
 */
@property (nonatomic, strong) NSMutableArray *gradeList;
/**
 *  颜色列表数组(BagParametersModel)
 */
@property (nonatomic, strong) NSMutableArray *colorList;
/**
 *  硬度列表数组(BagParametersModel)
 */
@property (nonatomic, strong) NSMutableArray *hardnessList;
/**
 *  镶嵌列表数组(BagParametersModel)
 */
@property (nonatomic, strong) NSMutableArray *fillInList;
/**
 *  配饰列表数组(BagParametersModel)
 */
@property (nonatomic, strong) NSMutableArray *accessoriesList;
/**
 *  包装
 */
@property (nonatomic, copy) NSString *pack;

@end

@interface BagParametersModel : NSObject

/**
 *  名称  
 */
@property (nonatomic, strong) NSString *name;
/**
 *  价格
 */
@property (nonatomic, assign) float price;
/**
 *  是否选择
 */
@property (nonatomic, assign) BOOL isChose;
/**
 *  数量
 */
@property (nonatomic, assign) int count;

@end
