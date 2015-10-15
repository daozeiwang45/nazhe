//
//  NZOrderSelectedViewController.m
//  nazhe
//
//  Created by WSGG on 15/9/28.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZOrderSelectedViewController.h"
#import "NZOrderConfirmViewController.h"
#import "GoodParametersModel.h"
#import "NZShoppingBagViewController.h"

//选择框高度
#define Height1 25
//间距
#define Height2 10
//离边的距离
#define Width1 25
//选择框为了好看预留长度
#define Width2 30
//间距
#define Width3 10

#define Width4 50

@interface NZOrderSelectedViewController (){
    
    CGFloat selectedViewHight;//选择参数视图高度

}

//页面数据模型
@property (nonatomic,strong)GoodParametersModel *goodParametersModel;
//基本参数
@property (nonatomic,strong)ParametersModel *parametersModel;
//重量
@property (nonatomic,strong)NSMutableArray *weightListModelArry;
//尺寸
@property (nonatomic,strong)NSMutableArray *sizeListModelArry;
//等级
@property (nonatomic,strong)NSMutableArray *gradeListModelArry;
//硬度
@property (nonatomic,strong)NSMutableArray *hardnessListModelArry;
//镶嵌
@property (nonatomic,strong)NSMutableArray *fillInListModelArry;
//配饰
@property (nonatomic,strong)NSMutableArray *accessoriesListModelArry;
//颜色
@property (nonatomic,strong)NSMutableArray *colorListModelArry;
//包装
@property (nonatomic,strong)NSMutableArray *packListModelArry;

//----------选中各个模块中的第几个参数
//重量
@property (nonatomic,assign)int weightListIndex;
//尺寸
@property (nonatomic,assign)int sizeListModelIndex;
//等级
@property (nonatomic,assign)int gradeListModelIndex;
//硬度
@property (nonatomic,assign)int hardnessListModelIndex;
//镶嵌
@property (nonatomic,assign)int fillInListModelIndex;
//配饰
@property (nonatomic,assign)int accessoriesListModelIndex;
//配饰
@property (nonatomic,assign)int colorListModelIndex;
//包装
@property (nonatomic,assign)int packListModelIndex;


@property (nonatomic, assign) float goodPrice;//价格
@property (nonatomic, assign) int goodCount;//库存
@property (nonatomic, assign) int number;//购买数量
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float totalPrice;

@end

@implementation NZOrderSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"参数选择"];
    [self leftButtonTitle:nil];
    
}
-(void)creteInitValue{
    
    self.expressPrice = 10;
    selectedViewHight = 0;
    self.weightListIndex = -1;
    self.sizeListModelIndex = -1;
    self.gradeListModelIndex = -1;
    self.hardnessListModelIndex = -1;
    self.fillInListModelIndex = -1;
    self.accessoriesListModelIndex = -1;
    self.colorListModelIndex = -1;
    self.packListModelIndex = -1;
}
-(void)initView{
    
    NSLog(@"----------%i",self.goodID);
    self.number = 1;
    
    self.orderSelectedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderSelectedTable.delegate = self;
    self.orderSelectedTable.dataSource = self;
    self.selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    self.selectedView.backgroundColor = [UIColor whiteColor];
    
    self.addShopButton.backgroundColor = tintOrangeColor;
    self.addShopButton.layer.cornerRadius = 2;
    self.addShopButton.layer.masksToBounds = YES;
    self.buyButton.backgroundColor = darkRedColor;
    self.buyButton.layer.cornerRadius = 2;
    self.buyButton.layer.masksToBounds = YES;
    
    
    //页面赋值
    self.numLab.text = [NSString stringWithFormat:@"%d",self.number];
    self.goodNameLab.text = self.parametersModel.name;
    self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
    self.goodNumLab.text = [NSString stringWithFormat:@"库存%i件",self.goodCount];
    [self createSelectedView];
    
    [self.orderSelectedTable reloadData];
}
#pragma mark 创建选择参数视图
-(void)createSelectedView{
    
    //颜色参数选择-----------------------------------------------
    if (self.colorListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *colorLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, 0, ScreenWidth-Width1*2, Width1)];
        colorLab.text = @"颜色分类";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:colorLab];
        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.colorListModelArry.count; i++) {
            
            ColorListModel *colorListModel = self.colorListModelArry[i];
            CGFloat width = [self calculateTextSize:colorListModel.name].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                colorButton.tag = 100+i;
                [colorButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [colorButton setTitle:colorListModel.name forState:UIControlStateNormal];
                colorButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                if (colorListModel.count == 0) {
                    
                    colorButton.tintColor = [UIColor lightGrayColor];

                }else{
                    
                    colorButton.tintColor = [UIColor darkTextColor];
                    [colorButton addTarget:self action:@selector(colorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:colorButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                colorButton.tag = 100+i;
                [colorButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [colorButton setTitle:colorListModel.name forState:UIControlStateNormal];
                colorButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                if (colorListModel.count == 0) {
                    
                    colorButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    colorButton.tintColor = [UIColor darkTextColor];
                    [colorButton addTarget:self action:@selector(colorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:colorButton];
                colorWidth += (width+Width2)+Width3;

            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
        //添加一条分割线
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, 1)];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        [self.selectedView addSubview:lineLab];
        selectedViewHight += 1;
    }
    
    
    //规格参数选择-----------------------------------------------
    if (self.sizeListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *sizeLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, Width1)];
        sizeLab.text = @"规格分类";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:sizeLab];
        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.sizeListModelArry.count; i++) {
            
            SizeListModel *sizeListModel = self.sizeListModelArry[i];
            CGFloat width = [self calculateTextSize:sizeListModel.name].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *sizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                sizeButton.tag = 200+i;
                [sizeButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [sizeButton setTitle:sizeListModel.name forState:UIControlStateNormal];
                sizeButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];

                if (sizeListModel.count == 0) {
                    
                    sizeButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    sizeButton.tintColor = [UIColor darkTextColor];
                    [sizeButton addTarget:self action:@selector(sizeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:sizeButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *sizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                sizeButton.tag = 200+i;
                [sizeButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [sizeButton setTitle:sizeListModel.name forState:UIControlStateNormal];
                sizeButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                if (sizeListModel.count == 0) {
                    
                    sizeButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    sizeButton.tintColor = [UIColor darkTextColor];
                    [sizeButton addTarget:self action:@selector(sizeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:sizeButton];
                colorWidth += (width+Width2)+Width3;
                
            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
        //添加一条分割线
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, 1)];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        [self.selectedView addSubview:lineLab];
        selectedViewHight += 1;
    }

    //镶嵌参数选择-----------------------------------------------
    if (self.fillInListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *fillInLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, Width1)];
        fillInLab.text = @"镶嵌分类";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:fillInLab];
        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.fillInListModelArry.count; i++) {
            
            FillInListModel *fillInListModel = self.fillInListModelArry[i];
            CGFloat width = [self calculateTextSize:fillInListModel.name].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *fillInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                fillInButton.tag = 300+i;
                [fillInButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [fillInButton setTitle:fillInListModel.name forState:UIControlStateNormal];
                fillInButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (fillInListModel.count == 0) {
                    
                    fillInButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    fillInButton.tintColor = [UIColor darkTextColor];
                    [fillInButton addTarget:self action:@selector(fillInButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:fillInButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *fillInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                fillInButton.tag = 300+i;
                [fillInButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [fillInButton setTitle:fillInListModel.name forState:UIControlStateNormal];
                fillInButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (fillInListModel.count == 0) {
                    
                    fillInButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    fillInButton.tintColor = [UIColor darkTextColor];
                    [fillInButton addTarget:self action:@selector(fillInButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:fillInButton];
                colorWidth += (width+Width2)+Width3;

                
            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
        //添加一条分割线
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, 1)];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        [self.selectedView addSubview:lineLab];
        selectedViewHight += 1;
    }

    //重量参数选择-----------------------------------------------
    if (self.weightListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *weightLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, Width1)];
        weightLab.text = @"重量分类";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:weightLab];
        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.weightListModelArry.count; i++) {
            
            WeightListModel *weightListModel = self.weightListModelArry[i];
            CGFloat width = [self calculateTextSize:weightListModel.name].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *weightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                weightButton.tag = 400+i;
                [weightButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [weightButton setTitle:weightListModel.name forState:UIControlStateNormal];
                weightButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (weightListModel.count == 0) {
                    
                    weightButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    weightButton.tintColor = [UIColor darkTextColor];
                    [weightButton addTarget:self action:@selector(weightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:weightButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *weightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                weightButton.tag = 400+i;
                [weightButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [weightButton setTitle:weightListModel.name forState:UIControlStateNormal];
                weightButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (weightListModel.count == 0) {
                    
                    weightButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    weightButton.tintColor = [UIColor darkTextColor];
                    [weightButton addTarget:self action:@selector(weightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:weightButton];
                colorWidth += (width+Width2)+Width3;
            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
        //添加一条分割线
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, 1)];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        [self.selectedView addSubview:lineLab];
        selectedViewHight += 1;
    }

    //等级参数选择-----------------------------------------------
    if (self.gradeListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *gradeLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, Width1)];
        gradeLab.text = @"等级分类";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:gradeLab];
        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.gradeListModelArry.count; i++) {
            
            GradeListModel *gradeListModel = self.gradeListModelArry[i];
            CGFloat width = [self calculateTextSize:gradeListModel.name].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *gradeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                gradeButton.tag = 500+i;
                [gradeButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [gradeButton setTitle:gradeListModel.name forState:UIControlStateNormal];
                gradeButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (gradeListModel.count == 0) {
                    
                    gradeButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    gradeButton.tintColor = [UIColor darkTextColor];
                    [gradeButton addTarget:self action:@selector(gradeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:gradeButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *gradeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                gradeButton.tag = 500+i;
                [gradeButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [gradeButton setTitle:gradeListModel.name forState:UIControlStateNormal];
                gradeButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (gradeListModel.count == 0) {
                    
                    gradeButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    gradeButton.tintColor = [UIColor darkTextColor];
                    [gradeButton addTarget:self action:@selector(gradeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:gradeButton];
                colorWidth += (width+Width2)+Width3;
            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
        //添加一条分割线
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, 1)];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        [self.selectedView addSubview:lineLab];
        selectedViewHight += 1;
    }

    //硬度选择-----------------------------------------------
    if (self.hardnessListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *hardnessLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, Width1)];
        hardnessLab.text = @"硬度分类";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:hardnessLab];
        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.hardnessListModelArry.count; i++) {
            
            HardnessListModel *hardnessListModel = self.hardnessListModelArry[i];
            CGFloat width = [self calculateTextSize:hardnessListModel.name].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *hardnessButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                hardnessButton.tag = 600+i;
                [hardnessButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [hardnessButton setTitle:hardnessListModel.name forState:UIControlStateNormal];
                hardnessButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (hardnessListModel.count == 0) {
                    
                    hardnessButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    hardnessButton.tintColor = [UIColor darkTextColor];
                    [hardnessButton addTarget:self action:@selector(hardnessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:hardnessButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *hardnessButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                hardnessButton.tag = 600+i;
                [hardnessButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [hardnessButton setTitle:hardnessListModel.name forState:UIControlStateNormal];
                hardnessButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (hardnessListModel.count == 0) {
                    
                    hardnessButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    hardnessButton.tintColor = [UIColor darkTextColor];
                    [hardnessButton addTarget:self action:@selector(hardnessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:hardnessButton];
                colorWidth += (width+Width2)+Width3;
                
            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
        //添加一条分割线
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, 1)];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        [self.selectedView addSubview:lineLab];
        selectedViewHight += 1;
    }

    //配饰选择-----------------------------------------------
    if (self.accessoriesListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *accessoriesLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, Width1)];
        accessoriesLab.text = @"配饰分类";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:accessoriesLab];
        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.accessoriesListModelArry.count; i++) {
            
            AccessoriesListModel *accessoriesListModel = self.accessoriesListModelArry[i];
            CGFloat width = [self calculateTextSize:accessoriesListModel.name].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *accessoriesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                accessoriesButton.tag = 700+i;
                [accessoriesButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [accessoriesButton setTitle:accessoriesListModel.name forState:UIControlStateNormal];
                accessoriesButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (accessoriesListModel.count == 0) {
                    
                    accessoriesButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    accessoriesButton.tintColor = [UIColor darkTextColor];
                    [accessoriesButton addTarget:self action:@selector(accessoriesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:accessoriesButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *accessoriesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                accessoriesButton.tag = 700+i;
                [accessoriesButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [accessoriesButton setTitle:accessoriesListModel.name forState:UIControlStateNormal];
                accessoriesButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                if (accessoriesListModel.count == 0) {
                    
                    accessoriesButton.tintColor = [UIColor lightGrayColor];
                    
                }else{
                    
                    accessoriesButton.tintColor = [UIColor darkTextColor];
                    [accessoriesButton addTarget:self action:@selector(accessoriesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.selectedView addSubview:accessoriesButton];
                colorWidth += (width+Width2)+Width3;
            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
        //添加一条分割线
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, 1)];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        [self.selectedView addSubview:lineLab];
        selectedViewHight += 1;
    }
    
    //包装选择-----------------------------------------------
    if (self.packListModelArry.count != 0) {
        
        //创建一个颜色的Lable
        UILabel *packLab = [[UILabel alloc]initWithFrame:CGRectMake(Width1, selectedViewHight, ScreenWidth-Width1*2, Width1)];
        packLab.text = @"包装";
        //计算高度
        selectedViewHight +=Height1;
        
        [self.selectedView addSubview:packLab];

        
        CGFloat colorWidth = Width1;
        for (int i=0; i< self.packListModelArry.count; i++) {
            
            CGFloat width = [self calculateTextSize:self.packListModelArry[i]].width;
            //判断是否要换行创建
            if (colorWidth+(width+Width2) < ScreenWidth-Width1*2) {
                
                //创建按钮
                UIButton *packButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                packButton.tag = 800+i;
                [packButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [packButton setTitle:self.packListModelArry[i] forState:UIControlStateNormal];
                packButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                packButton.tintColor = [UIColor darkTextColor];
                [packButton addTarget:self action:@selector(packButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.selectedView addSubview:packButton];
                colorWidth += (width+Width2)+Width3;
                
            }else{
                
                colorWidth = Width1;
                //计算高度
                selectedViewHight += Height1+Height2;
                
                //创建按钮
                UIButton *packButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                packButton.tag = 800+i;
                [packButton setFrame:CGRectMake(colorWidth, selectedViewHight, width+Width2, Height1)];
                [packButton setTitle:self.packListModelArry[i] forState:UIControlStateNormal];
                packButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
                
                packButton.tintColor = [UIColor darkTextColor];
                [packButton addTarget:self action:@selector(packButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.selectedView addSubview:packButton];
                colorWidth += (width+Width2)+Width3;

            }
            
        }
        
        //计算高度
        selectedViewHight += Height1+Height2;
    }

    
}

#pragma mark 颜色选择方法
-(void)colorButtonAction:(UIButton *)sender{
    
    //self.colorListModelIndex = (int)sender.tag - 100;
    ColorListModel *colorListModel = self.colorListModelArry[sender.tag-100];
    NSLog(@"-----------%li",(long)sender.tag);
    if (self.colorListModelIndex != sender.tag-100) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.colorListModelIndex+100];
        
        if (self.colorListModelIndex != -1) {
            ColorListModel *colorListModelOld = self.colorListModelArry[self.colorListModelIndex];
            //改变价格和库存
            self.goodPrice -= colorListModelOld.price;
            self.goodPrice += colorListModel.price;
            
        }else{
            
            self.goodPrice += colorListModel.price;
        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.colorListModelIndex = (int)sender.tag - 100;
        
        //改变价格和库存
        self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
    
}
#pragma mark 选择规格方法
-(void)sizeButtonAction:(UIButton *)sender{
    
    SizeListModel *sizeListModel = self.sizeListModelArry[sender.tag-200];
    NSLog(@"----222-------%li",(long)sender.tag);
    if (self.sizeListModelIndex != sender.tag-200) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.sizeListModelIndex+200];
        
        if (self.sizeListModelIndex != -1) {
            SizeListModel *sizeListModelOld = self.sizeListModelArry[self.sizeListModelIndex];
            //改变价格和库存
            self.goodPrice -= sizeListModelOld.price;
            self.goodPrice += sizeListModel.price;
            
        }else{
            
            self.goodPrice += sizeListModel.price;
        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.sizeListModelIndex = (int)sender.tag - 200;
        
        //改变价格和库存
        self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
}

#pragma mark 镶嵌参数选择方法
-(void)fillInButtonAction:(UIButton *)sender{
    
    FillInListModel *fillInListModel = self.fillInListModelArry[sender.tag-300];
    NSLog(@"----222-------%li",(long)sender.tag);
    if (self.fillInListModelIndex != sender.tag-300) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.sizeListModelIndex+300];
        
        if (self.fillInListModelIndex != -1) {
            FillInListModel *fillInListModelOld = self.fillInListModelArry[self.fillInListModelIndex];
            //改变价格和库存
            self.goodPrice -= fillInListModelOld.price;
            self.goodPrice += fillInListModel.price;
            
        }else{
            
            self.goodPrice += fillInListModel.price;
        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.fillInListModelIndex = (int)sender.tag - 300;
        
        //改变价格和库存
        self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
}

#pragma mark 选择重量方法
-(void)weightButtonAction:(UIButton *)sender{
    
    WeightListModel *weightListModel = self.weightListModelArry[sender.tag-400];
    NSLog(@"----222-------%li",(long)sender.tag);
    if (self.weightListIndex != sender.tag-400) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.weightListIndex+400];
        
        if (self.weightListIndex != -1) {
            WeightListModel *weightListModelOld = self.weightListModelArry[self.weightListIndex];
            //改变价格和库存
            self.goodPrice -= weightListModelOld.price;
            self.goodPrice += weightListModel.price;
            
        }else{
            
            self.goodPrice += weightListModel.price;
        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.weightListIndex = (int)sender.tag - 400;
        
        //改变价格和库存
        self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
}

#pragma mark 选择等级方法
-(void)gradeButtonAction:(UIButton *)sender{
    
    GradeListModel *gradeListModel = self.gradeListModelArry[sender.tag-500];
    NSLog(@"----222-------%li",(long)sender.tag);
    if (self.gradeListModelIndex != sender.tag-500) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.gradeListModelIndex+500];
        
        if (self.gradeListModelIndex != -1) {
            GradeListModel *gradeListModelOld = self.gradeListModelArry[self.gradeListModelIndex];
            //改变价格和库存
            self.goodPrice -= gradeListModelOld.price;
            self.goodPrice += gradeListModel.price;
            
        }else{
            
            self.goodPrice += gradeListModel.price;
        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.gradeListModelIndex = (int)sender.tag - 500;
        
        //改变价格和库存
        self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
}

#pragma mark 选择硬度方法
-(void)hardnessButtonAction:(UIButton *)sender{
    
    HardnessListModel *hardnessListModel = self.hardnessListModelArry[sender.tag-600];
    NSLog(@"----222-------%li",(long)sender.tag);
    if (self.hardnessListModelIndex != sender.tag-600) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.hardnessListModelIndex+600];
        
        if (self.hardnessListModelIndex != -1) {
            HardnessListModel *hardnessListModelOld = self.hardnessListModelArry[self.hardnessListModelIndex];
            //改变价格和库存
            self.goodPrice -= hardnessListModelOld.price;
            self.goodPrice += hardnessListModel.price;
            
        }else{
            
            self.goodPrice += hardnessListModel.price;
        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.hardnessListModelIndex = (int)sender.tag - 600;
        
        //改变价格和库存
        self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
}

#pragma mark 选择配饰方法
-(void)accessoriesButtonAction:(UIButton *)sender{
    
    AccessoriesListModel *accessoriesListModel = self.accessoriesListModelArry[sender.tag-700];
    NSLog(@"----222-------%li",(long)sender.tag);
    if (self.accessoriesListModelIndex != sender.tag-700) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.accessoriesListModelIndex+700];
        
        if (self.accessoriesListModelIndex != -1) {
            AccessoriesListModel *accessoriesListModelOld = self.accessoriesListModelArry[self.accessoriesListModelIndex];
            //改变价格和库存
            self.goodPrice -= accessoriesListModelOld.price;
            self.goodPrice += accessoriesListModel.price;
            
        }else{
            
            self.goodPrice += accessoriesListModel.price;
        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.accessoriesListModelIndex = (int)sender.tag - 700;
        
        //改变价格和库存
        self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
}
#pragma mark 选择包装方法
-(void)packButtonAction:(UIButton *)sender{
    
    //AccessoriesListModel *accessoriesListModel = self.accessoriesListModelArry[sender.tag-700];
    NSLog(@"----222-------%li",(long)sender.tag);
    if (self.packListModelIndex != sender.tag-800) {
        
        sender.backgroundColor = darkRedColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *oldButton = (UIButton *)[self.selectedView viewWithTag:self.packListModelIndex+800];
//        
//        if (self.packListModelIndex != -1) {
//            AccessoriesListModel *accessoriesListModelOld = self.accessoriesListModelArry[self.accessoriesListModelIndex];
//            //改变价格和库存
//            //self.goodPrice -= accessoriesListModelOld.price;
//            //self.goodPrice += accessoriesListModel.price;
//            
//        }else{
//            
//            self.goodPrice += accessoriesListModel.price;
//        }
        
        oldButton.backgroundColor = [UIColor colorWithRed:0.935 green:0.921 blue:0.932 alpha:1.000];
        [oldButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.packListModelIndex = (int)sender.tag - 800;
        
        //改变价格和库存
        //self.goodPriceLab.text = [NSString stringWithFormat:@"￥%f",self.goodPrice];
        
    }
}


-(void)loadData{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    // NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 
                                 @"goodsId":[NSNumber numberWithInt:53]
                                 
                                 };
    NSString *webGoodParameters = @"Goods/Take";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
            
             self.weightListModelArry   = [NSMutableArray new];
             self.sizeListModelArry     = [NSMutableArray new];
             self.gradeListModelArry    = [NSMutableArray new];
             self.hardnessListModelArry = [NSMutableArray new];
             self.fillInListModelArry   = [NSMutableArray new];
             self.accessoriesListModelArry = [NSMutableArray new];
             self.packListModelArry        = [NSMutableArray new];
             
             self.goodParametersModel = [GoodParametersModel objectWithKeyValues:retInfo];
             //基本数据赋值
             self.parametersModel = self.goodParametersModel.goodsInfo[0];
             self.goodPrice = self.parametersModel.marketPrice;
             self.goodCount = self.parametersModel.count;
             
             self.weightListModelArry = self.goodParametersModel.weightList;
             self.sizeListModelArry = self.goodParametersModel.sizeList;
             self.gradeListModelArry = self.goodParametersModel.gradeList;
             self.hardnessListModelArry = self.goodParametersModel.hardnessList;
             self.fillInListModelArry = self.goodParametersModel.fillInList;
             self.accessoriesListModelArry = self.goodParametersModel.accessoriesList;
             self.colorListModelArry = self.goodParametersModel.colorList;
             NSArray *packArry = [NSArray arrayWithObjects:@"礼盒包装",@"普通包装", nil];
             [self.packListModelArry addObjectsFromArray:packArry];
             
             //数据请求完-------初始化页面
             [self initView];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
  
}

-(void)addShopCarLoadData{
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    // NZUser *user = [NZUserManager sharedObject].user;
    
    NSDictionary *parameters = @{
                                 @"userId":[NSNumber numberWithInt:6],
                                 @"goodsId":[NSNumber numberWithInt:53],
                                 @"count":[NSNumber numberWithInt:self.number],
                                 @"totalPrice":[NSNumber numberWithFloat:self.goodPrice*self.number],
                                 @"expressPrice":[NSNumber numberWithFloat:self.expressPrice],
                                 @"size":self.sizeStr,
                                 @"weight":self.weightStr,
                                 @"grade":self.gradeStr,
                                 @"color":self.colorStr,
                                 @"hardness":self.hardnessStr,
                                 @"fillIn":self.fillInStr,
                                 @"accessories":self.accessoriesStr,
                                 @"pack":self.packStr,
                                 
                                 };
    NSString *webGoodParameters = @"Goods/AddShoppingBags";
    
    [handler postURLStr:webGoodParameters postDic:parameters
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
             NSLog(@"-----------加入购物车成功--------");
             NSString *info = @"加入购物车成功";
             UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             [alertV show];

         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;

}

-(CGSize)calculateTextSize:(NSString *)str{
    
    NSString *moneyStr = str;
    UIFont *contentFont = [UIFont systemFontOfSize:20.f];
    NSDictionary *attribute = @{NSFontAttributeName:contentFont};
    CGSize limitSize = CGSizeMake(MAXFLOAT, 25);
    // 计算尺寸
    CGSize contentSize = [moneyStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return contentSize;
}

#pragma mark - 表格的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    
    return cell;
}


//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//下面是设置一些头部高度什么的
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return selectedViewHight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.selectedView;
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (IBAction)buyAction:(UIButton *)sender {
    
    if ([self checkGoodValue]) {
        
        //先给选好的参数赋值
        [self addGoodBaseValue];
        
        NZOrderConfirmViewController *orderConfirmViewCtr = [[NZOrderConfirmViewController alloc] initWithNibName:@"NZOrderConfirmViewController" bundle:nil];
        
        //给订单基本信息赋值
        orderConfirmViewCtr.orderGoodImgView = self.parametersModel.img;
        orderConfirmViewCtr.orderGoodName = self.parametersModel.name;
        orderConfirmViewCtr.orderGoodNum = [NSString stringWithFormat:@"×%i",self.number];
        orderConfirmViewCtr.orderGoodPrice = [NSString stringWithFormat:@"￥%.2f",self.goodPrice];
        orderConfirmViewCtr.orderGoodAllNum = [NSString stringWithFormat:@"共%i件商品",self.number];
        orderConfirmViewCtr.orderGoodAllPrice = [NSString stringWithFormat:@"￥%.2f",self.goodPrice*self.number];
        
        //给订单产品参数赋值
        orderConfirmViewCtr.goodPayPrice = self.goodPrice*self.number;
        orderConfirmViewCtr.goodPayNum = self.number;
        //给选择好的产品参数赋值
        orderConfirmViewCtr.weightStr = self.weightStr;
        orderConfirmViewCtr.sizeStr = self.sizeStr;
        orderConfirmViewCtr.gradeStr = self.gradeStr;
        orderConfirmViewCtr.hardnessStr = self.hardnessStr;
        orderConfirmViewCtr.fillInStr = self.fillInStr;
        orderConfirmViewCtr.accessoriesStr = self.accessoriesStr;
        orderConfirmViewCtr.colorStr = self.colorStr;
        orderConfirmViewCtr.packStr = self.packStr;
        
        [self.navigationController pushViewController:orderConfirmViewCtr animated:YES];

    }
}

//加入购物车-----
- (IBAction)addShopCarAction:(UIButton *)sender {
    
    if ([self checkGoodValue]) {
        
        //先给选好的参数赋值
        [self addGoodBaseValue];
        //加入购物车网络请求---
        [self addShopCarLoadData];
    }
    
//     NZShoppingBagViewController *shoppingBagViewCtr = [[NZShoppingBagViewController alloc] initWithNibName:@"NZShoppingBagViewController" bundle:nil];
//    [self.navigationController pushViewController:shoppingBagViewCtr animated:YES];
    
}
- (IBAction)addNumberAction:(UIButton *)sender {
    
    self.number += 1;
    self.numLab.text = [NSString stringWithFormat:@"%d",self.number];
    
    self.totalPrice = self.price * self.number;
//    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
//    
//    [self.delegate addSelectState:self.selectState andSinglePrice:self.price];
}
- (IBAction)reduceNumberAction:(UIButton *)sender {
    
    if (self.number > 1) {
        self.number -= 1;
        self.numLab.text = [NSString stringWithFormat:@"%d",self.number];
        
        self.totalPrice = self.price * self.number;
//        self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
//        
//        [self.delegate reduceSelectState:self.selectState andSinglePrice:self.price];
    }

}

//给选择好的产品参数赋值
-(void)addGoodBaseValue{

    if (self.weightListIndex != -1) {
        
        WeightListModel *weightListModel  = self.weightListModelArry[self.weightListIndex];
        self.weightStr = weightListModel.name;
        
    }else{
        
        self.weightStr = @"无";
    }
    
    if (self.sizeListModelIndex != -1) {
        
        SizeListModel *sizeListModel  =  self.sizeListModelArry[self.sizeListModelIndex];
        self.sizeStr = sizeListModel.name;
        
    }else{
        
        self.sizeStr = @"无";
    }
    
    if (self.gradeListModelIndex != -1) {
        
        GradeListModel *gradeListModel  =  self.gradeListModelArry[self.gradeListModelIndex];
        self.gradeStr = gradeListModel.name;
        
    }else{
        
        self.gradeStr = @"无";
    }
    
    if (self.hardnessListModelIndex != -1) {
        
        HardnessListModel *hardnessListModel  =  self.hardnessListModelArry[self.hardnessListModelIndex];
        self.hardnessStr = hardnessListModel.name;
        
    }else{
        
        self.hardnessStr = @"无";
    }
    
    if (self.fillInListModelIndex != -1) {
        
        FillInListModel *fillInListModel  =  self.fillInListModelArry[self.fillInListModelIndex];
        self.fillInStr = fillInListModel.name;
        
    }
    else{
        
        self.fillInStr = @"无";
    }
    
    if (self.accessoriesListModelIndex != -1) {
        
        AccessoriesListModel *accessoriesListModel  =  self.accessoriesListModelArry[self.accessoriesListModelIndex];
        self.accessoriesStr = accessoriesListModel.name;
        
    }else{
        
        self.accessoriesStr = @"无";
    }
    
    if (self.colorListModelIndex != -1) {
        
        ColorListModel *colorListModel  =  self.colorListModelArry[self.colorListModelIndex];
        self.colorStr = colorListModel.name;
        
    }else{
        
        self.colorStr = @"无";
    }
    
    if (self.packListModelIndex != -1) {
        
        self.packStr = self.packListModelArry[self.packListModelIndex];
        
    }else{
        
        self.packStr = @"无";
    }

}

//检查是否选中了产品参数
-(BOOL)checkGoodValue{
    
    NSString *info;
    if (self.weightListModelArry.count != 0 && self.weightListIndex == -1) {
        
        info = @"请选择重量";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
        return NO;
    }
    if (self.sizeListModelArry.count != 0 && self.sizeListModelIndex == -1) {
        
        info = @"请选择尺寸";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

        [alertV show];
        return NO;
    }

    if (self.gradeListModelArry.count != 0 && self.gradeListModelIndex == -1) {
        
        info = @"请选择等级";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

        [alertV show];
        return NO;
    }

    if (self.hardnessListModelArry.count != 0 && self.hardnessListModelIndex == -1) {
        
        info = @"请选择硬度";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

        [alertV show];
        return NO;
    }
    if (self.fillInListModelArry.count != 0 && self.fillInListModelIndex == -1) {
        
        info = @"请选择镶嵌分类";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertV show];
        return NO;
    }

    if (self.accessoriesListModelArry.count != 0 && self.accessoriesListModelIndex == -1) {
        
        info = @"请选择配饰";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertV show];
        return NO;
    }

    if (self.colorListModelArry.count != 0 && self.colorListModelIndex == -1) {
        
        info = @"请选择颜色";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertV show];
        return NO;
    }

    if (self.packListModelArry.count != 0 && self.packListModelIndex == -1) {
        
        info = @"请选择包装";
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertV show];
        return NO;
    }


    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    //初值
    [self creteInitValue];
    //加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
