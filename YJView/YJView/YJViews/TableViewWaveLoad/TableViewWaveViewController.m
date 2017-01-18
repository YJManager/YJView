//
//  TableViewWaveViewController.m
//  YJView
//
//  Created by YJHou on 2017/1/17.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "TableViewWaveViewController.h"
#import "UITableView+Wave.h"

@interface TableViewWaveViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TableViewWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setUpWaveTableViewNavgationView];
    [self _setUpWaveTableViewMainView];
    [self _loadWaveTableViewDataFormServer];
}

- (void)_setUpWaveTableViewNavgationView{
    self.navigationItem.title = @"动态加载Tableview";
}

- (void)_setUpWaveTableViewMainView{
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

-(void)_loadWaveTableViewDataFormServer{
    for (int i = 0 ; i < 100; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"第%d行",i]];
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;

}

#pragma mark - Lazy
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView reloadDataAnimateWithWave:WaveAnimationDirectionFromRight speed:0.1 bounceDistance:0.0];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
