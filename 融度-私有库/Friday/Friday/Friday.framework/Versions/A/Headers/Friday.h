//
//  Friday.h
//  Friday
//
//  Created by cxk@erongdu.com on 2017/4/21.
//  Copyright © 2017年 cxk. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friday : NSObject

#pragma mark Properties

/**
 设备唯一标识
 优先获取advertisingIdentifier
 获取identifierForVendor
 生成随机标识码
 */
@property (atomic, readonly, copy) NSString *deviceUUID;


/**
 业务上用户id
 */
@property (nonatomic, copy) NSString *userId;


/**
 渠道号，默认“AppStore”
 */
@property (nonatomic, copy) NSString *channelId;

/**
 是否打印log default YES
 */
@property (nonatomic, assign) BOOL enableLogging;


/**
 sdk版本号
 */
@property (nonatomic, readonly, copy) NSString *libVersion;

#pragma mark singleton instance


/**
 创建Friday对象通过token标识

 @param apiToken 特定标识
 */
+ (instancetype)sharedInstanceWithToken:(NSString *)apiToken;

/**
 获取生成的实例

 @return 返回已经生成的实例对象
 */
+ (nullable Friday *)sharedInstance;

#pragma mark track


/**
 记录事件

 @param event 事件名称
 */
- (void)track:(NSString *)event;


/**
 记录事件，附加参数

 @param event 事件名称
 @param properties 附加参数
 */
- (void)track:(NSString *)event properties:(nullable NSDictionary *)properties;

/**
 用户自定义事件开始时间

 @param event 事件名称
 @param properties 附加参数
 */
- (void)trackStart:(NSString *)event properties:(nullable NSDictionary *)properties;

/**
 用户自定义事件结束时间

 @param event 事件名称
 @param properties 附加参数
 */
- (void)trackEnd:(NSString *)event properties:(nullable NSDictionary *)properties;


#pragma mark -SuperProperties
/**
 自定义公共参数，针对业务

 @param properties 自定义参数
 */
- (void)registerSuperProperties:(NSDictionary *)properties;


/**
 移除自定义公共参数中的key

 @param propertyName 移除参数的key
 */
- (void)unregisterSuperProperty:(NSString *)propertyName;


/**
 移除自定义公共参数
 */
- (void)clearSuperProperties;


/**
 获取当前自定义的公共参数

 @return 自定义公共参数
 */
- (NSDictionary *)currentSuperProperties;
//test
- (void)flush;
@end

NS_ASSUME_NONNULL_END
