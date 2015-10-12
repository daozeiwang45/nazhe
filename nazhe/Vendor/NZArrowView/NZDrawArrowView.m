//
//  NZDrawArrowView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/27.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZDrawArrowView.h"

@interface NZDrawArrowView () {
    drawShape drawShape;
}

@end

@implementation NZDrawArrowView

+ (void)drawUpLineArrowWithFrame:(CGRect)frame {
    [self initialize];
}

+ (void)drawDownLineArrowWithFrame:(CGRect)frame {
    
}

+ (void)drawLeftLineArrowWithFrame:(CGRect)frame {
    
}

+ (void)drawRightLineArrowWithFrame:(CGRect)frame {
    
}

+ (void)drawUpTriangleArrowWithFrame:(CGRect)frame {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

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
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    
    //下一点
    CGContextAddLineToPoint(context, self.frame.size.width/2, 0);
    
    //下一点
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    
    //绘制完成
    CGContextStrokePath(context);
    
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor clearColor];
}

@end
