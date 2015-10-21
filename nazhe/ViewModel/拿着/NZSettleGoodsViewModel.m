//
//  NZSettleGoodsViewModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZSettleGoodsViewModel.h"

@implementation NZSettleGoodsViewModel

- (void)setShopBagGoodModel:(ShopBagGoodModel *)shopBagGoodModel {
    _shopBagGoodModel = shopBagGoodModel;
    
    UIFont *nameFont = [UIFont systemFontOfSize:15.f];
    NSDictionary *attribute1 = @{NSFontAttributeName:nameFont};
    CGSize limitSize1 = CGSizeMake(ScreenWidth*145/375, MAXFLOAT);
    // 计算尺寸
    CGSize nameSize = [shopBagGoodModel.name boundingRectWithSize:limitSize1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    // 规格尺寸
    _goodNameLabFrame = CGRectMake(ScreenWidth*154/375, ScreenWidth*25/375, limitSize1.width, nameSize.height);
    
    _priceLabFrame = CGRectMake(ScreenWidth*154/375, CGRectGetMaxY(_goodNameLabFrame), ScreenWidth-ScreenWidth*154/375, ScreenWidth*15/375);
    
    UIFont *specFont = [UIFont systemFontOfSize:12.f];
    NSDictionary *attribute2 = @{NSFontAttributeName:specFont};
    CGSize limitSize2 = CGSizeMake(ScreenWidth-ScreenWidth*194/375, MAXFLOAT);
    // 计算尺寸
    CGSize specSize = [shopBagGoodModel.descript boundingRectWithSize:limitSize2 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
    // 规格尺寸
    _specificationsFrame = CGRectMake(ScreenWidth*154/375, CGRectGetMaxY(_priceLabFrame)+ScreenWidth*5/375, limitSize2.width, specSize.height);
    
    // 数量尺寸
    _numberLabFrame = CGRectMake(_specificationsFrame.origin.x, CGRectGetMaxY(_specificationsFrame)+ScreenWidth*3/375, 50, ScreenWidth*15/375);
    
    CGFloat cellHeight = CGRectGetMaxY(_numberLabFrame)+ScreenWidth*15/375;
    // 下竖线尺寸
    _bottomLineFrame = CGRectMake(ScreenWidth*77/375, ScreenWidth*116/375, 1, cellHeight-ScreenWidth*110/375);
    
}

@end
