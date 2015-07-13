//
//  PPPopoverSlideViewController.m
//  PPPopoverSlideViewController
//
//  Created by StarNet on 7/10/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import "PPPopoverSlideViewController.h"
#import "PPMaskView.h"

@interface PPPopoverSlideViewController () {
    PPMaskView* _maskView;
}

@end

@implementation PPPopoverSlideViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController {
    self = [self init];
    if (self) {
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
    }
    return self;
}

- (void)setup {
    _menuViewSize = 300;
    _style = PPMaskStyleBlur;
}



- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加contentViewController
    [self addChildViewController:_contentViewController];
    _contentViewController.view.frame = self.view.bounds;
    _contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_contentViewController.view];
    [_contentViewController didMoveToParentViewController:self];
    
    _maskView = [[PPMaskView alloc] initWithFrame:self.view.bounds style:_style];
    _maskView.underlyingView = _contentViewController.view;
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_maskView];
    _maskView.userInteractionEnabled = NO;

    //添加menuViewController
    CGRect menuFrame = CGRectZero;
    UIViewAutoresizing autoresizingMask;
    switch (_direction) {
        case PPPopoverSlideViewControllerDirectionLeft:
            menuFrame = CGRectMake(-self.menuViewSize, 0, self.menuViewSize, self.view.bounds.size.height);
            autoresizingMask = UIViewAutoresizingFlexibleHeight;
            break;
        case PPPopoverSlideViewControllerDirectionTop:
            menuFrame = CGRectMake(0, -self.menuViewSize, self.view.bounds.size.width, self.menuViewSize);
            autoresizingMask = UIViewAutoresizingFlexibleWidth;
            break;
        case PPPopoverSlideViewControllerDirectionRight:
            menuFrame = CGRectMake(self.view.bounds.size.width, 0, self.menuViewSize, self.view.bounds.size.height);
            autoresizingMask = UIViewAutoresizingFlexibleHeight;
            break;
        case PPPopoverSlideViewControllerDirectionBottom:
            menuFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.menuViewSize);
            autoresizingMask = UIViewAutoresizingFlexibleWidth;
            break;
        default:
            break;
    }
    
    [self addChildViewController:_menuViewController];
    _menuViewController.view.frame = menuFrame;
    _menuViewController.view.autoresizingMask = autoresizingMask;
    [self.view addSubview:_menuViewController.view];
    [_menuViewController didMoveToParentViewController:self];
}

- (void)presentMenuViewController {
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = _menuViewController.view.frame;
        frame.origin.x = 0;
        _maskView.maskValue = 1.f;
        _menuViewController.view.frame = frame;
    }];
}

- (void)hideMenuViewController {
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = _menuViewController.view.frame;
        frame.origin.x = -self.menuViewSize;
        _maskView.maskValue = 0;
        _menuViewController.view.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma mark - UIViewController (PPPopoverSlideViewController)
@implementation UIViewController (PPPopoverSlideViewController)

- (PPPopoverSlideViewController* )popoverSlideViewController {
    UIViewController *vc = self.parentViewController;
    while (vc) {
        if ([vc isKindOfClass:[PPPopoverSlideViewController class]]) {
            return (PPPopoverSlideViewController *)vc;
        } else if (vc.parentViewController && vc.parentViewController != vc) {
            vc = vc.parentViewController;
        } else {
            vc = nil;
        }
    }
    return nil;
}

@end