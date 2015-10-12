//
//  NSArray+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "NSArray+Category.h"
#import "NSMutableArray+Category.h"

@implementation NSArray (Category)

-(id)objectOrNilAtIndex:(NSUInteger)i{
    if (i < [self count]) {
        return [self objectAtIndex:i];
    }
    return nil;
}

-(id)firstObject{
    return [self objectOrNilAtIndex:0];
}

-(id)randomObject{
    if ([self count] > 0) {
        int i = arc4random() % [self count];
        return [self objectAtIndex:i];
    }
    return nil;
}

-(NSArray *)shuffledArray{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self];
    [tmp shuffle];
    return [NSArray arrayWithArray:tmp];
}

-(NSArray *)reverseedArray{
    NSMutableArray *tmp =[NSMutableArray arrayWithArray:self];
    [tmp reverse];
    return [NSArray arrayWithArray:tmp];
}

-(NSArray *)uniqueArray{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self];
    [tmp unique];
    return [NSArray arrayWithArray:tmp];
}
@end
