//
//  RdAppServiceConfig.h
//  Pods
//
//  Created by aaaa on 16/8/24.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSecurityPolicy;

/**
 *  公共参数附加协议
 */
@protocol RdAppServiceConfigArgumentsProtocol <NSObject>

@required

/**
 *  附加公共参数
 *
 *  @param sourceBody 源参数
 *
 *  @return 返回附加后的字典
 */
- (NSDictionary *)rdAppServiceBodyArgumentsAttach:(NSDictionary *)sourceBody;

/**
 *  附加公共参数在头部
 *
 *  @param sourceHeader 源参数
 *
 *  @return 返回附加后的参数
 */
- (NSDictionary *)rdAppServiceHeaderArgumentsAttach:(NSDictionary *)sourceHeader;

/**
 *  附加extra server存在的时候，自定义header
 *
 *  @param sourceHeader 源参数
 *
 *  @return 返回附加后的参数
 */
- (NSDictionary *)rdAppServiceExtraBodyArgumentsAttach:(NSDictionary *)sourceHeader;
@end

@interface RdAppServiceConfig : NSObject

/**
 *  是否是生产环境，default = YES
 */
@property (nonatomic, assign) BOOL useProductionServer;

/**
 *  测试地址
 */
@property (nonatomic, copy) NSString *testBaseURL;

/**
 *   基本请求地址 如http://www.example.com/ default:@""
 */
@property (nonatomic, copy) NSString *baseURL;

/**
 *  测试CDN地址
 */
@property (nonatomic, copy) NSString *testCDNURL;

/**
 *  请求静态资源地址 如http://www.static.com/  default:@""
 */
@property (nonatomic, copy) NSString *CDNURL;

/**
 *  额外备用测试地址
 */
@property (nonatomic, copy) NSString *testExtraURL;

/**
 *  额外服务器地址，备用  default:@""
 */
@property (nonatomic, copy) NSString *extraURL;

/**
 *  请求超时时间  default:20s
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/**
 *  安全策略，默认是无
 */
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

/**
 *  实现公共参数协议类对象
 */
@property (nonatomic, strong) id<RdAppServiceConfigArgumentsProtocol> commentArguments;
/**
 *  创建单例
 *
 *  @return RdAppServiceConfig单例
 */
+ (instancetype)sharedInstance;



#pragma mark -URL

- (NSString *)baseURLWithPath:(NSString *)path;

- (NSString *)CDNURLWithPath:(NSString *)path;

- (NSString *)extraURLWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
