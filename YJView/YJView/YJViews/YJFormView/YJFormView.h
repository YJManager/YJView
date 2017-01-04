//
//  YJFormView.h
//  YJView
//
//  Created by YJHou on 2017/1/4.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJFormView : UIView

- (instancetype)initWithFrame:(CGRect)frame columnRatios:(NSArray <NSNumber *>*)columnRatios;
- (void)addRecord:(NSArray*)record;


@end
