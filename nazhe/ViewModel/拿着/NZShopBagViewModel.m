//
//  NZShopBagViewModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZShopBagViewModel.h"

@implementation NZShopBagViewModel

- (void)setShopBagGoodModel:(ShopBagGoodModel *)shopBagGoodModel {
    _shopBagGoodModel = shopBagGoodModel;
    
    UIFont *contentFont = [UIFont systemFontOfSize:12.f];
    NSDictionary *attribute = @{NSFontAttributeName:contentFont};
    CGSize limitSize = CGSizeMake(ScreenWidth-ScreenWidth*194/375, MAXFLOAT);
    // 计算尺寸
    CGSize contentSize = [shopBagGoodModel.descript boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    // 规格尺寸
    _specificationsFrame = CGRectMake(ScreenWidth*154/375, ScreenWidth*65/375, limitSize.width, contentSize.height);
    
    // 数量尺寸
    _numberLabFrame = CGRectMake(_specificationsFrame.origin.x, CGRectGetMaxY(_specificationsFrame)+ScreenWidth*3/375, 50, ScreenWidth*15/375);
    
    // 编辑按钮尺寸
    _editBtnFrame = CGRectMake(ScreenWidth-ScreenWidth*80/375, CGRectGetMaxY(_specificationsFrame)+ScreenWidth*15/375, ScreenWidth*60/375, ScreenWidth*17/375);
    
    CGFloat cellHeight = CGRectGetMaxY(_editBtnFrame)+ScreenWidth*15/375;
    // 下竖线尺寸
    _bottomLineFrame = CGRectMake(ScreenWidth*77/375, ScreenWidth*110/375, 1, cellHeight-ScreenWidth*110/375);
    
    /***** expand *****/
    
    // 向下箭头尺寸
    _downArrowFrame = CGRectMake(CGRectGetMaxX(_specificationsFrame)+ScreenWidth*4/375, (CGRectGetMaxY(_specificationsFrame)-_specificationsFrame.origin.y)/2+_specificationsFrame.origin.y-ScreenWidth*4/375, ScreenWidth*16/375, ScreenWidth*8/375);
    
    // 修改规格按钮尺寸
    _editSpeBtnFrame = CGRectMake(ScreenWidth*154/375, ScreenWidth*65/375, ScreenWidth-ScreenWidth*174/375, _specificationsFrame.size.height);
    
    // 减一尺寸
    _reduceBtnFrame = CGRectMake(_specificationsFrame.origin.x, CGRectGetMaxY(_specificationsFrame)+ScreenWidth*10/375, ScreenWidth*28/375, ScreenWidth*22/375);
    
    // 动态数量尺寸
    _dyNumberLabFrame = CGRectMake(CGRectGetMaxX(_reduceBtnFrame), _reduceBtnFrame.origin.y, ScreenWidth*70/375, ScreenWidth*22/375);
    
    // 加一尺寸
    _addBtnFrame = CGRectMake(CGRectGetMaxX(_dyNumberLabFrame), _dyNumberLabFrame.origin.y, ScreenWidth*28/375, ScreenWidth*22/375);
    
    // 完成按钮尺寸
    _commitBtnFrame = CGRectMake(ScreenWidth-ScreenWidth*80/375, CGRectGetMaxY(_dyNumberLabFrame)+ScreenWidth*30/375, ScreenWidth*60/375, ScreenWidth*17/375);
    
    // 取消按钮尺寸
    _cancelBtnFrame = CGRectMake(_commitBtnFrame.origin.x-ScreenWidth*70/375, _commitBtnFrame.origin.y, ScreenWidth*60/375, ScreenWidth*17/375);
    
    // 下竖线2尺寸
    _bottomLine2Frame = CGRectMake(ScreenWidth*77/375, ScreenWidth*110/375, 1, CGRectGetMaxY(_cancelBtnFrame)+ScreenWidth*15/375-ScreenWidth*110/375);
    
    // 下面横线尺寸
    _lineFrame = CGRectMake(_specificationsFrame.origin.x, CGRectGetMaxY(_cancelBtnFrame)+ScreenWidth*15/375-1, ScreenWidth-ScreenWidth*174/375, 1);
}

@end
