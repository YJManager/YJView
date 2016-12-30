//
//  TouchLinkLabelViewController.m
//  YJView
//
//  Created by YJHou on 2016/12/30.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "TouchLinkLabelViewController.h"
#import "YJTouchLabel.h"

@interface TouchLinkLabelViewController () <YJTouchLabelDelegate>

@property (nonatomic, strong) YJTouchLabel *touchLabel; /**< 可点击的label */
@property (nonatomic, strong) YJTouchLabel *linkLabel; /**< 可点击的label */

@end

@implementation TouchLinkLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YJTouchLabelDelegate
- (void)touchLabel:(YJTouchLabel *)label toucheBegan:(UITouch *)touch onCharacterAtIndex:(NSInteger)index{

}

- (void)touchLabel:(YJTouchLabel *)label toucheMoved:(UITouch *)touch onCharacterAtIndex:(NSInteger)index{

}

- (void)touchLabel:(YJTouchLabel *)label toucheEnded:(UITouch *)touch onCharacterAtIndex:(NSInteger)index{

}

- (void)touchLabel:(YJTouchLabel *)label toucheCancelled:(UITouch *)touch onCharacterAtIndex:(NSInteger)index{

}


#pragma mark - Lazy
- (YJTouchLabel *)touchLabel{
    if (_touchLabel == nil) {
        _touchLabel = [[YJTouchLabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.5)];
        _touchLabel.delegate = self;
        _touchLabel.numberOfLines = 0;
    }
    return _touchLabel;
}


@end
