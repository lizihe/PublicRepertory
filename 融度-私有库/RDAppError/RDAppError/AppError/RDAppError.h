//
//  RDAppError.h
//  Pods
//
//  Created by cxk@erongdu.com on 2016/11/23.
//
//

#import <Foundation/Foundation.h>
#import <RdAppService/RdAppService.h>

@class RDAppError;

/**
 网络成功时的回调
 
 @param task 请求任务
 @param error 错误信息
 @param model 数据模型
 */
typedef void(^RDAppErrorSuccessBlock)(NSURLSessionDataTask *task, RDAppError *error, id model);


/**
 网络失败时回调
 
 @param task 请求任务
 @param error 错误信息
 */
typedef void(^RDAppErrorFailBlock)(NSURLSessionDataTask *task, RDAppError *error);

/**
 文件下载目标地址回调
 
 @param targetPath 目标地址
 @param response 返回数据
 @return
 */
typedef NSURL *(^RDAppErrorDestinationBlock)(NSURL *targetPath, NSURLResponse *response);


/**
 下载文件进度回调
 
 @param downloadProgress <#downloadProgress description#>
 */
typedef void (^RDAppErrorProgressBlock)(NSProgress *downloadProgress);

/**
 下载成功
 
 @param task <#task description#>
 @param response <#response description#>
 */
typedef void (^RDAppErrorDownloadSuccess)(NSURLSessionDownloadTask *task, NSURLResponse *response);

@protocol RDAppErrorDelegate <NSObject>

@required


/**
 请求之前需要做的操作
 
 @param url 请求地址
 @param headerParameter
 @param parameter 参数
 @param defaultFlag 额外标识符
 */
- (void)beforeRequestURL:(NSString **)url headerParameter:(NSMutableDictionary **)headerParameter parameter:(NSMutableDictionary **)parameter;


/**
 网络请求成功时返回RDAppError对象
 
 @param responseObject 网络请求返回数据
 @return RDAppError对象
 */
- (RDAppError *)successRDAppErrorWithResponseObject:(id)responseObject;

/**
 网络请求失败时返回RDAppError对象
 
 @param error 网络错误信息
 @return RDAppError对象
 */
- (RDAppError *)failRDAppErrorWithNetworkError:(NSError *)error;



/**
 将数据转换成Model，在成功回调中返回
 
 @param responseObject 返回数据
 @param modelClass 数据模型
 @return 数据模型对象
 */
- (id)response:(id)responseObject convertToModelClass:(__unsafe_unretained Class)ModelClass appError:(RDAppError *)appError;


/**
 根据code判断是否可封装数据
 
 @param appError 是一步产生的错误对象
 @return 是否可封装
 */
- (BOOL)isResponseCanConvert:(RDAppError *)appError;

/**
 在成功和错误回调之前进行统一处理代理
 
 @param appError 生成的错误对象
 */
- (void)unifiedTreatmentAppError:(RDAppError *)appError;


@end
@interface RDAppError : NSObject

/**
 返回code保护成功或网络失败的code
 */
@property (nonatomic, assign) NSInteger errorCode;

/**
 返回成功信息或网络错误信息
 */
@property (nonatomic, copy) NSString *errorMessage;

/**
 网络请求成功时返回的数据
 */
@property (nonatomic, strong) id errorData;

@property (nonatomic, strong) NSDictionary *resData;

/**
 有些平台（现金贷） 页码数据与data 同一层级
 */
@property (nonatomic, strong) NSDictionary *pageData;
/**
 创建RDAppError对象
 
 @param code code
 @param errorMessage 信息
 @param responseData 返回数据
 @return RDAppError对象
 */
- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                responseData:(id)responseData;


- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData;

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData pageData:(NSDictionary *)pageDic;
/**
 对网络请求进行封装，基本网络请求
 
 @param method 请求方式
 @param URL 请求地址
 @param parameters 参数
 @param errorDelegate 代理
 @param success 网络成功回调
 @param fail 网络失败回调
 */
+ (void)requestHTTPMethod:(RdAppServiceMethod)method
                      URL:(NSString *)URL
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                  success:(RDAppErrorSuccessBlock)success
                     fail:(RDAppErrorFailBlock)fail;

+ (void)requestHTTPMethod:(RdAppServiceMethod)method
                      URL:(NSString *)URL
         headerParameters:(NSDictionary *)headerParameters
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                  success:(RDAppErrorSuccessBlock)success
                     fail:(RDAppErrorFailBlock)fail;

/**
 返回不封装的结果数据
 
 @param method
 @param URL
 @param headerParameters
 @param parameters
 @param modelClass
 @param errorDelegate
 @param success
 @param fail
 */
+(void)requestWithoutWrapperHTTPMethod:(RdAppServiceMethod)method
                                   URL:(NSString *)URL
                      headerParameters:(NSDictionary *)headerParameters
                            parameters:(NSDictionary *)parameters
                            modelClass:(__unsafe_unretained Class)modelClass
                         errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                               success:(RDAppErrorSuccessBlock)success
                                  fail:(RDAppErrorFailBlock)fail;

/**
 对文件上传的网络请求进行封装
 
 @param URL 请求地址
 @param parameters 参数
 @param uploadFiles 文件数组
 @param modelClass 模型类名
 @param errorDelegate 代理
 @param progressCallBack 进度
 @param success 成功回调
 @param fail 失败回调
 */

+ (void)requestUploadWithUrl:(NSString *)URL
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<RdAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(RDAppErrorSuccessBlock)success
                        fail:(RDAppErrorFailBlock)fail;

+ (void)requestUploadWithUrl:(NSString *)URL
            headerParameters:(NSDictionary *)headerParameters
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<RdAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(RDAppErrorSuccessBlock)success
                        fail:(RDAppErrorFailBlock)fail;


+ (void)requestDownloadWithHTTPMethod:(RdAppServiceMethod)method
                                  URL:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                             progress:(RDAppErrorProgressBlock)progress
                          destination:(RDAppErrorDestinationBlock)destination
                              success:(RDAppErrorDownloadSuccess)success
                                 fail:(RDAppErrorFailBlock)fail;


+ (void)requestDownloadWithHTTPMethod:(RdAppServiceMethod)method
                                  URL:(NSString *)URL
                     headerParameters:(NSDictionary *)headerParameters
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                             progress:(RDAppErrorProgressBlock)progress
                          destination:(RDAppErrorDestinationBlock)destination
                              success:(RDAppErrorDownloadSuccess)success
                                 fail:(RDAppErrorFailBlock)fail;


@end

