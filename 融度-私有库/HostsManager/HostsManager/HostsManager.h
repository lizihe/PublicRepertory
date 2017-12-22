//
//  HostsManager.h
//  HostsChangeDemo
//
//  Created by Mr_zhaohy on 2017/11/9.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HostsUrl @"url"
#define DefaultHosts @"default"

@interface HostsManager : NSObject

@property (nonatomic,copy,readonly) NSString *currentHostsUrl;

@property (nonatomic,copy,readonly) NSArray *hostsArray;

+ (instancetype)shared;

- (void)addHostsUrl:(NSString *)url default:(BOOL)isDefault;

- (void)removeHostsUrl:(NSString *)url;
@end
