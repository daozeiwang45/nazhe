//
//  JJNewFeatureCell.m
//  NewFeature
//
//  Created by Suzumiya Haruhi on 15/8/15.
//  Copyright (c) 2015年 杨佳鑫. All rights reserved.
//

#import "JJNewFeatureCell.h"

@interface JJNewFeatureCell ()

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation JJNewFeatureCell

- (UIImageView *)imageView {
    
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        _imageView = imageView;
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    self.imageView.image = image;
}

@end
