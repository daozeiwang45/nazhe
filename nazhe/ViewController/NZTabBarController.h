//
//  NZTabBarController.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateTabbar.h"

@interface NZTabBarController : UITabBarController<AnimateTabbarDelegate>

@property (nonatomic,strong) AnimateTabbarView *customTabBar;

@end
