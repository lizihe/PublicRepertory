//
//  CustomHostsView.h
//  HostsChangeDemo
//
//  Created by Mr_zhaohy on 2017/11/9.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CustomHostsViewDelegate <NSObject>
/**
 设置默认地址

 @param url 地址
 */
-(void)setDefaultWithUrl:(NSString *)url;
/**
 消失
 */
-(void)customHostsViewDismiss;

@end


@interface CustomHostsView : UIView

@property (nonatomic,retain) id<CustomHostsViewDelegate> delegate;

/**
 显示
 */
- (void)show;

/**
 消失
 */
- (void)dismiss;

-(instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
