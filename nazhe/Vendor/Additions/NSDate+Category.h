//
//  NSDate+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)
-(NSDateComponents *)dateComponents;
//判断目前是否比一个日期早
-(BOOL)isEarlizerThanDate:(NSDate *)dt;
//判断目前是否比一个日期晚
-(BOOL)isLaterThanDate:(NSDate *)dt;
//判断是否目前和一个日期是否同年
-(BOOL)isSameYearAsDate:(NSDate *)dt;
//判断是否目前和一个日期是否同年同月
-(BOOL)isSameMonthAsDate:(NSDate *)dt;
//判断是否目前和一个日期是否同年同月同日
-(BOOL)isSameDayAsDate:(NSDate *)dt;
@end
