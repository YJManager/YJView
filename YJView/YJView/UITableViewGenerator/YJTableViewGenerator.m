//
//  YJTableViewGenerator.m
//  YJView
//
//  Created by YJHou on 2016/12/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "YJTableViewGenerator.h"

static NSMutableArray *_array;
@interface YJTableViewGenerator () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation YJTableViewGenerator{
    SelectedHandle _selectedHandle;
    ScrollHandle _scrollHandle;
}

+ (void)initialize {
    _array = [NSMutableArray array];
}

+ (instancetype)shareInstance {
    id instance = [self new];
    [_array addObject:instance];
    return instance;
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


@end
