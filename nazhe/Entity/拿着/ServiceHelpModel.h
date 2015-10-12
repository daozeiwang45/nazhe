//
//  ServiceHelpModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceHelpModel : NSObject

/**
 *  帮助数组(ServiceHelpInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface ServiceHelpInfoModel : NSObject

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  类型
 */
@property (nonatomic, assign) int type;



@end
