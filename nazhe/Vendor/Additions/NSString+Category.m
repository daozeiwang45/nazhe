//
//  NSString+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-24.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "NSString+Category.h"
#import "NSMutableString+Category.h"
#import "NSData+Category.h"
#import "UIDevice+Category.h"
@implementation NSString (Category)

+(BOOL)CheckUsernameInput:(NSString *)_text
{
    NSString *Regex = @"^\\w{2,16}{1}quot";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+(BOOL)CheckPhonenumberInput:(NSString *)_text{
    NSString *Regex = @"1\\d{10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+(BOOL)CheckMailInput:(NSString *)_text{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+(BOOL)CheckPasswordInput:(NSString *)_text{
    NSString *Regex = @"\\w{6,16}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+(BOOL)isLetters:(NSString *)_text{
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

+(BOOL)isNumbers:(NSString *)_text{
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

+(BOOL)isNumberOrLetters:(NSString *)_text{
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

+(NSString *)stringWithUTF8Data:(NSData *)data{
    return [self stringWithData:data encoding:NSUTF8StringEncoding];
}

+(NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding{
    return [[NSString alloc] initWithData:data encoding:encoding];
}

+(NSString *)stringWithUUID{
    CFUUIDRef UUIDObject = CFUUIDCreate(NULL);
    NSString *UUIDString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, UUIDObject));
    CFRelease(UUIDObject);
    return UUIDString;
}

+(NSString *)randStringWithLength:(NSUInteger)length{
    if (length <= 0) {
        return @"";
    }
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0U; i < length; i++) {
        [string appendFormat:@"%c",[letters characterAtIndex:arc4random() % [letters length]]];
    }
    return [NSString stringWithString:string];
}

+(NSString *)randAlphanumericStringWithLength:(NSUInteger)length{
    if (length <= 0) {
        return @"";
    }
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0U; i < length; i++) {
        [string appendFormat:@"%c",[letters characterAtIndex:arc4random() % [letters length]]];
    }
    return [NSString stringWithString:string];
}

-(NSURL *)URL{
    return [NSURL URLWithString:self];
}

-(NSString *)URLEncodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, ((CFStringRef)self), NULL, CFSTR("!*'();:@&=+$,/?%#[]<>"), kCFStringEncodingUTF8));
    return result;
}

-(NSString *)URLDecodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8));
    return result;
}

-(NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp addQueryDictionary:dictionary];
    return [NSString stringWithString:tmp];
}

-(NSString *)stringByAppendingParameter:(id)parametet forKey:(NSString *)key{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp appendParameter:parametet forKey:key];
    return [NSString stringWithString:tmp];
}

-(CGFloat)widthWithFont:(UIFont *)font{
    CGSize size = [self sizeWithFont:font];
    return size.width;
}



-(BOOL)containsString:(NSString *)string{
    return [self containsString:string ignoringCase:YES];
}

-(BOOL)containsString:(NSString *)string ignoringCase:(BOOL)ignore{
    NSStringCompareOptions options = NSLiteralSearch;
    if (ignore) {
        options = NSCaseInsensitiveSearch;
    }
    
    NSRange range = [self rangeOfString:string options:options];
    return (range.location != NSNotFound);
}

-(BOOL)equalsToString:(NSString *)string{
    return [self equalsToString:string ignoringCase:YES];
}

-(BOOL)equalsToString:(NSString *)string ignoringCase:(BOOL)ignore{
    NSStringCompareOptions options = NSLiteralSearch;
    if (ignore) {
        options = NSCaseInsensitiveSearch;
    }
    return (NSOrderedSame == [self compare:string options:options]);
}

-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString{
    return [self stringByReplacingString:string withString:newString ignoringCase:NO];
}

-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString ignoringCase:(BOOL)ignore{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp replaceString:string withString:newString ignoringCase:ignore];
    return [NSString stringWithString:tmp];
}

-(NSString *)stringByRemovingWhitespace{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespace];
    return [NSString stringWithString:tmp];
}

-(NSString *)stringByRemovingWhitespaceAndNewLine{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespaceAndNewline];
    return [NSString stringWithString:tmp];
}

#pragma mark - Hash

- (NSString *)MD5HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5HashString];
}

- (NSString *)SHA1HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1HashString];
}

#pragma mark - Public

- (NSInteger)heightWithFont:(UIFont* )font width:(CGFloat)width {
    CGRect bounds = CGRectZero;
    
    if ([UIDevice isIOS7])
    {
        bounds = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    }else
    {
        bounds.size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    }
    
    return ceilf(bounds.size.height);
}


@end
