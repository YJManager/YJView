//
//  ActivityIndicatorViewController.m
//  YJView
//
//  Created by YJHou on 2017/2/6.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "ActivityIndicatorViewController.h"
#import "YJActivityIndicatorView.h"
#import "YJActivityIndicatorSubExample.h"

@interface ActivityIndicatorViewController ()

@end

@implementation ActivityIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"各种活动指示圈圈";
    [self _setUpActivityIndicatorMainView];
}

- (void)_setUpActivityIndicatorMainView{
    
    YJActivityIndicatorView *activityIndicator = [[YJActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 50, 0, 0)];
    activityIndicator.backgroundColor = self.view.backgroundColor;
    activityIndicator.opaque = YES;
    activityIndicator.steps = 6;
    activityIndicator.finSize = CGSizeMake(17, 10);
    activityIndicator.indicatorRadius = 20;
    activityIndicator.stepDuration = 0.5;
    activityIndicator.color = [UIColor redColor];
    activityIndicator.cornerRadii = CGSizeMake(0, 0);
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    activityIndicator = [[YJActivityIndicatorSubExample alloc] initWithFrame:CGRectMake(150, 50, 0, 0)];
    activityIndicator.backgroundColor = self.view.backgroundColor;
    activityIndicator.opaque = YES;
    activityIndicator.steps = 8;
    activityIndicator.finSize = CGSizeMake(20, 10);
    activityIndicator.indicatorRadius = 10;
    activityIndicator.stepDuration = 0.0570;
    activityIndicator.roundedCoreners = UIRectCornerAllCorners;
    activityIndicator.cornerRadii = CGSizeMake(4, 4);
    activityIndicator.color = [UIColor darkGrayColor];
    activityIndicator.direction = YJActivityIndicatorDirectionCounterClockwise;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    activityIndicator = [[YJActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 150, 0, 0)];
    activityIndicator.backgroundColor = self.view.backgroundColor;
    activityIndicator.opaque = YES;
    activityIndicator.steps = 16;
    activityIndicator.finSize = CGSizeMake(8, 40);
    activityIndicator.indicatorRadius = 20;
    activityIndicator.stepDuration = 0.100;
    activityIndicator.color = [UIColor colorWithRed:0.0 green:34.0/255.0 blue:85.0/255.0 alpha:1.000];
    activityIndicator.roundedCoreners = UIRectCornerTopRight;
    activityIndicator.cornerRadii = CGSizeMake(10, 10);
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];

}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
