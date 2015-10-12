//
//  NZSettingContentView.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/2.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZSettingContentView.h"

@interface NZSettingContentView () {
    
}



@end

@implementation NZSettingContentView

- (void)layoutSubviews {
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width / 2;
    self.headImage.layer.masksToBounds = YES;
    
    
}

@end
