//
//  NSString+NZ_Category.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NSString+NZ_Category.h"

@implementation NSString (NZ_Category)

- (NSString *) trim
{
    if( nil == self ){
        return emptyString ;
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
}

- (NSString *) emptyToSpaceString
{
    if( self && [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] equalsToString:emptyString] ){
        return spaceString ;
    }
    return self ;
}

- (BOOL) isNotEqualsToString:(NSString *) string
{
    BOOL flag = ! ( [[string trim] equalsToString:self] ) ;
    return flag ;
}

- (BOOL) isNotEqualsToString:(NSString *) string ignoringCase:(BOOL)ignore
{
    BOOL flag = ! ( [[string trim] equalsToString:self ignoringCase:ignore] ) ;
    return flag ;
}

- (NSString *) deleteString:(NSString *)beReplace
{
    NSString * str = [self stringByReplacingOccurrencesOfString:beReplace withString:emptyString] ;
    NSArray* arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    NSString * string = emptyString ;
    if( arr && [arr count] > 1 ){
        for( int i = 0 ; i<[arr count] ; i++ ){
            string = [string stringByAppendingString:arr[i]] ;
        }
        return string ;
    }
    else{
        return str ;
    }
}

#pragma -mark private

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

@end
