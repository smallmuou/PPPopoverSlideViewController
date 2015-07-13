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
#define kBlurIterations 3       //嵌套次数，越大越模糊

@interface PPMaskView () {
    UIImageView* _blurImageView;
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
            case PPMaskStyleMask:
                self.backgroundColor = [UIColor blackColor];
                break;
            case PPMaskStyleClear:
                self.backgroundColor = [UIColor clearColor];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)setMaskValue:(CGFloat)maskValue {
    _maskValue = maskValue;
    switch (_style) {
        case PPMaskStyleBlur:
            [_blurImageView setImage:[[UIImage imageForView:_underlyingView] blurImageWithRadius:maskValue*kBlurRadiusBase iterations:kBlurIterations tintColor:[UIColor clearColor]]];
            break;
        case PPMaskStyleMask:
            self.alpha = maskValue;
            break;
        case PPMaskStyleClear:
            break;
        default:
            break;
    }
}

@end
