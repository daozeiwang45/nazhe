//
//  NZDefineH.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//
//  这里放 Define 和 枚举
//

#ifndef E___NZDefineH_h
#define E___NZDefineH_h

#define tmpIdentify(object) [NSString stringWithFormat:@"%p",(object)] ;

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define JJRectMake(x, y, width, height) CGRectMake(ScreenWidth*x/375, ScreenWidth*y/375, ScreenWidth*width/375, ScreenWidth*height/375)

#define IS_IPHONE_6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#define UIColorFromRGB(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIDefaultBackgroundColor       UIColorFromRGB(0xf1f2f3)
#define UIDefaultNavBarBackgroundColor UIColorFromRGB(0x009a44)
#define UIDefaultSepLineColor          UIColorFromRGB(0xebebeb)
#define BKColor [UIColor colorWithWhite:0.957 alpha:1.000]
#define darkRedColor [UIColor colorWithRed:190/255.f green:1/255.f blue:8/255.f alpha:1.0] // 深红色
#define goldColor [UIColor colorWithRed:211/255.f green:168/255.f blue:9/255.f alpha:1.0] // 限时抢时间label底色
#define darkGoldColor [UIColor colorWithRed:183/255.f green:134/255.f blue:91/255.f alpha:1.0] // 暗金色
#define tintOrangeColor [UIColor colorWithRed:236/255.f green:108/255.f blue:0/255.f alpha:1.0] // 橘黄色（保存按钮）
#define toolBarColor [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.0] // 顶部44分类工具条颜色
#define orderBarColor [UIColor colorWithRed:204/255.f green:161/255.f blue:106/255.f alpha:1.0] //

#define UIDefaultBackImage       [UIImage imageNamed:@"返回按钮"]
#define scanCodeImage            [UIImage imageNamed:@"扫码"]
#define searchImage              [UIImage imageNamed:@"查找"]
#define defaultImage             [UIImage imageNamed:@"默认图片"]

//                                                                                             __________________________________________________

//enum (enum) typedef enum (enumt)

typedef NS_ENUM(NSInteger , enumtOrderType)
{
    enumtOrderType_All = 0,                       // 全部订单
    enumtOrderType_WaitPay,                       // 待付款
    enumtOrderType_WaitReceipt,                   // 待收货
    enumtOrderType_EndService                     // 已完成
};


typedef NS_ENUM(NSInteger , enumtActivitiesType)
{
    enumtActivitiesType_Grab = 0,                   // 限时抢
    enumtActivitiesType_newProduct,                 // 新品汇
    enumtActivitiesType_Coupons,                    // 优享券
    enumtActivitiesType_MajorSuit                   // 大牌档
};

typedef NS_ENUM(NSInteger , enumtMaterialOrStyleType)
{
    enumtMaterialOrStyleType_Material = 10,         // 材质
    enumtMaterialOrStyleType_Style                  // 款式
};

// 新品汇和大排档详情两个界面图标
typedef NS_ENUM(NSInteger , enumtNewClubOrBuyNow)
{
    enumtNewClubOrBuyNow_NewClub = 0,                // 新品club
    enumtNewClubOrBuyNow_BuyNow                      // 立即抢购
};

// 我的优享券两种状态
typedef NS_ENUM(NSInteger , enumtMyCouponState)
{
    enumtMyCouponState_UnUsed = 0,                   // 未使用
    enumtMyCouponState_Used                          // 已使用
};

// 五种账单
typedef NS_ENUM(NSInteger , enumtBillRecordState)
{
    enumtBillRecordState_Recharge = 0,                   // 充值
    enumtBillRecordState_Buy,                            // 消费
    enumtBillRecordState_Cash,                           // 提现
    enumtBillRecordState_Score,                          // 积分
    enumtBillRecordState_Coupons                         // 优享券
};

// 四种pickerview（日期、地区、故乡、职业）
typedef NS_ENUM(NSInteger , enumtPickerViewType)
{
    enumtPickerViewType_Date = 0,                   // 日期
    enumtPickerViewType_Area,                       // 地区
    enumtPickerViewType_Hometown,                   // 故乡
    enumtPickerViewType_Job                         // 职业
};

// 客服帮助里面五种类型问题
typedef NS_ENUM(NSInteger , enumtHelpType)
{
    enumtHelpType_Wallet = 0,                      // 关于钱包
    enumtHelpType_Integral,                        // 关于积分
    enumtHelpType_Privilege,                       // 关于特权
    enumtHelpType_CustomerService,                 // 关于售后
    enumtHelpType_Order                            // 关于订单
};

// 添加还是修改收货地址
typedef NS_ENUM(NSInteger , enumtAddressType)
{
    enumtAddressType_Add = 0,                      // 添加收货地址
    enumtAddressType_Edit                          // 修改收货地址
};

// 信息中分系统消息还是信息收藏
typedef NS_ENUM(NSInteger , enumtMessageType)
{
    enumtMessageType_SystemMessage = 0,                      // 系统消息
    enumtMessageType_MessageCollection                       // 信息收藏
};

// 动态信息中分积分动态还是账户动态...
typedef NS_ENUM(NSInteger , enumtDynamicType)
{
    enumtDynamicType_Integral = 0,                  // 积分动态
    enumtDynamicType_Account,                       // 账户动态
    enumtDynamicType_Trading,                       // 交易提醒
    enumtDynamicType_Notice,                        // 系统通知
    enumtDynamicType_Activity                       // 尊享活动

};

#endif
