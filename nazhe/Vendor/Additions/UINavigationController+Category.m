//
//  UINavigationController+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-26.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "UINavigationController+Category.h"

@implementation UINavigationController (Category)
- (void)setBackgroudImage:(UIImage*)image
{
    CGSize imageSize = [image size];
    self.navigationBar.frame = CGRectMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y - 20, self.navigationBar.frame.size.width, imageSize.height);
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    backgroundImage.frame = self.navigationBar.frame;
    [self.navigationBar addSubview:backgroundImage];
}
@end
