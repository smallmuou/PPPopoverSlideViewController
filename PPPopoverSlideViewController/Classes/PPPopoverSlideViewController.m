//
//  PPPopoverSlideViewController.m
//  PPPopoverSlideViewController
//
//  Created by StarNet on 7/10/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import "PPPopoverSlideViewController.h"
#import "PPMaskView.h"

@interface PPPopoverSlideViewController () <PPMaskViewDelegate> {
    PPMaskView*             _maskView;
    NSInteger               _dragCount;
    CGPoint                 _lastPoint;
    UIPanGestureRecognizer* _panGestureRecognizer;
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
    
    self.contentViewController = _contentViewController;
    
    _maskView = [[PPMaskView alloc] initWithFrame:self.view.bounds style:_style];
    _maskView.underlyingView = _contentViewController.view;
    _maskView.delegate = self;
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_maskView];

    UIViewController* viewController = _menuViewController;
    _menuViewController = nil;
    self.menuViewController = viewController;
}

- (void)layoutMenuView:(UIView* )view {
    if (_menuViewController) {
        view.frame = _menuViewController.view.frame;
        view.autoresizingMask = _menuViewController.view.autoresizingMask;
    } else {
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
        view.frame = menuFrame;
        NSLog(@"menuFrame=%f, %f", menuFrame.origin.x, menuFrame.size.width);
        view.autoresizingMask = autoresizingMask;
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    [_menuViewController removeFromParentViewController];
    [_menuViewController.view removeFromSuperview];
    
    if (menuViewController) {
        [_menuViewController.view removeGestureRecognizer:_panGestureRecognizer];
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureRecognizerAction:)];
        [self layoutMenuView:menuViewController.view];
        [self.view addSubview:menuViewController.view];
        [self addChildViewController:menuViewController];
        [menuViewController.view addGestureRecognizer:_panGestureRecognizer];
        [menuViewController didMoveToParentViewController:self];
    }
    _menuViewController = menuViewController;
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    [_contentViewController removeFromParentViewController];
    [_contentViewController.view removeFromSuperview];
    
    if (contentViewController) {
        [self addChildViewController:contentViewController];
        contentViewController.view.frame = self.view.bounds;
        [self.view insertSubview:contentViewController.view atIndex:0];
        [contentViewController didMoveToParentViewController:self];
    }
    _contentViewController = contentViewController;
}

- (void)onPanGestureRecognizerAction:(UIPanGestureRecognizer* )gesture {
    CGPoint point = [gesture locationInView:_maskView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self maskViewDidBeganDrag:_maskView offset:CGPointMake(0, 0)];
            break;
        case UIGestureRecognizerStateChanged:
            [self maskViewDidDraged:_maskView offset:CGPointMake(point.x-_lastPoint.x, point.y-_lastPoint.y)];
            break;
        case UIGestureRecognizerStateEnded:
            [self maskViewDidEndedDrag:_maskView offset:CGPointMake(point.x-_lastPoint.x, point.y-_lastPoint.y) velocity:[gesture velocityInView:_maskView]];
            break;
        default:
            break;
    }
    
    _lastPoint = point;
}

- (void)presentMenuViewController {
    //动态
    _maskView.underlyingView = _contentViewController.view;
    
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

#pragma mark - PPMaskViewDelegate
- (void)maskViewDidTap:(PPMaskView* )maskView {
    [self hideMenuViewController];
}

- (void)maskViewDidBeganDrag:(PPMaskView *)maskView offset:(CGPoint)offset {
    _dragCount = 0;
    [self maskViewDidDraged:maskView offset:offset];
}

- (void)maskViewDidDraged:(PPMaskView *)maskView offset:(CGPoint)offset {
    CGRect frame = _menuViewController.view.frame;
    frame.origin.x += offset.x;
    
    if (frame.origin.x > 0) {
        frame.origin.x = 0;
    } else if (frame.origin.x < -_menuViewSize) {
        frame.origin.x = -_menuViewSize;
    }
    
    //防止更新过频繁，导致界面不流畅
    if (_style != PPMaskStyleBlur || _dragCount%5 == 0) {
        _maskView.maskValue = (_menuViewSize - fabs(frame.origin.x))/_menuViewSize;
    }
    _menuViewController.view.frame = frame;
    _dragCount++;
}

- (void)maskViewDidEndedDrag:(PPMaskView *)maskView offset:(CGPoint)offset velocity:(CGPoint)velocity {
    CGFloat x = fabs(_menuViewController.view.frame.origin.x);
    CGFloat maskValue;
    
    BOOL show;
    if (velocity.x > 400) {
        show = YES;
    } else if (velocity.x < -400) {
        show = NO;
    } else {
        show = (x - _menuViewSize/2) < 0;
    }

    if (!show) {
        x = -_menuViewSize;
        maskValue = 0.f;
    } else {
        x = 0.f;
        maskValue = 1.f;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = _menuViewController.view.frame;
        frame.origin.x = x;
        _maskView.maskValue = maskValue;
        _menuViewController.view.frame = frame;
    }];
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