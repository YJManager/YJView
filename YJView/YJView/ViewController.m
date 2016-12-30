//
//  ViewController.m
//  YJView
//
//  Created by YJHou on 2016/12/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "ViewController.h"
#import "YJTableViewGenerator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setUpMainNavgationView];
    [self _setUpMainMainView];
    [self _loadMainDataFormServer];
}

- (void)_setUpMainNavgationView{
    self.navigationItem.title = @"自定义View";
}

- (void)_setUpMainMainView{
    
    NSArray * dataSource = @[@"可点击的Label"];
    __weak typeof(self) weakSelf = self;
    [[YJTableViewGenerator shareInstance] createTableViewWithDataSource:dataSource rowHeight:44 inController:self didSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRow:indexPath];
    } didScrollBlock:^(UIScrollView *tableView, CGPoint contentOffset) {
        [weakSelf scrollView:tableView contentOffset:contentOffset];
    }];
}

-(void)_loadMainDataFormServer{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - RealAction
- (void)tableView:(UITableView *)tableView didSelectRow:(NSIndexPath *)indexPath{
    NSLog(@"-->%ld", indexPath.row);
}

- (void)scrollView:(UIScrollView *)tableView contentOffset:(CGPoint)contentOffset{
//    NSLog(@"Point-->%@", NSStringFromCGPoint(contentOffset));
}


@end
