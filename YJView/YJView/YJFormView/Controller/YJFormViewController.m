//
//  YJFormViewController.m
//  YJView
//
//  Created by YJHou on 2017/1/4.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJFormViewController.h"
#import "YJFormView.h"

@interface YJFormViewController () <YJFormViewDatasource>

@property (nonatomic, strong) YJFormView *formView; /**< 原生表格 */

@end

@implementation YJFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setUpYJFormNavgationView];
    [self _setUpYJFormMainView];
}

- (void)_setUpYJFormNavgationView{
    self.navigationItem.title = @"原生表格";
}

- (void)_setUpYJFormMainView{
    
    [self.view addSubview:self.formView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.formView reload];
    });
    
}

- (NSArray *)formViewWithFormDataSource:(YJFormView *)formView{
    return @[@[@"编号", @"姓名", @"身高"], @[@"01", @"张三", @"175cm"], @[@"02", @"李四", @"180cm"], @[@"03", @"王五", @"165cm"], @[@"04", @"王蛋", @"159cm"], @[@"05", @"李四哈哈哈哈哈哈", @"180c545151515151515m"]];
}

#pragma mark - Lazy
- (YJFormView *)formView{
    if (_formView == nil) {
        _formView = [[YJFormView alloc] initWithFrame:CGRectMake(5, 80, kSCREEN_WIDTH - 10, 200) columnRatios:[[NSArray alloc] initWithObjects:@0.1,@0.45,@0.45, nil]];
        _formView.dataSource = self;
        _formView.borderLineColor = [UIColor redColor];
        _formView.borderLineWidth = 2.0f;
    }
    return _formView;
}

@end
