//
//  NZPrivilegeContentView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/2.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZPrivilegeContentView.h"
#import "ProgressBarView.h"
#import "NZUsingMethodView.h"

@interface NZPrivilegeContentView () {
    
}

@property (strong, nonatomic) ProgressBarView *progressBarView;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (strong, nonatomic) IBOutlet UIButton *useBtn;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UILabel *conditionLab;
@property (strong, nonatomic) UILabel *rulesLab;
@property (strong, nonatomic) IBOutlet UILabel *rulesTitleLab;

@property (strong, nonatomic) IBOutlet NZUsingMethodView *methodView1;
@property (strong, nonatomic) IBOutlet NZUsingMethodView *methodView2;
@property (strong, nonatomic) IBOutlet NZUsingMethodView *methodView3;
@property (strong, nonatomic) IBOutlet NZUsingMethodView *methodView4;

@end

@implementation NZPrivilegeContentView

- (void)layoutSubviews {
    self.progressBarView = [[ProgressBarView alloc]initWithFrame:CGRectMake((ScreenWidth - 100) / 2, 20, 100, 100)];
    [self.progressBarView setBackgroundColor:[UIColor clearColor]];
    self.progressBarView.delegate = self;
    [self addSubview: self.progressBarView];
    
    self.useBtn.layer.cornerRadius = 3.f;
    self.useBtn.layer.masksToBounds = YES;
    self.useBtn.layer.borderWidth = 0.5f;
    self.useBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 585, ScreenWidth - 40, 45)];
    self.contentLab.text = @"拿着平台会员生日前一周可获得相应折扣的生日专用优享卡，在生日当天可食用，最高折扣4.5折。";
    self.contentLab.textColor = [UIColor darkGrayColor];
    self.contentLab.font = [UIFont systemFontOfSize:12];
    self.contentLab.numberOfLines = 0;
    [self addSubview:self.contentLab];
    [self.contentLab sizeToFit];
    
    self.conditionLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 671, ScreenWidth - 40, 30)];
    self.conditionLab.text = @"拿着平台2星级以上会员。";
    self.conditionLab.textColor = [UIColor darkGrayColor];
    self.conditionLab.font = [UIFont systemFontOfSize:12];
    self.conditionLab.numberOfLines = 0;
    [self addSubview:self.conditionLab];
    [self.conditionLab sizeToFit];
    
    self.methodView1.useMethod = @"生日当天选购产品";
    self.methodView1.step = 1;
    
    self.methodView2.useMethod = @"生日当天选购产品";
    self.methodView2.step = 2;
    
    self.methodView3.useMethod = @"生日当天选购产品";
    self.methodView3.step = 3;
    
    self.methodView4.useMethod = @"生日当天选购产品";
    self.methodView4.step = 4;
    
    self.rulesLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.rulesTitleLab.origin.y + self.rulesTitleLab.frame.size.height + 20, ScreenWidth - 40, 120)];
    self.rulesLab.text = @"1.生日专用优享卡为平台寿星2星级以上会员专属定制；\n2.生日前一周可领取，请注意查看系统消息并领取；\n3.使用生日专享折扣将不与其他优惠活动同享；\n4.生日专用优享卡仅限生日当天有效，逾期失效；\n5.本卡解释权归拿着平台所有。";
    self.rulesLab.textColor = [UIColor darkGrayColor];
    self.rulesLab.font = [UIFont systemFontOfSize:12];
    self.rulesLab.numberOfLines = 0;
    [self addSubview:self.rulesLab];
    [self.rulesLab sizeToFit];
    
}

#pragma mark 让经验条动起来的方法
- (void)animationDidStop:(CAAnimation *)processAnimation finished:(BOOL)flag {
    
    float currentProgress = self.progressBarView.currentProgress * 100;
    
    if (self.progressBarView.currentProgress < 0.839f) {
        self.percentLabel.text = [NSString stringWithFormat:@"%.1f%@", currentProgress, @"%"];
        [self.progressBarView run:self.progressBarView.currentProgress andPercent:0.839f];
    }
}

@end
