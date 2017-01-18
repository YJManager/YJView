//
//  UITableView+Wave.h
//  YJView
//
//  Created by YJHou on 2017/1/17.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBOUNCE_DISTANCE  10

typedef NS_ENUM(NSInteger, WaveAnimationDirection) {
    WaveAnimationDirectionBottom = 0,
    WaveAnimationDirectionFromLeft = -1,
    WaveAnimationDirectionFromRight = 1
};


@interface UITableView (Wave)

/** 逐条动画加载可视tableview
    animation 方向
    speed加载速度
    bounceDistance左右晃动的程度
 */
- (void)reloadDataAnimateWithWave:(WaveAnimationDirection)animation speed:(CGFloat)speed bounceDistance:(CGFloat)bounceDistance;


@end
