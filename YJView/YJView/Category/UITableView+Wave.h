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

- (void)reloadDataAnimateWithWave:(WaveAnimationDirection)animation;


@end
