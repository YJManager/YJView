//
//  YJFormViewController.m
//  YJView
//
//  Created by YJHou on 2017/1/4.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJFormViewController.h"
#import "YJFormView.h"

@interface YJFormViewController ()

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
    
    YJFormView * matrix = [[YJFormView alloc] initWithFrame:CGRectMake(5, 60, kSCREEN_WIDTH - 10, 200) columnRatios:[[NSArray alloc] initWithObjects:@0.2,@0.4,@0.4, nil]];
    
    
    [matrix addRecord:[[NSArray alloc] initWithObjects:@" ", @"Old Value", @"New value ", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"Field1", @"hello", @"This is a really really long string and should wrap to multiple lines.", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"Some Date", @"06/24/2013", @"06/30/2013", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"Field2", @"some value", @"some new value", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"Long Fields", @"The quick brown fox jumps over the little lazy dog.", @"some new value", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"Long Fields", @"The quick brown fox jumps over the little lazy dog.", @"some new value", nil]];
    
    [self.view addSubview:matrix];
    
}

-(void)_loadYJFormDataFormServer{
    
}

@end
