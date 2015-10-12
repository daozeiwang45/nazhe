//
//  NZReplyViewModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServiceReplyModel.h"

@interface NZReplyViewModel : NSObject

@property (nonatomic, strong) ServiceReplyInfoModel *reply;

@property (nonatomic, copy) NSString *quesStr;
// 提问内容
@property (nonatomic, assign) CGRect contentFrame;

// 回复内容
@property (nonatomic, assign) CGRect replyContentFrame;

@end
