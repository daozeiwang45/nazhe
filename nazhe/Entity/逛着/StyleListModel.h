//
//  StyleListModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleListModel : NSObject

/**
 *  款式数组(StyleModel)
 */
@property (nonatomic, strong) NSMutableArray *styleList;

@end

@interface StyleModel : NSObject

/**
 *  材质编号
 */
@property (nonatomic, assign) int styleID;
/**
 *  款式中文名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  款式英文名
 */
@property (nonatomic, copy) NSString *englishName;
/**
 *  款式背景图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  款式标志
 */
@property (nonatomic, copy) NSString *icon;

@end
