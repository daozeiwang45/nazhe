//
//  NSMutableArray+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Category)

//如果object不为nil就加入
-(id)addObjectIfNotNil:(id)object;
//如果不存在object就加入
-(id)addNonEqualObjectIfNotNil:(id)object;
-(id)addNonIdenticalObjectIfNotNil:(id)object;
//插入object
-(id)insertObject:(id)object atIndexIfNotNil:(NSUInteger)index;
//将一个obgject移动到指定位置
-(id)moveObjectAthIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;
//删除第一个object
-(void)removeFirstObject;
//重新排列随即数组
-(void)shuffle;
//倒排数组元素
-(void)reverse;
//删除数组中相同元素
-(void)unique;
//添加一个元素
-(id)push:(id)object;
//弹出最后一个元素
-(id)pop;
//加入一个object在第一个位置
-(id)enqueue:(id)object;
//弹出最后一个元素
-(id)dequeue;

@end
