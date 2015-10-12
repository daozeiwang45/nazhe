//
//  NZConstellationScrollView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/24.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZConstellationScrollView.h"

#define labelTag 100
#define tapTag 1000

#define hugeFont [UIFont systemFontOfSize:18.f]
#define bigFont [UIFont systemFontOfSize:15.f]
#define mediumFont [UIFont systemFontOfSize:11.f]
#define smallFont [UIFont systemFontOfSize:7.f]

#define bigGray [UIColor darkGrayColor]
#define mediumGray [UIColor colorWithWhite:100/255.f alpha:1]
#define smallGray [UIColor colorWithWhite:120/255.f alpha:1]

/*****************     黑底时用的颜色     *******************/
#define bigWhite [UIColor colorWithWhite:220/255.f alpha:1]
#define mediumWhite [UIColor colorWithWhite:200/255.f alpha:1]
#define smallWhite [UIColor colorWithWhite:180/255.f alpha:1]

@interface NZConstellationScrollView () {
    UIScrollView *constellationScrollView;
    CGSize scrollViewSize;
    
    NSMutableArray *constellationArray;
    CGFloat divisionWidth;
    CGFloat VIEW_HEIGHT;
    CGFloat startX;
    CGFloat maxLabelWidth;
    CGFloat bigLabelWidth;
    CGFloat mediumLabelWidth;
    CGFloat smallLabelWidth;
    CGFloat endFloat;
    
    int currentIndex;
}

@end

@implementation NZConstellationScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        scrollViewSize = frame.size;
        constellationArray = [NSMutableArray arrayWithObjects:@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"魔蝎座", @"水瓶座", @"双鱼座", nil];
        divisionWidth = self.frame.size.width / 12.f;
        VIEW_HEIGHT = self.frame.size.height;
        startX = divisionWidth * 4.5f;
        maxLabelWidth = divisionWidth * 3.f;
        bigLabelWidth = divisionWidth * 2.f;
        mediumLabelWidth = divisionWidth * 1.5f;
        smallLabelWidth = divisionWidth;
        endFloat = divisionWidth * 6.5f;

//        divisionWidth = self.frame.size.width / 10.f;
//        VIEW_HEIGHT = self.frame.size.height;
//        startX = divisionWidth * 4.5f;
//        maxLabelWidth = divisionWidth * 2.f;
//        bigLabelWidth = divisionWidth * 1.7f;
//        mediumLabelWidth = divisionWidth * 1.3f;
//        smallLabelWidth = divisionWidth;
//        endFloat = divisionWidth * 6.5f;
        
        currentIndex = 5;
    }
    return self;
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor clearColor];
    [self initScrollView];
    [self initLabels];
}

- (void)initScrollView {
    constellationScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height)];
    constellationScrollView.delegate = self;
    constellationScrollView.showsHorizontalScrollIndicator = NO;
    constellationScrollView.scrollEnabled = YES;
//    constellationScrollView.maximumZoomScale = 
    constellationScrollView.backgroundColor = [UIColor clearColor];
    CGSize myContentSize;
    // 第一个label始终距离scrollview4.5，然后算滑倒最右边星座时，总的contentsize
    myContentSize.width = divisionWidth * 24.5f;
    myContentSize.height = self.frame.size.height;
    constellationScrollView.contentSize = myContentSize;
    constellationScrollView.decelerationRate = 0.5;
    [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 6.5f, 0) animated:NO];
    [self addSubview:constellationScrollView];
}

- (void)initLabels {
    int i = 0;
    for (NSString *labelName in constellationArray) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.tag = labelTag + i;
        label.text = labelName;
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
//        label.adjustsFontSizeToFitWidth = true
//        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(constellationClick:)];
        tapGesture.numberOfTapsRequired = 1;
        [label addGestureRecognizer:tapGesture];
        
        if (i == 0) {
            label.font = smallFont;
            label.textColor = smallGray;
            [constellationScrollView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(constellationScrollView.mas_left).with.offset(divisionWidth * 4.5f);
                make.width.mas_equalTo(divisionWidth);
            }];
        } else if (i == 1) {
            label.font = smallFont;
            label.textColor = smallGray;
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(divisionWidth);
            }];
        } else if (i == 2) {
            label.font = smallFont;
            label.textColor = smallGray;
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(divisionWidth);
            }];
        } else if (i == 3) {
            label.font = mediumFont;
            label.textColor = mediumGray;
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(mediumLabelWidth);
            }];
        } else if (i == 4) {
            label.font = bigFont;
            label.textColor = bigGray;
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(bigLabelWidth);
            }];
        } else if (i == 5) {
            label.font = hugeFont;
            label.textColor = [UIColor blackColor];
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(maxLabelWidth);
            }];
        } else if (i == 6) {
            label.font = bigFont;
            label.textColor = bigGray;
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(bigLabelWidth);
            }];
        } else if (i == 7) {
            label.font = mediumFont;
            label.textColor = mediumGray;
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(mediumLabelWidth);
            }];
        } else if (i > 7) {
            label.font = smallFont;
            label.textColor = smallGray;
            [constellationScrollView addSubview:label];
            UILabel *referenceLabel = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i - 1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(constellationScrollView.mas_top);
                make.height.mas_equalTo(VIEW_HEIGHT);
                make.left.equalTo(referenceLabel.mas_right);
                make.width.mas_equalTo(divisionWidth);
            }];
        }
        ++i;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.x;
    
    // 手指向左滑
    if(endFloat < currentOffset)
    {
        if (currentIndex < 11) {
            CGFloat centerXset = currentOffset + divisionWidth * 7.5f;
            UILabel *label = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex + 1)];
            if (label.origin.x < centerXset) {
                currentIndex += 1;
                int i;
                for (i = 0; i < 12; i++) {
                    UILabel *label = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i)];
                    label.font = smallFont;
                    label.textColor = smallGray;
                    [label mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(divisionWidth);
                    }];
                }
                UILabel *label1 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex - 2)];
                UILabel *label2 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex - 1)];
                UILabel *label3 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex)];
                UILabel *label4 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex + 1)];
                UILabel *label5 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex + 2)];
                
                label1.font = mediumFont;
                label1.textColor = mediumGray;
                [label1 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(mediumLabelWidth);
                }];
                label2.font = bigFont;
                label2.textColor = bigGray;
                [label2 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(bigLabelWidth);
                }];
                label3.font = hugeFont;
                label3.textColor = [UIColor blackColor];
                [label3 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(maxLabelWidth);
                }];
                label4.font = bigFont;
                label4.textColor = bigGray;
                [label4 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(bigLabelWidth);
                }];
                label5.font = mediumFont;
                label5.textColor = mediumGray;
                [label5 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(mediumLabelWidth);
                }];
            }
        }
    }
    
    // 手指向右滑
    if(endFloat > currentOffset)
    {
        if (currentIndex > 0) {
            CGFloat centerXset = currentOffset + divisionWidth * 4.5f;
            UILabel *label = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex - 1)];
            if ((label.origin.x + label.frame.size.width) > centerXset) {
                currentIndex -= 1;
                int i;
                for (i = 0; i < 12; i++) {
                    UILabel *label = (UILabel *)[constellationScrollView viewWithTag:(labelTag + i)];
                    label.font = smallFont;
                    label.textColor = smallGray;
                    [label mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(divisionWidth);
                    }];
                }
                UILabel *label1 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex - 2)];
                UILabel *label2 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex - 1)];
                UILabel *label3 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex)];
                UILabel *label4 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex + 1)];
                UILabel *label5 = (UILabel *)[constellationScrollView viewWithTag:(labelTag + currentIndex + 2)];
                
                label1.font = mediumFont;
                label1.textColor = mediumGray;
                [label1 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(mediumLabelWidth);
                }];
                label2.font = bigFont;
                label2.textColor = bigGray;
                [label2 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(bigLabelWidth);
                }];
                label3.font = hugeFont;
                label3.textColor = [UIColor blackColor];
                [label3 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(maxLabelWidth);
                }];
                label4.font = bigFont;
                label4.textColor = bigGray;
                [label4 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(bigLabelWidth);
                }];
                label5.font = mediumFont;
                label5.textColor = mediumGray;
                [label5 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(mediumLabelWidth);
                }];
            }
        }
    }
    endFloat = currentOffset;
}

#pragma mark label点击事件
- (void)constellationClick:(UIGestureRecognizer *)sender {
    UILabel *tapLabel = (UILabel *)sender.view;
    int index = (int)tapLabel.tag - 100;
    [self.delegate switchWitchConstellation:index];
    [self fixContentOffset:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.delegate switchWitchConstellation:currentIndex];
    [self fixContentOffset:currentIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self.delegate switchWitchConstellation:currentIndex];
        [self fixContentOffset:currentIndex];
    }
}

- (void)fixContentOffset:(int)index {
    switch (index) {
        case 0:
            [constellationScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
            
        case 1:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 2.f, 0) animated:YES];
            break;
            
        case 2:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 3.5f, 0) animated:YES];
            break;
            
        case 3:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 4.5f, 0) animated:YES];
            break;
            
        case 4:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 5.5f, 0) animated:YES];
            break;
            
        case 5:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 6.5f, 0) animated:YES];
            break;
            
        case 6:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 7.5f, 0) animated:YES];
            break;
            
        case 7:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 8.5f, 0) animated:YES];
            break;
            
        case 8:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 9.5f, 0) animated:YES];
            break;
            
        case 9:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 10.5f, 0) animated:YES];
            break;
            
        case 10:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 11.5f, 0) animated:YES];
            break;
            
        case 11:
            [constellationScrollView setContentOffset:CGPointMake(divisionWidth * 12.5f, 0) animated:YES];
            break;
            
        default:
            break;
    }
}

@end
