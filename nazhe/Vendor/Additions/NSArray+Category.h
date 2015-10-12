//
//  NSArray+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)

//返回index位置的元素
-(id)objectOrNilAtIndex:(NSUInteger)i;
//第一个元素
-(id)firstObject;
//随机一个元素
-(id)randomObject;
//返回一个元素随机的数组
-(NSArray *)shuffledArray;
//返回一个倒序的数组
-(NSArray *)reverseedArray;
//返回一个无相同元素的数组
-(NSArray *)uniqueArray;
@end
