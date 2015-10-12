//
//  MessageNumberModel.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/23.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageNumberModel : NSObject

/**************   系统消息   ***************/

/**
 *  账户动态未读数
 */
@property (nonatomic, assign) int countDynamic;
/**
 *  积分动态未读数
 */
@property (nonatomic, assign) int countScorer;
/**
 *  交易提醒未读数
 */
@property (nonatomic, assign) int countTrading;

/**
 *  尊享活动未读数 / 尊享活动收藏数
 */
@property (nonatomic, assign) int countActivity;

/**
 *  系统通知未读数
 */
@property (nonatomic, assign) int countNotice;

/*************   信息收藏   *****************/

/**
 *  好友聊天收藏数
 */
@property (nonatomic, assign) int countChat;



@end
