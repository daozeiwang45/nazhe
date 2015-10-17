//
//  NZShopBagExpandTableViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/16.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZShopBagExpandTableViewCell.h"

@interface NZShopBagExpandTableViewCell () {
    UIView *imgBackGround;
    UIImageView *goodImgView;
    UIButton *selectBtn;
    UIButton *deleteBtn;
    UILabel *goodNameLab;
    UILabel *priceLab;
    UILabel *specificationsLab;
    UIImageView *downArrow;
    UIButton *editSpeBtn;
    UILabel *dyNumLab;
    UIButton *addBtn;
    UIButton *reduceBtn;
    UIButton *commitBtn;
    UIButton *cancelBtn;
    UIView *line;
}

@end

@implementation NZShopBagExpandTableViewCell

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
    
    downArrow = [[UIImageView alloc] init];
    downArrow.image = [UIImage imageNamed:@"钱包下键"];
    [self.contentView addSubview:downArrow];
    
    // 减一按钮
    reduceBtn = [[UIButton alloc] init];
    [reduceBtn setBackgroundImage:[UIImage imageNamed:@"-"] forState:UIControlStateNormal];
    [reduceBtn addTarget:self action:@selector(reduceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:reduceBtn];
    
    // 动态数量label
    dyNumLab = [[UILabel alloc] init];
    dyNumLab.textColor = [UIColor grayColor];
    dyNumLab.font = [UIFont systemFontOfSize:21.f];
    dyNumLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dyNumLab];
    
    // 加一按钮
    addBtn = [[UIButton alloc] init];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];
    
    // 取消按钮
    cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:darkRedColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    cancelBtn.layer.cornerRadius = 2.f;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderColor = darkRedColor.CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    
    // 完成按钮
    commitBtn = [[UIButton alloc] init];
    commitBtn.backgroundColor = darkRedColor;
    [commitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    commitBtn.layer.cornerRadius = 2.f;
    commitBtn.layer.masksToBounds = YES;
    [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commitBtn];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
}

- (void)setShopBagViewModel:(NZShopBagViewModel *)shopBagViewModel {
    _shopBagViewModel = shopBagViewModel;
    
    [goodImgView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:shopBagViewModel.shopBagGoodModel.img]] placeholderImage:defaultImage];
    
    if (shopBagViewModel.shopBagGoodModel.selectState) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"圆-已选"] forState:UIControlStateNormal];
    } else {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"圆-未选"] forState:UIControlStateNormal];
    }
    
    _bottomLine.frame = shopBagViewModel.bottomLine2Frame;
    
    goodNameLab.text = shopBagViewModel.shopBagGoodModel.name;
    
    self.price = shopBagViewModel.shopBagGoodModel.totalPrice/shopBagViewModel.shopBagGoodModel.count;
    self.totalPrice = shopBagViewModel.shopBagGoodModel.totalPrice;
    priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    
    specificationsLab.frame = shopBagViewModel.specificationsFrame;
    specificationsLab.text = shopBagViewModel.shopBagGoodModel.descript;
    
    downArrow.frame = shopBagViewModel.downArrowFrame;
    
    dyNumLab.frame = shopBagViewModel.dyNumberLabFrame;
    dyNumLab.text = [NSString stringWithFormat:@"%d",shopBagViewModel.shopBagGoodModel.count];
    self.number = shopBagViewModel.shopBagGoodModel.count;
    
    reduceBtn.frame = shopBagViewModel.reduceBtnFrame;
    
    addBtn.frame = shopBagViewModel.addBtnFrame;
    
    cancelBtn.frame = shopBagViewModel.cancelBtnFrame;
    
    commitBtn.frame = shopBagViewModel.commitBtnFrame;
    
    line.frame = shopBagViewModel.lineFrame;
    
    self.selectState = shopBagViewModel.shopBagGoodModel.selectState;
}

- (void)addNumberAction:(UIButton *)sender {
    
    self.number += 1;
    dyNumLab.text = [NSString stringWithFormat:@"%d",self.number];
    
    self.totalPrice = self.price * self.number;
    priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    
    [self.delegate addSelectState:self.selectState andSinglePrice:self.price];
}

- (void)reduceAction:(UIButton *)sender {
    
    if (self.number > 1) {
        self.number -= 1;
        dyNumLab.text = [NSString stringWithFormat:@"%d",self.number];
        
        self.totalPrice = self.price * self.number;
        priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
        
        [self.delegate reduceSelectState:self.selectState andSinglePrice:self.price];
    }
}

- (void)commitAction:(UIButton *)sender {
    [self.delegate commitWithSection:self.section andRow:self.row andNumber:self.number andSinglePrice:self.price];
}

- (void)cancelAction:(UIButton *)sender {
    [self.delegate cancelWithSection:self.section andRow:self.row andNumber:self.number andSinglePrice:self.price];
}

@end
