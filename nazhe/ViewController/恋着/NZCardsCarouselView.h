//
//  NZCardsCarouselView.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoveModel.h"

@protocol NZCardsCarouselViewDelegate <NSObject>

@optional
- (void)switchWitchCommodity:(int)commodityID;

@end

@interface NZCardsCarouselView : UIView

@property (nonatomic, strong) NSMutableArray *starList;

@property (nonatomic, weak) id<NZCardsCarouselViewDelegate> delegate;

@end
