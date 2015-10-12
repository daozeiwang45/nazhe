//
//  JJNewFeatureController.m
//  NewFeature
//
//  Created by Suzumiya Haruhi on 15/8/15.
//  Copyright (c) 2015年 杨佳鑫. All rights reserved.
//

#import "JJNewFeatureController.h"
#import "JJNewFeatureCell.h"

@interface JJNewFeatureController ()

@end

@implementation JJNewFeatureController

static NSString *ID = @"NewFeatureCell";

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    // 清空行距
    layout.minimumLineSpacing = 0;
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //
    
    return [super initWithCollectionViewLayout:layout];
}

// 在UICollectionViewController中
// self.collectionView != self.view
// self.collectionView 是 self.view的子控件

// 使用UICollectionViewController
// 1.初始化的时候设置布局参数
// 2.必须collectionView要注册cell
// 3.自定义cell
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor greenColor];
    
    // 注册cell
    [self.collectionView registerClass:[JJNewFeatureCell class] forCellWithReuseIdentifier:ID];
    
    // 分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

// 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回第section组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

// 返回cell长什么样子
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // dequeueReusableCellWithReuseIdentifier
    // 1.首先从缓存池里取cell
    // 2.看下当前是否有注册cell,如果注册了cell,就会帮你创建cell
    // 3.没有注册,报错
    
    JJNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 获取图片名称
    NSString *imageName = _imageArray[indexPath.row];
    //给cell传值
    UIImage *image = [UIImage imageNamed:imageName];
    cell.image = image;
    
    return cell;
}

@end
