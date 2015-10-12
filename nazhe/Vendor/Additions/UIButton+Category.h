//
//  UIButton+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)
//-(void)centerButtonAndImageWithSapcing:(CGFloat)spacing;
//-(void)exchangeImageAndTitleWithSpacing:(CGFloat)spacing;
//-(void)centerMyTitle:(CGFloat)spacing;
//-(void)normorlMyTitle;
//button根据image大小改变
- (void)setBackgroundImage:(UIImage*)image;
- (void)setBackgroundImageByName:(NSString*)imageName;

- (void)normalTitle:(NSString *)string;
- (void)normalImage:(UIImage *)image;
- (void)highlightTitle:(NSString *)string;
- (void)highlightImage:(UIImage *)image;
@end
