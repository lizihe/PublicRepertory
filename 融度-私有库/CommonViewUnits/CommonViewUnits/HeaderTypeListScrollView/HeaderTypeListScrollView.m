//
//  HeaderTypeListScrollView.m
//  Pods
//
//  Created by cxk@erongdu.com on 16/10/27.
//
//

#import "HeaderTypeListScrollView.h"
#import <Masonry/Masonry.h>


@implementation NSString (StringSize)

- (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)size
{
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName:font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)sizeWithString:(NSString*)str font:(UIFont*)font maxSize:(CGSize)size{
    NSDictionary*attrs =@{NSFontAttributeName:font};
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs  context:nil].size;
}
@end

@interface HeaderTypeListScrollView ()

/**
 *  按钮标题数组
 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;

/**
 *  所以按钮文字宽度总和
 */
@property (nonatomic, assign) CGFloat totalButtonWidth;

/**
 *  放内容
 */
//@property (nonatomic, strong) UIView *contentView;

/**
 *  当前间隙
 */
@property (nonatomic, assign) CGFloat currentSpace;


@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  选中索引
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 *  底部线条
 */
@property (nonatomic, strong) UIView *bottomLine;

/**
 *  选择线条
 */
@property (nonatomic, strong) UIView *selectLint;

@end

@implementation HeaderTypeListScrollView

- (instancetype)initWithFrame:(CGRect)frame ButtonTitles:(NSArray *)buttonTitles
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = UIScrollView.new;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.delaysContentTouches = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        
        _selectLint = [UIView new];
        [self addSubview:_selectLint];
        //添加约束
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
//        [_scrollView addSubview:_contentView];
        
//        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_scrollView);
//            make.height.equalTo(_scrollView);
//        }];
        
        [self addSubview:_bottomLine];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        _buttonTitles = [NSMutableArray arrayWithArray:buttonTitles];
        _buttons = [NSMutableArray arrayWithCapacity:0];
        
        _totalButtonWidth = 0;
        _minSpace = 30;
        _currentSpace = 0;
        _selectIndex = -1;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [self createButtons];
}

- (void)layoutSubviews
{
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
}

- (void)createButtons
{
    //创建button
    for (NSUInteger i = 0; i<_buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        [button setTitle:_buttonTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = _buttonTitleFont;
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
        
        _totalButtonWidth = _totalButtonWidth + [_buttonTitles[i] sizeWithFont:_buttonTitleFont maxSize:self.frame.size].width;
        
        [_scrollView addSubview:button];
    }
    
        //默认选中第一个
    UIButton *button = _buttons[0];
    button.selected = YES;
    _selectIndex = 0;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    _selectLint.backgroundColor = selectedColor;
    for (UIButton *button in _buttons) {
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    for (UIButton *button in _buttons) {
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
    }
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont
{
    _buttonTitleFont = buttonTitleFont;
    for (UIButton *button in _buttons) {
        button.titleLabel.font = _buttonTitleFont;
    }
}

- (void)selectButton:(UIButton *)button
{
    if (_selectIndex == -1 ||_selectIndex > _buttons.count) {
        _selectIndex = [_buttons indexOfObject:button];
        button.selected = YES;
    }
    else
    {
        if (_selectIndex < _buttons.count) {
            UIButton *lastButton = [_buttons objectAtIndex:_selectIndex];
            lastButton.selected = NO;
            
            _selectIndex = [_buttons indexOfObject:button];
            button.selected = YES;
            [self scrollToButton:button];
            //更新约束
            UIButton *button = _buttons[_selectIndex];
            [_selectLint mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(button.mas_bottom).offset(-2);
                make.left.equalTo(button.titleLabel.mas_left).offset(-5);
                make.right.equalTo(button.titleLabel.mas_right).offset(5);
                make.height.equalTo(@1);
            }];
            
            [UIView animateWithDuration:0.4 animations:^{
                [self layoutIfNeeded];
            }];
        }
    }
}

- (void)selectButtonAtIndex:(NSInteger)index
{
    if(index >=0 && index<_buttons.count)
    {
        UIButton *button = _buttons[index];
        [self selectButton:button];
    }
}
//重写父类方法
- (void)updateConstraints
{
    UIButton *lastButton;
    //获取合适间隙
    CGFloat space;
    if ((self.frame.size.width - _totalButtonWidth)/_buttons.count > _minSpace) {
        space = (self.frame.size.width - _totalButtonWidth)/_buttons.count;
    }
    else
    {
        space = _minSpace;
    }
    
    //间距不改变的情况下
    if (_currentSpace != space) {
        _currentSpace = space;
        //添加约束
        for (UIButton *button in _buttons) {
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButton?lastButton.mas_right:@0);
                make.top.equalTo(self);
                make.bottom.equalTo(self);
                make.width.equalTo(@(_currentSpace + [button.titleLabel.text sizeWithFont:_buttonTitleFont maxSize:self.frame.size].width));
            }];
            lastButton =  button;
        }
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastButton);
        }];
        
        UIButton *button = _buttons[_selectIndex];
        [_selectLint mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button.mas_bottom).offset(-1.5);
            make.left.equalTo(button.titleLabel.mas_left).offset(-5);
            make.right.equalTo(button.titleLabel.mas_right).offset(5);
            make.height.equalTo(@1);
        }];
    }
    [super updateConstraints];
}

- (void)scrollToButton:(UIButton *)button
{
    //当前偏移量
    CGFloat offsetX = _scrollView.contentOffset.x;
    //scrollview的X
    CGFloat scrollCenterX = _scrollView.center.x;
    //scrollview的width
    CGFloat scrollWidth = _scrollView.frame.size.width;
    //ContentSize的With
    CGFloat contentSizeWidth = _scrollView.contentSize.width;
    //button的x
    CGFloat buttonX = button.frame.origin.x;
    //button的centerX
    CGFloat buttonCenterX = button.center.x;
    //需要偏移距离
    CGFloat needOffsetX = buttonCenterX - offsetX - scrollCenterX;
    //右边可移动距离
    CGFloat canOffsetX = contentSizeWidth - offsetX - scrollWidth;
    
    //往左移
    if (needOffsetX > 0)
    {
        CGFloat moveLength = MIN(ABS(needOffsetX), ABS(canOffsetX));
        [_scrollView setContentOffset:CGPointMake(offsetX + moveLength, 0) animated:YES];
    }
    //往右移
    else
    {
        CGFloat moveLength = MIN(ABS(needOffsetX), ABS(offsetX));
        [_scrollView setContentOffset:CGPointMake(offsetX - moveLength, 0) animated:YES];
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



