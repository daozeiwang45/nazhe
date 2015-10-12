//
//  NZDrawArrowView.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/27.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, drawShape)
{
    upLineShape = 1 ,      // 向上的线性三角箭头
    downLineShape = 2 ,    // 向下的线性三角箭头
    leftLineShape = 3 ,    // 向左的线性三角箭头
    rightLineShape = 4 ,   // 向右的线性三角箭头
    upTriangleShape = 5 ,  // 向上的实心三角箭头
};

@interface NZDrawArrowView : UIView

+ (void)drawUpLineArrowWithFrame:(CGRect)frame;

+ (void)drawDownLineArrowWithFrame:(CGRect)frame;

+ (void)drawLeftLineArrowWithFrame:(CGRect)frame;

+ (void)drawRightLineArrowWithFrame:(CGRect)frame;

+ (void)drawUpTriangleArrowWithFrame:(CGRect)frame;

@end
