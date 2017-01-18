//
//  YJGridView.m
//  YJView
//
//  Created by YJHou on 2017/1/18.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJGridView.h"
#import "YJGridViewCell.h"

static const NSInteger outerOffset = 1;

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


- (void)reloadData{
    //fetch total grid size
    // 获取格子的大小
    self.rows = [self.dataSource numberOfRowsInGridView:self];
    self.columns = [self.dataSource numberOfColumnsInGridView:self];
    
    // 获取可见区域大小
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfVisibleRowsInGridView:)]) {
        self.visibleRows = [self.dataSource numberOfVisibleRowsInGridView:self];
    }else{
        self.visibleRows = self.rows;
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfVisibleColumnsInGridView:)]) {
        self.visibleColumns = [self.dataSource numberOfVisibleColumnsInGridView:self];
    }else{
        self.visibleColumns = self.columns;
    }
    
    [self initCells];
}

-(void)initCells{
    
    // 移除所有子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect myFrame = self.bounds;
    
    // 上下
    for(int row = -outerOffset; row < self.visibleRows + outerOffset; row++){
        // 左右
        for(int column = -outerOffset; column < self.visibleColumns + outerOffset; column++){
            
            // 确定当前cell的位置
            YJPosition cellPosition = YJPositionMake(row, column);
            YJGridViewCell *cell = [self.dataSource gridView:self cellAtPosition:cellPosition];
            cell.tag = [self _tagForPosition:cellPosition];
            
            //create the frame based on the current position, the view's bounds and the grid's size
            CGRect cellFrame;
            cellFrame.size.width = myFrame.size.width / self.visibleColumns;
            cellFrame.size.height = myFrame.size.height / self.visibleRows;
            cellFrame.origin.x = column * cellFrame.size.width;
            cellFrame.origin.y = row * cellFrame.size.height;
            cell.frame = cellFrame;
            //add the cell to the grid view
            [self addSubview:cell];
            
            //if the cell is on screen bring it to the front
            if(row >= 0 && row < self.visibleRows && column >= 0 && column < self.visibleColumns){
                [self bringSubviewToFront:cell];
            }
            //if the cell is off screen send it to the bck
            else
            {
                [self sendSubviewToBack:cell];
            }
        }
    }
}


#pragma mark - UIPanGestureRecognizer
-(void)panGestureDetected:(UIPanGestureRecognizer *)gestureRecognizer{
    
    
}

#pragma mark - SettingSupport
static inline YJPosition YJPositionMake(NSInteger row, NSInteger column) {
    return (YJPosition) {row, column};
}

/** 根据位置生成tag */
- (NSInteger)_tagForPosition:(YJPosition)position{
    
    NSInteger tag = position.row * self.columns + position.column;
    if(tag == 0){
        tag = INT_MAX;
    }
    return tag;
}


@end
