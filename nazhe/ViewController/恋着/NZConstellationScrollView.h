//
//  NZConstellationScrollView.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NZConstellationScrollViewDelegate <NSObject>

@optional
- (void)switchWitchConstellation:(int)index;

@end

@interface NZConstellationScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<NZConstellationScrollViewDelegate> delegate;

@end
