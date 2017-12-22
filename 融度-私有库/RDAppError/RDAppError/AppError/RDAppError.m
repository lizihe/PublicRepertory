//
//  RDAppError.m
//  Pods
//
//  Created by cxk@erongdu.com on 2016/11/23.
//
//

#import "RDAppError.h"

@implementation RDAppError

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                responseData:(id)responseData
{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _errorData = responseData;
    }
    return self;
}

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData
{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _resData = resData;
    }
    return self;
}

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData pageData:(NSDictionary *)pageDic
{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _resData = resData;
        _pageData = pageDic;
    }
    return self;
}



+ (void)requestHTTPMethod:(RdAppServiceMethod)method
                      URL:(NSString *)URL
         headerParameters:(NSDictionary *)headerParameters
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                  success:(RDAppErrorSuccessBlock)success
                     fail:(RDAppErrorFailBlock)fail
{
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建RDAppError对象
    __block RDAppError *appError;
    
    //请求网络
    [[RdAppServiceAgent shareService] appDataTaskWithHTTPMethod:method URLString:URL parameters:parameters headerParamters:headerParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功处理
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(successRDAppErrorWithResponseObject:)])
        {
            appError = [errorDelegate successRDAppErrorWithResponseObject:responseObject];
        }
        id object;
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(isResponseCanConvert:)])
        {
            if ([errorDelegate isResponseCanConvert:appError]) {
                //封装模型
                if (errorDelegate && [errorDelegate respondsToSelector:@selector(response:convertToModelClass:appError:)]) {
                    object = [errorDelegate response:responseObject convertToModelClass:modelClass appError:appError];
                }
            }
        }
        
        if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
        {
            [errorDelegate unifiedTreatmentAppError:appError];
        }
        success(task, appError, object);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //错误处理
        if ([errorDelegate respondsToSelector:@selector(failRDAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failRDAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }
        fail(task, appError);
    }];
    
}


+(void)requestWithoutWrapperHTTPMethod:(RdAppServiceMethod)method
                                   URL:(NSString *)URL
                      headerParameters:(NSDictionary *)headerParameters
                            parameters:(NSDictionary *)parameters
                            modelClass:(__unsafe_unretained Class)modelClass
                         errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                               success:(RDAppErrorSuccessBlock)success
                                  fail:(RDAppErrorFailBlock)fail
{
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建RDAppError对象
    __block RDAppError *appError;
    
    //请求网络
    [[RdAppServiceAgent shareService] appDataTaskWithHTTPMethod:method URLString:URL parameters:parameters headerParamters:headerParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功处理
        
        id object = responseObject;
        
        success(task, nil, object);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //错误处理
        if ([errorDelegate respondsToSelector:@selector(failRDAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failRDAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }
        fail(task, appError);
    }];
}

+ (void)requestHTTPMethod:(RdAppServiceMethod)method
                      URL:(NSString *)URL
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                  success:(RDAppErrorSuccessBlock)success
                     fail:(RDAppErrorFailBlock)fail
{
    [RDAppError requestHTTPMethod:method
                              URL:URL
                 headerParameters:nil
                       parameters:parameters
                       modelClass:modelClass
                    errorDelegate:errorDelegate
                          success:success
                             fail:fail];
}


+ (void)requestUploadWithUrl:(NSString *)URL
            headerParameters:(NSDictionary *)headerParameters
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<RdAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(RDAppErrorSuccessBlock)success
                        fail:(RDAppErrorFailBlock)fail

{
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建RDAppError对象
    __block RDAppError *appError;
    
    [[RdAppServiceAgent shareService] appUploadTaskWithURLString:URL parameters:parameters headerParamters:headerParameters uploadFiles:uploadFiles progress:^(NSProgress *uploadProgress) {
        progressCallBack(uploadProgress);
    } success:^(NSURLSessionUploadTask *task, id responseObject) {
        //成功处理
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(successRDAppErrorWithResponseObject:)])
        {
            appError = [errorDelegate successRDAppErrorWithResponseObject:responseObject];
        }
        id object;
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(isResponseCanConvert:)])
        {
            if ([errorDelegate isResponseCanConvert:appError]) {
                //封装模型
                if (errorDelegate && [errorDelegate respondsToSelector:@selector(response:convertToModelClass:appError:)]) {
                    object = [errorDelegate response:responseObject convertToModelClass:modelClass appError:appError];
                }
            }
        }
        
        if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
        {
            [errorDelegate unifiedTreatmentAppError:appError];
        }
        success(task, appError, object);
    } failure:^(NSURLSessionUploadTask *task, NSError *error) {
        //错误处理
        if ([errorDelegate respondsToSelector:@selector(failRDAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failRDAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }
        fail(task, appError);
        
    }];
    
}


+ (void)requestUploadWithUrl:(NSString *)URL
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<RdAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(RDAppErrorSuccessBlock)success
                        fail:(RDAppErrorFailBlock)fail
{
    [RDAppError requestUploadWithUrl:URL headerParameters:nil parameters:parameters uploadFiles:uploadFiles modelClass:modelClass errorDelegate:errorDelegate progress:progressCallBack success:success fail:fail];
}


+ (void)requestDownloadWithHTTPMethod:(RdAppServiceMethod)method
                                  URL:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                             progress:(RDAppErrorProgressBlock)progress
                          destination:(RDAppErrorDestinationBlock)destination
                              success:(RDAppErrorDownloadSuccess)success
                                 fail:(RDAppErrorFailBlock)fail
{
    [RDAppError requestDownloadWithHTTPMethod:method
                                          URL:URL headerParameters:nil
                                   parameters:parameters
                                errorDelegate:errorDelegate
                                     progress:progress
                                  destination:destination
                                      success:success
                                         fail:fail];
}


+ (void)requestDownloadWithHTTPMethod:(RdAppServiceMethod)method
                                  URL:(NSString *)URL
                     headerParameters:(NSDictionary *)headerParameters
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<RDAppErrorDelegate>)errorDelegate
                             progress:(RDAppErrorProgressBlock)progress
                          destination:(RDAppErrorDestinationBlock)destination
                              success:(RDAppErrorDownloadSuccess)success
                                 fail:(RDAppErrorFailBlock)fail
{
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建RDAppError对象
    __block RDAppError *appError;
    
    [[RdAppServiceAgent shareService] appDownloadTaskWithHTTPMethod:method URLString:URL parameters:parameters headerParamters:headerParameters progress:^(NSProgress *downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return destination(targetPath, response);
    } success:^(NSURLSessionDownloadTask *task, NSURLResponse *response) {
        success(task, response);
    } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
        if ([errorDelegate respondsToSelector:@selector(failRDAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failRDAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }
        fail(task, appError);
    }];
}
@end
