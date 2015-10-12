//
//  NZOrderExpendTableViewCell.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderExpendTableViewCell.h"

@implementation NZOrderExpendTableViewCell

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

- (void)setOrderVM:(NZOrderViewModel *)orderVM {
    _orderVM = orderVM;
    
    /**********************  商品图片  ***********************/
    UIView *imgBackV = [[UIView alloc] initWithFrame:JJRectMake(20, 13.5, 98, 98)];
    imgBackV.backgroundColor = [UIColor whiteColor];
    imgBackV.layer.cornerRadius = imgBackV.frame.size.width / 2;
    imgBackV.layer.masksToBounds = YES;
    imgBackV.layer.borderWidth = 0.5f;
    imgBackV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:imgBackV];
    
    _imgV = [[UIImageView alloc] initWithFrame:JJRectMake(5, 5, 88, 88)];
    _imgV.backgroundColor = [UIColor whiteColor];
    _imgV.layer.cornerRadius = _imgV.frame.size.width / 2 ;
    _imgV.layer.masksToBounds= YES ;
    [imgBackV addSubview:_imgV];
    
    /**********************  商品图片上下的线  ***********************/
    UIView *topLine = [[UIView alloc] initWithFrame:JJRectMake(68.5, 0, 1, 10)];
    topLine.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:JJRectMake(68.5, 115, 1, 10)];
    bottomLine.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:bottomLine];
    
    /**********************  商品名称Label  ***********************/
    _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgBackV.frame)+ScreenWidth*20/375, (ScreenWidth*125/375-20)/2, ScreenWidth-CGRectGetMaxX(imgBackV.frame)-ScreenWidth*20/375, 20)];
    _nameL.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:_nameL];
    
    /**********************  订单日期  ***********************/
    _dateL = [[UILabel alloc] initWithFrame:CGRectMake(_nameL.origin.x, _nameL.origin.y-20, 100, 15)];
    _dateL.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:_dateL];
    
    /**********************  商品数量  ***********************/
    _countL = [[UILabel alloc] initWithFrame:CGRectMake(_nameL.origin.x, CGRectGetMaxY(_nameL.frame), 50, 15)];
    _countL.textColor = [UIColor grayColor];
    _countL.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_countL];
    
    /**********************  横线1  ***********************/
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(_countL.origin.x, CGRectGetMaxY(_countL.frame)+ScreenWidth*10/375, _nameL.frame.size.width-ScreenWidth*18/375, 0.5)];
    line1.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line1];
    
    /**********************  订单收起按钮  ***********************/
    _takeBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*43/375, ScreenWidth*27/375, ScreenWidth*25/375, ScreenWidth*25/375)];
    [_takeBackBtn setBackgroundImage:[UIImage imageNamed:@"向上圈"] forState:UIControlStateNormal];
    [self.contentView addSubview:_takeBackBtn];
    
    /**********************  订单状态  ***********************/
    _stateL = [[UILabel alloc] initWithFrame:CGRectMake(_takeBackBtn.origin.x-50, _takeBackBtn.origin.y, 50, ScreenWidth*25/375)];
    _stateL.textColor = [UIColor grayColor];
    _stateL.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_stateL];
    
    /**********************  订单详情  ***********************/
    UILabel *orderDetailLab = [[UILabel alloc] initWithFrame:orderVM.orderDetailFrame];
    orderDetailLab.text = @"订单详情";
    orderDetailLab.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:orderDetailLab];
    
    /**********************  收货人  ***********************/
    UILabel *consigneeLab = [[UILabel alloc] initWithFrame:orderVM.consigneeFrame];
    consigneeLab.text = [NSString stringWithFormat:@"收货人：%@  %@",orderVM.orderInfo.receiverName, orderVM.orderInfo.phone];
    consigneeLab.textColor = [UIColor grayColor];
    consigneeLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:consigneeLab];
    
    /**********************  收货地址  ***********************/
    UILabel *receivingAddressLab = [[UILabel alloc] initWithFrame:orderVM.receivingAddressFrame];
    receivingAddressLab.text = [NSString stringWithFormat:@"收货地址：%@",orderVM.orderInfo.address];
    receivingAddressLab.textColor = [UIColor grayColor];
    receivingAddressLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:receivingAddressLab];
    
    /**********************  订单编号  ***********************/
    UILabel *orderIDLab = [[UILabel alloc] initWithFrame:orderVM.orderIDFrame];
    orderIDLab.text = [NSString stringWithFormat:@"订单编号  %@",orderVM.orderInfo.orderId];
    orderIDLab.textColor = [UIColor grayColor];
    orderIDLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:orderIDLab];
    
    /**********************  交易号  ***********************/
    UILabel *tradingNumberLab = [[UILabel alloc] initWithFrame:orderVM.tradingNumberFrame];
    tradingNumberLab.text = [NSString stringWithFormat:@"交易号  %@",orderVM.orderInfo.tradingNumber];
    tradingNumberLab.textColor = [UIColor grayColor];
    tradingNumberLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:tradingNumberLab];
    
    /**********************  创建时间  ***********************/
    UILabel *createTimeLab = [[UILabel alloc] initWithFrame:orderVM.createTimeFrame];
    createTimeLab.text = [NSString stringWithFormat:@"创建时间  %@",orderVM.orderInfo.createDate];
    createTimeLab.textColor = [UIColor grayColor];
    createTimeLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:createTimeLab];
    
    /**********************  付款时间  ***********************/
    UILabel *payTimeLab = [[UILabel alloc] initWithFrame:orderVM.payTimeFrame];
    payTimeLab.text = [NSString stringWithFormat:@"付款时间  %@",orderVM.orderInfo.payDate];
    payTimeLab.textColor = [UIColor grayColor];
    payTimeLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:payTimeLab];
    
    /**********************  发货时间  ***********************/
    UILabel *sendTimeLab = [[UILabel alloc] initWithFrame:orderVM.sendTimeFrame];
    sendTimeLab.text = [NSString stringWithFormat:@"发货时间  %@",orderVM.orderInfo.sendDate];
    sendTimeLab.textColor = [UIColor grayColor];
    sendTimeLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:sendTimeLab];
    
    /**********************  折扣  ***********************/
    UILabel *discountLab = [[UILabel alloc] initWithFrame:orderVM.discountFrame];
    discountLab.text = [NSString stringWithFormat:@"折扣  －￥%.2f",orderVM.orderInfo.discountPrice];
    discountLab.textColor = [UIColor grayColor];
    discountLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:discountLab];
    
    /**********************  实付款  ***********************/
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付款  ￥%.2f",orderVM.orderInfo.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:darkRedColor range:NSMakeRange(4, str.length-4)];

    UILabel *totalPriceLab = [[UILabel alloc] initWithFrame:orderVM.totalPriceFrame];
    totalPriceLab.attributedText = str;
    totalPriceLab.textColor = [UIColor grayColor];
    totalPriceLab.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:totalPriceLab];
    
    /**********************  右下角按钮2  ***********************/
    _button2 = [[UIButton alloc] initWithFrame:orderVM.button2Frame];
    _button2.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _button2.layer.cornerRadius = 2.f;
    _button2.layer.masksToBounds = YES;
    _button2.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_button2];
    
    /**********************  右下角按钮1  ***********************/
    _button1 = [[UIButton alloc] initWithFrame:orderVM.button1Frame];
    _button1.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _button1.layer.cornerRadius = 2.f;
    _button1.layer.masksToBounds = YES;
    _button1.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_button1];
    
    /**********************  line2  ***********************/
    UIView *line2 = [[UIView alloc] initWithFrame:orderVM.line2Frame];
    line2.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line2];
    
    GoodsInfoModel *goodInfo = orderVM.orderInfo.goods[0];
    
    [_imgV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:goodInfo.img]]];
    _nameL.text = goodInfo.name;
    _dateL.text = orderVM.orderInfo.date;
    _countL.text = [NSString stringWithFormat:@"X %d",goodInfo.count];
    if (orderVM.orderInfo.state == 1) {
        _stateL.text = @"待付款";
        _button1.hidden = YES;
        [_button2 setTitle:@"去付款" forState:UIControlStateNormal];
        [_button2 setTitleColor:darkRedColor forState:UIControlStateNormal];
        _button2.layer.borderColor = darkRedColor.CGColor;
    } else if (orderVM.orderInfo.state == 2) {
        _stateL.text = @"待收货";
        _button1.hidden = YES;
        [_button2 setTitle:@"确认收货" forState:UIControlStateNormal];
        [_button2 setTitleColor:darkRedColor forState:UIControlStateNormal];
        _button2.layer.borderColor = darkRedColor.CGColor;
    } else if (orderVM.orderInfo.state == 3) {
        _stateL.text = @"已完成";
        
        [_button1 setTitle:@"评价" forState:UIControlStateNormal];
        [_button1 setTitleColor:tintOrangeColor forState:UIControlStateNormal];
        _button1.layer.borderColor = tintOrangeColor.CGColor;
        
        [_button2 setTitle:@"I SHOW" forState:UIControlStateNormal];
        [_button2 setTitleColor:tintOrangeColor forState:UIControlStateNormal];
        _button2.layer.borderColor = tintOrangeColor.CGColor;
    }
    
    if (orderVM.orderInfo.goods.count > 1) {
        for (int i=0; i<orderVM.orderInfo.goods.count-1; i++) {
            GoodsInfoModel *goodInfo = orderVM.orderInfo.goods[i+1];
            
            /**********************  展开商品图片  ***********************/
            _imgBackView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*20/375, ScreenWidth*125/375+ScreenWidth*(108*i)/375, ScreenWidth*98/375, ScreenWidth*98/375)];
            _imgBackView.backgroundColor = [UIColor whiteColor];
            _imgBackView.layer.cornerRadius = _imgBackView.frame.size.width / 2;
            _imgBackView.layer.masksToBounds = YES;
            _imgBackView.layer.borderWidth = 0.5f;
            _imgBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [self.contentView addSubview:_imgBackView];
            
            _imgView = [[UIImageView alloc] initWithFrame:JJRectMake(5, 5, 88, 88)];
            _imgView.backgroundColor = [UIColor whiteColor];
            _imgView.layer.cornerRadius = _imgView.frame.size.width / 2 ;
            _imgView.layer.masksToBounds= YES ;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:goodInfo.img]]];
            [_imgBackView addSubview:_imgView];
            
            /**********************  展开商品图片下面竖线  ***********************/
            _bottomLine = [[UIView alloc] init];
            if (i == orderVM.orderInfo.goods.count-2) {
                _bottomLine.frame = CGRectMake(ScreenWidth*68.5/375, CGRectGetMaxY(_imgBackView.frame), ScreenWidth*1/375, CGRectGetMaxY(_button2.frame)+ScreenWidth*15/375-CGRectGetMaxY(_imgBackView.frame));
            } else {
                _bottomLine.frame = CGRectMake(ScreenWidth*68.5/375, CGRectGetMaxY(_imgBackView.frame), ScreenWidth*1/375, ScreenWidth*10/375);
            }
            _bottomLine.backgroundColor = [UIColor darkGrayColor];
            [self.contentView addSubview:_bottomLine];
            
            /**********************  商品名称Label  ***********************/
            _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgBackView.frame)+ScreenWidth*20/375, _imgBackView.origin.y+(ScreenWidth*98/375-20)/2, ScreenWidth-CGRectGetMaxX(_imgBackView.frame)-ScreenWidth*20/375, 20)];
            _nameLab.font = [UIFont systemFontOfSize:15.f];
            _nameLab.text = goodInfo.name;
            [self.contentView addSubview:_nameLab];
            
            /**********************  订单日期  ***********************/
            _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(_nameLab.origin.x, _nameLab.origin.y-20, 100, 15)];
            _dateLab.font = [UIFont systemFontOfSize:15.f];
            _dateLab.text = orderVM.orderInfo.date;
            [self.contentView addSubview:_dateLab];
            
            /**********************  商品数量  ***********************/
            _countLab = [[UILabel alloc] initWithFrame:CGRectMake(_nameLab.origin.x, CGRectGetMaxY(_nameLab.frame), 50, 15)];
            _countLab.textColor = [UIColor grayColor];
            _countLab.font = [UIFont systemFontOfSize:13.f];
            _countLab.text = [NSString stringWithFormat:@"X %d",goodInfo.count];
            [self.contentView addSubview:_countLab];
        }
    } else {
        bottomLine.frame = CGRectMake(ScreenWidth*68.5/375, ScreenWidth*115/375, ScreenWidth*1/375, CGRectGetMaxY(_button2.frame)+ScreenWidth*15/375-CGRectGetMaxY(imgBackV.frame));
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
