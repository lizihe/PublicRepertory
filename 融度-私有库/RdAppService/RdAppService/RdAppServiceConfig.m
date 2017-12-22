//
//  RdAppServiceConfig.m
//  Pods
//
//  Created by aaaa on 16/8/24.
//
//

#import "RdAppServiceConfig.h"
#import <AFNetworking/AFNetworking.h>

@implementation RdAppServiceConfig

+ (instancetype)sharedInstance
{
    static RdAppServiceConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[RdAppServiceConfig alloc] init];
    });
    return config;
}

- (instancetype)init
{
    if (self = [super init]) {
        _baseURL = @"";
        _CDNURL = @"";
        _extraURL = @"";
        _testBaseURL = @"";
        _testCDNURL = @"";
        _testExtraURL = @"";
        _requestTimeoutInterval = 20;
        _useProductionServer = YES;
        _securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    return self;
}

#pragma mark -URL

- (NSString *)BaseURL
{
    return _useProductionServer?_baseURL:_testBaseURL;
}

- (NSString *)CDNURL
{
    return _useProductionServer?_CDNURL:_testCDNURL;
}

- (NSString *)ExtraURL
{
    return _useProductionServer?_extraURL:_testExtraURL;
}

- (NSString *)domaine:(NSString *)domaine path:(NSString *)path
{
//    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:domaine]].absoluteString;
    NSString *last = [domaine substringFromIndex:domaine.length-1];
    if (![last isEqualToString:@"/"]) {
        //域名地址最后一个字符不是 ／的话 进行拼接
        domaine = [domaine stringByAppendingString:@"/"];
    }
    return  [domaine stringByAppendingString:path];
}

- (NSString *)baseURLWithPath:(NSString *)path
{
    return [self domaine:self.BaseURL path:path];
}

- (NSString *)CDNURLWithPath:(NSString *)path
{
    return [self domaine:self.CDNURL path:path];
}

- (NSString *)extraURLWithPath:(NSString *)path
{
    return [self domaine:self.ExtraURL path:path];
}
@end
