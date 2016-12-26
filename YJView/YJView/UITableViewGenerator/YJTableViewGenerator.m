//
//  YJTableViewGenerator.m
//  YJView
//
//  Created by YJHou on 2016/12/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "YJTableViewGenerator.h"

@interface YJTableViewGenerator () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource; /**< 数据源 */
@property (nonatomic, copy) didSelectRowHandleBlock didselectRowBlock; /**< 点击row */
@property (nonatomic, copy) didScrollHandleBlock didScrollBlock; /**< 滚动block */

@end

@implementation YJTableViewGenerator

+ (YJTableViewGenerator *)shareInstance{
    static YJTableViewGenerator *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YJTableViewGenerator alloc] init];
    });
    return _instance;
}

- (UITableView *)createTableViewWithDataSource:(NSArray *)dataSource
                                     rowHeight:(CGFloat)rowHeight
                                 inController:(UIViewController *)controller
                            didSelectRowBlock:(didSelectRowHandleBlock)didSelectRowBlock
                               didScrollBlock:(didScrollHandleBlock)didScrollBlock{
    
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
    self.didselectRowBlock = didSelectRowBlock;
    self.didScrollBlock = didScrollBlock;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:controller.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = rowHeight;
    tableView.tableFooterView = [UIView new];
    [controller.view addSubview:tableView];
    return tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellId = @"YJTableViewGeneratorCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didselectRowBlock) {
        self.didselectRowBlock(tableView, indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScrollBlock) {
        self.didScrollBlock(scrollView, scrollView.contentOffset);
    }
}

#pragma mark - Lazy
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
