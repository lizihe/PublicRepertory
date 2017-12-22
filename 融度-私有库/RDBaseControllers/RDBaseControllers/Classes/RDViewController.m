//
//  RDViewController.m
//  demoapp
//
//  Created by Liang Shen on 16/3/23.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import "RDViewController.h"

@interface RDViewController ()
{
//    NetworkProblemView *networkProblemView ;
}

@end

@implementation RDViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewControllerDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"您进入了 %@",self.class);
    if ([self.navigationController viewControllers].count > 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Need Overwriting

- (void)viewControllerDidLoad
{
    
}


@end
