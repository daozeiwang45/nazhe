//
//  NSMutableDictionary+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "NSMutableDictionary+Category.h"

@implementation NSMutableDictionary (Category)
-(void)setObject:(id)object forKeyIfNotNil:(id)key{
    if (object && key) {
        [self setObject:object forKey:key];
    }
}
@end
