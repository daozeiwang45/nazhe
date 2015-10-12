//  AppDelegate.h
//  AnimatTabbarSample
//
//  Created by chenyanming on 14-4-9.
//  Copyright (c) 2014年 chenyanming. All rights reserved.
//

#import "AnimateTabbar.h"

@interface AnimateTabbarView () {
    float tabitem_width;
    float tabitem_hight;
    float tab_hight;
    float tab_width;
    float other_offtop;
    
    float img_hight;
    float img_width;
    float img_x;
    float img_y;
}

@end

@implementation AnimateTabbarView

@synthesize  firstBtn,secondBtn,thirdBtn,fourthBtn,delegate,backBtn;

- (id)initWithFrame:(CGRect)frame
{
    tabitem_width = ScreenWidth / 4;
    tabitem_hight = 49;
    tab_hight = 49;
    tab_width = ScreenWidth;
    other_offtop = 0;
    
    img_hight = 40;
    img_width = 40;
    img_x = (tabitem_width - img_width) / 2;
    img_y = (tabitem_hight - img_hight) / 2;
    
//    CGRect frame1=CGRectMake(frame.origin.x, frame.size.height-tab_hight, tab_width, tab_hight);

    CGRect frame1 = CGRectMake(0, 0, tab_width, tab_hight);
    
    self = [super initWithFrame:frame1];
    if (self) {
        
        
        [self setBackgroundColor:[UIColor blackColor]];
        backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(0, 0, tab_width, tab_hight)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"BUTTON底块"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"BUTTON底块"] forState:UIControlStateSelected];
        
        UIImageView *btnImgView;
        
        //first
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"恋着"] highlightedImage:[UIImage imageNamed:@"恋着-放大"]];
        btnImgView.highlighted = YES;
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
        firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [firstBtn setFrame:CGRectMake(0, other_offtop, tabitem_width, tabitem_hight)];
        [firstBtn setTag:1];
        [firstBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [firstBtn addSubview:btnImgView];
        
        //second
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"逛着"] highlightedImage:[UIImage imageNamed:@"逛着-放大"]];
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
        secondBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [secondBtn setFrame:CGRectMake(tabitem_width, other_offtop, tabitem_width, tabitem_hight)];
        [secondBtn setTag:2];
        [secondBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [secondBtn addSubview:btnImgView];
        
        //third
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"聊着"] highlightedImage:[UIImage imageNamed:@"聊着-放大"]];
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
        thirdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [thirdBtn setFrame:CGRectMake(tabitem_width*2, other_offtop, tabitem_width, tabitem_hight)];
        [thirdBtn setTag:3];
        [thirdBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [thirdBtn addSubview:btnImgView];
        
        //fourth
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"拿着"] highlightedImage:[UIImage imageNamed:@"拿着-放大"]];
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
        fourthBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [fourthBtn setFrame:CGRectMake(tabitem_width*3, other_offtop, tabitem_width, tabitem_hight)];
        [fourthBtn setTag:4];
        [fourthBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [fourthBtn addSubview:btnImgView];
        
        [backBtn addSubview:firstBtn];
        [backBtn addSubview:secondBtn];
        [backBtn addSubview:thirdBtn];
        [backBtn addSubview:fourthBtn];
        
        [self addSubview:backBtn];

    }
    
  
    return self;
    
    
}

-(void)callButtonAction:(UIButton *)sender{
    int value = (int)sender.tag;
    if (value == 1) {
        [self.delegate FirstBtnClick];
    }
    if (value == 2) {
        [self.delegate SecondBtnClick];
      }
    if (value == 3) {
        [self.delegate ThirdBtnClick];
    }
    if (value == 4) {
        [self.delegate FourthBtnClick];
    }
}

int g_selectedTag=1;

-(void)buttonClickAction:(id)sender{
    UIButton *btn=(UIButton *)sender;
   // UIImageView *view=btn1.subviews[0];
    if(g_selectedTag == btn.tag)
        return;
    else
        g_selectedTag = (int)btn.tag;
    
    if (firstBtn.tag!=btn.tag) {
        ((UIImageView *)firstBtn.subviews[0]).highlighted=NO;
    }
    
    if (secondBtn.tag!=btn.tag) {
        ((UIImageView *)secondBtn.subviews[0]).highlighted=NO;
    }
    
    if (thirdBtn.tag!=btn.tag) {
       
        ((UIImageView *)thirdBtn.subviews[0]).highlighted=NO;
    }
    
    if (fourthBtn.tag!=btn.tag) {
        
        ((UIImageView *)fourthBtn.subviews[0]).highlighted=NO;
    }
    
    [self imgAnimate:btn];
    
    ((UIImageView *)btn.subviews[0]).highlighted=YES;
    
    [self callButtonAction:btn];
    
    return;
    
    
    

}

- (void)imgAnimate:(UIButton*)btn{
    
    UIView *view=btn.subviews[0];
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
          view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);
         
         
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              
              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
              
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   
                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
                   
                   
               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
    
    
}



@end
