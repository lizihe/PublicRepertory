//
//  LGAlertPasswordView.h
//  Pods
//
//  Created by cxk@erongdu.com on 2016/12/20.
//
//

#import <UIKit/UIKit.h>

@class LGAlertPasswordView;

@protocol LGAlertPasswordViewDelegate <NSObject>

@optional

/**
 *  监听输入的改变
 */
- (void)passwordDidChange:(LGAlertPasswordView *)passwordView;

/**
 *  监听输入的完成时
 */
- (void)passwordCompleteInput:(LGAlertPasswordView *)passwordView;

/**
 *  监听开始输入
 */
- (void)passwordBeginInput:(LGAlertPasswordView *)passwordView;

@end
@interface LGAlertPasswordView : UIView<UIKeyInput>

/**
 密码位数
 */
@property (nonatomic, assign) NSUInteger passwordCount;

/**
 边框颜色
 */
@property (nonatomic, strong) UIColor *rectBorderColor;

/**
 输入的字符串
 */
@property (nonatomic, readonly) NSString *inputCode;

/**
 代理
 */
@property (nonatomic, weak)id<LGAlertPasswordViewDelegate> delegate;

@end
