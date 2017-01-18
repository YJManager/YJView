//
//  YJGridView.m
//  YJView
//
//  Created by YJHou on 2017/1/18.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJGridView.h"

@interface YJGridView (){

        UIPanGestureRecognizer *_panRecognizer; // 拖动手势
        NSThread *_easeThread;                  // 线程
}
@property (nonatomic, assign) NSInteger rows;           /**< 共有多少行 */
@property (nonatomic, assign) NSInteger columns;        /**< 共有多少列 */
@property (nonatomic, assign) NSInteger visibleRows;    /**< 可见共有多少行 */
@property (nonatomic, assign) NSInteger visibleColumns; /**< 可见共有多少行 */

@property (nonatomic, assign) BOOL isHorizontallyMoving; /**< 水平方向正在滑动 */
@property (nonatomic, assign) BOOL isVerticallyMoving;   /**< 纵向正在滑动 */

@property (nonatomic, strong) NSTimer *easeOutTimer;     /**< 缓解滑出定时器 */

@end

@implementation YJGridView

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
        [self addGestureRecognizer:_panRecognizer];
    }
    return self;
}

/** 恢复位置 */
- (YJPosition)normalizePosition:(YJPosition)position{
    
    if(position.row < 0){
        position.row += self.rows;
    }else if(position.row >= self.rows){
        position.row -= self.rows;
    }
    
    if(position.column < 0){
        position.column += self.columns;
    }else if(position.column >= self.columns){
        position.column -= self.columns;
    }
    return position;
}


#pragma mark - UIPanGestureRecognizer
-(void)panGestureDetected:(UIPanGestureRecognizer *)gestureRecognizer{
    
    
}

@end
