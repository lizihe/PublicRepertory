//
//  RdTableView.h
//  demoapp
//
//  Created by Liang Shen on 16/4/28.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RdTableView : UITableView

@property (nonatomic , strong) NSString *emptyText;

@property (nonatomic , strong) UIImage *emptyImg;

@property (nonatomic , assign) BOOL showEmptyView;

/**
 空态时，tableview背景色，默认白色
 */
@property (nonatomic , strong) UIColor *emptyBackgroundColor;
/**
 取消选中的cell
 */
- (void)cancelSelectStatus;
@end
