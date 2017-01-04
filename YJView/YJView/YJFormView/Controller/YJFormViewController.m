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
    [self _loadYJFormDataFormServer];
}

- (void)_setUpYJFormNavgationView{
    self.navigationItem.title = @"原生表格";
}

- (void)_setUpYJFormMainView{
    
    [self.view addSubview:self.formView];
    
}

- (NSArray *)formViewWithFormDataSource:(YJFormView *)formView{
    return @[@[@"编号", @"姓名", @"身高"], @[@"01", @"张三", @"175cm"], @[@"02", @"李四", @"180cm"], @[@"03", @"王五", @"165cm"], @[@"04", @"王蛋", @"159cm"], @[@"05", @"李四哈哈哈哈哈哈", @"180c545151515151515m"]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.formView reload];
}

-(void)_loadYJFormDataFormServer{
    
}

#pragma mark - Lazy
- (YJFormView *)formView{
    if (_formView == nil) {
        _formView = [[YJFormView alloc] initWithFrame:CGRectMake(5, 80, kSCREEN_WIDTH - 10, 200) columnRatios:[[NSArray alloc] initWithObjects:@0.2,@0.4,@0.4, nil]];
        _formView.dataSource = self;
        _formView.borderLineColor = [UIColor redColor];
    }
    return _formView;
}

@end
