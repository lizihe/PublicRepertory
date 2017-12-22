//
//  NSDate+Tool.h
//  Pods
//
//  Created by cxk@erongdu.com on 2017/1/5.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)

/**
 比较2个时间是否是同一天

 @param compareDate 被比较的时间
 @return YES则是同一天
 */
- (BOOL)isSameDayCompare:(NSDate *)compareDate;

/**
 与compareDate比较天数间隔 如果小于compareDate 则是正 反之则负
 
 @param compareDate <#compareDate description#>
 @return <#return value description#>
 */
- (NSInteger)numberDayToDate:(NSDate *)compareDate;
@end
