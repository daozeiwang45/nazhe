//
//  NZActivityReviewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZActivityReviewCell.h"

@interface NZActivityReviewCell () {
    // 评论人头像
    UIImageView *headImgV;
    // 评论人昵称
    UILabel *nickNameLab;
    // 评论人星级
    UILabel *starLab;
    // 评论时间
    UILabel *timeLab;
    // 点赞数
    UILabel *likeCountLab;
    // 点赞
    UIButton *likeBtn;
    // 虚线
    UIImageView *line;
    // 回复对象
    UILabel *friendLab;
    // 评论内容
    UILabel *contentLab;
    // 举报按钮
    UIButton *reportBtn;
    // 分割线
    UIView *dividingLine;
    // 回复按钮
    UIButton *replyBtn;
    
}

@end

@implementation NZActivityReviewCell

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initInterface];
    }
    return self;
}

- (void)initInterface {
    
    // 评论人头像
    headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*20/375, ScreenWidth*12/375, ScreenWidth*38/375, ScreenWidth*38/375)];
    headImgV.layer.cornerRadius = headImgV.frame.size.width/2;
    headImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:headImgV];
    
    // 评论人昵称
    nickNameLab = [[UILabel alloc] init];
    nickNameLab.textColor = [UIColor darkGrayColor];
    nickNameLab.font = [UIFont systemFontOfSize:10.f];
    [self.contentView addSubview:nickNameLab];
    
    // 评论人星级
    starLab = [[UILabel alloc] init];
    starLab.textColor = [UIColor darkGrayColor];
    starLab.font = [UIFont systemFontOfSize:10.f];
    [self.contentView addSubview:starLab];
    
    // 评论时间
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImgV.frame)+5, headImgV.origin.y+ScreenWidth*19/375, 150, ScreenWidth*15/375)];
    timeLab.textColor = [UIColor darkGrayColor];
    timeLab.font = [UIFont systemFontOfSize:10.f];
    [self.contentView addSubview:timeLab];
    
    // 点赞按钮
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*45/375, headImgV.origin.y+ScreenWidth*6.5/375, ScreenWidth*25/375, ScreenWidth*25/375)];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"评论赞"] forState:UIControlStateNormal];
    [self.contentView addSubview:likeBtn];
    
    // 点赞数
    likeCountLab = [[UILabel alloc] initWithFrame:CGRectMake(likeBtn.origin.x-55, headImgV.origin.y+ScreenWidth*9/375, 50, ScreenWidth*20/375)];
    likeCountLab.textColor = [UIColor darkGrayColor];
    likeCountLab.font = [UIFont systemFontOfSize:13.f];
    likeCountLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:likeCountLab];
    
    // 虚线
    line = [[UIImageView alloc] initWithFrame:CGRectMake(timeLab.origin.x, headImgV.origin.y+ScreenWidth*37/375, ScreenWidth-ScreenWidth*78/375-5, 1)];
    line.image = [UIImage imageNamed:@"收货地址虚线"];
    [self.contentView addSubview:line];
    
    // 回复对象
    friendLab = [[UILabel alloc] init];
    [self.contentView addSubview:friendLab];
    
    // 评论内容
    contentLab = [[UILabel alloc] init];
    contentLab.textColor = [UIColor darkGrayColor];
    contentLab.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:contentLab];
    
    // 举报按钮
    reportBtn = [[UIButton alloc] init];
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:reportBtn];
    
    // 分割线
    dividingLine = [[UIView alloc] init];
    dividingLine.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:dividingLine];
    
    // 回复按钮
    replyBtn = [[UIButton alloc] init];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [replyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:replyBtn];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1.0;
    objc_setAssociatedObject(longPress, "index", [NSNumber numberWithInt:self.index], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.contentView addGestureRecognizer:longPress];
}

- (void)setCommemtVM:(NZCommentViewModel *)commemtVM {
    _commemtVM = commemtVM;
    
    [headImgV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:commemtVM.review.headImg]] placeholderImage:defaultImage];
    
    nickNameLab.text = commemtVM.review.NickName;
    nickNameLab.frame = commemtVM.nameFrame;
    
    starLab.text = [NSString stringWithFormat:@"%d星级",commemtVM.review.star];
    starLab.frame = commemtVM.starFrame;
    
    timeLab.text = commemtVM.review.time;
    
    likeCountLab.text = [NSString stringWithFormat:@"%d", commemtVM.review.countPraise];
    
    if ([NZGlobal isNotBlankString:commemtVM.review.friendName]) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复 %@", commemtVM.review.friendName]];
        [str addAttribute:NSForegroundColorAttributeName value:darkRedColor range:NSMakeRange(0,2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(2,str.length-2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, str.length)];
        
        friendLab.frame = commemtVM.friendFrame;
        friendLab.attributedText = str;
    }
    
    contentLab.text = [NSString stringWithFormat:@"      %@", commemtVM.review.content];
    contentLab.frame = commemtVM.contentFrame;
    
    reportBtn.frame = commemtVM.reportFrame;
    dividingLine.frame = commemtVM.dividingFrame;
    replyBtn.frame = commemtVM.replyFrame;
    
}

#pragma mark 回复
- (void)replyAction:(UIButton *)button {
    
    [self.delegate replyWithIndex:self.index];
    
}

#pragma mark 长按1秒删除
- (void)longPressAction:(UIGestureRecognizer *)sender {
    [self.delegate deleteWithIndex:self.index];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
