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


+ (UITableView *)createRandomTableViewAtController:(UIViewController *)controller
                                 didSelectedHandle:(SelectedHandle)selectedHandle
                                   didScrollHandle:(ScrollHandle)scrollHandle {
    YJTableViewGenerator *generator = [self shareInstance];
    generator->_selectedHandle = selectedHandle;
    generator->_scrollHandle = scrollHandle;
    UITableView *tableView = [[UITableView alloc] initWithFrame:controller.view.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = generator;
    tableView.dataSource = generator;
    tableView.rowHeight = 44;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [controller.view addSubview:tableView];
    return tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedHandle(tableView, indexPath);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _scrollHandle(scrollView, scrollView.contentOffset);
}

#pragma mark - Lazy
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
