//
//  UITableView+Category.m
//  TestIM
//
//  Created by mac iko on 13-10-13.
//  Copyright (c) 2013年 mac iko. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Category)
- (void)scrollToBottom:(BOOL)animated
{
    NSUInteger sectionCount = [self numberOfSections];
    if (sectionCount) {
        NSUInteger rowCount = [self numberOfRowsInSection:0];
        if (rowCount) {
            NSUInteger ii[2] = {0, rowCount-1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
                                animated:animated];
        }
    }
}
@end
