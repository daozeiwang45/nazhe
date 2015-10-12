//
//  NZTabBarController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZTabBarController.h"
#import "NZLoginViewController.h"

@interface NZTabBarController ()

@end

@implementation NZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customTabBar = [[AnimateTabbarView alloc]initWithFrame:self.view.frame];
    self.customTabBar.delegate = self;
    [self.tabBar addSubview:self.customTabBar];
}

// callback
int g_flags = 1;
-(void)FirstBtnClick{
    if(g_flags == 1)
        return;
    g_flags = 1;
    [self setSelectedIndex:0];
}

-(void)SecondBtnClick{
    if(g_flags == 2)
        return;
    g_flags = 2;
    [self setSelectedIndex:1];
}

-(void)ThirdBtnClick{
    if(g_flags == 3)
        return;
    g_flags = 3;
    [self setSelectedIndex:2];
}

-(void)FourthBtnClick{
    if(g_flags == 4)
        return;
    g_flags = 4;
    [self setSelectedIndex:3];
}

@end
