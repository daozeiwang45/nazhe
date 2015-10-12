//
//  NZUsingMethodView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/2.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZUsingMethodView.h"

@interface NZUsingMethodView () {
    CGRect selfRect;
}

@property (nonatomic,strong) UILabel *methodLab;
@property (nonatomic,strong) UILabel *stepLab;

@end

@implementation NZUsingMethodView

- (void)drawRect:(CGRect)rect {
    selfRect = rect;
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0.6, 0.6, 0.6, 0.8);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    
    CGContextAddEllipseInRect(context, rect); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}

- (void)layoutSubviews {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height / 2 + 3, self
                                                            .frame.size.width - 10, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    
}

- (void)setUseMethod:(NSString *)useMethod {
    CGFloat labWidth = (ScreenWidth - 100) / 4;
    
    _methodLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, labWidth - 16, labWidth / 2 + 3)];
    _methodLab.text = useMethod;
    _methodLab.textColor = [UIColor darkGrayColor];
    _methodLab.font = [UIFont systemFontOfSize:9.f];
    _methodLab.textAlignment = NSTextAlignmentCenter;
    _methodLab.numberOfLines = 0;
    [self addSubview:_methodLab];
}

- (void)setStep:(int)step {
    CGFloat labWidth = (ScreenWidth - 100) / 4;
    
    _stepLab = [[UILabel alloc] initWithFrame:CGRectMake(8, labWidth / 2 + 6, labWidth - 16, labWidth / 2 - 8)];
    _stepLab.text = [NSString stringWithFormat:@"%d",step];
    _stepLab.textColor = [UIColor darkGrayColor];
    _stepLab.font = [UIFont systemFontOfSize:15.f];
    _stepLab.textAlignment = NSTextAlignmentCenter;
    _stepLab.numberOfLines = 0;
    [self addSubview:_stepLab];
}

@end
