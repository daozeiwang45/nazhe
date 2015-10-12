//
//  NZLeftTriangleArrowView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/27.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZLeftTriangleArrowView.h"

@implementation NZLeftTriangleArrowView

- (void)drawRect:(CGRect)rect {
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    //指定直线样式
    //    CGContextSetLineCap(context, kCGLineCapSquare);
    
    //直线宽度
    CGContextSetLineWidth(context, 1.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    
    //开始绘制
    CGContextBeginPath(context);
    
    //画笔移动到点
    CGContextMoveToPoint(context, self.frame.size.width, 0);
    
    //下一点
    CGContextAddLineToPoint(context, 0, self.frame.size.height/2);
    
    //下一点
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    CGContextSetRGBFillColor (context,  1.0, 1.0, 1.0, 1.0);//设置填充颜色
    
    //绘制完成
    CGContextDrawPath(context, kCGPathFill);
    
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor clearColor];
}

@end
