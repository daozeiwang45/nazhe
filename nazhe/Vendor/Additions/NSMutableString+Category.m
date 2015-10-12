//
//  NSMutableString+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "NSMutableString+Category.h"
#import "NSString+Category.h"

@implementation NSMutableString (Category)
-(void)addQueryDictionary:(NSDictionary *)dictionary{
    NSEnumerator *keyEnumerator = [dictionary keyEnumerator];
    NSString *key = nil;
    while ((key = [keyEnumerator nextObject])) {
        NSString *value = [dictionary objectForKey:key];
        [self appendParameter:value forKey:key];
    }
}

-(void)appendParameter:(id)paramter forKey:(NSString *)key{
    if (paramter) {
        BOOL needsQuestionMark = [self rangeOfString:@"?" options:0].location == NSNotFound;
        if (needsQuestionMark) {
            [self appendString:@"?"];
        }
        
        BOOL charOnEnd = [self hasSuffix:@"&"] || [self hasSuffix:@"?"];
        if (!charOnEnd) {
            [self appendString:@"&"];
        }
        
        paramter = [NSString stringWithFormat:@"%@",paramter] ;
        
        [self appendFormat:@"%@=%@",[key URLEncodedString],[paramter URLEncodedString]];
    }
}

-(void)replaceString:(NSString *)searchString withString:(NSString *)newString{
    [self replaceString:searchString withString:newString ignoringCase:NO];
}

-(void)replaceString:(NSString *)searchString withString:(NSString *)newString ignoringCase:(BOOL)ignore{
    NSStringCompareOptions options = NSLiteralSearch;
    if (ignore) {
        options = NSCaseInsensitiveSearch;
    }
    
    [self replaceOccurrencesOfString:searchString withString:newString options:options range:NSMakeRange(0, [self length])];
}

-(void)removeWhitespace{
    NSString *replaced = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self replaceCharactersInRange:NSMakeRange(0, [self length]) withString:replaced];
}

-(void)removeWhitespaceAndNewline{
    NSString *replaced = [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    [self replaceCharactersInRange:NSMakeRange(0, [self length]) withString:replaced];
}
@end
