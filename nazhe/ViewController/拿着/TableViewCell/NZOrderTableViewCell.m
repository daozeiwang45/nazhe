//
//  NZOrderTableViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderTableViewCell.h"

@implementation NZOrderTableViewCell

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

- (void)setOrderInfo:(OrderInfoModel *)orderInfo {
    _orderInfo = orderInfo;
    
    /**********************  商品图片  ***********************/
    UIView *imgBackView = [[UIView alloc] initWithFrame:JJRectMake(20, 13.5, 98, 98)];
    imgBackView.backgroundColor = [UIColor whiteColor];
    imgBackView.layer.cornerRadius = imgBackView.frame.size.width / 2;
    imgBackView.layer.masksToBounds = YES;
    imgBackView.layer.borderWidth = 0.5f;
    imgBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:imgBackView];
    
    _imgView = [[UIImageView alloc] initWithFrame:JJRectMake(5, 5, 88, 88)];
    _imgView.backgroundColor = [UIColor whiteColor];
    _imgView.layer.cornerRadius = _imgView.frame.size.width / 2 ;
    _imgView.layer.masksToBounds= YES ;
    [imgBackView addSubview:_imgView];
    
    /**********************  商品图片上下的线  ***********************/
    UIView *topLine = [[UIView alloc] initWithFrame:JJRectMake(68.5, 0, 1, 10)];
    topLine.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:JJRectMake(68.5, 115, 1, 10)];
    bottomLine.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:bottomLine];
    
    /**********************  商品名称Label  ***********************/
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgBackView.frame)+ScreenWidth*20/375, (ScreenWidth*125/375-20)/2, ScreenWidth-CGRectGetMaxX(imgBackView.frame)-ScreenWidth*20/375, 20)];
    _nameLab.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:_nameLab];
    
    /**********************  订单日期  ***********************/
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(_nameLab.origin.x, _nameLab.origin.y-20, 100, 15)];
    _dateLab.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:_dateLab];
    
    /**********************  订单状态  ***********************/
    _stateLab = [[UILabel alloc] initWithFrame:CGRectMake(_nameLab.origin.x, CGRectGetMaxY(_nameLab.frame), 50, 15)];
    _stateLab.textColor = [UIColor grayColor];
    _stateLab.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_stateLab];
    
    /**********************  删除订单按钮  ***********************/
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*31/375, ScreenWidth*27/375, ScreenWidth*13/375, ScreenWidth*13/375)];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    
    /**********************  右下角按钮2  ***********************/
    _button2 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*78/375, ScreenWidth*95/375, ScreenWidth*60/375, ScreenWidth*18/375)];
    _button2.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _button2.layer.cornerRadius = 2.f;
    _button2.layer.masksToBounds = YES;
    _button2.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_button2];
    
    /**********************  右下角按钮1  ***********************/
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(_button2.origin.x-ScreenWidth*70/375, _button2.origin.y, ScreenWidth*60/375, ScreenWidth*18/375)];
    _button1.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _button1.layer.cornerRadius = 2.f;
    _button1.layer.masksToBounds = YES;
    _button1.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_button1];
    
    GoodsInfoModel *goodInfo = orderInfo.goods[0];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:goodInfo.img]]];
    _nameLab.text = goodInfo.name;
    _dateLab.text = orderInfo.date;
    if (orderInfo.state == 1) {
        _stateLab.text = @"待付款";
        _button1.hidden = YES;
        [_button2 setTitle:@"去付款" forState:UIControlStateNormal];
        [_button2 setTitleColor:darkRedColor forState:UIControlStateNormal];
        _button2.layer.borderColor = darkRedColor.CGColor;
    } else if (orderInfo.state == 2) {
        _stateLab.text = @"待收货";
        _button1.hidden = YES;
        [_button2 setTitle:@"确认收货" forState:UIControlStateNormal];
        [_button2 setTitleColor:darkRedColor forState:UIControlStateNormal];
        _button2.layer.borderColor = darkRedColor.CGColor;
    } else if (orderInfo.state == 3) {
        _stateLab.text = @"已完成";
        
        [_button1 setTitle:@"评价" forState:UIControlStateNormal];
        [_button1 setTitleColor:tintOrangeColor forState:UIControlStateNormal];
        _button1.layer.borderColor = tintOrangeColor.CGColor;
        
        [_button2 setTitle:@"I SHOW" forState:UIControlStateNormal];
        [_button2 setTitleColor:tintOrangeColor forState:UIControlStateNormal];
        _button2.layer.borderColor = tintOrangeColor.CGColor;
    }
}

- (void)initInterface {
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
