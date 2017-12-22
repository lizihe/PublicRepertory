//
//
//  RongDuKeJi
//
//  Created by 于海波 on 16/2/17.
//  Copyright © 2016年 Mr_zhaohy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/**
 *  肤色主题
 */
@interface RdAppSkinColor : NSObject


//获取全局的单例

+ (RdAppSkinColor*)sharedInstance;

//---------------------------------全局---------------------------------
/**
 * APP主色调，用于特别强调或突出的文字、背景、按钮和icon #F95A28
 */
@property (nonatomic, strong) UIColor *mainColor;

/**
 *  辅助色，用于强调特别突出的文字  #48AFFB
 */
@property (nonatomic, strong) UIColor *generalAColor;

/**
 *  辅助色，用于数据记录里面的一些金额文字 #4ABE89
 */
@property (nonatomic, strong) UIColor *generalBColor;

//---------------------------------背景用色-----------------------------
/**
 *  背景色 #F5F5F5
 */
@property (nonatomic, strong) UIColor *viewBackgroundColor;

//---------------------------分割线-----------------------

/**
 *  分割线 #dddddd
 */
@property (nonatomic, strong) UIColor *separatorColor;

//-------------------------进度条未过轨迹颜色-------------

/**
 *  #f2f4f8
 */
@property (nonatomic, strong) UIColor *trackTintColor;


//--------------------------------文字用色---------------------

/**
 *  导航栏颜色 #f9f9f9
 */
@property (nonatomic, strong) UIColor *normalNavigationBarColor;

/**
 *  重点文字颜色 #333333
 */
@property (nonatomic, strong) UIColor *emphasisSubTextColor;

/**
 *  导航栏文字，二级菜单文字 #666666
 */
@property (nonatomic, strong) UIColor *navigationTextColor;

/**
 *  次要文字，提示文字 #999999
 */
@property (nonatomic, strong) UIColor *secondaryTextColor;

/**
 *  提示输入状态文字 #cccccc
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

//------------------------------------按钮用色--------------------------
/**
 *  按钮正常颜色
 */
@property (nonatomic, strong) UIColor *normalButtonColor;
/**
 *  按钮选中以后高亮颜色
 */
@property (nonatomic, strong) UIColor *highlightedButtonColor;
/**
 *  按钮不可点击颜色
 */
@property (nonatomic, strong) UIColor *disableButtonColor;
//------------------------------------标准字体--------------------------

/**
 *  详情页利率 60
 */
@property (nonatomic, strong) UIFont *detailBigNumberFont;

/**
 *  优惠券数值 36
 */
@property (nonatomic, strong) UIFont *couponNumberFont;

/**
 *  优惠券单位 21
 */
@property (nonatomic, strong) UIFont *couponUnitFont;
/**
 *  详情页百分号 20
 */
@property (nonatomic, strong) UIFont *detailPercentFont;
/**
 *  超大字体，利率显示大小  28
 */
@property (nonatomic, strong) UIFont *bigImportantFont;
/**
 *  用于少数重要页面大标题，导航栏，按钮文字及重要文案等 18
 */
@property (nonatomic, strong) UIFont  *importantTitleFont;

/**
 *  用于一些较为重要的文字或操作按钮，详情页标题及列表标题等 16
 */
@property (nonatomic, strong) UIFont  *importantNormalTitleFont;

/**
 *  用于一些较为重要的理财标题和介绍  15
 */
@property (nonatomic, strong) UIFont  *importantTextFont;

/**
 *  用于大多数的辅助线文字，二级栏头，详情内容文字等等 14
 */
@property (nonatomic, strong) UIFont  *subTitleFont;

/**
 *  用于一些按钮及辅助线文字 13
 */
@property (nonatomic, strong) UIFont  *subTextFont;

/**
 *  用于辅助性提示文字，数据列表文字等 12
 */
@property (nonatomic, strong) UIFont  *recommendTitleFont;

/**
 *  用于辅助性文字（如tabbar文字）11
 */
@property (nonatomic, strong) UIFont  *tabbarFont;
@end
