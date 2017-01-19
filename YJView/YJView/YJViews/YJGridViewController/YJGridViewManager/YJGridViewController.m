//
//  YJGridViewController.m
//  YJView
//
//  Created by YJHou on 2017/1/18.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJGridViewController.h"

@interface YJGridViewController () <YJGridViewDataSource, YJGridViewDelegate>

@property (nonatomic, strong) YJGridView *gridView; /**< 格子视图 */

@end

@implementation YJGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.gridView reloadData];
}

#pragma mark - YJGridViewDataSource
-(NSInteger)numberOfColumnsInGridView:(YJGridView *)gridView{
    return 0;
}

-(NSInteger)numberOfRowsInGridView:(YJGridView *)gridView{
    return 0;
}

-(NSInteger)numberOfVisibleRowsInGridView:(YJGridView *)gridView{
    return 0;
}

-(NSInteger)numberOfVisibleColumnsInGridView:(YJGridView *)gridView{
    return 0;
}

-(YJGridViewCell *)gridView:(YJGridView *)gridView cellAtPosition:(YJPosition)position{
    YJGridViewCell *cell = [[self cellDictionaryAtPosition:position] objectForKey:@"Cell"];
    if(!cell){
        cell = [[YJGridViewCell alloc] init];
    }
    return cell;
}

#pragma mark - YJGridViewDelegate
- (void)gridView:(YJGridView *)gridView didMoveCell:(YJGridViewCell *)cell fromPosition:(YJPosition)fromPosition toPosition:(YJPosition)toPosition{
    
    // y 滚动
    toPosition = [gridView normalizePosition:toPosition];
    if(toPosition.column == fromPosition.column){
        
        // 多少个在移动可以为负数
        NSInteger amount = toPosition.row - fromPosition.row;
        NSMutableDictionary *cellDict = [self cellDictionaryAtPosition:fromPosition];
        NSMutableDictionary *toCell;
        do{
            // 得到下一个cell
            toCell = [self cellDictionaryAtPosition:toPosition];
            
            // 更新当前cell
            [cellDict setObject:[NSNumber numberWithInteger:toPosition.row] forKey:@"Row"];
            
            // 准备下一个cell
            cellDict = toCell;
            
            // 计算下一个位置
            toPosition.row += amount;
            
            toPosition = [gridView normalizePosition:toPosition];
        }while (toCell);
    }else{ // 水平滚动
        
        NSInteger amount = toPosition.column - fromPosition.column;
        NSMutableDictionary *cellDict = [self cellDictionaryAtPosition:fromPosition];
        NSMutableDictionary *toCell;
        do{
            // 得到下一个cell
            toCell = [self cellDictionaryAtPosition:toPosition];
            
            // 更新当前cell
            [cellDict setObject:[NSNumber numberWithInteger:toPosition.column] forKey:@"Column"];
            
            // 准备下一个cell
            cellDict = toCell;
            
            // 计算下一个位置
            toPosition.column += amount;
            toPosition = [gridView normalizePosition:toPosition];
        }while (toCell);
        
    }
}


#pragma mark - Lazy
- (YJGridView *)gridView{
    if (_gridView == nil) {
        _gridView = [[YJGridView alloc] init];
        _gridView.dataSource = self;
        _gridView.delegate = self;
        self.view = _gridView;
    }
    return _gridView;
}

- (NSMutableArray *)cells{
    if (_cells == nil) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

#pragma mark - Supporting
- (NSMutableDictionary *)cellDictionaryAtPosition:(YJPosition)position{
    
    position = [self normalizePosition:position inGridView:_gridView];
    for(NSMutableDictionary *cellDict in _cells){
        if([[cellDict objectForKey:@"Row"] intValue] == position.row){
            if([[cellDict objectForKey:@"Column"] intValue] == position.column){
                return cellDict;
            }else{
                continue;
            }
        }else{
            continue;
        }
    }
    
    return nil;
}

- (YJPosition)normalizePosition:(YJPosition)position inGridView:(YJGridView *)gridView{
    return [gridView normalizePosition:position];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
