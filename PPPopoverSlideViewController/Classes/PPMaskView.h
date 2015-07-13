//
//  PPMaskView.h
//  PPPopoverSlideViewController
//
//  Created by StarNet on 7/13/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PPMaskStyle) {
    PPMaskStyleBlur,
    PPMaskStyleLight,
    PPMaskStyleBlack,
    PPMaskStyleClear,
};

@class PPMaskView;
@protocol PPMaskViewDelegate <NSObject>

@optional

- (void)maskViewDidTap:(PPMaskView* )maskView;
- (void)maskViewDidBeganDrag:(PPMaskView *)maskView offset:(CGPoint)offset;
- (void)maskViewDidDraged:(PPMaskView *)maskView offset:(CGPoint)offset;
- (void)maskViewDidEndedDrag:(PPMaskView *)maskView offset:(CGPoint)offset velocity:(CGPoint)velocity;

@end

@interface PPMaskView : UIView

- (instancetype)initWithFrame:(CGRect)frame style:(PPMaskStyle)style;

@property (nonatomic, weak) id <PPMaskViewDelegate> delegate;

@property (nonatomic, readonly) PPMaskStyle style;

/** Between 0 to 1 */
@property (nonatomic, assign) CGFloat maskValue;

/** For PPMaskStyleBlur, must set underlyingView */
@property (nonatomic, strong) UIView* underlyingView;

@end
