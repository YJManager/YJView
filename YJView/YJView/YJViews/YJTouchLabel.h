//
//  YJTouchLabel.h
//  YJView
//
//  Created by YJHou on 2016/12/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YJTouchLabelDelegate <NSObject>


@end

@interface YJTouchLabel : UILabel

@property (nonatomic, weak) id<YJTouchLabelDelegate> delegate;

@end
