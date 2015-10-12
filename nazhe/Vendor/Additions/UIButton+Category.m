//
//  UIButton+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)
//===============————————本方法未被使用
//-(void)centerButtonAndImageWithSapcing:(CGFloat)spacing{
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    NSLog(@"%f %f",self.titleLabel.frame.origin.x,self.titleLabel.frame.origin.y);
//    NSLog(@"%f",imageSize.height);
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
//    titleSize = self.titleLabel.frame.size;
//    NSLog(@"%f %f",self.titleLabel.frame.origin.x,self.titleLabel.frame.origin.y);
//    self.imageEdgeInsets = UIEdgeInsetsMake(0.0 - (titleSize.height + spacing), 0.0, 0.0, 0.0 - titleSize.width);
//}

//-(void)exchangeImageAndTitleWithSpacing:(CGFloat)spacing{
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width-spacing, 0.0, 0.0);
//    titleSize = self.titleLabel.frame.size;
//    
//    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0+titleSize.width+imageSize.width, 0, 0);
//}
//
//-(void)centerMyTitle:(CGFloat)spacing{
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, 0.0, 0.0);
//    titleSize = self.titleLabel.frame.size;
//    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width - spacing, 0.0, 0.0);
//}
//
//-(void)normorlMyTitle{
//    CGSize titleSize = self.titleLabel.frame.size;
//    self.titleEdgeInsets = UIEdgeInsetsZero;
//    titleSize = self.titleLabel.frame.size;
//    self.imageEdgeInsets =UIEdgeInsetsZero;
//}

-(void)setBackgroundImage:(UIImage *)image{
    CGRect rect;
    rect       = self.frame;
    rect.size  = image.size;            // set button size as image size
    self.frame = rect;
    
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)setBackgroundImageByName:(NSString *)imageName{
    [self setBackgroundImage:[UIImage imageNamed:imageName]];
}


- (void)normalTitle:(NSString *)string
{
    [self setTitle:string forState:UIControlStateNormal];
}

- (void)normalImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)highlightTitle:(NSString *)string
{
    [self setTitle:string forState:UIControlStateHighlighted];
}

- (void)highlightImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateHighlighted];
}
@end
