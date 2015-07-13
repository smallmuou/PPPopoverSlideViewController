//
//  PPPopoverSlideViewController.h
//  PPPopoverSlideViewController
//
//  Created by StarNet on 7/10/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMaskView.h"

typedef NS_ENUM(NSInteger, PPPopoverSlideViewControllerDirection) {
    PPPopoverSlideViewControllerDirectionLeft,
    PPPopoverSlideViewControllerDirectionRight,
    PPPopoverSlideViewControllerDirectionTop,
    PPPopoverSlideViewControllerDirectionBottom
};

@class PPPopoverSlideViewController;
@protocol PPPopoverSlideViewControllerDelegate <NSObject>

@optional
- (void)popoverSlideViewController:(PPPopoverSlideViewController* )popoverSlideViewController willShowMenuViewController:(UIViewController *)menuViewController;
- (void)popoverSlideViewController:(PPPopoverSlideViewController* )popoverSlideViewController didShowMenuViewController:(UIViewController *)menuViewController;
- (void)popoverSlideViewController:(PPPopoverSlideViewController* )popoverSlideViewController willHideMenuViewController:(UIViewController *)menuViewController;
- (void)popoverSlideViewController:(PPPopoverSlideViewController* )popoverSlideViewController didHideMenuViewController:(UIViewController *)menuViewController;

@end

@interface PPPopoverSlideViewController : UIViewController

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController;

@property (nonatomic, assign) PPPopoverSlideViewControllerDirection direction;

/** See PPMaskStyle for detail, default PPMaskStyleBlur */
@property (nonatomic, assign) PPMaskStyle style;

@property (nonatomic, assign) CGFloat menuViewSize;

@property (nonatomic, assign) BOOL panGestureEnabled;

@property (nonatomic, strong) UIViewController* contentViewController;

@property (nonatomic, strong) UIViewController* menuViewController;

- (void)presentMenuViewController;

- (void)hideMenuViewController;

@end

#pragma mark - UIViewController (PPPopoverSlideViewController)

@interface UIViewController (PPPopoverSlideViewController)

- (PPPopoverSlideViewController* )popoverSlideViewController;

@end
