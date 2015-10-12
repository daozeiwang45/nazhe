//
//  NZOrderViewModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderViewModel.h"

@implementation NZOrderViewModel

- (void)setOrderInfo:(OrderInfoModel *)orderInfo {
    _orderInfo = orderInfo;
    
    NSArray *goodsArray = orderInfo.goods;
    float startY;
    if (goodsArray.count == 1) {
        startY = ScreenWidth*120/375;
    } else if (goodsArray.count == 2) {
        startY = ScreenWidth*228/375;
    } else if (goodsArray.count > 2) {
        startY = ScreenWidth*130/375+(goodsArray.count-1)*ScreenWidth*98/375+(goodsArray.count-2)*ScreenWidth*10/375;
    }
    
    float startX = ScreenWidth*138/375;
    
    float width = ScreenWidth-startX;
    
    // 订单详情尺寸
    _orderDetailFrame = CGRectMake(startX, startY, width, 20);
    
    // 收货人尺寸
    _consigneeFrame = CGRectMake(startX, CGRectGetMaxY(_orderDetailFrame), width, 15);
    
    // 收货地址尺寸
    UIFont *contentFont = [UIFont systemFontOfSize:12.f];
    NSDictionary *attribute = @{NSFontAttributeName:contentFont};
    CGSize limitSize = CGSizeMake(width-ScreenWidth*20/375, MAXFLOAT);
    // 计算尺寸
    CGSize contentSize = [[NSString stringWithFormat:@"收货地址：%@",orderInfo.address] boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _receivingAddressFrame = CGRectMake(startX, CGRectGetMaxY(_consigneeFrame), contentSize.width, contentSize.height);
    
    // 订单编号尺寸
    _orderIDFrame = CGRectMake(startX, CGRectGetMaxY(_receivingAddressFrame)+ScreenWidth*15/375, width, 15);
    
    // 交易号尺寸
    _tradingNumberFrame = CGRectMake(startX, CGRectGetMaxY(_orderIDFrame), width, 15);
    
    // 创建时间尺寸
    _createTimeFrame = CGRectMake(startX, CGRectGetMaxY(_tradingNumberFrame), width, 15);
    
    // 付款时间尺寸
    _payTimeFrame = CGRectMake(startX, CGRectGetMaxY(_createTimeFrame), width, 15);
    
    // 发货时间尺寸
    _sendTimeFrame = CGRectMake(startX, CGRectGetMaxY(_payTimeFrame), width, 15);
    
    // 折扣尺寸
    _discountFrame = CGRectMake(startX, CGRectGetMaxY(_sendTimeFrame), width, 15);
    
    // 实付款尺寸
    _totalPriceFrame = CGRectMake(startX, CGRectGetMaxY(_discountFrame), width, 15);
    
    // button2尺寸
    _button2Frame = CGRectMake(ScreenWidth-ScreenWidth*78/375, CGRectGetMaxY(_totalPriceFrame)+ScreenWidth*5/375, ScreenWidth*60/375, ScreenWidth*18/375);
    
    // button1尺寸
    _button1Frame = CGRectMake(_button2Frame.origin.x-ScreenWidth*70/375, _button2Frame.origin.y, ScreenWidth*60/375, ScreenWidth*18/375);
    
    // line2尺寸
    _line2Frame = CGRectMake(startX, CGRectGetMaxY(_button2Frame)+ScreenWidth*10/375, width-ScreenWidth*18/375, 0.5);
}

@end
