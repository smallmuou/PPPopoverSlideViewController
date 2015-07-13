//
//  UIImage+PPMaskView.h
//  PPPopoverSlideViewController
//
//  Created by StarNet on 7/13/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PPMaskView)

+ (UIImage* )imageForView:(UIView* )view;

- (UIImage *)blurImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
