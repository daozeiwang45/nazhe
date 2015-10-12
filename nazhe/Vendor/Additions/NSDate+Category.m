//
//  NSDate+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-25.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

-(NSDateComponents *)dateComponents{
    NSCalendarUnit calendarUnit =
    NSEraCalendarUnit |
    NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit |
    NSWeekCalendarUnit |
    NSWeekdayCalendarUnit |
    NSWeekdayOrdinalCalendarUnit |
    NSQuarterCalendarUnit |
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    NSWeekOfMonthCalendarUnit |
    NSWeekOfYearCalendarUnit |
    NSYearForWeekOfYearCalendarUnit |
#endif
    NSCalendarCalendarUnit |
    NSTimeZoneCalendarUnit;
    return [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
}

-(BOOL)isEarlizerThanDate:(NSDate *)dt{
    return ([self earlierDate:dt] == self);
}

-(BOOL)isLaterThanDate:(NSDate *)dt{
    return ([self laterDate:dt] == self);
}

-(BOOL)isSameYearAsDate:(NSDate *)dt{
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [dt dateComponents];
    return ([components1 year] == [components2 year]);
}

-(BOOL)isSameMonthAsDate:(NSDate *)dt{
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [dt dateComponents];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]));
}

-(BOOL)isSameDayAsDate:(NSDate *)dt{
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [self dateComponents];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month] )&&
            ([components1 day] == [components2 day]));
}

@end
