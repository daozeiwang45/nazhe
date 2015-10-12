//
//  ServiceReplyModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceReplyModel : NSObject

/**
 *  总页数
 */
@property (nonatomic, assign) int total;
/**
 *  当前页
 */
@property (nonatomic, assign) int page_count;
/**
 *  回复数组(MyDeliveryAddressInfoModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface ServiceReplyInfoModel : NSObject

/**
 *  类型
 */
@property (nonatomic, copy) NSString *type;

/**
 *  主题
 */
@property (nonatomic, copy) NSString *theme;

/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  客服回复
 */
@property (nonatomic, copy) NSString *reply;

/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *time;

/**
 *  回复时间
 */
@property (nonatomic, copy) NSString *replyTime;

@end