//
//  NZFastOperate.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZFastOperate : NSObject

+ (instancetype) sharedObject ;

- (BOOL) isLogin ;

- (id) createInstanceStoryboardName:(NSString *)storyboardName bundle:(NSBundle*)bundle;


@end
