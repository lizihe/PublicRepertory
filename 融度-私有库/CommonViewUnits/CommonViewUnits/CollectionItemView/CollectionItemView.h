//
//  CollectionItemView.h
//  Pods
//
//  Created by Mr_zhaohy on 2016/10/20.
//
//

#import <UIKit/UIKit.h>

@class CollectionItemView,CollectionItemCell;

@protocol CollectionItemViewDelegate <NSObject>
/**
 *  选中item
 *
 *  @param view      CollectionItemView
 *  @param item      选中的<CollectionItemCell>item
 *  @param indexPath 选中的索引
 */
-(void)CollectionItemView:(CollectionItemView *)view didSelectedCell:(CollectionItemCell *)item indexPath:(NSIndexPath *)indexPath;

@end

@interface CollectionItemView : UIView

/**
 标题字体颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 背景色
 */
@property (nonatomic, strong) UIColor *viewBackgroundColor;

@property (retain,nonatomic) id <CollectionItemViewDelegate> delegate;
/**
 *  九宫格配置数组
 *  格式:@[@[@"标题1",@"图片名1"],@[@"标题2",@"图片名2"],...]
 */
@property (nonatomic,strong) NSMutableArray *itemArray;
/**
 *  列数
 *  default is 3
 */
@property (assign,nonatomic) int column;

-(instancetype)initWithTitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;

@end

@interface CollectionItemCell : UICollectionViewCell
/**
 *  标题
 */
@property (strong,nonatomic) UILabel *titleLabel;
/**
 *  图片
 */
@property (strong,nonatomic) UIImageView *imageView;
/**
 *  设置cell的标题和图片
 *
 *  @param title 标题
 *  @param image 图片
 */
-(void)setupTitle:(NSString *)title image:(UIImage *)image titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;

@end
