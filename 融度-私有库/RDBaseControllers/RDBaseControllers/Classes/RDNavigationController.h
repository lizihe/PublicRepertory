//
//  RDNavigationController.h
//  demoapp
//
//  Created by Liang Shen on 16/3/21.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDNavigationController : UINavigationController

/**
 返回按钮图片
 */
@property (nonatomic, strong) UIImage *backButtonItemImage;

#pragma mark -Need Overwriting

/**
 navigationViewController进行DidLoad时，调用设置显示属性，子类需重写该方法
 */
- (void)navigationViewDidLoad;


#pragma mark -API
/**
 *  透明导航栏，默认字体白色
 */
- (void)showClearNavigationBar;
/**
 *  修改导航栏背景色
 *
 *  @param color       颜色
 *  @param tintColor   字体颜色
 *  @param translucent 是否半透明
 */
- (void)showImageColorNavigationBarBackground:(UIColor *)color textTintColor:(UIColor *)tintColor isTranslucent:(BOOL)translucent;
/**
 *  显示默认导航栏
 *
 *  @param tintColor 字体颜色
 */
- (void)showNormalNavigationBarTintColor:(UIColor *)tintColor;

/**
 *  设置NavigationBar的背景图片
 *
 *  @param bgImage 图片
 */
- (void)setNavigationBarBackgroundImage:(UIImage *)bgImage;

/**
 *  添加线条
 */
- (void)addNormalShadowImage;

/**
 *  去除底部线条
 */
- (void)removeShadowImage;


@end
