//
//  NSDate+Tool.m
//  Pods
//
//  Created by cxk@erongdu.com on 2017/1/5.
//
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

- (BOOL)isSameDayCompare:(NSDate *)compareDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    // 1.获得比较对象的年月日
    NSDateComponents *compareCmps = [calendar components:unit fromDate:compareDate];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (compareCmps.year == selfCmps.year)&&(compareCmps.month == selfCmps.month)&&(compareCmps.day == selfCmps.day);
}


/**
 与compareDate比较天数间隔 如果小于compareDate 则是正 反之则负

 @param compareDate <#compareDate description#>
 @return <#return value description#>
 */
- (NSInteger)numberDayToDate:(NSDate *)compareDate
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:self];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:compareDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
@end
