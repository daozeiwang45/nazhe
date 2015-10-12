//
//  NZChatController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZChatController.h"

@interface NZChatController ()

@end

@implementation NZChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"聊着"];
    [self createLeftAndRightNavigationItemButton];
}

#pragma mark 四个主视图的tabBar收缩自如
- (void)viewWillAppear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

@end
