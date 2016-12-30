//
//  YJTouchLabel.h
//  YJView
//
//  Created by YJHou on 2014/11/23.
//  Copyright © 2014年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJTouchLabel;
@protocol YJTouchLabelDelegate <NSObject>

@optional
/** 点击index */
- (void)touchLabel:(YJTouchLabel *)label toucheBegan:(UITouch *)touch onCharacterAtIndex:(NSInteger)index;
/** 移动 */
- (void)touchLabel:(YJTouchLabel *)label toucheMoved:(UITouch *)touch onCharacterAtIndex:(NSInteger)index;
/** 结束 */
- (void)touchLabel:(YJTouchLabel *)label toucheEnded:(UITouch *)touch onCharacterAtIndex:(NSInteger)index;
/** 取消 */
- (void)touchLabel:(YJTouchLabel *)label toucheCancelled:(UITouch *)touch onCharacterAtIndex:(NSInteger)index;

@end

@interface YJTouchLabel : UILabel

@property (nonatomic, weak) id<YJTouchLabelDelegate> delegate;

@end
