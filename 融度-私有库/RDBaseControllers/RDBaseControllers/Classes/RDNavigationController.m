//
//  RDNavigationController.m
//  demoapp
//
//  Created by Liang Shen on 16/3/21.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import "RDNavigationController.h"
#import <CategoryGroup/UIImage+Tint.h>
#import <CategoryGroup/UIImage+Resize.h>
#import <CategoryGroup/UIColor+Palette.h>

@interface RDNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation RDNavigationController

#pragma mark -Need Overwriting

- (void)navigationViewDidLoad
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  去除底部线条
 */
- (void)removeShadowImage
{
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

/**
 *  添加线条
 */
- (void)addNormalShadowImage
{
    [self.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"#dddddd"]]];    
}

/**
 *  设置NavigationBar的背景图片
 *
 *  @param bgImage 图片
 */
- (void)setNavigationBarBackgroundImage:(UIImage *)bgImage
{
    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)showImageColorNavigationBarBackground:(UIColor *)color textTintColor:(UIColor *)tintColor isTranslucent:(BOOL)translucent
{
    self.navigationBar.translucent = translucent;
    self.navigationBar.tintColor = tintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:tintColor};
    [self setNavigationBarBackgroundImage:[UIImage createImageWithColor:color]];
    [self removeShadowImage];
}

- (void)showClearNavigationBar
{
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self setNavigationBarBackgroundImage:[UIImage new]];
    [self removeShadowImage];
}

- (void)showNormalNavigationBarTintColor:(UIColor *)tintColor
{
    self.navigationBar.tintColor = tintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:tintColor};
    [self setNavigationBarBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"#FFFFFF"]]];
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor colorFromHexString:@"#333333"],[UIFont systemFontOfSize:20.0],[[NSShadow alloc] init],nil]forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName,NSShadowAttributeName,nil]];
    self.navigationBar.titleTextAttributes = dict;
    self.navigationBar.tintColor = [UIColor colorFromHexString:@"#333333"];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

-(void)popself
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*) createBackButton

{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:_backButtonItemImage style:UIBarButtonItemStyleBordered target:self action:@selector(popself)];
    return backBtn;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return  YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        
        
        //        viewController.navigationItem.backBarButtonItem.title = @"";
    }
    
}

- (void)pushViewController:(UIViewController *)viewController title:(NSString*)title animated:(BOOL)animated

{
    
    [super pushViewController:viewController animated:animated];
    viewController.title = title;
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        
        
        //        viewController.navigationItem.backBarButtonItem.title = @"";
    }
    
}



@end
