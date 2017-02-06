//
//  YJActivityIndicatorView.h
//  YJView
//
//  Created by YJHou on 2017/2/6.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 旋转方向 */
typedef NS_ENUM(NSInteger, YJActivityIndicatorDirection) {
    YJActivityIndicatorDirectionClockwise = 0,
    YJActivityIndicatorDirectionCounterClockwise
};

@interface YJActivityIndicatorView : UIView

@property (nonatomic, assign) NSUInteger steps;                                         /**< 步节个数 */
@property (nonatomic, assign) NSUInteger indicatorRadius;                               /**< 指示半径 */
@property (nonatomic, assign) CGFloat stepDuration;                                     /**< 时间 */
@property (nonatomic, assign) CGSize finSize;                                           /**< 翅片大小 */
@property (nonatomic, strong) UIColor *color;                                           /**< 颜色 */
@property (nonatomic, assign) UIRectCorner roundedCoreners;                             /**< 圆角弧度 */
@property (nonatomic, assign) CGSize cornerRadii;                                       /**< 圆角半径 */
@property (nonatomic, assign) YJActivityIndicatorDirection direction;                   /**< 旋转方向 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;  /**< 显示类型 */
@property (nonatomic, assign) BOOL hidesWhenStopped;                                    /**< 停止隐藏 */
@property (nonatomic, assign) BOOL isAnimating;                                         /**< 是否正在动画 */

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (CGPathRef)finPathWithRect:(CGRect)rect;

@end
