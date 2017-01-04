//
//  PlaceholderTextViewController.m
//  YJView
//
//  Created by YJHou on 2017/1/4.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "PlaceholderTextViewController.h"
#import "YJPlaceholderTextView.h"

@interface PlaceholderTextViewController ()

@property (nonatomic, strong) YJPlaceholderTextView *textView;

@end

@implementation PlaceholderTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setUpPlaceholderTextViewNavgationView];
    [self _setUpPlaceholderTextViewMainView];
    [self _loadPlaceholderTextViewDataFormServer];
}

- (void)_setUpPlaceholderTextViewNavgationView{
    self.navigationItem.title = @"带有placeholderTextView";
}

- (void)_setUpPlaceholderTextViewMainView{
    [self.view addSubview:self.textView];
}

-(void)_loadPlaceholderTextViewDataFormServer{
    
}

#pragma mark - Lazy
- (YJPlaceholderTextView *)textView{
    if (_textView == nil) {
        _textView = [[YJPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH - 20, 260)];
        _textView.placeholder = @"placeholder";
        _textView.textColor = [UIColor grayColor];
        _textView.layer.cornerRadius = 2;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _textView;
}

@end
