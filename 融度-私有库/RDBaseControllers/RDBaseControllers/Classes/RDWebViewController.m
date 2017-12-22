//
//  RDWebViewController.m
//  Pods
//
//  Created by cxk@erongdu.com on 2017/1/11.
//
//

#import "RDWebViewController.h"
#import <Masonry/Masonry.h>

static NSString const * htmlTitle = @"document.title";


@interface RDWebViewController ()<WKNavigationDelegate>

/**
 进度条
 */
@property (nonatomic, strong) UIProgressView * loadProgressView;

/**
 是否已post请求
 */
@property (nonatomic, assign) BOOL didPostRequest;

/**
 记录请求，刷新用
 */
@property (nonatomic, strong) NSURLRequest *temRequest;

@end

@implementation RDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _didPostRequest = NO;
    //创建web
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    //添加观察者
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:_wkWebView];
    
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
    
    if (_method == RDWebViewSendMethodGET) {
        
        // 绘制loadProgressView
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height, navigationBarBounds.size.width, progressBarHeight);
        
        
        _loadProgressView = [[UIProgressView alloc] initWithFrame:barFrame];// CGRectMake(0, 100, 375, 2)
        
        // [self.view addSubview:self.myProgressView];
        [self.view addSubview:_loadProgressView];
        
        
        [_loadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@2);
        }];
        
        [self changeShowView:_wkWebView progressView:_loadProgressView];
        NSMutableURLRequest *request;
        if (_standardUrl) {
            //请求
            NSURLComponents *components = [NSURLComponents componentsWithString:_url];
            NSMutableArray *queryItems = [NSMutableArray array];
            for (NSString *key in _param) {
                NSObject *object = _param[key];
                if ([object isKindOfClass:[NSString class]]) {
                    [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:_param[key]]];
                }
                else
                {
                    [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@",object]]];
                }
            }
            //添加之前的参数
            [queryItems addObjectsFromArray:components.queryItems];
            components.queryItems = queryItems;
            
            //创建完整url
            request = [NSMutableURLRequest requestWithURL:components.URL];
        }
        else
        {
            //为了解决请求连接中 包含 # 符号，导致的url异常，使用以下拼接方法
            NSMutableString *mstr = [NSMutableString stringWithString:@""];
            if (![_url containsString:@"?"]) {
                
                mstr = [NSMutableString stringWithString:@"?"];
                
                [_param enumerateKeysAndObjectsUsingBlock:^(id key ,id obj , BOOL *pStop ) {
                    [mstr appendFormat:@"%@=%@&",key,obj];
                    *pStop = NO;
                }];
            }
            //不进入 上面的判断条件，认为是 url 所有的参数都是自己拼接好穿进来的
            if (mstr.length > 0) {
                NSString *last = [mstr substringFromIndex:mstr.length-1];
                if ([last isEqualToString:@"&"]) {
                    [mstr deleteCharactersInRange:NSMakeRange(mstr.length - 1, 1)];
                }
            }
            
            NSString *requestUrl = [NSString stringWithFormat:@"%@%@",_url,mstr];
            //创建完整url
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        }
        if (_headerParam) {
            [_headerParam enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [request setValue:obj forHTTPHeaderField:key];
            }];
        }
        _temRequest = request;
        [_wkWebView loadRequest:request];
    }
    else
    {
        // 设置访问的URL
        NSURL *url = [NSURL URLWithString:_url];
        // 根据URL创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        // 设置请求方法为POST
        [request setHTTPMethod:@"POST"];
        // 设置请求参数
        NSData *data =    [NSJSONSerialization dataWithJSONObject:_param options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:data];
        
        // 实例化网络会话
        NSURLSession *session = [NSURLSession sharedSession];
        // 创建请求Task
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            // 将请求到的网页数据用loadHTMLString 的方法加载
            NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [_wkWebView loadHTMLString:htmlStr baseURL:nil];
        }];
        // 开启网络任务
        [task resume];
    }
    
    
}

- (void)postRequest:(NSString *)postData
{
    NSString *postJSString = [NSString stringWithFormat:@"post('%@', {%@});", _url, postData];
    [_wkWebView evaluateJavaScript:postJSString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
    }];
    _didPostRequest = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 刷新网页
 */
-(void)needRefreshWebView
{
    [_wkWebView loadRequest:_temRequest];
    //    [_wkWebView reload];
}

- (void)dealloc {
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [_wkWebView setNavigationDelegate:nil];
    [_wkWebView setUIDelegate:nil];
}

#pragma mark -需要重写

- (void)changeShowView:(WKWebView *)webview progressView:(UIProgressView *)progressView
{
    
}
#pragma mark -WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if(_isShowTitle)
    {
        self.title = webView.title;
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 处理拨打电话
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == _wkWebView) {
        [_loadProgressView setAlpha:1.0f];
        [_loadProgressView setProgress:_wkWebView.estimatedProgress animated:YES];
        
        if(_wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_loadProgressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [_loadProgressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

