//
//  NSMutableDictionary+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Category)
//将一个元素加入dictionary
-(void)setObject:(id)object forKeyIfNotNil:(id)key;
@end
