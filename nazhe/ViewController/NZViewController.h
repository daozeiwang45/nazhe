//
//  NZViewController.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZViewController : UIViewController {
    //navigationItem
    UILabel *_navItemTitleView ;
    void(^_navItemTitleViewOnClickFun)(id)  ;
    
    //navigationbar
    UIButton *_leftButton ; // 覆盖系统的左按钮，默认用于返回上一界面
    UIButton *_rightButton;
}

/*** @brief 根据标题创建navigationItem TitleView */
- (void) createNavigationItemTitleViewWithTitle:(NSString *)title ; // 设置navigationItem TitleView标题

/*** @brief 根据所属的image创建navigationItem TitleView */
- (void) createNavigationItemTitleViewWithImage:(UIImage *)image ;

- (void) navigationItemTitleViewOnClick:(void(^)(id mySelf)) onclick ; // 监听TitleView触发事件;

/*** @brief 创建左按钮时，带上文字，注意：如果用户复写了leftButton方法，则本方法不再执行新的创建 */
- (void) leftButtonTitle:(NSString *)title ;
/*** @brief 如果左键存在，则强制让其出现 */
- (void) notificationLeftBarItemDisplay ;
/***
 * @brief 1、方法可复写
 * @brief 2、这是左键的左边图标
 * @brief 3、系统默认分配一个UIImageView对象
 */
- (UIImageView *) leftImageView ;

/*** @brief 创建首页的左右按钮 */
- (void)createLeftAndRightNavigationItemButton;
/*** @brief 首页左边的扫码图标 */
- (UIImageView *) leftScanImageView;
/*** @brief 首页右边的搜索图标 */
- (UIImageView *) rightSearchImageView;

///*** @brief 方法可复写 @brief 键盘出现触发 */
//- (void) keyboardWillShowNotification:(NSNotification *)aNotification ;
///*** @brief 方法可复写 @brief 键盘消失触发 */
//- (void) keyboardWillHideNotification ;
///*** @brief 方法可复写 @brief 点击自身触发，所有子视图取消第一响应者 */
//- (void) selfViewOnClick:(id)sender ;
///*** @brief 取消点击自身方法(selfViewOnClick:)，以及相关的监听者 */
//- (void) notificationRemoveSelfViewOnClickListener ;


@end
