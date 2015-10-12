//
//  NZTakeContentView.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/31.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZTakeContentView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *headImageView; // 头像
@property (strong, nonatomic) IBOutlet UIButton *intoWalletBtn; // 进入钱包按钮
@property (strong, nonatomic) IBOutlet UIButton *rewardBtn;

@property (strong, nonatomic) IBOutlet UIView *serviceView;
@property (strong, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (strong, nonatomic) IBOutlet UIView *favoritesView;
@property (strong, nonatomic) IBOutlet UIView *privilegeView;
@property (strong, nonatomic) IBOutlet UIView *shopBagView;
@property (strong, nonatomic) IBOutlet UIView *friendsView;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UIView *orderView;

@property (strong, nonatomic) IBOutlet UIButton *friendsBtn;
@property (strong, nonatomic) IBOutlet UIButton *messageBtn;
@property (strong, nonatomic) IBOutlet UIButton *orderBtn;
@property (strong, nonatomic) IBOutlet UIButton *favoritesBtn;
@property (strong, nonatomic) IBOutlet UIButton *privilegeBtn;
@property (strong, nonatomic) IBOutlet UIButton *shopBagBtn;
@property (strong, nonatomic) IBOutlet UIButton *serviceBtn;
@property (strong, nonatomic) IBOutlet UIButton *gameBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;

@property (strong, nonatomic) IBOutlet UILabel *nickNameLab; // 昵称
@property (strong, nonatomic) IBOutlet UILabel *signDaysLab; // 连续签到天数
@property (strong, nonatomic) IBOutlet UILabel *integralLab; // 积分
@property (strong, nonatomic) IBOutlet UIImageView *starBar; // 星星条
@property (strong, nonatomic) IBOutlet UILabel *totalIncomeLab; // 总收益
@property (nonatomic, strong) UIImageView *upArrow; // 总收益右边的箭头
@property (strong, nonatomic) IBOutlet UILabel *countFriendLab; // 好友人数
@property (strong, nonatomic) IBOutlet UILabel *countMsgLab; // 信息条数
@property (strong, nonatomic) IBOutlet UILabel *countOrderLab; // 正在交易的订单数
@property (strong, nonatomic) IBOutlet UILabel *countFavoritesLab; // 收藏夹个数
@property (strong, nonatomic) IBOutlet UILabel *countPrivilegeLab; // 已点亮特权个数
@property (strong, nonatomic) IBOutlet UILabel *countBagLab; // 购物袋个数
@property (strong, nonatomic) IBOutlet UILabel *countServiceLab; // 客服回复未读条数
@property (strong, nonatomic) IBOutlet UILabel *countPrizeLab; // 获得游戏奖品个数
@property (strong, nonatomic) IBOutlet UILabel *versionLab; // 当前版本数

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *friendsTop; // 下面九宫格的高度


@end
