//
//  NZReplyViewModel.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZReplyViewModel.h"

@implementation NZReplyViewModel

- (void)setReply:(ServiceReplyInfoModel *)reply {
    _reply = reply;
    
    NSString *questionStr = [NSString stringWithFormat:@"主题：%@\n正文：%@",reply.theme,reply.content];
    UIFont *contentFont = [UIFont systemFontOfSize:13.f];
    NSDictionary *attribute = @{NSFontAttributeName:contentFont};
    
    CGSize limitSize = CGSizeMake(ScreenWidth-30, MAXFLOAT);
    // 计算提问内容的尺寸
    CGSize contentSize = [questionStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _quesStr = questionStr;
    _contentFrame = CGRectMake(0, 30, ScreenWidth, contentSize.height+20);
    
    // 计算回复内容的尺寸
    CGSize replyContentSize = [reply.reply boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _replyContentFrame = CGRectMake(0, CGRectGetMaxY(_contentFrame)+30, ScreenWidth, replyContentSize.height+30);
    
    
}

@end
