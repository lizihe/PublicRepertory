//
//  HeaderTypeListScrollView.h
//  Pods
//
//  Created by cxk@erongdu.com on 16/10/27.
//
//

#import <UIKit/UIKit.h>

@interface HeaderTypeListScrollView : UIView

/**
 *  正常颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 *  选中颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 *  按钮字体
 */
@property (nonatomic, strong) UIFont *buttonTitleFont;

/**
 *  最小间隙
 */
@property (nonatomic, assign) CGFloat minSpace;

/**
 *  按钮数组
 */
@property (nonatomic, readonly) NSMutableArray<UIButton *> *buttons;

- (instancetype)initWithFrame:(CGRect)frame ButtonTitles:(NSArray *)buttonTitles;

/**
 *  选择指定按钮
 *
 *  @param index 按钮索引
 */
- (void)selectButtonAtIndex:(NSInteger)index;
@end
