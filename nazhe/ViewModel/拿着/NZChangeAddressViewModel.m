//
//  NZChangeAddressViewModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/20.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZChangeAddressViewModel.h"

@implementation NZChangeAddressViewModel

- (void)setMyAddressInfoModel:(MyDeliveryAddressInfoModel *)myAddressInfoModel {
    _myAddressInfoModel = myAddressInfoModel;
    
    UIFont *nameFont = [UIFont systemFontOfSize:19.f];
    NSDictionary *attribute1 = @{NSFontAttributeName:nameFont};
    CGSize limitSize1 = CGSizeMake(MAXFLOAT, 20);
    // 计算尺寸
    CGSize nameSize = [myAddressInfoModel.name boundingRectWithSize:limitSize1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    _nameLabFrame = CGRectMake(ScreenWidth*15/375, ScreenWidth*10/375, nameSize.width, limitSize1.height);
    
    _phoneLabFrame = CGRectMake(CGRectGetMaxX(_nameLabFrame)+ScreenWidth*15/375, _nameLabFrame.origin.y+3, 100, 15);
    
    UIFont *addressFont = [UIFont systemFontOfSize:13.f];
    NSDictionary *attribute2 = @{NSFontAttributeName:addressFont};
    CGSize limitSize2 = CGSizeMake(ScreenWidth-ScreenWidth*80/375, MAXFLOAT);
    // 计算尺寸
    CGSize addressSize = [myAddressInfoModel.address boundingRectWithSize:limitSize2 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
    _detailAddressFrame = CGRectMake(_nameLabFrame.origin.x, CGRectGetMaxY(_nameLabFrame)+ScreenWidth*10/375, limitSize2.width, addressSize.height);
    
    _lineFrame = CGRectMake(0, CGRectGetMaxY(_detailAddressFrame)+ScreenWidth*10/375, ScreenWidth-ScreenWidth*50/375, 1);
}

@end
