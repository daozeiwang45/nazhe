//
//  NSMutableString+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Category)
-(void)addQueryDictionary:(NSDictionary *)dictionary;
-(void)appendParameter:(id)paramter forKey:(NSString *)key;
-(void)replaceString:(NSString *)searchString withString:(NSString *)newString;
-(void)replaceString:(NSString *)searchString withString:(NSString *)newString ignoringCase:(BOOL)ignore;
-(void)removeWhitespace;
-(void)removeWhitespaceAndNewline;
@end
