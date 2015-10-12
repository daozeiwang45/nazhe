//
//  NZViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZViewController.h"

@interface NZViewController ()

//@property (nonatomic , strong) UITapGestureRecognizer * theSelfTapGestureRecognizer ;

@end

@implementation NZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
//    self.theSelfTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewOnClick:)] ;
//    
//    [self.view addGestureRecognizer:self.theSelfTapGestureRecognizer] ;
}

- (void) createNavigationItemTitleViewWithTitle:(NSString *)title
{
    if( _navItemTitleView == nil){
        _navItemTitleView = [[UILabel alloc] init] ;
        _navItemTitleView.font = [UIFont systemFontOfSize:18.0f] ;
        _navItemTitleView.mj_h = 44.0f ;
        _navItemTitleView.mj_w  = 60.0f ;
        _navItemTitleView.textColor = [UIColor blackColor] ;
        _navItemTitleView.backgroundColor = [UIColor clearColor] ;
        _navItemTitleView.userInteractionEnabled = YES ;
        _navItemTitleView.textAlignment = NSTextAlignmentCenter ;
        [_navItemTitleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_navItemTitleViewOnClick:)]] ;
    };
    _navItemTitleView.text = title ;
    self.navigationItem.titleView = _navItemTitleView ;
}

- (void) createNavigationItemTitleViewWithImage:(UIImage *)image
{
    if( _navItemTitleView == nil){
        _navItemTitleView = [[UILabel alloc] init] ;
        _navItemTitleView.mj_h = 40.0f ;
        _navItemTitleView.mj_w  = 80.0f ;
        _navItemTitleView.userInteractionEnabled = YES ;
        [_navItemTitleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_navItemTitleViewOnClick:)]] ;
    };
    [_navItemTitleView addSubview:[[UIImageView alloc] initWithImage:image]] ;
    self.navigationItem.titleView = _navItemTitleView ;
}

- (void) navigationItemTitleViewOnClick:(void(^)(id mySelf)) onclick
{
    _navItemTitleViewOnClickFun = onclick ;
}

- (void) _navItemTitleViewOnClick:(id)sender
{
    if( _navItemTitleViewOnClickFun )
    {
        _navItemTitleViewOnClickFun(self) ;
    }
}

- (void) leftButtonTitle:(NSString *)title
{
    if( self.navigationItem == nil )
    {
        return ;
    }
    
    // 初始化
    CGFloat titleWidth = 0.0 ;
    CGFloat imgVWidth = 12.0 ;
    CGFloat imgVHeight = 24.f;
    CGFloat btnHeight = 44.0f ;
    UIImageView * imgView = [self leftImageView] ;
    UILabel *textLabel = [[UILabel alloc] init] ;
    
    // 数据设置
    textLabel.textColor = [UIColor whiteColor] ;
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    if( title ){
        UIFont *theFont = [UIFont systemFontOfSize:14.0f] ;
//        titleWidth = [self textHeight:title font:theFont flagHeight:btnHeight] ;
        CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:theFont,NSFontAttributeName, nil]];
        titleWidth = size.width;
        textLabel.text = title ;
        textLabel.font = theFont ;
    }
    if( titleWidth<20.0 ){
        titleWidth = 20.0f ;
    }
    imgView.frame = CGRectMake(0, (btnHeight-imgVHeight)/2, imgVWidth, imgVHeight) ;
    textLabel.frame = CGRectMake(imgView.right, 0, titleWidth, btnHeight) ;
    _leftButton.frame = CGRectMake(0, 0, titleWidth + imgVWidth, btnHeight) ;
    _leftButton.userInteractionEnabled = YES ;
    
    // 填充数据
    [_leftButton addSubview:imgView] ;
    [_leftButton addSubview:textLabel] ;
    [_leftButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBarItemOnClick:)]] ;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton] ;
//    [self leftButtonDisplayState] ;
}

- (UIImageView *) leftImageView
{
    return [[UIImageView alloc] initWithImage:UIDefaultBackImage] ;
}

- (void) leftButtonDisplayState // 不可现函数
{
    if( [self.navigationController.viewControllers count] < 1)
    {
        _leftButton.hidden = YES ;
    }
    else
    {
        _leftButton.hidden = NO  ;
    }
}

- (void) notificationLeftBarItemDisplay
{
    if( _leftButton && _leftButton.hidden )
    {
        _leftButton.hidden = !_leftButton.hidden ;
    }
}

- (void) leftBarItemOnClick:(id)sender
{
    if( self.navigationController && [self.navigationController.viewControllers count] > 1 )
    {
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }
}

//- (CGFloat) textHeight:(NSString *)textString font:(UIFont *)textFont flagHeight:(CGFloat)flagHeight // 不可现函数
//{
//    CGFloat width = textHeight(textString, textFont, CGSizeMake(CGFLOAT_MAX, flagHeight)).width;
//    return width ;
//}

//- (void) keyboardWillShowNotification:(NSNotification *)aNotification
//{
//    ;
//}
//
//- (void) keyboardWillHideNotification
//{
//    [self resignFirstResponderWith:self.view] ;
//}
//
//- (void) selfViewOnClick:(id)sender
//{
//    [self keyboardWillHideNotification] ;
//}
//- (void) notificationRemoveSelfViewOnClickListener
//{
//    if( self.theSelfTapGestureRecognizer )
//    {
//        [self.view removeGestureRecognizer:self.theSelfTapGestureRecognizer] ;
//        
//        self.theSelfTapGestureRecognizer = nil ;
//    }
//}
//
//- (void) resignFirstResponderWith:(UIView *)view // 不可现函数
//{
//    [view resignFirstResponder] ;
//    NSArray *subviews = [view subviews] ;
//    if(subviews){
//        for (UIView *subview in subviews) {
//            [subview resignFirstResponder] ;
//            NSArray *anewSubViews = [subview subviews] ;
//            if( anewSubViews && [anewSubViews count]>0 )
//            {
//                [self resignFirstResponderWith:subview] ;
//            }
//        }
//    }
//}

#pragma mark 首页左右导航按钮（扫码、搜索）
- (void)createLeftAndRightNavigationItemButton {
    if( self.navigationItem == nil )
    {
        return ;
    }
    /*******************************   扫码按钮   ********************************/
    // 初始化
    CGFloat imgVWidth = 25.f ;
    CGFloat btnHeight = 44.0f ;
    UIImageView * leftImgView = [self leftScanImageView] ;
    
    // 数据设置
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    leftImgView.frame = CGRectMake(0, (btnHeight-imgVWidth)/2, imgVWidth, imgVWidth) ;
    _leftButton.frame = CGRectMake(0, 0, 25.f + imgVWidth, btnHeight) ;
    _leftButton.userInteractionEnabled = YES ;
    
    // 填充数据
    [_leftButton addSubview:leftImgView] ;
    [_leftButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanCodeClick:)]] ;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton] ;
    
    /*******************************   搜索按钮   ********************************/
    // 初始化
    UIImageView * rightImgView = [self rightSearchImageView] ;
    
    // 数据设置
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    rightImgView.frame = CGRectMake(25.f, (btnHeight-imgVWidth)/2, imgVWidth, imgVWidth) ;
    _rightButton.frame = CGRectMake(0, 0, 25.f + imgVWidth, btnHeight) ;
    _rightButton.userInteractionEnabled = YES ;
    
    // 填充数据
    [_rightButton addSubview:rightImgView] ;
    [_rightButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick:)]] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton] ;
}

- (UIImageView *) leftScanImageView
{
    return [[UIImageView alloc] initWithImage:scanCodeImage] ;
}

- (UIImageView *) rightSearchImageView
{
    return [[UIImageView alloc] initWithImage:searchImage] ;
}

- (void) scanCodeClick:(id)sender
{
    NSLog(@"扫码");
}

- (void) searchClick:(id)sender
{
    NSLog(@"搜索");
}

@end
