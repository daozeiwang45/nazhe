//
//  DynamicMessageModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/23.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicMessageModel : NSObject

/**
 *  总页数
 */
@property (nonatomic, assign) int total;
/**
 *  当前页
 */
@property (nonatomic, assign) int page_count;
/**
 *  消息内容数组(DynamicMessageInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface DynamicMessageInfoModel : NSObject

/**
 *  发送时间
 */
@property (nonatomic, copy) NSString *time;

/**
 *  变动金额
 */
@property (nonatomic, assign) float money;

/**
 *  当前金额
 */
@property (nonatomic, assign) float currentAccount;

/**
 *  变动积分
 */
@property (nonatomic, assign) int score;

/**
 *  当前积分
 */
@property (nonatomic, assign) int currentScore;

/**
 *  类型(0:增加,1:扣除)
 */
@property (nonatomic, assign) int state;

/**
 *  说明
 */
@property (nonatomic, copy) NSString *info;

/**
 *  订单号
 */
@property (nonatomic, copy) NSString *orderId;

/**
 *  背景图片
 */
@property (nonatomic, copy) NSString *bgImg;

/**
 *  主题
 */
@property (nonatomic, copy) NSString *theme;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;


@end
