//
//  NSDictionary+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "NSDictionary+Category.h"
#import "NSString+Category.h"
@implementation NSDictionary (Category)

-(BOOL)hasObjectForkey:(id)key{
    return [[self allKeys] containsObject:key];
}

-(NSString *)queryString{
    NSMutableArray *parameters = [NSMutableArray array];
    
    NSEnumerator *enumerator = [self keyEnumerator];
    NSString *key = nil;
    while ((key = [enumerator nextObject])) {
        NSString *parameter = [self objectForKey:key];
        [parameters addObject:[NSString stringWithFormat:@"%@=%@",[key URLEncodedString],[parameter URLEncodedString]]];
    }
    
    return [parameters componentsJoinedByString:@"&"];
}


- (id)objectOrNilForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else
    {
        return object;
    }
}
@end
