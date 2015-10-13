//
//  NZCommentViewModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZCommentViewModel.h"

@implementation NZCommentViewModel

- (void)setReview:(ReviewModel *)review {
    _review = review;
    
    UIFont *nameFont = [UIFont systemFontOfSize:10.f];
    NSDictionary *nameAttribute = @{NSFontAttributeName:nameFont};
    CGSize nameLimitSize = CGSizeMake(MAXFLOAT, ScreenWidth*15/375);
    // 计算尺寸
    CGSize nameSize = [review.NickName boundingRectWithSize:nameLimitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nameAttribute context:nil].size;
    _nameFrame = CGRectMake(ScreenWidth*58/375+5, ScreenWidth*16/375, nameSize.width, nameSize.height);
    
    _starFrame = CGRectMake(CGRectGetMaxX(_nameFrame)+8, _nameFrame.origin.y, 100, _nameFrame.size.height);
    
    CGFloat contentOriginY;
    
    if ([NZGlobal isNotBlankString:review.friendName]) {
        _friendFrame = CGRectMake(_nameFrame.origin.x, ScreenWidth*58/375, ScreenWidth-ScreenWidth*78/375-5, 15);
        contentOriginY = ScreenWidth*58/375+18;
    } else {
        contentOriginY = ScreenWidth*58/375;
    }
    
    UIFont *contentFont = [UIFont systemFontOfSize:13.f];
    NSDictionary *contentAttribute = @{NSFontAttributeName:contentFont};
    CGSize contentLimitSize = CGSizeMake(ScreenWidth-ScreenWidth*78/375-5, MAXFLOAT);
    // 计算尺寸
    CGSize contentSize = [review.content boundingRectWithSize:contentLimitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute context:nil].size;
    _contentFrame = CGRectMake(_nameFrame.origin.x, contentOriginY, contentLimitSize.width, contentSize.height);
    
    _replyFrame = CGRectMake(ScreenWidth-ScreenWidth*20/375-45, CGRectGetMaxY(_contentFrame)+ScreenWidth*10/375, 45, 10);
    
    _dividingFrame = CGRectMake(_replyFrame.origin.x-1, _replyFrame.origin.y, 1, 10);
    
    _reportFrame = CGRectMake(_dividingFrame.origin.x-45, _dividingFrame.origin.y, 45, 10);
}

@end
