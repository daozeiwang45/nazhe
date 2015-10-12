//
//  NZCommodityListViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/27.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZCommodityListViewController.h"
#import "NZCommodityListCell.h"
#import "JSDropDownMenu.h"
#import "NZCommodityDetailController.h"
#import "GoodListModel.h"

#define maskViewTag 100
#define labelViewTag 1000
#define gestureTag 10000
#define animationDuration 0.25

@interface NZCommodityListViewController ()<UITableViewDataSource, UITableViewDelegate, JSDropDownMenuDataSource, JSDropDownMenuDelegate> {
    // 下面6个都是下拉框的数据源
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    
    BOOL checkCommodity;
    int selectCommodityIndex;
    
    BOOL expand;
    
    // 因为是用约束布局，当前打开cell离开显示区域，再回到显示区域，会变形，所以动画移动后，还要改变相应的约束
    NSLayoutConstraint *selectMaskConstraint;
    NSLayoutConstraint *selectLabelConstraint;
    
    
    // 商品列表数据
    GoodListModel *goodListModel;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NZCommodityListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initDropDownMenu];
        [self initTableViewDataSource];
    }
    return self;
}

#pragma mark 初始化下拉列表
- (void)initDropDownMenu {
    _data1 = [NSMutableArray arrayWithObjects:@"价格", @"价格最低", @"价格最高", nil];
    _data2 = [NSMutableArray arrayWithObjects:@"销量", @"销量最高", @"销量最低", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"发布时间", @"最新发布", @"最早发布", nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}

#pragma mark 初始化表示图数据
- (void)initTableViewDataSource {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectCommodityIndex = -1;
    expand = NO;
    [self createNavigationItemTitleViewWithTitle:@"商品列表"];
    [self leftButtonTitle:nil];
    
    _tableView.backgroundColor = UIDefaultBackgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setParameters:(PasspParametersModel *)parameters {
    _parameters = parameters;
    
    NSLog(@"%d",self.parameters.materialID);
    NSLog(@"%d",self.parameters.styleID);
    NSLog(@"%d",self.parameters.varOrBrandID);
    NSLog(@"%d",self.parameters.sortID);
    
    [self requestGoodsListData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return goodListModel.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NZCommodityListCell *cell = [tableView dequeueReusableCellWithIdentifier:NZCommodityListCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NZCommodityListCell" owner:self options:nil] lastObject] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GoodModel *goodModel = goodListModel.goodsList[indexPath.row];
    
    [cell.commodityImageView sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:goodModel.listImg]]];
    if ((int)indexPath.row % 2 == 0) { // 是偶数行
        cell.rightMaskView.tag = maskViewTag + (int)indexPath.row;
        cell.rightLabelView.tag = labelViewTag + (int)indexPath.row;
        cell.leftMaskView.hidden = YES;
        cell.leftLabelView.hidden = YES;
        if ((int)indexPath.row == selectCommodityIndex) {
            // 保持点击后的状态，改变frame或者center都没用，因为是约束布局，只能改变约束
            selectMaskConstraint = cell.rightMaskConstraints;
            selectLabelConstraint = cell.rightLabelConstraints;
            cell.rightMaskConstraints.constant = - cell.rightMaskView.frame.size.width / 2;
            cell.rightMaskView.hidden = YES;
            cell.rightLabelConstraints.constant = 0;
            cell.rightLabelView.hidden = NO;
        } else {
            cell.rightLabelView.hidden = YES;
        }
        // 添加点击收回手势
        UITapGestureRecognizer *rightLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        rightLabTap.numberOfTapsRequired = 1;
        [cell.rightLabelView addGestureRecognizer:rightLabTap];
        
        /*****************   赋值   ***********************/
        [cell.rightLogoImgV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:goodModel.logo]] placeholderImage:defaultImage];
        cell.rightBrandName.text = goodModel.shopName;
        cell.rightEnglishName.text = goodModel.englishName;
        cell.rightGoodName.text = goodModel.goodsName;
        cell.rightVerticalLab.text = goodModel.goodsName;
        
    } else { // 是奇数行
        cell.leftMaskView.tag = maskViewTag + (int)indexPath.row;
        cell.leftLabelView.tag = labelViewTag + (int)indexPath.row;
        cell.rightMaskView.hidden = YES;
        cell.rightLabelView.hidden = YES;
        if ((int)indexPath.row == selectCommodityIndex) {
            // 保持点击后的状态，改变frame或者center都没用，因为是约束布局，只能改变约束
            selectMaskConstraint = cell.leftMaskConstraints;
            selectLabelConstraint = cell.leftLabelConstraints;
            cell.leftMaskConstraints.constant = - cell.leftMaskView.frame.size.width / 2;
            cell.leftMaskView.hidden = YES;
            cell.leftLabelConstraints.constant = 0;
            cell.leftLabelView.hidden = NO;
        } else {
            cell.leftLabelView.hidden = YES;
        }
        // 添加点击收回手势
        UITapGestureRecognizer *leftLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        leftLabTap.numberOfTapsRequired = 1;
        [cell.leftLabelView addGestureRecognizer:leftLabTap];
        
        /*****************   赋值   ***********************/
        [cell.leftLogoImgV sd_setImageWithURL:[NSURL URLWithString:[NZGlobal GetImgBaseURL:goodModel.logo]] placeholderImage:defaultImage];
        cell.leftBrandName.text = goodModel.shopName;
        cell.leftEnglishName.text = goodModel.englishName;
        cell.leftGoodName.text = goodModel.goodsName;
        cell.leftVerticalLab.text = goodModel.goodsName;
    }
    
    
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodModel *goodModel = goodListModel.goodsList[indexPath.row];
    
    if (goodModel.isBig) {
        return 253.f;
    } else {
        return 175.f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (expand) {
        if ((int)indexPath.row == selectCommodityIndex) {
            GoodModel *goodModel = goodListModel.goodsList[indexPath.row];
            // 跳转商品详情页面
            NZCommodityDetailController *commodityDetailVCTR = [[NZCommodityDetailController alloc] init];
            commodityDetailVCTR.goodID = goodModel.goodID;
            [self.navigationController pushViewController:commodityDetailVCTR animated:YES];
        } else {
            UIView *lastMaskView = [_tableView viewWithTag:maskViewTag + selectCommodityIndex];
            UIView *lastLabelView = [_tableView viewWithTag:labelViewTag + selectCommodityIndex];
            
            UIView *maskView = [_tableView viewWithTag:maskViewTag + (int)indexPath.row];
            UIView *labelView = [_tableView viewWithTag:labelViewTag + (int)indexPath.row];
            
            if ((int)indexPath.row % 2 == 0) { // 是偶数行
                [UIView animateWithDuration:animationDuration animations:^{
                    if (selectCommodityIndex % 2 == 0) {
                        lastLabelView.center = CGPointMake(lastMaskView.frame.size.width + 15, lastMaskView.frame.size.height / 2);
                    } else {
                        lastLabelView.center = CGPointMake( -15, lastMaskView.frame.size.height / 2);
                    }
                    maskView.center = CGPointMake(maskView.frame.size.width, maskView.frame.size.height / 2);
                } completion:^(BOOL finished) {
                    labelView.hidden = NO;
                    maskView.hidden = YES;
                    lastMaskView.hidden = NO;
                    lastLabelView.hidden = YES;
                    [UIView animateWithDuration:animationDuration animations:^{
                        lastMaskView.center = CGPointMake(lastMaskView.frame.size.width / 2, lastMaskView.frame.size.height / 2);
                        labelView.center = CGPointMake(maskView.frame.size.width - 25, maskView.frame.size.height / 2);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            } else { // 是奇数行
                [UIView animateWithDuration:animationDuration animations:^{
                    if (selectCommodityIndex % 2 == 0) {
                        lastLabelView.center = CGPointMake(lastMaskView.frame.size.width + 15, lastMaskView.frame.size.height / 2);
                    } else {
                        lastLabelView.center = CGPointMake( -15, lastMaskView.frame.size.height / 2);
                    }
                    maskView.center = CGPointMake(0, maskView.frame.size.height / 2);
                } completion:^(BOOL finished) {
                    labelView.hidden = NO;
                    maskView.hidden = YES;
                    lastMaskView.hidden = NO;
                    lastLabelView.hidden = YES;
                    [UIView animateWithDuration:animationDuration animations:^{
                        lastMaskView.center = CGPointMake(lastMaskView.frame.size.width / 2, lastMaskView.frame.size.height / 2);
                        labelView.center = CGPointMake(25, maskView.frame.size.height / 2);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }
            selectCommodityIndex = (int)indexPath.row;
        }
        
    } else {
        expand = YES;
        selectCommodityIndex = (int)indexPath.row;
        UIView *maskView = [_tableView viewWithTag:maskViewTag + (int)indexPath.row];
        UIView *labelView = [_tableView viewWithTag:labelViewTag + (int)indexPath.row];
        if ((int)indexPath.row % 2 == 0) { // 是偶数行
            [UIView animateWithDuration:animationDuration animations:^{
                maskView.center = CGPointMake(maskView.frame.size.width, maskView.frame.size.height / 2);
            } completion:^(BOOL finished) {
                labelView.hidden = NO;
                maskView.hidden = YES;
                [UIView animateWithDuration:animationDuration animations:^{
                    labelView.center = CGPointMake(maskView.frame.size.width - 25, maskView.frame.size.height / 2);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        } else {
            [UIView animateWithDuration:animationDuration animations:^{
                maskView.center = CGPointMake(0, maskView.frame.size.height / 2);
            } completion:^(BOOL finished) {
                labelView.hidden = NO;
                maskView.hidden = YES;
                [UIView animateWithDuration:animationDuration animations:^{
                    labelView.center = CGPointMake(25, maskView.frame.size.height / 2);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }
    }
    
}

#pragma mark JSDropDownMenuDatasource
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return _currentData3Index;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        
        return _data1.count;
        
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _data1[0];
            break;
        case 1: return _data2[0];
            break;
        case 2: return _data3[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return _data1[indexPath.row];
        
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        return _data3[indexPath.row];
    }
}

#pragma mark JSDropDownMenuDelegate
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        _currentData1Index = indexPath.row;
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}

#pragma mark 左右label点击收回事件
- (void)labelClick:(UIGestureRecognizer *)sender {
    expand = NO;
    selectCommodityIndex = -1;
    int index = (int)[sender view].tag - labelViewTag;
    UIView *maskView = [_tableView viewWithTag:maskViewTag + index];
    UIView *labelView = [_tableView viewWithTag:labelViewTag + index];
    if (index % 2 == 0) { // 是偶数行
        // 解决改变约束后的bug
        selectMaskConstraint.constant = 0.f;
        selectLabelConstraint.constant = -40.f;
        maskView.center = CGPointMake(maskView.frame.size.width, maskView.frame.size.height / 2);
        labelView.center = CGPointMake(maskView.frame.size.width - 25, maskView.frame.size.height / 2);
        
        [UIView animateWithDuration:animationDuration animations:^{
            labelView.center = CGPointMake(maskView.frame.size.width + 15, maskView.frame.size.height / 2);
        } completion:^(BOOL finished) {
            labelView.hidden = YES;
            maskView.hidden = NO;
            [UIView animateWithDuration:animationDuration animations:^{
                maskView.center = CGPointMake(maskView.frame.size.width / 2, maskView.frame.size.height / 2);
            } completion:^(BOOL finished) {
                
            }];
        }];
    } else {
        // 解决改变约束后的bug
        selectMaskConstraint.constant = 0.f;
        selectLabelConstraint.constant = -40.f;
        maskView.center = CGPointMake(0, maskView.frame.size.height / 2);
        labelView.center = CGPointMake(25, maskView.frame.size.height / 2);
        
        [UIView animateWithDuration:animationDuration animations:^{
            labelView.center = CGPointMake( -15, maskView.frame.size.height / 2);
        } completion:^(BOOL finished) {
            labelView.hidden = YES;
            maskView.hidden = NO;
            [UIView animateWithDuration:animationDuration animations:^{
                maskView.center = CGPointMake(maskView.frame.size.width / 2, maskView.frame.size.height / 2);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark 请求商品列表数据
- (void)requestGoodsListData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NSDictionary *parameters;
    
    if (_parameters.type == enumtMaterialOrStyleType_Material) {
        parameters = @{
                        @"styleId":[NSNumber numberWithInt:_parameters.styleID],
                        @"categoryId":[NSNumber numberWithInt:_parameters.materialID],
                        @"varietyId":[NSNumber numberWithInt:_parameters.varOrBrandID],
                        @"page_no":[NSNumber numberWithInt:1],
                        @"orderby":[NSNumber numberWithInt:_parameters.sortID]
                      } ;
    } else {
        parameters = @{
                       @"styleId":[NSNumber numberWithInt:_parameters.styleID],
                       @"categoryId":[NSNumber numberWithInt:_parameters.materialID],
                       @"shopId":[NSNumber numberWithInt:_parameters.varOrBrandID],
                       @"page_no":[NSNumber numberWithInt:1],
                       @"orderby":[NSNumber numberWithInt:_parameters.sortID]
                       } ;
    }
    
    [handler postURLStr:webGoodsList postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
         
         if( error )
         {
             [wSelf.view makeToast:@"网络错误"];
             return ;
         }
         if( retInfo == nil )
         {
             [wSelf.view makeToast:@"网络错误"];
             return ;
         }
         
         BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
         
         if( state )
         {
             goodListModel = [GoodListModel objectWithKeyValues:retInfo[@"result"]];
             
             for (int i=0; i<goodListModel.goodsList.count; i++) {
                 GoodModel *goodModel = goodListModel.goodsList[i];
                 goodModel.goodID = [retInfo[@"result"][@"goodsList"][i][@"id"] intValue];
             }
             
             [_tableView reloadData];
             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

@end
