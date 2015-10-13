//
//  NZExtern.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZExtern.h"

NSString *emptyString = @"";
NSString *spaceString = @" ";

// web interface

NSString *apiBaseUrl = @"http://10.0.0.177:8000/app";
NSString *imgBaseUrl = @"http://10.0.0.177:8000";

NSString *webLogin = @"client/Login"; // 登录接口

NSString *webIsExistPhone = @"client/IsExistPhone"; // 验证账号是否已存在接口
NSString *webGetCode = @"client/Code"; // 获取验证码接口
NSString *webIsCodeRight = @"client/IsExistCode"; // 校对验证码是否正确接口
NSString *webIsExistNickName = @"client/IsExistNickName"; // 验证昵称是否被注册接口
NSString *webRegister = @"Client/Register"; // 注册接口

NSString *webLoveFirstPage = @"LianZhe/List"; // 恋着首页接口
NSString *webActivityDetail = @"lianzhe/ActivityDetail"; // 活动详情页接口

NSString *webStrollFirstPage = @"Goods/GetCategory"; // 逛着首页材质列表接口
NSString *webGetStyleList = @"Goods/GetStyle"; // 逛着首页款式列表接口
NSString *webGetLimitedList = @"Activity/GetLimitedList"; // 逛着优惠活动限时抢列表接口
NSString *webGetNewList = @"Activity/GetNewGoodsList"; // 逛着优惠活动新品汇列表接口
NSString *webGetCouponsList = @"Activity/GetCouponsList"; // 逛着优惠活动优享卷列表接口
NSString *webReceiveCoupons = @"Activity/ReceiveCoupons"; // 逛着优惠活动优享卷领取接口Activity/GetShopList
NSString *webGetMajorSuit = @"Activity/GetShopList"; // 逛着优惠活动大牌档接口
NSString *webGetMajorSuitIndex = @"Goods/ShopIndex"; // 逛着优惠活动大牌档首页接口
NSString *webGoodsList = @"Goods/GoodsList"; // 逛着商品列表接口
NSString *webGoodsDetail = @"Goods/GoodsDetail"; // 逛着商品详情接口
NSString *webGoodSetLike = @"Goods/SetIsLike"; // 喜欢和取消喜欢接口
NSString *webGoodSetCollection = @"Goods/SetIsCollect"; // 收藏和取消收藏接口

NSString *webMyDeliveryAddress = @"MyAddress/List"; // 我的收货地址
NSString *webSetDefaultAddress = @"MyAddress/SetDefault"; // 设置默认收货地址
NSString *webDetailAddress = @"MyAddress/Detail"; // 收货地址详细信息接口
NSString *webAddAddress = @"MyAddress/Add"; // 添加收货地址
NSString *webEditAddress = @"MyAddress/Update"; // 修改收货地址
NSString *webDeleteAddress = @"MyAddress/Delete"; // 删除收货地址

NSString *webTakeFirstPage = @"Client/Personal"; // 拿着一级页面接口
NSString *webSettingPage = @"client/Set"; // 设置页面接口
NSString *webMyProfile = @"client/MyProfile"; // 个人资料接口
NSString *webBankCardList = @"bankCard/List"; // 银行卡接口
NSString *webDeleteBankCard = @"BankCard/Delete"; // 删除银行卡接口

NSString *webMyWalletDetail = @"myWallet/Detail"; // 我的钱包接口
NSString *webMyCouponsList = @"myWallet/MyCouponsList"; // 我的优享券接口
NSString *webBillRecord = @"myWallet/MyBillList"; // 账单纪录接口

NSString *webServiceHelp = @"client/HelpInfoList"; // 客服帮助接口
NSString *webServiceMessage = @"client/Feedback"; // 客服留言接口
NSString *webServiceReply = @"Client/Reply"; // 客服回复接口

NSString *webEditAccountPassword = @"client/UpdateAccountPwd"; // 修改帐号密码接口
NSString *webEditTradingPassword = @"client/UpdateTradingPwd"; // 修改交易密码接口

NSString *webNoReadMessage = @"myNews/SysNews"; // 查询未读消息数接口
NSString *webMessageDetailList = @"myNews/SysNewsList"; // 查看系统消息列表接口

NSString *webOrderList = @"orders/List"; // 订单列表接口

// UITableViewCell ...

NSString *NZMaterialOrStyleCellIdentify = @"NZMaterialOrStyleCellIdentify";
NSString *NZMaterialOrStyleExpandCellIdentify = @"NZMaterialOrStyleExpandCellIdentify";
NSString *NZCommodityListCellIdentify = @"NZCommodityListCellIdentify";
NSString *NZOrderViewCellIdentify = @"NZOrderViewCellIdentify";
NSString *NZOrderExpendViewCellIdentify = @"NZOrderExpendViewCellIdentify";

/******************   客服帮助需要十种identify   *******************/
// 关于钱包
NSString *NZHelpWalletCellIdentify = @"NZHelpWalletCellIdentify";
NSString *NZHelpWalletExpendCellIdentify = @"NZHelpWalletExpendCellIdentify";
// 关于积分
NSString *NZHelpIntegralCellIdentify = @"NZHelpIntegralCellIdentify";
NSString *NZHelpIntegralExpendCellIdentify = @"NZHelpIntegralExpendCellIdentify";
// 关于特权
NSString *NZHelpPrivilegeCellIdentify = @"NZHelpPrivilegeCellIdentify";
NSString *NZHelpPrivilegeExpendCellIdentify = @"NZHelpPrivilegeExpendCellIdentify";
// 关于售后
NSString *NZHelpOrderCellIdentify = @"NZHelpOrderCellIdentify";
NSString *NZHelpOrderExpendCellIdentify = @"NZHelpOrderExpendCellIdentify";
// 关于订单
NSString *NZHelpCustomerServiceCellIdentify = @"NZHelpCustomerServiceCellIdentify";
NSString *NZHelpCustomerServiceExpendCellIdentify = @"NZHelpCustomerServiceExpendCellIdentify";

// 优惠活动cell
NSString *NZGrabActivityCellIdentify = @"NZGrabActivityCellIdentify";
NSString *NZNewProductActivityCellIdentify = @"NZNewProductActivityCellIdentify";
NSString *NZCouponsActivityCellIdentify = @"NZCouponsActivityCellIdentify";
// 大牌档cell
NSString *NZMajorSuitCellIdentify = @"NZMajorSuitCellIdentify";
// 购物袋cell
NSString *NZShopBagCellIdentify = @"NZShopBagCellIdentify";
NSString *NZShopBagExpendCellIdentify = @"NZShopBagExpendCellIdentify";
// 收货地址cell
NSString *NZDeliveryAddressViewCellIdentify = @"NZDeliveryAddressViewCellIdentify";
// 账单纪录cell
NSString *NZBillingViewCellIdentify = @"NZBillingViewCellIdentify";
// 客服 回复cell
NSString *NZReplyViewCellIdentify = @"NZReplyViewCellIdentify";
// 银行卡cell
NSString *NZBankCardCellIdentify = @"NZBankCardCellIdentify";
// 我的优享券cell
NSString *NZUnUsedCouponCellIdentify = @"NZUnUsedCouponCellIdentify";
NSString *NZUsedCouponCellIdentify = @"NZUsedCouponCellIdentify";

// 信息
NSString *NZSystemMessageTypeCellIdentify = @"NZSystemMessageTypeCellIdentify";
NSString *NZMessageCollectionTypeCellIdentify = @"NZMessageCollectionTypeCellIdentify";
NSString *NZMessageViewCellIdentify = @"NZMessageViewCellIdentify";
NSString *NZMessageExpendViewCellIdentify = @"NZMessageExpendViewCellIdentify";

@implementation NZExtern

@end
