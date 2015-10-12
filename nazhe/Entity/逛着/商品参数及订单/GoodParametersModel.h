//
//  GoodParametersModel.h
//  nazhe
//
//  Created by WSGG on 15/9/29.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//信息存在对应的数组
@interface GoodParametersModel : NSObject

@property (nonatomic,strong) NSMutableArray *goodsInfo;
@property (nonatomic,strong) NSMutableArray *weightList;
@property (nonatomic,strong) NSMutableArray *sizeList;
@property (nonatomic,strong) NSMutableArray *gradeList;
@property (nonatomic,strong) NSMutableArray *hardnessList;
@property (nonatomic,strong) NSMutableArray *fillInList;
@property (nonatomic,strong) NSMutableArray *accessoriesList;
@property (nonatomic,strong) NSMutableArray *colorList;

@end

//基本信息
@interface ParametersModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,assign) CGFloat marketPrice;
@property (nonatomic,assign) int count;

@end

//重量
@interface WeightListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int count;

@end

//规格
@interface SizeListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int count;

@end

//等级
@interface GradeListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int count;

@end

//硬度
@interface HardnessListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int count;

@end

//镶嵌
@interface FillInListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int count;

@end

//配饰
@interface AccessoriesListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int  count;

@end

//颜色
@interface ColorListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int count;

@end