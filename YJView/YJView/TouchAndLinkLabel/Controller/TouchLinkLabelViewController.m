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
    [self.view addSubview:self.touchLabel];
    [self.view addSubview:self.linkLabel];
}


#pragma mark - YJTouchLabelDelegate
- (void)touchLabel:(YJTouchLabel *)label toucheBegan:(UITouch *)touch onCharacterAtIndex:(CFIndex)index{
    if (label == self.touchLabel) {
        [self touchLabel:label highlightCharacterAtIndex:index];
    }else if (label == self.linkLabel){
    
    }
}

- (void)touchLabel:(YJTouchLabel *)label toucheMoved:(UITouch *)touch onCharacterAtIndex:(CFIndex)index{
    if (label == self.touchLabel) {
        [self touchLabel:label highlightCharacterAtIndex:index];
    }else if (label == self.linkLabel){
        
    }
}

- (void)touchLabel:(YJTouchLabel *)label toucheEnded:(UITouch *)touch onCharacterAtIndex:(CFIndex)index{
    if (label == self.touchLabel) {
        [self removeHighlightWithLabel:label];
    }else if (label == self.linkLabel){
        
    }
}

- (void)touchLabel:(YJTouchLabel *)label toucheCancelled:(UITouch *)touch onCharacterAtIndex:(CFIndex)index{
    if (label == self.touchLabel) {
        [self removeHighlightWithLabel:label];
    }else if (label == self.linkLabel){
        
    }
}

#pragma mark - SettingSupport
- (void)touchLabel:(YJTouchLabel *)label highlightCharacterAtIndex:(CFIndex)charIndex {
    
    if (charIndex == NSNotFound) {
        [self removeHighlightWithLabel:label];
        return;
    }
    
    NSString *string = label.text;
    
    //compute the positions of space characters next to the charIndex
    NSString *blankString = @" ";
    NSRange front = [string rangeOfString:blankString options:NSBackwardsSearch range:NSMakeRange(0, charIndex)];
    NSRange end = [string rangeOfString:blankString options:NSCaseInsensitiveSearch range:NSMakeRange(charIndex, string.length - charIndex)];
    
    if (front.location == NSNotFound) {
        front.location = 0;
    }
    
    if (end.location == NSNotFound) {
        end.location = string.length;
    }
    
    NSRange wordRange = NSMakeRange(front.location, end.location - front.location);
    
    if (front.location != 0) {
        wordRange.location += 1;
        wordRange.length -= 1;
    }
    
    if (wordRange.location == label.highlightedRange.location) {
        return;
    }else {
        [self removeHighlightWithLabel:label];
    }
    
    label.highlightedRange = wordRange;
    
    NSMutableAttributedString *attributedString = [label.attributedText mutableCopy];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor redColor] range:wordRange];
    label.attributedText = attributedString;
    
//    NSString *wordString = [label.text substringWithRange:wordRange];
//    NSLog(@"wordString-->%@", wordString);
}

- (void)removeHighlightWithLabel:(YJTouchLabel *)label{
    
    if (label.highlightedRange.location != NSNotFound) {
        
        NSMutableAttributedString *attributedString = [label.attributedText mutableCopy];
        [attributedString removeAttribute:NSBackgroundColorAttributeName range:label.highlightedRange];
        label.attributedText = attributedString;
        label.highlightedRange = NSMakeRange(NSNotFound, 0);
    }
}

#pragma mark - Lazy
- (YJTouchLabel *)touchLabel{
    if (_touchLabel == nil) {
        _touchLabel = [[YJTouchLabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.5)];
        _touchLabel.delegate = self;
        _touchLabel.text = @"是中国 最专业 最有数据凝聚力的 移动开发 者服务平台 友盟以移动应用 统计分析为产品起点 发展成为提 供从基础设置搭 建-开发-运营服务的 整合服务平台 致力于为移动开发 者提供专业的数据统计分析 开发和运营组件及推广服务 2013年10月推出“一站式“解决方案，服务包含移 动用统计分析以 及细分行的移动 游戏统计分析 社会化分享组件 消息推送 自动更新 用户反馈错误分析等产品";
        _touchLabel.numberOfLines = 0;
    }
    return _touchLabel;
}

- (YJTouchLabel *)linkLabel{
    if (_linkLabel == nil) {
        _linkLabel = [[YJTouchLabel alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT * 0.5, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.5)];
        _linkLabel.layer.borderWidth = 1;
        _linkLabel.numberOfLines = 0;
        _linkLabel.layer.borderColor = [UIColor grayColor].CGColor;
        _linkLabel.delegate = self;
    }
    return _linkLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
