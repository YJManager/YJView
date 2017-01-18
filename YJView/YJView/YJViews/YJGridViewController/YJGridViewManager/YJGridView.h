//
//  YJGridView.h
//  YJView
//
//  Created by YJHou on 2017/1/18.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJGridViewCell.h"

@class YJGridView;

typedef struct{
    NSInteger row;
    NSInteger column;
}YJPosition;

static inline YJPosition YJPositionMake(NSInteger row, NSInteger column);

/** 数据源方法 */
@protocol YJGridViewDataSource <NSObject>

@required
-(NSInteger)numberOfRowsInGridView:(YJGridView *)gridView;
-(NSInteger)numberOfColumnsInGridView:(YJGridView *)gridView;
-(YJGridViewCell *)gridView:(YJGridView *)gridView cellAtPosition:(YJPosition)position;
@optional
-(NSInteger)numberOfVisibleRowsInGridView:(YJGridView *)gridView;
-(NSInteger)numberOfVisibleColumnsInGridView:(YJGridView *)gridView;

@end

/** 数据源方法 */
@protocol YJGridViewDelegate <NSObject>




@end

@interface YJGridView : UIView

@property (nonatomic, weak) id<YJGridViewDataSource> dataSource;
@property (nonatomic, weak) id<YJGridViewDelegate> delegate;

/** 恢复位置 */
- (YJPosition)normalizePosition:(YJPosition)position;

/** 刷新数据 */
- (void)reloadData;

@end
