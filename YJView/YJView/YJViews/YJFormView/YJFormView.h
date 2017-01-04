//
//  YJFormView.h
//  YJView
//
//  Created by YJHou on 2017/1/4.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJFormView;
@protocol YJFormViewDatasource <NSObject>

- (NSArray *)formViewWithFormDataSource:(YJFormView *)formView;

@end

@interface YJFormView : UIView

@property (nonatomic, weak) id<YJFormViewDatasource> dataSource;
@property (nonatomic, strong) UIColor *borderLineColor; /**< 线的颜色 */
@property (nonatomic, assign) CGFloat borderLineWidth; /**< 线的宽度 */

- (instancetype)initWithFrame:(CGRect)frame columnRatios:(NSArray <NSNumber *>*)columnRatios;

- (void)reload;


@end
