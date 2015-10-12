//
//  NSDictionary+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

//判断是否有这个key
-(BOOL)hasObjectForkey:(id)key;
-(NSString *)queryString;
- (id)objectOrNilForKey:(NSString *)key;
@end
