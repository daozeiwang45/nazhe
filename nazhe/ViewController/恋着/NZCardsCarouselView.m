//
//  NZCardsCarouselView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZCardsCarouselView.h"

const static CGFloat animationDuration = 0.5f;

@interface NZCardsCarouselView () {
    NSMutableArray *imagesURL; // 图片数组
    NSMutableArray *imagesID; // 图片ID
    
    UIView *leftOneView;
    UIView *leftTwoView;
    UIView *centerView;
    UIView *rightOneView;
    UIView *rightTwoView;
    
    UIImageView *leftOneImageView;
    UIImageView *leftTwoImageView;
    UIImageView *centerImageView;
    UIImageView *rightOneImageView;
    UIImageView *rightTwoImageView;
    
    UIView *leftOneMaskView;
    UIView *leftTwoMaskView;
    UIView *centerMaskView;
    UIView *rightOneMaskView;
    UIView *rightTwoMaskView;
    
    CGPoint leftOnePosition;
    CGPoint leftTwoPosition;
    CGPoint centerPosition;
    CGPoint rightOnePosition;
    CGPoint rightTwoPosition;
    
    NSTimer *timer;
    BOOL isAnimationing;
    
    int last2Index;
    int lastIndex;
    int currentIndex;
    int nextIndex;
    int next2Index;
}

@end

@implementation NZCardsCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setupElements];
    }
    return self;
}

- (void)layoutSubviews {
    
}

- (void)setStarList:(NSMutableArray *)starList {
    _starList = starList;
    
    NSMutableArray *imgAry = [NSMutableArray array];
    NSMutableArray *imgID = [NSMutableArray array];
    for (int i=0; i<starList.count; i++) {
        StarModel *starModel = starList[i];
        [imgAry addObject:starModel.img];
        [imgID addObject:[NSNumber numberWithInt:starModel.starImgID]];
    }
    imagesURL = imgAry;
    imagesID = imgID;
    
    last2Index = (int)imagesURL.count - 2;
    lastIndex = (int)imagesURL.count - 1;
    currentIndex = 0;
    nextIndex = 1;
    next2Index = 2;
    
    [self refreshImages];
}

- (void)setupElements {
    [self setupCardsView];
}

- (void)setupCardsView {
    /*************   中间的卡片   ****************/
    centerView = [[UIView alloc] init];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(80);
        make.bottom.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(-80);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 5.f;
    centerView.clipsToBounds = YES;
    
    centerImageView = [[UIImageView alloc] init];
    [centerView addSubview:centerImageView];
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView).with.offset(5);
        make.left.equalTo(centerView).with.offset(5);
        make.bottom.equalTo(centerView).with.offset(-5);
        make.right.equalTo(centerView).with.offset(-5);
    }];
//    [centerImageView sd_setImageWithURL:imagesURL[currentIndex]];
    
    centerMaskView = [[UIView alloc] init];
    centerMaskView.backgroundColor = [UIColor whiteColor];
    centerMaskView.alpha = 0.7;
    centerMaskView.hidden = YES;
    [centerView addSubview:centerMaskView];
    [centerMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView).with.offset(0);
        make.left.equalTo(centerView).with.offset(0);
        make.bottom.equalTo(centerView).with.offset(0);
        make.right.equalTo(centerView).with.offset(0);
    }];
    
    /*************   左2的卡片   ****************/
    leftTwoView = [[UIView alloc] init];
    [self addSubview:leftTwoView];
    [leftTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(-40);
        make.centerY.equalTo(centerView.mas_centerY);
        make.width.equalTo(centerView.mas_width).multipliedBy(0.85);
        make.height.equalTo(centerView.mas_height).multipliedBy(0.85);
    }];
    leftTwoView.backgroundColor = [UIColor whiteColor];
    leftTwoView.layer.cornerRadius = 5.f;
    leftTwoView.clipsToBounds = YES;
    
    leftTwoImageView = [[UIImageView alloc] init];
    [leftTwoView addSubview:leftTwoImageView];
    [leftTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftTwoView).with.offset(4.25);
        make.left.equalTo(leftTwoView).with.offset(4.25);
        make.bottom.equalTo(leftTwoView).with.offset(-4.25);
        make.right.equalTo(leftTwoView).with.offset(-4.25);
    }];
//    [leftTwoImageView sd_setImageWithURL:imagesURL[lastIndex]];
    
    leftTwoMaskView = [[UIView alloc] init];
    leftTwoMaskView.backgroundColor = [UIColor whiteColor];
    leftTwoMaskView.alpha = 0.7;
    [leftTwoView addSubview:leftTwoMaskView];
    [leftTwoMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftTwoView).with.offset(0);
        make.left.equalTo(leftTwoView).with.offset(0);
        make.bottom.equalTo(leftTwoView).with.offset(0);
        make.right.equalTo(leftTwoView).with.offset(0);
    }];
    
    /*************   右1的卡片   ****************/
    rightOneView = [[UIView alloc] init];
    [self addSubview:rightOneView];
    [rightOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView.mas_right).offset(40);
        make.centerY.equalTo(centerView.mas_centerY);
        make.width.equalTo(centerView.mas_width).multipliedBy(0.85);
        make.height.equalTo(centerView.mas_height).multipliedBy(0.85);
    }];
    rightOneView.backgroundColor = [UIColor whiteColor];
    rightOneView.layer.cornerRadius = 5.f;
    rightOneView.clipsToBounds = YES;
    
    rightOneImageView = [[UIImageView alloc] init];
    [rightOneView addSubview:rightOneImageView];
    [rightOneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightOneView).with.offset(4.25);
        make.left.equalTo(rightOneView).with.offset(4.25);
        make.bottom.equalTo(rightOneView).with.offset(-4.25);
        make.right.equalTo(rightOneView).with.offset(-4.25);
    }];
//    [rightOneImageView sd_setImageWithURL:imagesURL[nextIndex]];
    
    rightOneMaskView = [[UIView alloc] init];
    rightOneMaskView.backgroundColor = [UIColor whiteColor];
    rightOneMaskView.alpha = 0.7;
    [rightOneView addSubview:rightOneMaskView];
    [rightOneMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightOneView).with.offset(0);
        make.left.equalTo(rightOneView).with.offset(0);
        make.bottom.equalTo(rightOneView).with.offset(0);
        make.right.equalTo(rightOneView).with.offset(0);
    }];
    
    /*************   左1的卡片   ****************/
    leftOneView = [[UIView alloc] init];
    [self addSubview:leftOneView];
    [leftOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(-80);
        make.centerY.equalTo(centerView.mas_centerY);
        make.width.equalTo(leftTwoView.mas_width).multipliedBy(0.85);
        make.height.equalTo(leftTwoView.mas_height).multipliedBy(0.85);
    }];
    leftOneView.backgroundColor = [UIColor whiteColor];
    leftOneView.layer.cornerRadius = 5.f;
    leftOneView.clipsToBounds = YES;
    
    leftOneImageView = [[UIImageView alloc] init];
    [leftOneView addSubview:leftOneImageView];
    [leftOneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftOneView).with.offset(3.61);
        make.left.equalTo(leftOneView).with.offset(3.61);
        make.bottom.equalTo(leftOneView).with.offset(-3.61);
        make.right.equalTo(leftOneView).with.offset(-3.61);
    }];
//    [leftOneImageView sd_setImageWithURL:imagesURL[last2Index]];
    
    leftOneMaskView = [[UIView alloc] init];
    leftOneMaskView.backgroundColor = [UIColor whiteColor];
    leftOneMaskView.alpha = 0.7;
    [leftOneView addSubview:leftOneMaskView];
    [leftOneMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftOneView).with.offset(0);
        make.left.equalTo(leftOneView).with.offset(0);
        make.bottom.equalTo(leftOneView).with.offset(0);
        make.right.equalTo(leftOneView).with.offset(0);
    }];
    
    /*************   右2的卡片   ****************/
    rightTwoView = [[UIView alloc] init];
    [self addSubview:rightTwoView];
    [rightTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView.mas_right).offset(80);
        make.centerY.equalTo(centerView.mas_centerY);
        make.width.equalTo(rightOneView.mas_width).multipliedBy(0.85);
        make.height.equalTo(rightOneView.mas_height).multipliedBy(0.85);
    }];
    rightTwoView.backgroundColor = [UIColor whiteColor];
    rightTwoView.layer.cornerRadius = 5.f;
    rightTwoView.clipsToBounds = YES;
    
    rightTwoImageView = [[UIImageView alloc] init];
    [rightTwoView addSubview:rightTwoImageView];
    [rightTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightTwoView).with.offset(3.61);
        make.left.equalTo(rightTwoView).with.offset(3.61);
        make.bottom.equalTo(rightTwoView).with.offset(-3.61);
        make.right.equalTo(rightTwoView).with.offset(-3.61);
    }];
//    [rightTwoImageView sd_setImageWithURL:imagesURL[next2Index]];
    
    rightTwoMaskView = [[UIView alloc] init];
    rightTwoMaskView.backgroundColor = [UIColor whiteColor];
    rightTwoMaskView.alpha = 0.7;
    [rightTwoView addSubview:rightTwoMaskView];
    [rightTwoMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightTwoView).with.offset(0);
        make.left.equalTo(rightTwoView).with.offset(0);
        make.bottom.equalTo(rightTwoView).with.offset(0);
        make.right.equalTo(rightTwoView).with.offset(0);
    }];
    
    // 定位5个位置的position
    [self layoutIfNeeded];
    leftOnePosition = leftOneView.layer.position;
    leftTwoPosition = leftTwoView.layer.position;
    centerPosition = centerView.layer.position;
    rightOnePosition = rightOneView.layer.position;
    rightTwoPosition = rightTwoView.layer.position;
    
    // 将centerView移到最上方，调整5个view的层次
    [self bringSubviewToFront:leftTwoView];
    [self bringSubviewToFront:rightOneView];
    [self bringSubviewToFront:centerView];
    
    /*************   添加滑动手势 执行卡片切换动画效果   ****************/
    UISwipeGestureRecognizer *previousSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToPrevious:)];
    [previousSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:previousSwipe];
    UISwipeGestureRecognizer *nextSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToNext:)];
    [nextSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:nextSwipe];
}

// 上一张
- (void)didSwipeToPrevious:(UISwipeGestureRecognizer *)sender {
    
    // 动画还未结束，不能进行下一次动画
    if (isAnimationing) {
        return;
    }
    isAnimationing = YES;
    leftTwoMaskView.hidden = YES;
    centerMaskView.hidden = NO;
    [self bringSubviewToFront:leftTwoView];
    [self sendSubviewToBack:rightTwoView];
    timer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(animationPreviousStop) userInfo:nil repeats:NO];
    //    [timer fire]; 上面的类方法不需要fire调用开始
    
    /*********************     centerView动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = animationDuration;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:centerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:rightOnePosition];
    //    positionAnimation.fillMode = kCAFillModeForwards;
    //    positionAnimation.removedOnCompletion = NO;
    [centerView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = animationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.85f];
    //    scaleAnimation.fillMode = kCAFillModeForwards;
    //    scaleAnimation.removedOnCompletion = NO;
    [centerView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    /*********************     左2动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation2.duration = animationDuration;
    positionAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation2.fromValue = [NSValue valueWithCGPoint:leftTwoPosition];
    positionAnimation2.toValue = [NSValue valueWithCGPoint:centerPosition];
    //    positionAnimation2.fillMode = kCAFillModeForwards;
    //    positionAnimation2.removedOnCompletion = NO;
    [leftTwoView.layer addAnimation:positionAnimation2 forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.duration = animationDuration;
    scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation2.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation2.toValue = [NSNumber numberWithFloat:1.176f];
    //    scaleAnimation2.fillMode = kCAFillModeForwards;
    //    scaleAnimation2.removedOnCompletion = NO;
    [leftTwoView.layer addAnimation:scaleAnimation2 forKey:@"scaleAnimation"];
    
    /*********************     左1动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation3 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation3.duration = animationDuration;
    positionAnimation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation3.fromValue = [NSValue valueWithCGPoint:leftOnePosition];
    positionAnimation3.toValue = [NSValue valueWithCGPoint:leftTwoPosition];
    //    positionAnimation3.fillMode = kCAFillModeForwards;
    //    positionAnimation3.removedOnCompletion = NO;
    [leftOneView.layer addAnimation:positionAnimation3 forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation3.duration = animationDuration;
    scaleAnimation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation3.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation3.toValue = [NSNumber numberWithFloat:1.176f];
    //    scaleAnimation2.fillMode = kCAFillModeForwards;
    //    scaleAnimation2.removedOnCompletion = NO;
    [leftOneView.layer addAnimation:scaleAnimation3 forKey:@"scaleAnimation"];
    
    /*********************     右2动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation4 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation4.duration = animationDuration;
    positionAnimation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation4.fromValue = [NSValue valueWithCGPoint:rightTwoPosition];
    positionAnimation4.toValue = [NSValue valueWithCGPoint:leftOnePosition];
    //    positionAnimation4.fillMode = kCAFillModeForwards;
    //    positionAnimation4.removedOnCompletion = NO;
    [rightTwoView.layer addAnimation:positionAnimation4 forKey:@"positionAnimation"];
    
    /*********************     右1动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation5 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation5.duration = animationDuration;
    positionAnimation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation5.fromValue = [NSValue valueWithCGPoint:rightOnePosition];
    positionAnimation5.toValue = [NSValue valueWithCGPoint:rightTwoPosition];
    //    positionAnimation.fillMode = kCAFillModeForwards;
    //    positionAnimation.removedOnCompletion = NO;
    [rightOneView.layer addAnimation:positionAnimation5 forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation5 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation5.duration = animationDuration;
    scaleAnimation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation5.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation5.toValue = [NSNumber numberWithFloat:0.85f];
    //    scaleAnimation.fillMode = kCAFillModeForwards;
    //    scaleAnimation.removedOnCompletion = NO;
    [rightOneView.layer addAnimation:scaleAnimation5 forKey:@"scaleAnimation"];
    
}

// 下一张
- (void)didSwipeToNext:(UISwipeGestureRecognizer *)sender {
    // 动画还未结束，不能进行下一次动画
    if (isAnimationing) {
        return;
    }
    isAnimationing = YES;
    rightOneMaskView.hidden = YES;
    centerMaskView.hidden = NO;
    [self bringSubviewToFront:rightOneView];
    [self sendSubviewToBack:leftOneView];
    timer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(animationNextStop) userInfo:nil repeats:NO];
//    [timer fire]; 上面的类方法不需要fire调用开始
    
    /*********************     centerView动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = animationDuration;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:centerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:leftTwoPosition];
    //    positionAnimation.fillMode = kCAFillModeForwards;
    //    positionAnimation.removedOnCompletion = NO;
    [centerView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = animationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.85f];
    //    scaleAnimation.fillMode = kCAFillModeForwards;
    //    scaleAnimation.removedOnCompletion = NO;
    [centerView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    /*********************     左2动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation2.duration = animationDuration;
    positionAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation2.fromValue = [NSValue valueWithCGPoint:leftTwoPosition];
    positionAnimation2.toValue = [NSValue valueWithCGPoint:leftOnePosition];
    //    positionAnimation2.fillMode = kCAFillModeForwards;
    //    positionAnimation2.removedOnCompletion = NO;
    [leftTwoView.layer addAnimation:positionAnimation2 forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.duration = animationDuration;
    scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation2.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation2.toValue = [NSNumber numberWithFloat:0.85f];
    //    scaleAnimation2.fillMode = kCAFillModeForwards;
    //    scaleAnimation2.removedOnCompletion = NO;
    [leftTwoView.layer addAnimation:scaleAnimation2 forKey:@"scaleAnimation"];
    
    /*********************     左1动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation3 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation3.duration = animationDuration;
    positionAnimation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation3.fromValue = [NSValue valueWithCGPoint:leftOnePosition];
    positionAnimation3.toValue = [NSValue valueWithCGPoint:rightTwoPosition];
    //    positionAnimation3.fillMode = kCAFillModeForwards;
    //    positionAnimation3.removedOnCompletion = NO;
    [leftOneView.layer addAnimation:positionAnimation3 forKey:@"positionAnimation"];
    
    /*********************     右2动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation4 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation4.duration = animationDuration;
    positionAnimation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation4.fromValue = [NSValue valueWithCGPoint:rightTwoPosition];
    positionAnimation4.toValue = [NSValue valueWithCGPoint:rightOnePosition];
    //    positionAnimation4.fillMode = kCAFillModeForwards;
    //    positionAnimation4.removedOnCompletion = NO;
    [rightTwoView.layer addAnimation:positionAnimation4 forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation4 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation4.duration = animationDuration;
    scaleAnimation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation4.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation4.toValue = [NSNumber numberWithFloat:1.176f];
    //    scaleAnimation4.fillMode = kCAFillModeForwards;
    //    scaleAnimation4.removedOnCompletion = NO;
    [rightTwoView.layer addAnimation:scaleAnimation4 forKey:@"scaleAnimation"];
    
    /*********************     右1动画      ************************/
    // position animation
    CABasicAnimation *positionAnimation5 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation5.duration = animationDuration;
    positionAnimation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation5.fromValue = [NSValue valueWithCGPoint:rightOnePosition];
    positionAnimation5.toValue = [NSValue valueWithCGPoint:centerPosition];
    //    positionAnimation.fillMode = kCAFillModeForwards;
    //    positionAnimation.removedOnCompletion = NO;
    [rightOneView.layer addAnimation:positionAnimation5 forKey:@"positionAnimation"];
    
    // scale animation
    CABasicAnimation *scaleAnimation5 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation5.duration = animationDuration;
    scaleAnimation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation5.fromValue = [NSNumber numberWithFloat:1.f];
    scaleAnimation5.toValue = [NSNumber numberWithFloat:1.176f];
    //    scaleAnimation.fillMode = kCAFillModeForwards;
    //    scaleAnimation.removedOnCompletion = NO;
    [rightOneView.layer addAnimation:scaleAnimation5 forKey:@"scaleAnimation"];
    
}

// 上一张动画停止时，关闭定时器，并将centerview提前，动画结束，可进行下一次操作
- (void)animationPreviousStop {
    
    /*******************************    图片转换      ******************************/
    if (currentIndex == 2) {
        --currentIndex;
        last2Index = (int)imagesURL.count - 1;
        lastIndex = 0;
        nextIndex = 2;
        next2Index = 3;
        [self refreshImages];
    } else if (currentIndex == 1) {
        --currentIndex;
        last2Index = (int)imagesURL.count - 2;
        lastIndex = (int)imagesURL.count - 1;
        nextIndex = 1;
        next2Index = 2;
        [self refreshImages];
    } else if (currentIndex == 0) {
        currentIndex = (int)imagesURL.count - 1;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = 0;
        next2Index = 1;
        [self refreshImages];
    } else if (currentIndex == (int)imagesURL.count - 1) {
        --currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = 0;
        [self refreshImages];
    } else {
        --currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = currentIndex + 2;
        [self refreshImages];
    }
    
    // 释放定时器，视图还原，关闭动画
    if (timer.isValid) {
        [timer invalidate];
    }
    timer = nil;
    centerMaskView.hidden = YES;
    leftTwoMaskView.hidden = NO;
    [self bringSubviewToFront:centerView];
    isAnimationing = NO;
}


// 下一张动画停止时，关闭定时器，并将centerview提前，动画结束，可进行下一次操作
- (void)animationNextStop {
    
    /*******************************    图片转换      ******************************/
    if (currentIndex == (int)imagesURL.count - 3) {
        ++currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = 0;
        [self refreshImages];
    } else if (currentIndex == (int)imagesURL.count - 2) {
        ++currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = 0;
        next2Index = 1;
        [self refreshImages];
    } else if (currentIndex == (int)imagesURL.count - 1) {
        currentIndex = 0;
        last2Index = (int)imagesURL.count - 2;
        lastIndex = (int)imagesURL.count - 1;
        nextIndex = 1;
        next2Index = 2;
        [self refreshImages];
    } else if (currentIndex == 0) {
        ++currentIndex;
        last2Index = (int)imagesURL.count - 1;
        lastIndex = 0;
        nextIndex = 2;
        next2Index = 3;
        [self refreshImages];
    } else if (currentIndex == 1) {
        ++currentIndex;
        last2Index = 0;
        lastIndex = 1;
        nextIndex = 3;
        next2Index = 4;
        [self refreshImages];
    } else {
        ++currentIndex;
        last2Index = currentIndex - 2;
        lastIndex = currentIndex - 1;
        nextIndex = currentIndex + 1;
        next2Index = currentIndex + 2;
        [self refreshImages];
    }
    
    // 释放定时器，视图还原，关闭动画
    if (timer.isValid) {
        [timer invalidate];
    }
    timer = nil;
    centerMaskView.hidden = YES;
    rightOneMaskView.hidden = NO;
    [self bringSubviewToFront:centerView];
    isAnimationing = NO;
}

#pragma mark 刷新图片
- (void)refreshImages {
    [centerImageView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:imagesURL[currentIndex]]]];
    [leftTwoImageView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:imagesURL[lastIndex]]]];
    [rightOneImageView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:imagesURL[nextIndex]]]];
    [leftOneImageView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:imagesURL[last2Index]]]];
    [rightTwoImageView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:imagesURL[next2Index]]]];
}

@end
