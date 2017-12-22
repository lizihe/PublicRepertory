//
//  FrontView.m
//  test
//
//  Created by Mr_zhaohy on 2017/3/1.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import "FrontView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define HEIGHTOFSCREEN [[UIScreen mainScreen] bounds].size.height
#define WIDTHOFSCREEN [[UIScreen mainScreen] bounds].size.width

@interface FrontView ()<UIScrollViewDelegate>
{
    UIWindow *_window;
    UIScrollView *_scrollView;
    NSTimer *_timer;
    //持续时间
    double _duration;
    //图片数据
    NSMutableArray <UIImageView *> *_imagesArray;
    //当前页
    NSInteger _page;
}
@end
@implementation FrontView
-(instancetype)init{
    self = [super init];
    _window = [UIApplication sharedApplication].keyWindow;
    _page = 0;
    //设置默认显示分页指示器
    _showPageControl = YES;
    return self;
}
-(void)createSubViews{
    //初始化scrollView
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(WIDTHOFSCREEN, HEIGHTOFSCREEN);
    //开启分页
    _scrollView.pagingEnabled = YES;
    //关闭回弹
    _scrollView.bounces = NO;
    //隐藏容量指示线
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //初始化分页指示器
    _pageControl = [[UIPageControl alloc]init];
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-15);
    }];
    
    //初始化跳过按钮
    _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //按钮背景颜色
    [_skipButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [_skipButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    _skipButton.clipsToBounds = YES;
    _skipButton.layer.cornerRadius = 8;
    [_skipButton setTitle:@" 跳过 " forState:UIControlStateNormal];
    //默认不显示按钮
    _skipButton.hidden = YES;
    [self addSubview:_skipButton];
    [_skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.right.equalTo(self).offset(-20);
    }];
}
-(void)createImageView{
    UIImageView *imageView;

    if (self.imagesName.count) {
        //绑定数组数据
        _pageControl.numberOfPages = self.imagesName.count;
        //设置容量
        _scrollView.contentSize = CGSizeMake((WIDTHOFSCREEN)*self.imagesName.count, HEIGHTOFSCREEN);
       
        _imagesArray = [NSMutableArray arrayWithCapacity:0];
        //创建imageView
        for (NSString *named in self.imagesName) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:named]];
            [_scrollView addSubview:imageView];

            //添加手势
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            
            [_imagesArray addObject:imageView];

            NSInteger index = [self.imagesName indexOfObject:named];
            imageView.tag = index;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(WIDTHOFSCREEN, HEIGHTOFSCREEN));
                make.left.equalTo(_scrollView).offset(WIDTHOFSCREEN*index);
                make.top.equalTo(_scrollView);
            }];
        }
    }
    else if(self.imagesURL.count){
        //绑定数组数据
        _pageControl.numberOfPages = self.imagesURL.count;
        //设置容量
        _scrollView.contentSize = CGSizeMake((WIDTHOFSCREEN)*self.imagesURL.count, HEIGHTOFSCREEN);

        _imagesArray = [NSMutableArray arrayWithCapacity:0];
        //创建imageView
        for (NSURL *url in self.imagesURL) {
            imageView = [[UIImageView alloc] init];
            //获取网络图片
            [imageView sd_setImageWithURL:url];
            [_scrollView addSubview:imageView];
            //添加手势
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];

            [_imagesArray addObject:imageView];
            NSInteger index = [self.imagesURL indexOfObject:url];
            imageView.tag = index;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(WIDTHOFSCREEN, HEIGHTOFSCREEN));
                make.left.equalTo(_scrollView).offset(WIDTHOFSCREEN*index);
                make.top.equalTo(_scrollView);
            }];
        }
    }
}
-(void)clickButton{
    [_timer invalidate];
    _timer = nil;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickButtonInFrontView:)]){
        [self.delegate clickButtonInFrontView:self];
    }
    else{
        [self dismiss:self.autoDismissAnimation];
    }
}
-(void)show{
    if (!self.imagesName.count && !self.imagesURL.count) {
        //图片为空，则不显示，并提醒
        [[[UIAlertView alloc]initWithTitle:@"FrontView" message:@"错误：图片为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    [self createSubViews];
    [self createImageView];
    
    //设置是否隐藏分页指示器
    _pageControl.hidden = !self.showPageControl;
    _skipButton.hidden = YES;
    //添加FrontView到当前Window，并发送到顶部
    [_window addSubview:self];
    [_window bringSubviewToFront:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_window);
    }];
}
-(void)showCountdown:(BOOL)countdown duration:(double)duration{
    [self show];
    //小于1秒不显示倒计时
    if (duration >= 1) {
        _duration = duration;
        [_skipButton setTitle:[NSString stringWithFormat:@" 跳过 %d秒 ",(int)_duration] forState:UIControlStateNormal];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runCountdown:) userInfo:nil repeats:YES];
    }
    //按钮是否显示
    _skipButton.hidden = !countdown;
}
-(void)runCountdown:(NSTimer *)timer{
    //解决定时器和滑动冲突
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    _duration --;
    
    if (_duration <= 0) {
        [timer invalidate];
        timer = nil;
        if(self.delegate && [self.delegate respondsToSelector:@selector(countdownDidEndOfFrontView:)]){
            [self.delegate countdownDidEndOfFrontView:self];
        }
        else{
            [self dismiss:self.autoDismissAnimation];
        }
    }
    else{
        [_skipButton setTitle:[NSString stringWithFormat:@" 跳过 %d秒 ",(int)_duration] forState:UIControlStateNormal];
    }
}
-(void)dismiss:(ForntViewAnimationType)animation{
    [self addViewAnimation:animation];

    double duration = animation == ForntViewAnimationTypeNone ? 0 : 0.3f;
    [UIView animateWithDuration:duration animations:^{
        //刷新布局/展示动画
        [_window layoutIfNeeded];
        if (animation == ForntViewAnimationTypeGradual) {
            self.alpha = 0;
        }
    } completion:^(BOOL finished) {
        //动画结束，移除FrontView
        [self removeFromSuperview];
    }];
}
-(void)addViewAnimation:(ForntViewAnimationType)animation{
    UIEdgeInsets edges;
    switch (animation) {
        case ForntViewAnimationTypeFromLeft:
        {
            edges = UIEdgeInsetsMake(0, WIDTHOFSCREEN, 0, 0);
        }
            break;
        case ForntViewAnimationTypeFromRight:
        {
            edges = UIEdgeInsetsMake(0, 0, 0, WIDTHOFSCREEN);
        }
            break;
        case ForntViewAnimationTypeFromTop:
        {
            edges = UIEdgeInsetsMake(HEIGHTOFSCREEN, 0, 0, 0);
        }
            break;
        case ForntViewAnimationTypeFromBottom:
        {
            edges = UIEdgeInsetsMake(0, 0, HEIGHTOFSCREEN, 0);
        }
            break;
        case ForntViewAnimationTypeFromCenter:
        {
            edges = UIEdgeInsetsMake(HEIGHTOFSCREEN/2, WIDTHOFSCREEN/2, HEIGHTOFSCREEN/2, WIDTHOFSCREEN/2);
        }
            break;
        case ForntViewAnimationTypeGradual:
        case ForntViewAnimationTypeNone:
        {
            edges = UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
            
        default:
            break;
    }
    //更新约束
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(edges);
    }];
}
-(BOOL)currentPage{
    return _page;
}
-(void)tapImageView:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    if(self.delegate && [self.delegate respondsToSelector:@selector(frontView:clickedPage:isLastPage:)]){
        [self.delegate frontView:self clickedPage:imageView.tag isLastPage:imageView.tag == _imagesArray.count - 1 ? YES : NO];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _page = scrollView.contentOffset.x/WIDTHOFSCREEN;
    _pageControl.currentPage = _page;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(frontView:didScrollToPage:isLastPage:)]){
        [self.delegate frontView:self didScrollToPage:_page isLastPage:_page == _imagesArray.count - 1 ? YES : NO];
    }
    
    //滑动到最后一张，则永久显示按钮
//    if (_page == _imagesArray.count - 1) {
//        _skipButton.hidden = NO;
//    }

    //最后一张显示按钮
//    _skipButton.hidden = page == _imagesArray.count - 1 ? NO : YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
