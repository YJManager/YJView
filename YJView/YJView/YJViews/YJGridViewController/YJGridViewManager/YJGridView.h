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
-(BOOL)gridView:(YJGridView *)gridView shouldScrollCell:(YJGridViewCell *)cell atPosition:(YJPosition)position;
-(NSInteger)numberOfVisibleRowsInGridView:(YJGridView *)gridView;
-(NSInteger)numberOfVisibleColumnsInGridView:(YJGridView *)gridView;

@end

/** 数据源方法 */
@protocol YJGridViewDelegate <NSObject>

@optional
-(void)gridView:(YJGridView *)gridView willMoveCell:(YJGridViewCell *)cell fromPosition:(YJPosition)fromPosition toPosition:(YJPosition)toPosition;
-(void)gridView:(YJGridView *)gridView didMoveCell:(YJGridViewCell *)cell fromPosition:(YJPosition)fromPosition toPosition:(YJPosition)toPosition;

@end

@interface YJGridView : UIView

@property (nonatomic, weak) id<YJGridViewDataSource> dataSource;
@property (nonatomic, weak) id<YJGridViewDelegate> delegate;

/** 恢复位置 */
- (YJPosition)normalizePosition:(YJPosition)position;

/** 刷新数据 */
- (void)reloadData;

@end
