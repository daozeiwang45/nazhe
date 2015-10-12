//  AppDelegate.h
//  AnimatTabbarSample
//
//  Created by chenyanming on 14-4-9.
//  Copyright (c) 2014年 chenyanming. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AnimateTabbarDelegate<NSObject>
@required

-(void)FirstBtnClick;
-(void)SecondBtnClick;
-(void)ThirdBtnClick;
-(void)FourthBtnClick;

@end

@interface AnimateTabbarView : UIView

@property(nonatomic,strong)id <AnimateTabbarDelegate> delegate;
@property(nonatomic,strong) UIButton *firstBtn;
@property(nonatomic,strong) UIButton *secondBtn;
@property(nonatomic,strong) UIButton *thirdBtn;
@property(nonatomic,strong) UIButton *fourthBtn;

@property(nonatomic,strong) UIButton *backBtn;

-(void)buttonClickAction:(id)sender;

@end
