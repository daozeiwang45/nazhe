//
//  NZDownArrowView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/26.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZDownArrowView.h"

@implementation NZDownArrowView

- (void)drawRect:(CGRect)rect {
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    //指定直线样式
    //    CGContextSetLineCap(context, kCGLineCapSquare);
    
    //直线宽度
    CGContextSetLineWidth(context, 0.5);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    //开始绘制
    CGContextBeginPath(context);
    
    //画笔移动到点
    CGContextMoveToPoint(context, 0, 0);
    
    //下一点
    CGContextAddLineToPoint(context, self.frame.size.width/2, self.frame.size.height);
    
    //下一点
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    
    //绘制完成
    CGContextStrokePath(context);
    
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor clearColor];
}

@end
