//
//  NZShopBagTableViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZShopBagTableViewCell.h"

@interface NZShopBagTableViewCell () {
    UIView *imgBackGround;
    UIImageView *goodImgView;
    UIButton *selectBtn;
    UIButton *deleteBtn;
    UIButton *editBtn;
    UILabel *goodNameLab;
    UILabel *priceLab;
    UILabel *specificationsLab;
    UILabel *numLab;
}

@end

@implementation NZShopBagTableViewCell

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
    imgBackGround = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*30/375, ScreenWidth*13/375, ScreenWidth*94/375, ScreenWidth*94/375)];
    imgBackGround.backgroundColor = [UIColor whiteColor];
    imgBackGround.layer.cornerRadius = imgBackGround.frame.size.width/2;
    imgBackGround.layer.masksToBounds = YES;
    imgBackGround.layer.borderWidth = 0.5f;
    imgBackGround.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:imgBackGround];
    
    goodImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*5/375, ScreenWidth*5/375, ScreenWidth*84/375, ScreenWidth*84/375)];
    goodImgView.layer.cornerRadius = goodImgView.frame.size.width/2;
    goodImgView.layer.masksToBounds = YES;
    [imgBackGround addSubview:goodImgView];
    
    // 选中按钮
    selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*18/375, ScreenWidth*47.5/375, ScreenWidth*25/375, ScreenWidth*25/375)];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"圆-未选"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectBtn];
    
    // 上下两条竖线
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*77/375, 0, 1, ScreenWidth*10/375)];
    _topLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_bottomLine];
    
    // 删除按钮
    deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*31/375, ScreenWidth*15/375, ScreenWidth*13/375, ScreenWidth*13/375)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    
    // 商品名label
    goodNameLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*154/375, ScreenWidth*25/375, ScreenWidth-ScreenWidth*154/375, ScreenWidth*20/375)];
    goodNameLab.textColor = [UIColor blackColor];
    goodNameLab.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:goodNameLab];
    
    // 总价label
    priceLab = [[UILabel alloc] initWithFrame:CGRectMake(goodNameLab.origin.x, CGRectGetMaxY(goodNameLab.frame), goodNameLab.frame.size.width, ScreenWidth*15/375)];
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
    numLab = [[UILabel alloc] init];
    numLab.textColor = [UIColor grayColor];
    numLab.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:numLab];
    
    // 编辑按钮
    editBtn = [[UIButton alloc] init];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:darkRedColor forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    editBtn.layer.cornerRadius = 2.f;
    editBtn.layer.masksToBounds = YES;
    editBtn.layer.borderColor = darkRedColor.CGColor;
    editBtn.layer.borderWidth = 0.5f;
    [editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];
}

- (void)setShopBagViewModel:(NZShopBagViewModel *)shopBagViewModel {
    _shopBagViewModel = shopBagViewModel;
    
    [goodImgView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:shopBagViewModel.shopBagGoodModel.img]] placeholderImage:defaultImage];
    
    if (shopBagViewModel.shopBagGoodModel.selectState) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"圆-已选"] forState:UIControlStateNormal];
    } else {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"圆-未选"] forState:UIControlStateNormal];
    }
    
    _bottomLine.frame = shopBagViewModel.bottomLineFrame;
    
    goodNameLab.text = shopBagViewModel.shopBagGoodModel.name;
    
    self.price = shopBagViewModel.shopBagGoodModel.totalPrice/shopBagViewModel.shopBagGoodModel.count;
    self.totalPrice = shopBagViewModel.shopBagGoodModel.totalPrice;
    priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    
    specificationsLab.frame = shopBagViewModel.specificationsFrame;
    specificationsLab.text = shopBagViewModel.shopBagGoodModel.descript;
    
    numLab.frame = shopBagViewModel.numberLabFrame;
    numLab.text = [NSString stringWithFormat:@"x %d",shopBagViewModel.shopBagGoodModel.count];
    self.number = shopBagViewModel.shopBagGoodModel.count;
    
    editBtn.frame = shopBagViewModel.editBtnFrame;
    
    self.selectState = shopBagViewModel.shopBagGoodModel.selectState;
}

- (void)editAction:(UIButton *)sender {
    [self.delegate editClickWithSection:_section andRow:_row];
}

- (void)selectAction:(UIButton *)sender {
    self.selectState = !self.selectState;
    
    if (self.selectState) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"圆-已选"] forState:UIControlStateNormal];
    } else {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"圆-未选"] forState:UIControlStateNormal];
    }
    
    [self.delegate selectClickWithSection:_section andRow:_row andState:self.selectState andPrice:self.price andNumber:self.number];
}

- (void)deleteAction:(UIButton *)sender {
    [self.delegate deleteClickWithSection:_section andRow:_row andState:self.selectState andPrice:self.price andNumber:self.number];
}

@end
