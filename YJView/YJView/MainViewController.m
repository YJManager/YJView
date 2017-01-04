//
//  MainViewController.m
//  YJView
//
//  Created by YJHou on 2016/12/30.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "MainViewController.h"
#import "YJTableViewGenerator.h"
#import "TouchLinkLabelViewController.h"
#import "PlaceholderTextViewController.h"
#import "YJFormViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    NSArray * dataSource = @[@"可点击和超链接Label",
                             @"带有Placeholder的TextView",
                             @"原生的表格"
                             ];
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
    NSInteger index = indexPath.row;
    UIViewController *pushingController = nil;
    if (index == 0) {
        TouchLinkLabelViewController *vc = [[TouchLinkLabelViewController alloc] init];
        pushingController = vc;
    }else if (index == 1){
        PlaceholderTextViewController *vc = [[PlaceholderTextViewController alloc] init];
        pushingController = vc;
    }else if (index == 2){
        YJFormViewController *vc = [[YJFormViewController alloc] init];
        pushingController = vc;
    }
    
    if (pushingController) {
        pushingController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushingController animated:YES];
    }
}

- (void)scrollView:(UIScrollView *)tableView contentOffset:(CGPoint)contentOffset{
    //    NSLog(@"Point-->%@", NSStringFromCGPoint(contentOffset));
}


@end
