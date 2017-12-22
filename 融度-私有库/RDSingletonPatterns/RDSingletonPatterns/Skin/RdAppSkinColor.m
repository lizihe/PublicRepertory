//
//  RdAppSkinColor.m
//  RongDuKeJi
//
//  Created by 于海波 on 16/2/17.
//  Copyright © 2016年 Mr_zhaohy. All rights reserved.
//

#import "RdAppSkinColor.h"
#import <CategoryGroup/UIColor+Palette.h>

@implementation RdAppSkinColor

static  RdAppSkinColor *sharedInstance = nil;

/*
 获取全局的单例
 */
+(instancetype) sharedInstance {
    
    static RdAppSkinColor *sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[RdAppSkinColor alloc] init];
        });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _mainColor                = [UIColor colorFromHexString:@"#f95a28"];
        _generalAColor            = [UIColor colorFromHexString:@"#48AFFB"];
        _generalBColor            = [UIColor colorFromHexString:@"#4ABE89"];
        _viewBackgroundColor      = [UIColor colorFromHexString:@"#efeff4"];
        _normalNavigationBarColor = [UIColor colorFromHexString:@"#f95a28"];

        _separatorColor           = [UIColor colorFromHexString:@"#dddddd"];
        _emphasisSubTextColor     = [UIColor colorFromHexString:@"#333333"];
        _navigationTextColor      = [UIColor colorFromHexString:@"#666666"];
        _secondaryTextColor       = [UIColor colorFromHexString:@"#999999"];
        _placeholderTextColor     = [UIColor colorFromHexString:@"#cccccc"];
        _trackTintColor           = [UIColor colorFromHexString:@"#f2f4f8"];
        
        _normalButtonColor        = [UIColor colorFromHexString:@"#f95a28"];
        _highlightedButtonColor   = [UIColor colorFromHexString:@"#ea4612"];
        _disableButtonColor       = [UIColor colorFromHexString:@"#cccccc"];
        
        
        _detailBigNumberFont      = [UIFont systemFontOfSize:60.0];
        _couponNumberFont         = [UIFont systemFontOfSize:36.0];
        _couponUnitFont           = [UIFont systemFontOfSize:21.0];
        _detailPercentFont        = [UIFont systemFontOfSize:20.0];
        _bigImportantFont         = [UIFont systemFontOfSize:28.0];
        _importantTitleFont       = [UIFont systemFontOfSize:18.0];
        _importantNormalTitleFont = [UIFont systemFontOfSize:16.0];
        _importantTextFont        = [UIFont systemFontOfSize:15.0];
        _subTitleFont             = [UIFont systemFontOfSize:14.0];
        _subTextFont              = [UIFont systemFontOfSize:13.0];
        _recommendTitleFont       = [UIFont systemFontOfSize:12.0];
        _tabbarFont               = [UIFont systemFontOfSize:11.0];
            }
    return self;
}

@end
