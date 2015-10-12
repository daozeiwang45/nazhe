//
//  MaterialListModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialListModel : NSObject

/**
 *  材质数组(MaterialModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface MaterialModel : NSObject

/**
 *  材质编号
 */
@property (nonatomic, assign) int materialID;
/**
 *  品种数组(VarietyModel)
 */
@property (nonatomic, strong) NSMutableArray *variety;
/**
 *  材质中文名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  材质英文名
 */
@property (nonatomic, copy) NSString *englishName;
/**
 *  背景图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  材质标志
 */
@property (nonatomic, copy) NSString *icon;

@end

@interface VarietyModel : NSObject

/**
 *  品种编号
 */
@property (nonatomic, assign) int varietyID;
/**
 *  品种名称
 */
@property (nonatomic, strong) NSString *name;

@end
