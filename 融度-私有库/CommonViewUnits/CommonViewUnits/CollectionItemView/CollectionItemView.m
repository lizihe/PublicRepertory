//
//  CollectionItemView.m
//  Pods
//
//  Created by Mr_zhaohy on 2016/10/20.
//
//

#import "CollectionItemView.h"
#import <Masonry/Masonry.h>

#define BottomCell @"BottomCell"

#define CellSubview_Offset 5

@interface CollectionItemCell ()

@property (nonatomic, strong) UIView *view;

@end

@implementation CollectionItemCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
    
    return self;
}
-(void)initSubviews{
    _view = [UIView new];
    [_view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_view addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_view addSubview:_titleLabel];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_view);
        make.centerX.equalTo(_view.mas_centerX);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_view);
        make.top.equalTo(_imageView.mas_bottom).offset(5);
        make.centerX.equalTo(_view);
    }];
    
    [self.contentView addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView).priorityMedium;
    }];
}

-(void)setupTitle:(NSString *)title image:(UIImage *)image titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont
{
    self.titleLabel.text = title;
    self.imageView.image = image;
    self.titleLabel.textColor = titleColor;
    self.titleLabel.font = titleFont;
}
@end

@interface CollectionItemView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}
@end

@implementation CollectionItemView

-(instancetype)initWithTitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont
{
    self = [super init];
    if (self) {
        _titleColor = titleColor;
        _titleFont = titleFont;
        //未设置列数，默认3列
        _column = _column <= 0 ? 3 : _column;
        
        [self initCollectionView];
    }
    return self;
}


-(void)initCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //初始化layout
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    //去掉左部和底部线条
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    //禁止滑动
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = self.backgroundColor;
    
    _collectionView.dataSource = self;
    _collectionView.delegate  = self;
    
    [_collectionView registerClass:[CollectionItemCell class] forCellWithReuseIdentifier:BottomCell];
    
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
    _viewBackgroundColor = viewBackgroundColor;
    self.backgroundColor = viewBackgroundColor;
    _collectionView.backgroundColor = viewBackgroundColor;
}

-(void)setItemArray:(NSMutableArray *)itemArray
{
    _itemArray = itemArray;
    [_collectionView reloadData];
    
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BottomCell forIndexPath:indexPath];
    
    [cell setupTitle:_itemArray[indexPath.row][0] image:_itemArray[indexPath.row][1] titleColor:_titleColor titleFont:_titleFont];
    
    return cell;
}
#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //每个item的大小（根据设定的列数布局）
    CGFloat width = self.bounds.size.width/self.column - (1.0 / self.column * 2.0);
    CGFloat height = self.bounds.size.height/(_itemArray.count%self.column > 0 ? _itemArray.count/self.column + 1:_itemArray.count/self.column);
    return CGSizeMake(width,height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate)
    {
        [_delegate CollectionItemView:self didSelectedCell:[collectionView cellForItemAtIndexPath:indexPath] indexPath:indexPath];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

