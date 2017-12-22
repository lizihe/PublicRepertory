//
//  RdAppServiceAgent+tool.m
//  Pods
//
//  Created by aaaa on 16/8/29.
//
//

#import "RdAppServiceAgent+tool.h"
#import <AFNetworking/AFNetworking.h>

@implementation RdAppServiceAgent (tool)

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
#pragma mark - tool

+ (NSURL *)URLString:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    //将参数返回字符串
    NSString *query = AFQueryStringFromParameters(parameters);
    //创建临时URL
    NSURL *tempURL = [NSURL URLWithString:URLString];
    //如果之前URL有附带参数，则附加上去
    NSURL *new = [NSURL URLWithString:[NSString stringWithFormat:tempURL.query ? @"%@&%@" : @"%@?%@", URLString, query]];
    return new;
}

+ (NSString *)percentEscapedURLString:(NSString *)URLString
{
    return AFPercentEscapedStringFromString(URLString);
}

+ (NSString *)base64StringFromText:(NSString *)text{
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    return [self base64EncodedStringFrom:data];
    
}
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end
