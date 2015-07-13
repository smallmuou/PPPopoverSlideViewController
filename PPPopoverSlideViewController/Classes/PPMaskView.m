//
//  PPMaskView.m
//  PPPopoverSlideViewController
//
//  Created by StarNet on 7/13/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import "PPMaskView.h"
#import "UIImage+PPMaskView.h"

#define kBlurRadiusBase 20.0f   //半径基数
#define kBlurIterations 3      //嵌套次数，越大越模糊

@interface PPMaskView () {
    UIImageView*            _blurImageView;
    UITapGestureRecognizer* _tapGestureRecognizer;
    UIPanGestureRecognizer* _panGestureRecognizer;
    CGPoint                 _lastPoint;
    UIImage*                _snapshot;
    
    id                      _delegate __weak;
    
    struct {
        unsigned int didTap:1;
        unsigned int maskViewDidBeganDrag:1;
        unsigned int maskViewDidDraged:1;
        unsigned int maskViewDidEndedDrag:1;
    } _delegateFlags;
}

@end

@implementation PPMaskView

- (instancetype)initWithFrame:(CGRect)frame style:(PPMaskStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        switch (style) {
            case PPMaskStyleBlur:
                _blurImageView = [[UIImageView alloc] initWithFrame:self.bounds];
                _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                [self addSubview:_blurImageView];
                break;
            case PPMaskStyleBlack:
                self.backgroundColor = [UIColor blackColor];
                break;
            case PPMaskStyleLight:
                self.backgroundColor = [UIColor whiteColor];
                break;
            case PPMaskStyleClear:
                self.backgroundColor = [UIColor clearColor];
                break;
            default:
                break;
        }
        
        self.maskValue = 0;
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTabGestureRecognizerAction:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureRecognizerAction:)];
        [self addGestureRecognizer:_panGestureRecognizer];
    }
    return self;
}

- (void)dealloc {
    [self removeGestureRecognizer:_tapGestureRecognizer];
    [self removeGestureRecognizer:_panGestureRecognizer];
}

- (void)onTabGestureRecognizerAction:(UITapGestureRecognizer* )gesture {
    if (_delegateFlags.didTap) {
        [self.delegate maskViewDidTap:self];
    }
}

- (void)onPanGestureRecognizerAction:(UIPanGestureRecognizer* )gesture {
    CGPoint point = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if (_delegateFlags.maskViewDidBeganDrag) {
                [self.delegate maskViewDidBeganDrag:self offset:CGPointMake(0, 0)];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if (_delegateFlags.maskViewDidDraged) {
                [self.delegate maskViewDidDraged:self offset:CGPointMake(point.x-_lastPoint.x, point.y-_lastPoint.y)];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (_delegateFlags.maskViewDidEndedDrag) {
                [self.delegate maskViewDidEndedDrag:self offset:CGPointMake(point.x-_lastPoint.x, point.y-_lastPoint.y) velocity:[gesture velocityInView:self]];
            }
            break;
        default:
            break;
    }
    
    _lastPoint = point;
}

- (void)setDelegate:(id<PPMaskViewDelegate>)delegate {
    _delegate = delegate;
    
    _delegateFlags.didTap = [self.delegate respondsToSelector:@selector(maskViewDidTap:)]?1:0;
    _delegateFlags.maskViewDidBeganDrag = [self.delegate respondsToSelector:@selector(maskViewDidBeganDrag:offset:)]?1:0;
    _delegateFlags.maskViewDidDraged = [self.delegate respondsToSelector:@selector(maskViewDidDraged:offset:)]?1:0;
    _delegateFlags.maskViewDidEndedDrag = [self.delegate respondsToSelector:@selector(maskViewDidEndedDrag:offset:velocity:)]?1:0;
}

- (void)setMaskValue:(CGFloat)maskValue {
    _maskValue = maskValue;
    switch (_style) {
        case PPMaskStyleBlur: {
            self.hidden = (maskValue == 0.0f);
            if (!_snapshot) {
                _snapshot = [UIImage imageForView:_underlyingView];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* image = [_snapshot blurImageWithRadius:maskValue*kBlurRadiusBase iterations:kBlurIterations tintColor:[UIColor clearColor]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_blurImageView setImage:image];
                });
            });
            break;
        }
        case PPMaskStyleLight:
        case PPMaskStyleBlack:
            self.alpha = maskValue*0.5;
            break;
        case PPMaskStyleClear:
            break;
        default:
            break;
    }
}

@end
