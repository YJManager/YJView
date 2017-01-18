//
//  YJGridView.h
//  YJView
//
//  Created by YJHou on 2017/1/18.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct{
    NSInteger row;
    NSInteger column;
}YJPosition;

static inline YJPosition YJPositionMake(NSInteger row, NSInteger column);

@interface YJGridView : UIView

/** 恢复位置 */
- (YJPosition)normalizePosition:(YJPosition)position;

@end
