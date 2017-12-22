//
//  HostsManager.m
//  HostsChangeDemo
//
//  Created by Mr_zhaohy on 2017/11/9.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import "HostsManager.h"

#define HostsUrl @"url"
#define DefaultHosts @"default"
#define Hosts @"hosts"

@interface HostsManager(){
    NSMutableArray *_hosts;
}
@end

static HostsManager *manager = nil;
@implementation HostsManager
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HostsManager alloc]init];
        [manager loadUrl];
    });
    return manager;
}

-(NSString *)currentHostsUrl{
    for (NSDictionary *tmpDic in _hosts) {
        if ([tmpDic[DefaultHosts] boolValue]) {
            return tmpDic[HostsUrl];
        }
    }
    return  @"";
}
-(void)addHostsUrl:(NSString *)url default:(BOOL)isDefault{
    if (!_hosts) {
        _hosts = [NSMutableArray arrayWithCapacity:0];
    }
    //防止遍历异常
    NSMutableArray *array = [NSMutableArray arrayWithArray:_hosts];
    for (NSDictionary *tmpDic in array) {
        if ([tmpDic[HostsUrl] isEqualToString:url]) {
            [_hosts removeObjectAtIndex:[_hosts indexOfObject:tmpDic]];
        }
    }
    
    if (isDefault) {
        array = [NSMutableArray arrayWithArray:_hosts];
        for (NSDictionary *tmpDic in array) {
            if ([tmpDic[DefaultHosts] boolValue]) {
                [_hosts replaceObjectAtIndex:[_hosts indexOfObject:tmpDic] withObject:@{HostsUrl:tmpDic[HostsUrl],DefaultHosts:@(NO)}];
            }
        }
    }
    //将第一条设置为默认
    if (!_hosts.count) {
        isDefault = YES;
    }
    [_hosts insertObject:@{HostsUrl:url,DefaultHosts:@(isDefault)} atIndex:0];
    [self save];
}

-(void)removeHostsUrl:(NSString *)url{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_hosts];
    for (NSDictionary *tmpDic in array) {
        if ([tmpDic[HostsUrl] isEqualToString:url]) {
            [_hosts removeObjectAtIndex:[_hosts indexOfObject:tmpDic]];
        }
    }
    [self save];

}
-(NSArray *)hostsArray{
    return _hosts;
}
-(void)save{
    [[NSUserDefaults standardUserDefaults] setObject:_hosts forKey:Hosts];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)loadUrl{
    NSArray  *array = [[NSUserDefaults standardUserDefaults] objectForKey:Hosts];
    _hosts = [array mutableCopy];
}

@end
