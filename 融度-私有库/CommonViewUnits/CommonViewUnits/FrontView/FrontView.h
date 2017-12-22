//
//  FrontView.h
//  test
//
//  Created by Mr_zhaohy on 2017/3/1.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 动画类型

 - ForntViewAnimationTypeNone: 无
 - ForntViewAnimationTypeGradual: 渐变
 - ForntViewAnimationTypeFromLeft: 左侧划出/划入
 - ForntViewAnimationTypeFromRight: 右侧划出/划入
 - ForntViewAnimationTypeFromTop: 顶部划出/划入
 - ForntViewAnimationTypeFromBottom: 底部划出/划入
 - ForntViewAnimationTypeFromCenter: 中间展开/关闭
 */
typedef NS_ENUM(NSInteger,ForntViewAnimationType) {
    ForntViewAnimationTypeNone = 0,
    ForntViewAnimationTypeGradual = 1,
    ForntViewAnimationTypeFromLeft = 2,
    ForntViewAnimationTypeFromRight = 3,
    ForntViewAnimationTypeFromTop = 4,
    ForntViewAnimationTypeFromBottom = 5,
    ForntViewAnimationTypeFromCenter = 6
};
@class FrontView;
@protocol FrontViewDelegate <NSObject>

/**
 点击当前page

 @param frontView FrontView
 @param currentPage 当前页
 @param last 是否最后一页
 */
-(void)frontView:(FrontView *)frontView clickedPage:(NSInteger)currentPage isLastPage:(BOOL)last;

/**
 点击跳过按钮

 @param frontView FrontView
 */
-(void)clickButtonInFrontView:(FrontView *)frontView;

/**
 倒计时结束

 @param frontView FrontView
 */
-(void)countdownDidEndOfFrontView:(FrontView *)frontView;

/**
 滚动到某个页面

 @param frontView FrontView
 @param currentPage 当前页
 */
-(void)frontView:(FrontView *)frontView didScrollToPage:(NSInteger)currentPage isLastPage:(BOOL)last;

@end
@interface FrontView : UIView

@property(nonatomic,strong) UIButton *skipButton;

@property (nonatomic,retain) id <FrontViewDelegate> delegate;
//页面指示器
@property (nonatomic,strong) UIPageControl *pageControl;

/**
 本地图片名 @[@"name_1",@"name_2"]
 */
@property (nonatomic,strong) NSArray <NSString *> *imagesName;

/**
 远程图片地址 @[url_1,url_2]

 */
@property (nonatomic,strong) NSArray <NSURL *> *imagesURL;

/**
 展示页面指示器  default: YES
 */
@property (nonatomic,assign) BOOL showPageControl;

/**
 当前页
 */
@property (nonatomic,assign,readonly) BOOL currentPage;

/**
 自动消失动画
 */
@property (nonatomic,assign) ForntViewAnimationType autoDismissAnimation;

/**
 设置倒计时

 @param countdown 倒计时
 @param duration 时长
 */
-(void)showCountdown:(BOOL)countdown duration:(double)duration;

/**
 展示
  */
-(void)show;

/**
 消失

 @param animation 动画
 */
-(void)dismiss:(ForntViewAnimationType)animation;
@end
