# RdAppService
===

## 简介
针对[AFNetworking3.0](https://github.com/AFNetworking/AFNetworking)进行简易的封装。

## 功能
* http的基本请求，GET，HEAD，POST，PATCH，DELETE
* 多文件上传
* 文件下载

## 版本
* 0.1.0 实现基本功能

## 安装

在Podfile中添加插件名称，在这之前先添加私有库Specs的地址

```ruby
source 'http://git....' #存放私有Specs仓库地址  
source 'https://github.com/CocoaPods/Specs.git'  #官方地址
```

```ruby
pod "RdAppService"
```

## 代码结构

* RdAppServiceConfig
	- RdAppServiceConfigArgumentsProtocol
* RdAppServiceAgent
	- RdAppServiceAgent+tool
* RdAppServiceArgumentsAttach
* RdAppServiceUploadFile  

RdAppServiceConfig是配置网络请求包含属性`useProductionServer`是否使用生产环境，默认是YES，`requestTimeoutInterval`请求超时间，默认是20s，`securityPolicy`安全策略默认是无，是用于Https和SSL。

暴露的API方法


	//创建单例
	+ (instancetype)sharedInstance;
	//将当前使用的地址(判断useProductionServer获取使用地址)跟path拼接成完整的URL
	- (NSString *)baseURLWithPath:(NSString *)path;
	- (NSString *)CDNURLWithPath:(NSString *)path;
	- (NSString *)extraURLWithPath:(NSString *)path;

`<RdAppServiceConfigArgumentsProtocol>`协议是实现添加公共参数的协议，在header和body中添加公共参数。RdAppServiceArgumentsAttach类是实现该协议的类。


	- (NSDictionary *)rdAppServiceBodyArgumentsAttach:(NSDictionary *)sourceBody;
	- (NSDictionary *)rdAppServiceHeaderArgumentsAttach:(NSDictionary *)sourceHeader;


RdAppServiceArgumentsAttach实现`<RdAppServiceConfigArgumentsProtocol>`中的方法,rdAppServiceBodyArgumentsAttach中附加了`appkey`,`ts`,`signa`,`versionNumber`,`mobileType`。rdAppServiceHeaderArgumentsAttach未添加key，只是传入什么就传出什么。


RdAppServiceAgent实现基本方法，包括基本请求，下载文件，上传多文件功能。

RdAppServiceUploadFile文件上传需要使用的类属性有`fileURL`,`name`,`filename`,`mimeType`。`fileURL`是文件路径，`name`文件上传的参数名，`filename`是上传文件名，`mimeType`是文件类型。

如：Content-Disposition: file; filename=#{generated filename}; name=#{name}


## 使用方法

在application:didFinishLaunchingWithOptions中实现如下



	//使用测试环境
    [RdAppServiceAgent shareService].defaultConfig.useProductionServer = NO;
    //测试环境地址
    [RdAppServiceAgent shareService].defaultConfig.testBaseURL = @"http://httpbin.org/";
    //正式环境地址
    [RdAppServiceAgent shareService].defaultConfig.baseURL = @"http://httpbin.org/";
    //创建附加参数对象
    RdAppServiceArgumentsAttach *comment = [[RdAppServiceArgumentsAttach alloc] init];
    comment.appKey = @"8RIcXM2uEjhKbnwEx7JWtQ==";
    comment.appSecret = @"WOYNpJVTGEaXkIdwrQUd8A==";
    //添加
    [RdAppServiceAgent shareService].defaultConfig.commentArguments = comment;
    
 网络基本请求
 
 	[[RdAppServiceAgent shareService] appDataTaskWithHTTPMethod:RdAppServiceMethodGET 	URLString:[[RdAppServiceConfig sharedInstance] baseURLWithPath:@"get"] parameters:@{} 	headerParamters:nil success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
    }];
    
下载文件

	[[RdAppServiceAgent shareService] appDownloadTaskWithHTTPMethod:RdAppServiceMethodGET URLString:[[RdAppServiceConfig sharedInstance] baseURLWithPath:@"image/svg"]  parameters:@{} progress:^(NSProgress *downloadProgress) {
	//回到是在主线程中，所以操作都放在异步线程中
        dispatch_sync(dispatch_get_main_queue(), ^{
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
    	 //创建文件地址
    	 targetPath = [NSURL fileURLWithPath:文件地址]; 
         return targetPath;
    } success:^(NSURLSessionDownloadTask *task, NSURLResponse *response) {
    } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
    }];

