//
//  RDPageViewController.h
//  RDPageViewController v0.5
//
//  Created by Nico Arqueros on 10/17/14.
//  Copyright (c) 2014 Moblox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RDPageMode) {
    RD_FreeButtons,
    RD_LeftRightArrows,
    RD_SegmentController
};

@protocol RDPageControllerDataSource;
@protocol RDPageControllerDataDelegate;

@interface RDPageViewController : UIPageViewController

@property (nonatomic, assign) id<RDPageControllerDataSource>   RDDataSource;
@property (nonatomic, assign) id<RDPageControllerDataDelegate> RDDataDelegate;

@property (nonatomic, assign) RDPageMode                           pageMode;     // This selects the mode of the PageViewController

- (void)reloadPages;                                                        // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons
- (void)reloadPagesToCurrentPageIndex:(NSInteger)currentPageIndex;          // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons

- (void)moveToViewNumber:(NSInteger)viewNumber __attribute__((deprecated));                // Default to YES. Deprecated.
- (void)moveToViewNumber:(NSInteger)viewNumber animated:(BOOL)animated;     // The ViewController position. Starts from 0
@end

@protocol RDPageControllerDataSource <NSObject>
@required
- (NSArray *)RDPageButtons;
- (NSArray *)RDPageControllers;
- (UIView *)RDPageContainer;
@optional
- (void)otherConfiguration;                         // Good place to put methods that you want to execute after everything is ready i.e. moveToViewNumber to set a different starting page.
@end

@protocol RDPageControllerDataDelegate <NSObject>
@optional
- (void)RDPageChangedToIndex:(NSInteger)index;
@end
