//
//  RDViewController.h
//  demoapp
//
//  Created by Liang Shen on 16/3/23.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDViewController;
@protocol RDViewControllerDelegate <NSObject>
/**
 *  重新请求
 */
-(void) requestNow;

@end

@interface RDViewController : UIViewController

#pragma mark -Need Overwriting

/**
 RDViewController进行DidLoad时，调用设置显示属性，子类需重写该方法
 */
- (void)viewControllerDidLoad;

@property (nonatomic , assign) id<RDViewControllerDelegate> RDViewControllerDelegate;

/**
 *  展现无网络视图
 */
-(void) showNetworkProblemView;

/**
 *  移除无网络视图
 */
-(void)dismissNetwrokProblemView;


@end
