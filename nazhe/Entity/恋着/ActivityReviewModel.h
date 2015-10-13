//
//  ActivityReviewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityReviewModel : NSObject

/**
 *  总条数
 */
@property (nonatomic, assign) int total;
/**
 *  总页数
 */
@property (nonatomic, assign) int page_count;
/**
 *  活动评论数组(ReviewModel)
 */
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface ReviewModel : NSObject

/**
 *  评论编号
 */
@property (nonatomic, assign) int commentId;
/**
 *  用户id
 */
@property (nonatomic, assign) int friendId;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *NickName;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *headImg;
/**
 *  用户星级
 */
@property (nonatomic, assign) int star;
/**
 *  评论对象（默认为空字符串表示对活动评论，如果是非空字符串，表示对某人进行评论）
 */
@property (nonatomic, copy) NSString *friendName;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  评论时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  评论的点赞数
 */
@property (nonatomic, assign) int countPraise;

@end
