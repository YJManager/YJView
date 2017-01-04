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
- (void)touchLabel:(YJTouchLabel *)label toucheBegan:(UITouch *)touch onCharacterAtIndex:(CFIndex)index;
/** 移动 */
- (void)touchLabel:(YJTouchLabel *)label toucheMoved:(UITouch *)touch onCharacterAtIndex:(CFIndex)index;
/** 结束 */
- (void)touchLabel:(YJTouchLabel *)label toucheEnded:(UITouch *)touch onCharacterAtIndex:(CFIndex)index;
/** 取消 */
- (void)touchLabel:(YJTouchLabel *)label toucheCancelled:(UITouch *)touch onCharacterAtIndex:(CFIndex)index;

@end

@interface YJTouchLabel : UILabel

@property (nonatomic, assign) NSRange highlightedRange; /**< 上次选中的 */
@property (nonatomic, weak) id<YJTouchLabelDelegate> delegate;

@end
