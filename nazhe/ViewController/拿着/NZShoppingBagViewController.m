//
//  NZShoppingBagViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/2.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZShoppingBagViewController.h"
#import "NZShopBagViewCell.h"
#import "NZShopBagExpendViewCell.h"
#import "NZCommodityModel.h"

@interface NZShoppingBagViewController ()<UITableViewDataSource, UITableViewDelegate, NZShopBagDelegate, NZShopBagExpendDelegate> {
    
    int currentIndex; // 当前编辑cell
    
    BOOL isAllSelect; // 是否全选
    
    NSMutableArray *infoArr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *settelView;
@property (strong, nonatomic) IBOutlet UIImageView *selectImgV;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLab;
@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) double editPrice;
@property (strong, nonatomic) IBOutlet UIButton *settleBtn;
@property (assign, nonatomic) int settleNumber;

- (IBAction)allSelectAction:(UIButton *)sender;
- (IBAction)settleAction:(UIButton *)sender;

@end

@implementation NZShoppingBagViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super self];
    if (self) {
        currentIndex = -1;
        
        _totalPrice = 0.0;
        _editPrice = 0.0;
        
        _settleNumber = 0;
        
        infoArr = [[NSMutableArray alloc] init];
        
        /**
         
         *  初始化一个数组，数组里面放字典。字典里面放的是单元格需要展示的数据
         
         */
        
        for (int i = 0; i<3; i++)
            
        {
            
            NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
            
//            [infoDict setValue:@"img6.png" forKey:@"imageName"];
//            
//            [infoDict setValue:@"这是商品标题" forKey:@"goodsTitle"];
            
            [infoDict setValue:@"35000.00" forKey:@"commodityPrice"];
            
            [infoDict setValue:[NSNumber numberWithBool:YES] forKey:@"selectState"];
            
            [infoDict setValue:[NSNumber numberWithInt:1] forKey:@"commodityNum"];
            
            [infoDict setValue:[NSNumber numberWithInt:i]  forKey:@"index"];
            
            //封装数据模型
            
            NZCommodityModel *commodityModel = [[NZCommodityModel alloc] initWithDict:infoDict];
            
            //将数据模型放入数组中
            
            [infoArr addObject:commodityModel];
            
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"购物袋"];
    [self leftButtonTitle:nil];
    
    // 给下面的结算view添加阴影，附加层次感
    [self addShadowSubLayer];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 判断有几个选择了，算进总价和结算个数中（实际不需要，都为未选）
    for (int i = 0; i < infoArr.count; i++) {
        NZCommodityModel *commodityModel = infoArr[i];
        if (commodityModel.selectState) {
            self.totalPrice += commodityModel.commodityNum * [commodityModel.commodityPrice doubleValue];
            self.settleNumber ++;
        }
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
    _totalPriceLab.attributedText = str;
    
    [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
    
    // 判断有没有全选
    isAllSelect = YES;
    for (int i = 0; i < infoArr.count; i++) {
        NZCommodityModel *commodityModel = infoArr[i];
        if (!commodityModel.selectState) {
            isAllSelect = NO;
            break;
        }
    }
    
    if (isAllSelect) {
        _selectImgV.image = [UIImage imageNamed:@"圆-已选"];
        
    } else {
        _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((int)indexPath.row == currentIndex) {
        NZShopBagExpendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZShopBagExpendCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NZShopBagExpendViewCell" owner:self options:nil] lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ((int)indexPath.row == 0) {
            cell.topLine.hidden = YES;
        }
        
        cell.delegate = self;
        cell.commodityModel = infoArr[indexPath.row];
        
        return cell;
    } else {
        
        NZShopBagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZShopBagCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NZShopBagViewCell" owner:self options:nil] lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ((int)indexPath.row == 0) {
            cell.topLine.hidden = YES;
        }
        if ((int)indexPath.row == 2) {
            cell.bottonLine.hidden = YES;
        }
        
        cell.delegate = self;
        cell.commodityModel = infoArr[indexPath.row];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    whiteView.backgroundColor = [UIColor whiteColor];
    return whiteView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((int)indexPath.row == currentIndex) {
        return 220.f;
    } else {
        return 120.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark NZShopBagDelegate
- (void)deleteClick:(UITableViewCell *)cell {
    
}

- (void)selectClick:(int)index andState:(BOOL)selectState andPrice:(double)price andNumber:(int)number {
    // 不论是选择还是取消选择，都将结果纪录下来
    NZCommodityModel *commodityModel = infoArr[index];
    commodityModel.selectState = selectState;
    commodityModel.commodityNum = number;
    
    if (selectState) { // 如果是选择
        self.totalPrice += price * number; // 总价要加
        self.settleNumber ++; // 结算个数要加
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        // 判断有没有全选，如有，全选的图标要换已选
        isAllSelect = YES;
        for (int i = 0; i < infoArr.count; i++) {
            NZCommodityModel *commodityModel = infoArr[i];
            if (!commodityModel.selectState) {
                isAllSelect = NO;
                break;
            }
        }
        
        if (isAllSelect) {
            _selectImgV.image = [UIImage imageNamed:@"圆-已选"];
            
        } else {
            _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
        }
        
        [_tableView reloadData];
    } else { // 如果是取消选择
        self.totalPrice -= price * number; // 总价要减
        self.settleNumber --; // 结算个数要减
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
    _totalPriceLab.attributedText = str;
    
}

- (void)editClick:(int)index {
    if (currentIndex < 0) {
        currentIndex = index;
        [_tableView reloadData];
    } else {
        currentIndex = index;
        
        self.totalPrice -= self.editPrice;
        self.editPrice = 0.0;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
        
        [_tableView reloadData];
    }
}

#pragma mark NZShopBagExpendDelegate
- (void)addSelectState:(BOOL)selectState andSinglePrice:(double)price {
    if (selectState) {
        self.editPrice += price;
        self.totalPrice += price;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
    }
    
}

- (void)reduceSelectState:(BOOL)selectState andSinglePrice:(double)price {
    if (selectState) {
        self.editPrice -= price;
        self.totalPrice -= price;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
    }
}

- (void)commitIndex:(int)index andNumber:(int)number andSinglePrice:(double)price {
    
    currentIndex = -1;
    self.editPrice = 0.0;
    
    NZCommodityModel *commodityModel = infoArr[index];
    commodityModel.commodityNum = number;
    
    [_tableView reloadData];
}

- (void)cancelIndex:(int)index andNumber:(int)number andSinglePrice:(double)price {
    currentIndex = -1;
    
    self.totalPrice -= self.editPrice;
    self.editPrice = 0.0;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
    _totalPriceLab.attributedText = str;
    
    [_tableView reloadData];
}

#pragma mark 添加带阴影的子Layer（层）
- (void)addShadowSubLayer {
//    //添加子layer
//    CALayer *shadowLayer = [CALayer layer];
//    shadowLayer.backgroundColor = [UIColor cyanColor].CGColor;
//    shadowLayer.bounds = _settelView.bounds;
//    shadowLayer.position = CGPointZero;
    _settelView.layer.shadowOffset = CGSizeMake(0, 3); //设置阴影的偏移量
    _settelView.layer.shadowRadius = 10.0;  //设置阴影的半径
    _settelView.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
    _settelView.layer.shadowOpacity = 0.9; //设置阴影的不透明度
    
}

#pragma mark 按钮点击事件


- (IBAction)allSelectAction:(UIButton *)sender {
    // 编辑中不可选
    if (currentIndex > -1) {
        return;
    }
    
    isAllSelect = YES;
    // 判断有没有全选
    for (int i = 0; i < infoArr.count; i++) {
        NZCommodityModel *commodityModel = infoArr[i];
        if (!commodityModel.selectState) {
            isAllSelect = NO;
            break;
        }
    }
    
    if (isAllSelect) {
        self.settleNumber = 0;
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        _selectImgV.image = [UIImage imageNamed:@"圆-未选"];
        for (int i = 0; i < infoArr.count; i++) {
            NZCommodityModel *commodityModel = infoArr[i];
            commodityModel.selectState = NO;
        }
        
        self.totalPrice = 0.0;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
    } else {
        self.settleNumber = (int)infoArr.count;
        [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%d)",self.settleNumber] forState:UIControlStateNormal];
        
        _selectImgV.image = [UIImage imageNamed:@"圆-已选"];
        for (int i = 0; i < infoArr.count; i++) {
            NZCommodityModel *commodityModel = infoArr[i];
            
            if (!commodityModel.selectState) {
                self.totalPrice += commodityModel.commodityNum * [commodityModel.commodityPrice doubleValue];
            }
            commodityModel.selectState = YES;
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计￥%.2f",self.totalPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, 1)];
        _totalPriceLab.attributedText = str;
    }
    
    [_tableView reloadData];

}

- (IBAction)settleAction:(UIButton *)sender {
    
}

@end
