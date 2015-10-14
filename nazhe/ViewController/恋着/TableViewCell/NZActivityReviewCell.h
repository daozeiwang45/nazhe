//
//  NZActivityReviewCell.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCommentViewModel.h"

@protocol NZActivityReviewDelegate <NSObject>

- (void)replyWithIndex:(int)index;
- (void)deleteWithIndex:(int)index;

@end

@interface NZActivityReviewCell : UITableViewCell

@property (nonatomic, strong) NZCommentViewModel *commemtVM;

@property (nonatomic, assign) int index;

@property (assign, nonatomic) id<NZActivityReviewDelegate> delegate;

@end
