//
//  NZReplyViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZReplyViewCell.h"
#import "NZReplyModel.h"

@implementation NZReplyViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    ServiceReplyInfoModel *replyM = _replyVM.reply;
    // 提问标题label
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 30)];
    titleLab.text = replyM.type;
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont systemFontOfSize:15.f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLab];
    
    // 删除按钮
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 8, 15, 15)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:deleteBtn];
    
    // 提问时间
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-100, 0, 85, 30)];
    timeLab.text = replyM.time;
    timeLab.textColor = [UIColor grayColor];
    timeLab.font = [UIFont systemFontOfSize:15.f];
    timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLab];
    
    // 提问内容
    UIView *contentView = [[UIView alloc] initWithFrame:_replyVM.contentFrame];
    contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.contentView addSubview:contentView];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth-30, _replyVM.contentFrame.size.height-20)];
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.text = _replyVM.quesStr;
    contentLab.textColor = [UIColor grayColor];
    contentLab.font = [UIFont systemFontOfSize:13.f];
    contentLab.numberOfLines = 0;
    [contentView addSubview:contentLab];
    
    // 回复标题label
    UILabel *replyTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_replyVM.contentFrame), 60, 30)];
    replyTitleLab.text = @"回复";
    replyTitleLab.textColor = [UIColor redColor];
    replyTitleLab.font = [UIFont systemFontOfSize:15.f];
    replyTitleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:replyTitleLab];
    
    // 回复时间
    UILabel *replyTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-100, CGRectGetMaxY(_replyVM.contentFrame), 85, 30)];
    replyTimeLab.text = replyM.replyTime;
    replyTimeLab.textColor = [UIColor grayColor];
    replyTimeLab.font = [UIFont systemFontOfSize:15.f];
    replyTimeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:replyTimeLab];
    
    // 回复内容
    UIView *replyContentView = [[UIView alloc] initWithFrame:_replyVM.replyContentFrame];
    replyContentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.contentView addSubview:replyContentView];
    
    UILabel *replyContentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth-30, _replyVM.replyContentFrame.size.height-20)];
    replyContentLab.backgroundColor = [UIColor clearColor];
    replyContentLab.text = replyM.reply;
    replyContentLab.textColor = [UIColor grayColor];
    replyContentLab.font = [UIFont systemFontOfSize:13.f];
    replyContentLab.numberOfLines = 0;
    [replyContentView addSubview:replyContentLab];
    
    // 底部分割
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_replyVM.replyContentFrame), ScreenWidth, 10)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [self.contentView addSubview:bottomView];
}

@end
