//
//  YJActivityIndicatorSubExample.m
//  YJView
//
//  Created by YJHou on 2017/2/7.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJActivityIndicatorSubExample.h"

@implementation YJActivityIndicatorSubExample

- (CGPathRef)finPathWithRect:(CGRect)rect{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:rect.origin];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
                  controlPoint1:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)/4)
                  controlPoint2:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    CGPathRef path = CGPathCreateCopy([bezierPath CGPath]);
    return path;
    
}

@end
