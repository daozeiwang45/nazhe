//
//  NZSettleViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZSettleViewCell.h"

@interface NZSettleViewCell () {
    UIView *imgBackGround;
    UIImageView *goodImgView;
    UILabel *goodNameLab;
    UILabel *returnLab;
    UILabel *priceLab;
    UILabel *specificationsLab;
    UILabel *numberLab;
}

@end

@implementation NZSettleViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
    // 商品图片
    imgBackGround = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*28/375, ScreenWidth*13/375, ScreenWidth*100/375, ScreenWidth*100/375)];
    imgBackGround.backgroundColor = [UIColor whiteColor];
    imgBackGround.layer.cornerRadius = imgBackGround.frame.size.width/2;
    imgBackGround.layer.masksToBounds = YES;
    imgBackGround.layer.borderWidth = 0.5f;
    imgBackGround.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:imgBackGround];
    
    goodImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*5/375, ScreenWidth*5/375, ScreenWidth*90/375, ScreenWidth*90/375)];
    goodImgView.layer.cornerRadius = goodImgView.frame.size.width/2;
    goodImgView.layer.masksToBounds = YES;
    [imgBackGround addSubview:goodImgView];
    
    // 商品名label
    goodNameLab = [[UILabel alloc] init];
    goodNameLab.textColor = [UIColor blackColor];
    goodNameLab.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:goodNameLab];
    
    // 7天包换
    returnLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*60/375, ScreenWidth*30/375, ScreenWidth*40/375, ScreenWidth*11/375)];
    returnLab.backgroundColor = darkRedColor;
    returnLab.text = @"七天退换";
    returnLab.textColor = [UIColor whiteColor];
    returnLab.font = [UIFont systemFontOfSize:9.f];
    returnLab.textAlignment = NSTextAlignmentCenter;
    returnLab.layer.cornerRadius = 1.f;
    returnLab.layer.masksToBounds = YES;
    [self.contentView addSubview:returnLab];
    
    // 总价label
    priceLab = [[UILabel alloc] init];
    priceLab.textColor = darkRedColor;
    priceLab.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:priceLab];
    
    // 规格label
    specificationsLab = [[UILabel alloc] init];
    specificationsLab.textColor = [UIColor grayColor];
    specificationsLab.font = [UIFont systemFontOfSize:12.f];
    specificationsLab.numberOfLines = 0;
    [self.contentView addSubview:specificationsLab];
    
    // 数量label
    numberLab = [[UILabel alloc] init];
    numberLab.textColor = [UIColor grayColor];
    numberLab.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:numberLab];
    
    // 上下两条竖线
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*77/375, 0, 1, ScreenWidth*10/375)];
    _topLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_bottomLine];
    
}

- (void)setSettleGoodsVM:(NZSettleGoodsViewModel *)settleGoodsVM {
    _settleGoodsVM = settleGoodsVM;
    
    [goodImgView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:settleGoodsVM.shopBagGoodModel.img]] placeholderImage:defaultImage];
    
    goodNameLab.text = settleGoodsVM.shopBagGoodModel.name;
    goodNameLab.frame = settleGoodsVM.goodNameLabFrame;
    
    priceLab.text = [NSString stringWithFormat:@"￥%.2f",settleGoodsVM.shopBagGoodModel.totalPrice];
    priceLab.frame = settleGoodsVM.priceLabFrame;
    
    specificationsLab.frame = settleGoodsVM.specificationsFrame;
    specificationsLab.text = settleGoodsVM.shopBagGoodModel.descript;
    
    numberLab.text = [NSString stringWithFormat:@"x %d",settleGoodsVM.shopBagGoodModel.count];
    numberLab.frame = settleGoodsVM.numberLabFrame;
    
    _bottomLine.frame = settleGoodsVM.bottomLineFrame;
}

@end
