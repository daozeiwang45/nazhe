//
//  NZExtern.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *emptyString;
extern NSString *spaceString;

// web interface

extern NSString *apiBaseUrl;
extern NSString *imgBaseUrl;

extern NSString *webLogin; // 登录接口

extern NSString *webIsExistPhone; // 验证账号是否已存在接口
extern NSString *webGetCode; // 获取验证码接口
extern NSString *webIsCodeRight; // 校对验证码是否正确接口
extern NSString *webIsExistNickName; // 验证昵称是否被注册接口
extern NSString *webRegister; // 注册接口

extern NSString *webLoveFirstPage; // 恋着首页接口
extern NSString *webActivityDetail; // 活动详情页接口

extern NSString *webStrollFirstPage; // 逛着首页材质列表接口
extern NSString *webGetStyleList; // 逛着首页款式列表接口
extern NSString *webGetLimitedList; // 逛着优惠活动限时抢列表接口
extern NSString *webGetNewList;  // 逛着优惠活动新品汇列表接口
extern NSString *webGetCouponsList;  // 逛着优惠活动优享卷列表接口
extern NSString *webReceiveCoupons;  // 逛着优惠活动领取优享卷接口
extern NSString *webGetMajorSuit;  // 逛着优惠活动大牌档接口
extern NSString *webGetMajorSuitIndex;  // 逛着优惠活动大牌档首页接口

extern NSString *webGoodsList; // 逛着商品列表接口
extern NSString *webGoodsDetail; // 逛着商品详情接口
extern NSString *webGoodSetLike; // 喜欢和取消喜欢接口
extern NSString *webGoodSetCollection; // 收藏和取消收藏接口

extern NSString *webMyDeliveryAddress; // 我的收货地址接口
extern NSString *webSetDefaultAddress; // 设置默认收货地址接口
extern NSString *webDetailAddress; // 收货地址详细信息接口
extern NSString *webAddAddress; // 添加收货地址
extern NSString *webEditAddress; // 修改收货地址
extern NSString *webDeleteAddress; // 删除收货地址

extern NSString *webTakeFirstPage; // 拿着一级页面接口
extern NSString *webSettingPage; // 设置页面接口
extern NSString *webMyProfile; // 个人资料接口
extern NSString *webBankCardList; // 银行卡接口
extern NSString *webDeleteBankCard; // 删除银行卡接口

extern NSString *webMyWalletDetail; // 我的钱包接口
extern NSString *webMyCouponsList; // 我的优享券接口
extern NSString *webBillRecord; // 账单纪录接口

extern NSString *webServiceHelp; // 客服帮助接口
extern NSString *webServiceMessage; // 客服留言接口
extern NSString *webServiceReply; // 客服回复接口

extern NSString *webEditAccountPassword; // 修改帐号密码接口
extern NSString *webEditTradingPassword; // 修改交易密码接口

extern NSString *webNoReadMessage; // 查询未读消息数接口
extern NSString *webMessageDetailList; // 查看系统消息列表接口

extern NSString *webOrderList; // 订单列表接口

// UITableViewCell ...

extern NSString *NZMaterialOrStyleCellIdentify;
extern NSString *NZMaterialOrStyleExpandCellIdentify;
extern NSString *NZCommodityListCellIdentify;
extern NSString *NZOrderViewCellIdentify;
extern NSString *NZOrderExpendViewCellIdentify;

/******************   客服帮助需要十种identify   *******************/
// 关于钱包
extern NSString *NZHelpWalletCellIdentify;
extern NSString *NZHelpWalletExpendCellIdentify;
// 关于积分
extern NSString *NZHelpIntegralCellIdentify;
extern NSString *NZHelpIntegralExpendCellIdentify;
// 关于特权
extern NSString *NZHelpPrivilegeCellIdentify;
extern NSString *NZHelpPrivilegeExpendCellIdentify;
// 关于售后
extern NSString *NZHelpOrderCellIdentify;
extern NSString *NZHelpOrderExpendCellIdentify;
// 关于订单
extern NSString *NZHelpCustomerServiceCellIdentify;
extern NSString *NZHelpCustomerServiceExpendCellIdentify;
// 优惠活动cell
extern NSString *NZGrabActivityCellIdentify;
extern NSString *NZNewProductActivityCellIdentify;
extern NSString *NZCouponsActivityCellIdentify;
// 大牌档cell
extern NSString *NZMajorSuitCellIdentify;
// 购物袋cell
extern NSString *NZShopBagCellIdentify;
extern NSString *NZShopBagExpendCellIdentify;
// 收货地址cell
extern NSString *NZDeliveryAddressViewCellIdentify;
// 账单纪录cell
extern NSString *NZBillingViewCellIdentify;
// 客服 回复cell
extern NSString *NZReplyViewCellIdentify;
// 银行卡cell
extern NSString *NZBankCardCellIdentify;
// 我的优享券cell
extern NSString *NZUnUsedCouponCellIdentify;
extern NSString *NZUsedCouponCellIdentify;

// 信息
extern NSString *NZSystemMessageTypeCellIdentify;
extern NSString *NZMessageCollectionTypeCellIdentify;
extern NSString *NZMessageViewCellIdentify;
extern NSString *NZMessageExpendViewCellIdentify;

@interface NZExtern : NSObject

@end
