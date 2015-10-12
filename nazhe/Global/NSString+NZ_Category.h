//
//  NSString+NZ_Category.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NZ_Category)
/**
 *  去除字符串中的空格
 *
 *  @return <#return value description#>
 */
- (NSString *) trim ;
/**
 *  确认是否为空格字符串，yes返回单一空格 no则返回本身
 *
 *  @return <#return value description#>
 */
- (NSString *) emptyToSpaceString ;
/**
 *  判断两个字符串不相等
 *
 *  @param string 对string参数做去处空格处理
 *
 *  @return <#return value description#>
 */
- (BOOL) isNotEqualsToString:(NSString *) string ;
- (BOOL) isNotEqualsToString:(NSString *) string ignoringCase:(BOOL)ignore ;
- (NSString *) deleteString:(NSString *)beReplace ;

@end
