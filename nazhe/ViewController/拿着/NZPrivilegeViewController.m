//
//  NZPrivilegeViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/2.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZPrivilegeViewController.h"
#import "NZPrivilegeContentView.h"

@interface NZPrivilegeViewController () {
    NZPrivilegeContentView *contentView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NZPrivilegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"特权"];
    [self leftButtonTitle:nil];
    
    [self initInterface];
    
}

#pragma mark 初始化界面
- (void)initInterface {
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    contentView = [[[NSBundle mainBundle] loadNibNamed:@"NZPrivilegeContentView" owner:self options:nil] objectAtIndex:0];
    [self.scrollView addSubview:contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
}

#pragma mark contentView约束
- (void)viewDidLayoutSubviews {
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:self.scrollView.frame.size.width]);
        make.height.equalTo([NSNumber numberWithFloat:contentView.bottomLine.origin.y + 26]);
    }];
    
    [super viewDidLayoutSubviews];
}

@end
