//
//  NZCommentViewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityReviewModel.h"

@interface NZCommentViewModel : NSObject

@property (nonatomic, strong) ReviewModel *review;

// 评论人昵称
@property (nonatomic, assign) CGRect nameFrame;

// 评论人星级
@property (nonatomic, assign) CGRect starFrame;

// 回复对象
@property (nonatomic, assign) CGRect friendFrame;

// 评论内容
@property (nonatomic, assign) CGRect contentFrame;

// 举报Frame
@property (nonatomic, assign) CGRect reportFrame;

// 分割线Frame
@property (nonatomic, assign) CGRect dividingFrame;

// 回复Frame
@property (nonatomic, assign) CGRect replyFrame;

@end
