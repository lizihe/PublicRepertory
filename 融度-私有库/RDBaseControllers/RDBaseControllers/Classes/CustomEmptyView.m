//
//  CustomEmptyView.m
//  Pods
//
//  Created by hey on 2016/12/9.
//
//

#import "CustomEmptyView.h"
#import <CategoryGroup/UIColor+Palette.h>

@interface CustomEmptyView ()

@end

@implementation CustomEmptyView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

-(instancetype)initEmptyView
{
    self = [super init];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

-(void)createViews
{
    _infoView = [[UIView alloc] init];
    [self addSubview:_infoView];
    
    _emptyImageView = [[UIImageView alloc] init];
    [_infoView addSubview:_emptyImageView];
    
    _describeLabel = [[UILabel alloc] init];
    _describeLabel.adjustsFontSizeToFitWidth = YES;
    _describeLabel.font = [UIFont systemFontOfSize:15];
    _describeLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    _describeLabel.textAlignment = NSTextAlignmentCenter;
    [_infoView addSubview:_describeLabel];
}

-(void)createConstrains
{
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [_emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoView);
        make.centerX.equalTo(_infoView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_infoView).offset(-10);
        make.left.equalTo(_infoView);
        make.right.equalTo(_infoView);
    }];
}

-(void)updateViewImage:(UIImage *)image description:(NSString *)text
{
    _emptyImageView.image = image;
    _describeLabel.text = text;
}

@end
