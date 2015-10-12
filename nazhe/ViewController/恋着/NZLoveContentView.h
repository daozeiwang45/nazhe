//
//  NZLoveContentView.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/7.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZLoveContentView : UIView

/***************** 限时抢 ********************/
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyAndCountLab;
@property (strong, nonatomic) IBOutlet UIImageView *limitTimeBackImgV;

@property (strong, nonatomic) IBOutlet UIScrollView *npScrollView; // 新品汇轮播图

/***************** 优惠券 ********************/
@property (strong, nonatomic) IBOutlet UILabel *cashCouponLabel;
@property (strong, nonatomic) IBOutlet UILabel *scroeAndCountLab;
@property (strong, nonatomic) IBOutlet UIImageView *couponIcon;
@property (strong, nonatomic) IBOutlet UIImageView *couponBackV;

/***************** 幸运星辰 ********************/
@property (strong, nonatomic) IBOutlet UIView *luckyView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIView *bottom;

@property (strong, nonatomic) IBOutlet UIButton *registBtn; // 注册按钮

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *registViewTop; // 也就是轮播的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *shadowHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *npHeight; // 限时抢高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight; // 新品汇高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labBottom1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconBottom1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labTop1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *couponsHeight; // 优惠券高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labBottom2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconBottom2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labTop2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *starHeight; // 幸运星辰高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dateTop; // 日期lab的上约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *starBarTop; // 星座条的上约束




@end
