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
        self.contentViewController = contentViewController;
        self.menuViewController = menuViewController;
    }
    return self;
}

- (void)setup {
    _menuViewSize = 350;
    _style = PPMaskStyleLight;
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
    _maskView.delegate = self;
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_maskView];

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

- (void)setMenuViewController:(UIViewController *)menuViewController {
    _menuViewController = menuViewController;
    [_menuViewController.view removeGestureRecognizer:_panGestureRecognizer];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureRecognizerAction:)];
    [_menuViewController.view addGestureRecognizer:_panGestureRecognizer];;
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
    if (_dragCount%2 == 0) {
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