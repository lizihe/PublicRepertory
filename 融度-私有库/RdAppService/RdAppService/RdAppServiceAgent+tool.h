//
//  RdAppServiceAgent+tool.h
//  Pods
//
//  Created by aaaa on 16/8/29.
//
//

#import "RdAppServiceAgent.h"

@interface RdAppServiceAgent (tool)

#pragma mark -

/**
 *  将url和parmaters拼接成完整的URL
 *
 *  @param URLString 请求地址
 *  @param parameters 参数
 *
 *  @return 返回拼接好的URL
 */
+ (NSURL *)URLString:(NSString *)URLString parameters:(NSDictionary *)parameters;


/**
 *  对url进行编码
 *
 *  @param URLString
 *
 *  @return 返回编码后的字符串
 */
+ (NSString *)percentEscapedURLString:(NSString *)URLString;

/**
 base 64 加密

 @param text
 @return 密文
 */
+ (NSString *)base64StringFromText:(NSString *)text;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;

@end
