//
//  YJActivityIndicatorView.m
//  YJView
//
//  Created by YJHou on 2017/2/6.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJActivityIndicatorView.h"

@interface YJActivityIndicatorView ()

@property (nonatomic, strong) NSTimer *timer;            /**< 定时器 */
@property (nonatomic, assign) CGFloat anglePerStep;      /**< 单角度 */
@property (nonatomic, assign) CGFloat currentStep;      /**< 当前的位置 */
@property (nonatomic, assign) BOOL currIsAnimating;     /**< 是否正在动画 */

@end

@implementation YJActivityIndicatorView

#pragma mark - init
- (void)awakeFromNib{
    [super awakeFromNib];
    [self _setPropertiesForStyle:UIActivityIndicatorViewStyleWhite];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setPropertiesForStyle:UIActivityIndicatorViewStyleWhite];
    }
    return self;
}

- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;{
    self = [self initWithFrame:CGRectZero];
    if (self){
        [self _setPropertiesForStyle:style];
    }
    return self;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    [self _setPropertiesForStyle:activityIndicatorViewStyle];
}

- (void)_setPropertiesForStyle:(UIActivityIndicatorViewStyle)style{
    
    self.backgroundColor = [UIColor clearColor];
    self.direction = YJActivityIndicatorDirectionClockwise;
    self.roundedCoreners = UIRectCornerAllCorners;
    self.cornerRadii = CGSizeMake(1, 1);
    self.stepDuration = 0.1;
    self.steps = 12;
    
    switch (style) {
        case UIActivityIndicatorViewStyleGray:{
            self.color = [UIColor darkGrayColor];
            self.finSize = CGSizeMake(2, 5);
            self.indicatorRadius = 5;
            break;
        }
        case UIActivityIndicatorViewStyleWhite:{
            self.color = [UIColor whiteColor];
            self.finSize = CGSizeMake(2, 5);
            self.indicatorRadius = 5;
            break;
        }
        case UIActivityIndicatorViewStyleWhiteLarge:{
            self.color = [UIColor whiteColor];
            self.cornerRadii = CGSizeMake(2, 2);
            self.finSize = CGSizeMake(3, 9);
            self.indicatorRadius = 8.5;
            break;
        }
        default:
            [NSException raise:NSInvalidArgumentException format:@"style invalid"];
            break;
    }
    
    self.currIsAnimating = NO;
    if (self.hidesWhenStopped)
        self.hidden = YES;
}

#pragma mark - UIActivityIndicator
- (void)startAnimating{
    self.currentStep = 0;
    /** 先执行一次 */
    [self _repeatAnimation:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.stepDuration target:self selector:@selector(_repeatAnimation:) userInfo:nil repeats:YES];
    self.currIsAnimating = YES;
    
    if (self.hidesWhenStopped)
        self.hidden = NO;
}

- (void)_repeatAnimation:(NSTimer *)timer{
    
    self.currentStep++;
    [self setNeedsDisplay];
}

- (void)stopAnimating{
    if (self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.currIsAnimating = NO;
    if (self.hidesWhenStopped)
        self.hidden = YES;
}

- (BOOL)isAnimating{
    return self.currIsAnimating;
}

#pragma mark - YJActivityIndicator Drawing
- (void)setIndicatorRadius:(NSUInteger)indicatorRadius{
    
    _indicatorRadius = indicatorRadius;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _indicatorRadius * 2 + _finSize.height * 2, _indicatorRadius * 2 + _finSize.height * 2);
    [self setNeedsDisplay];
}

- (void)setSteps:(NSUInteger)steps{
    self.anglePerStep = (360/steps) * M_PI / 180;
    _steps = steps;
    [self setNeedsDisplay];
}

- (void)setFinSize:(CGSize)finSize{
    _finSize = finSize;
    [self setNeedsDisplay];
}

/** 根据进度返回不同颜色 */
- (UIColor *)_colorForStep:(NSUInteger)stepIndex{
    CGFloat alpha = 1.0 - (stepIndex % _steps) * (1.0 / _steps);
    return [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(_color.CGColor, alpha)];
}

- (CGPathRef)finPathWithRect:(CGRect)rect{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:_roundedCoreners cornerRadii:_cornerRadii];
    CGPathRef path = CGPathCreateCopy([bezierPath CGPath]);
    return path;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect finRect = CGRectMake(self.bounds.size.width * 0.5 - _finSize.width * 0.5, 0, _finSize.width, _finSize.height);
    CGPathRef bezierPath = [self finPathWithRect:finRect];
    
    for (int i = 0; i < self.steps; i++){
        [[self _colorForStep:self.currentStep + i * _direction] set];
        
        CGContextBeginPath(context);
        CGContextAddPath(context, bezierPath);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        CGContextTranslateCTM(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        CGContextRotateCTM(context, self.anglePerStep);
        CGContextTranslateCTM(context, -(self.bounds.size.width * 0.5), -(self.bounds.size.height * 0.5));
    }
}


@end
