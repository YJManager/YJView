//
//  UITableView+Wave.h
//  YJView
//
//  Created by YJHou on 2017/1/17.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBOUNCE_DISTANCE  2

typedef NS_ENUM(NSInteger,WaveAnimation) {
    LeftToRightWaveAnimation = -1,
    RightToLeftWaveAnimation = 1
};


@interface UITableView (Wave)

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation;


@end
