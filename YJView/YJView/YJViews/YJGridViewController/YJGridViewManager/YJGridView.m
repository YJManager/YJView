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
static const CGFloat stepSize = 300.0;

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
        //self can't have tag 0 because there is a tile with tag 0 which will conflict when moving
        self.tag = 1337;
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
        [self addGestureRecognizer:_panRecognizer];
    }
    return self;
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
            
            // 设置cellFrame
            CGRect cellFrame;
            cellFrame.size.width = myFrame.size.width / self.visibleColumns;
            cellFrame.size.height = myFrame.size.height / self.visibleRows;
            cellFrame.origin.x = column * cellFrame.size.width;
            cellFrame.origin.y = row * cellFrame.size.height;
            cell.frame = cellFrame;
            
            [self addSubview:cell];
            
            if(row >= 0 && row < self.visibleRows && column >= 0 && column < self.visibleColumns){ // 在屏幕内置前
                [self bringSubviewToFront:cell];
            }else{ // 在屏幕外置后
                [self sendSubviewToBack:cell];
            }
        }
    }
}


#pragma mark - UIPanGestureRecognizer
-(void)panGestureDetected:(UIPanGestureRecognizer *)gestureRecognizer{
    
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        if(_easeOutTimer){
            [_easeOutTimer invalidate];
            //[_easeOutTimer finalize];
            _easeOutTimer = nil;
        }
        
        if(_easeThread){
            [_easeThread cancel];
            _easeThread = nil;
        }
        
        // 初始化数据
        [self reloadData];
        self.isHorizontallyMoving = NO;
        self.isVerticallyMoving = NO;
    }else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        
        // x速度分量大于y, 且y方向没有滚动
        if(fabs(velocity.x) > fabs(velocity.y) && !self.isVerticallyMoving){
            
            self.isHorizontallyMoving = YES;
            YJPosition touchPosition = [self determinePositionAtPoint:[gestureRecognizer locationInView:self]];
            CGPoint translation = [gestureRecognizer translationInView:self];
            [self moveCellAtPosition:touchPosition horizontallyBy:velocity.x withTranslation:translation reloadingData:YES];
            [gestureRecognizer setTranslation:CGPointZero inView:self];
            
        }else if(!self.isHorizontallyMoving){ // 竖直滚动
            
            self.isVerticallyMoving = YES;
            YJPosition touchPosition = [self determinePositionAtPoint:[gestureRecognizer locationInView:self]];
            CGPoint translation = [gestureRecognizer translationInView:self];
            [self moveCellAtPosition:touchPosition verticallyBy:velocity.y withTranslation:translation reloadingData:YES];
            [gestureRecognizer setTranslation:CGPointZero inView:self];
        }
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        YJPosition touchPosition = [self determinePositionAtPoint:[gestureRecognizer locationInView:self]];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithFloat:velocity.x] forKey:@"VelocityX"];
        [dict setObject:[NSNumber numberWithFloat:velocity.y] forKey:@"VelocityY"];
        [dict setObject:[NSNumber numberWithFloat:touchPosition.row] forKey:@"TouchRow"];
        [dict setObject:[NSNumber numberWithFloat:touchPosition.column] forKey:@"TouchColumn"];
        _easeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(easeOut:) userInfo:dict repeats:NO];
    }
}

-(void)easeOut:(NSTimer *)timer{
    if(self.isHorizontallyMoving){
        _easeThread = [[NSThread alloc] initWithTarget:self selector:@selector(easeRow:) object:timer.userInfo];
        [_easeThread start];
    }else{
        _easeThread = [[NSThread alloc] initWithTarget:self selector:@selector(easeColumn:) object:timer.userInfo];
        [_easeThread start];
    }
    _easeOutTimer = nil;
}

#pragma mark - easeRow
-(void)easeRow:(NSDictionary *)params{
    
    CGPoint velocity = CGPointMake([[params objectForKey:@"VelocityX"] floatValue], [[params objectForKey:@"VelocityY"] floatValue]);
    YJPosition touchPosition = YJPositionMake([[params objectForKey:@"TouchRow"] floatValue], [[params objectForKey:@"TouchColumn"] floatValue]);
    
    CGFloat width = self.bounds.size.width;
    CGFloat columnWidth = width / self.visibleColumns;
    
    if( fabs(velocity.x) < columnWidth){
        if (velocity.x < 0 ){
            velocity.x = -columnWidth;
        }else{
            velocity.x = columnWidth;
        }
    }
    
    CGFloat direction = velocity.x / stepSize;
    if(velocity.x < 0){ // 左滑
        for(CGFloat i = 0; ![[NSThread currentThread] isCancelled]; i += fabs(direction)){
            if( i >= fabs(velocity.x) - columnWidth){
                YJGridViewCell *cell = [self.dataSource gridView:self cellAtPosition:YJPositionMake(touchPosition.row, 0)];
                if((int)roundf(cell.frame.origin.x) % (int)roundf(columnWidth) == 0){
                    if(cell.frame.origin.x != 0){
                        direction = cell.frame.origin.x - columnWidth;
                        
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithFloat:velocity.x], @"velocity",
                                              [NSNumber numberWithBool:YES], @"reloadingData",
                                              [NSNumber numberWithFloat:direction], @"translationX",
                                              [NSNumber numberWithFloat:0], @"translationY",
                                              [NSNumber numberWithBool:YES], @"isMovingHorizontally",
                                              [NSNumber numberWithInteger:touchPosition.row], @"positionX",
                                              [NSNumber numberWithInt:0], @"positionY",
                                              nil];
                        [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
                    }
                    break;
                }
            }
            
            direction = (velocity.x + i) / stepSize;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:velocity.x], @"velocity",
                                  [NSNumber numberWithBool:YES], @"reloadingData",
                                  [NSNumber numberWithFloat:direction], @"translationX",
                                  [NSNumber numberWithFloat:0], @"translationY",
                                  [NSNumber numberWithBool:YES], @"isMovingHorizontally",
                                  [NSNumber numberWithInteger:touchPosition.row], @"positionX",
                                  [NSNumber numberWithInteger:touchPosition.column], @"positionY",
                                  nil];
            [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.001];
        }
    }else{ // 右滑
        for(CGFloat i = 0; ![[NSThread currentThread] isCancelled]; i += fabs(direction)){
            if( i >= fabs(velocity.x) - columnWidth){
                YJGridViewCell *cell = [self.dataSource gridView:self cellAtPosition:YJPositionMake(touchPosition.row, 0)];
                if((int)roundf(cell.frame.origin.x) % (int)roundf(columnWidth) == 0)
                {
                    if(cell.frame.origin.x != 0)
                    {
                        direction = columnWidth - cell.frame.origin.x;
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithFloat:velocity.x], @"velocity",
                                              [NSNumber numberWithBool:YES], @"reloadingData",
                                              [NSNumber numberWithFloat:direction], @"translationX",
                                              [NSNumber numberWithFloat:0], @"translationY",
                                              [NSNumber numberWithBool:YES], @"isMovingHorizontally",
                                              [NSNumber numberWithInteger:touchPosition.row], @"positionX",
                                              [NSNumber numberWithInt:0], @"positionY",
                                              nil];
                        [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
                    }
                    break;
                }
            }
            
            direction = (velocity.x - i) / stepSize;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:velocity.x], @"velocity",
                                  [NSNumber numberWithBool:YES], @"reloadingData",
                                  [NSNumber numberWithFloat:direction], @"translationX",
                                  [NSNumber numberWithFloat:0], @"translationY",
                                  [NSNumber numberWithBool:YES], @"isMovingHorizontally",
                                  [NSNumber numberWithInteger:touchPosition.row], @"positionX",
                                  [NSNumber numberWithInteger:touchPosition.column], @"positionY",
                                  nil];
            
            [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.001];
        }
    }
    
    if(![[NSThread currentThread] isCancelled])
    {
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - easeColumn
- (void)easeColumn:(NSDictionary *)params{
    
    CGPoint velocity = CGPointMake([[params objectForKey:@"VelocityX"] floatValue], [[params objectForKey:@"VelocityY"] floatValue]);
    YJPosition touchPosition = YJPositionMake([[params objectForKey:@"TouchRow"] floatValue], [[params objectForKey:@"TouchColumn"] floatValue]);
    
    CGFloat height = self.bounds.size.height;
    CGFloat rowHeight = height / self.visibleRows;
    
    if( fabs(velocity.y) < rowHeight){
        if (velocity.y < 0 ){
            velocity.y = -rowHeight;
        }else{
            velocity.y = rowHeight;
        }
    }
    
    CGFloat direction = velocity.y / stepSize;
    if(velocity.y < 0){ // 上滑
        for(CGFloat i = 0; ![[NSThread currentThread] isCancelled]; i+=fabs(direction)){
            if( i >= fabs(velocity.y) - rowHeight){
                
                YJGridViewCell *cell = [self.dataSource gridView:self cellAtPosition:YJPositionMake(0, touchPosition.column)];
                if((int)roundf(cell.frame.origin.y) % (int)roundf(rowHeight) == 0){
                    if(cell.frame.origin.y != 0){
                        direction = cell.frame.origin.y - rowHeight;
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithFloat:velocity.y], @"velocity",
                                              [NSNumber numberWithBool:YES], @"reloadingData",
                                              [NSNumber numberWithFloat:0], @"translationX",
                                              [NSNumber numberWithFloat:direction], @"translationY",
                                              [NSNumber numberWithBool:NO], @"isMovingHorizontally",
                                              [NSNumber numberWithInt:0], @"positionX",
                                              [NSNumber numberWithInteger:touchPosition.column], @"positionY",
                                              nil];
                        [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
                    }
                    break;
                }
            }
            
            direction = (velocity.y + i) / stepSize;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:velocity.y], @"velocity",
                                  [NSNumber numberWithBool:YES], @"reloadingData",
                                  [NSNumber numberWithFloat:0], @"translationX",
                                  [NSNumber numberWithFloat:direction], @"translationY",
                                  [NSNumber numberWithBool:NO], @"isMovingHorizontally",
                                  [NSNumber numberWithInteger:touchPosition.row], @"positionX",
                                  [NSNumber numberWithInteger:touchPosition.column], @"positionY",
                                  nil];
            [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.001];
        }
    }else{ // 下滑
        
        for(CGFloat i = 0; ![[NSThread currentThread] isCancelled]; i+=fabs(direction)){
            if( i >= fabs(velocity.y) - rowHeight){
                YJGridViewCell *cell = [self.dataSource gridView:self cellAtPosition:YJPositionMake(0, touchPosition.column)];
                if((int)roundf(cell.frame.origin.y) % (int)roundf(rowHeight) == 0){
                    if(cell.frame.origin.y != 0){
                        direction = rowHeight - cell.frame.origin.y;
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithFloat:velocity.y], @"velocity",
                                              [NSNumber numberWithBool:YES], @"reloadingData",
                                              [NSNumber numberWithFloat:0], @"translationX",
                                              [NSNumber numberWithFloat:direction], @"translationY",
                                              [NSNumber numberWithBool:NO], @"isMovingHorizontally",
                                              [NSNumber numberWithInt:0], @"positionX",
                                              [NSNumber numberWithInteger:touchPosition.column], @"positionY",
                                              nil];
                        [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
                    }
                    break;
                }
            }
            
            direction = (velocity.y - i) / stepSize;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:velocity.y], @"velocity",
                                  [NSNumber numberWithBool:YES], @"reloadingData",
                                  [NSNumber numberWithFloat:0], @"translationX",
                                  [NSNumber numberWithFloat:direction], @"translationY",
                                  [NSNumber numberWithBool:NO], @"isMovingHorizontally",
                                  [NSNumber numberWithInteger:touchPosition.row], @"positionX",
                                  [NSNumber numberWithInteger:touchPosition.column], @"positionY",
                                  nil];
            [self performSelectorOnMainThread:@selector(moveCellSelector:) withObject:dict waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.001];
            
        }
    }
    
    if(![[NSThread currentThread] isCancelled]){
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}


-(void)moveCellSelector:(NSDictionary *)params{
    
    CGFloat velocity = [[params objectForKey:@"velocity"] floatValue];
    BOOL reloadingData = [[params objectForKey:@"reloadingData"] boolValue];
    CGPoint translation = CGPointMake([[params objectForKey:@"translationX"] floatValue], [[params objectForKey:@"translationY"] floatValue]);
    BOOL isMovingHorizontally = [[params objectForKey:@"isMovingHorizontally"] boolValue];
    YJPosition position = YJPositionMake([[params objectForKey:@"positionX"] intValue], [[params objectForKey:@"positionY"] intValue]);
    
    if(isMovingHorizontally){
        [self moveCellAtPosition:position horizontallyBy:velocity withTranslation:translation reloadingData:reloadingData];
    }else{
        [self moveCellAtPosition:position verticallyBy:velocity withTranslation:translation reloadingData:reloadingData];
    }
}

#pragma mark - SettingSupport
static inline YJPosition YJPositionMake(NSInteger row, NSInteger column) {
    return (YJPosition) {row, column};
}

/** 根据位置生成tag  This will only work if the row and column counter start at 0*/
- (NSInteger)_tagForPosition:(YJPosition)position{
    
    NSInteger tag = position.row * self.columns + position.column;
    if(tag == 0){
        tag = INT_MAX;
    }
    return tag;
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

/** 确定位置 */
-(YJPosition)determinePositionAtPoint:(CGPoint)point{
    
    YJPosition position;
    CGFloat height = self.bounds.size.height;
    CGFloat posY = point.y;
    CGFloat rowHeight = height / self.visibleRows; // 行高
    position.row = floor(posY / rowHeight);
    
    CGFloat width = self.bounds.size.width;
    CGFloat posX = point.x;
    CGFloat columnWidth = width / self.visibleColumns;
    position.column = floor(posX / columnWidth);
    
    return position;
}

-(void)moveCellAtPosition:(YJPosition)position horizontallyBy:(CGFloat)velocity withTranslation:(CGPoint)translation reloadingData:(BOOL)shouldReload{
    for(int i = -outerOffset; i< self.visibleColumns+outerOffset; i++){
        UIView *cell = [self viewWithTag:[self _tagForPosition:YJPositionMake(position.row, i)]];
        
        CGPoint center = cell.center;
        center.x += translation.x;
        cell.center = center;
    }
    
    UIView *cell = [self viewWithTag:[self _tagForPosition:YJPositionMake(position.row, 0)]];
    CGFloat width = self.bounds.size.width;
    CGFloat columnWidth = width / self.visibleColumns;
    CGFloat posX = cell.frame.origin.x;
    if(posX >= columnWidth){
        [self.delegate gridView:self didMoveCell:[self.dataSource gridView:self cellAtPosition:position] fromPosition:position toPosition:YJPositionMake(position.row, position.column + 1)];
        if(shouldReload){
            [self reloadData];
        }
    }else if(posX <= 0 - columnWidth){
        [self.delegate gridView:self didMoveCell:[self.dataSource gridView:self cellAtPosition:position] fromPosition:position toPosition:YJPositionMake(position.row, position.column - 1)];
        if(shouldReload){
            [self reloadData];
        }
    }
}

-(void)moveCellAtPosition:(YJPosition)position verticallyBy:(CGFloat)velocity withTranslation:(CGPoint)translation reloadingData:(BOOL)shouldReload{
    for(int i = -outerOffset; i< self.visibleRows + outerOffset; i++){
        UIView *cell = [self viewWithTag:[self _tagForPosition:YJPositionMake(i, position.column)]];
        CGPoint center = cell.center;
        center.y += translation.y;
        cell.center = center;
    }
    
    UIView *cell = [self viewWithTag:[self _tagForPosition:YJPositionMake(0, position.column)]];
    CGFloat height = self.bounds.size.height;
    CGFloat rowHeight = height / self.visibleRows;
    CGFloat posY = cell.frame.origin.y;
    if(posY >= rowHeight){
        [self.delegate gridView:self didMoveCell:[self.dataSource gridView:self cellAtPosition:position] fromPosition:position toPosition:YJPositionMake(position.row +1, position.column)];
        if(shouldReload){
            [self reloadData];
        }
    }else if(posY <= 0-rowHeight){
        [self.delegate gridView:self didMoveCell:[self.dataSource gridView:self cellAtPosition:position] fromPosition:position toPosition:YJPositionMake(position.row -1, position.column)];
        if(shouldReload){
            [self reloadData];
        }
    }
}

@end
