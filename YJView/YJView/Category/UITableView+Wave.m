//
//  UITableView+Wave.m
//  YJView
//
//  Created by YJHou on 2017/1/17.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "UITableView+Wave.h"

@implementation UITableView (Wave)

- (void)reloadDataAnimateWithWave:(WaveAnimationDirection)animation{
    
    [self setContentOffset:self.contentOffset animated:NO];
    [UIView animateWithDuration:0.0 animations:^{
        [self setHidden:YES];
        [self reloadData];
    }completion:^(BOOL finished){
        [self setHidden:NO];
        
        // reloadData 加载完毕
        [self visibleRowsBeginAnimation:animation];
    }];
}


- (void)visibleRowsBeginAnimation:(WaveAnimationDirection)animation{
    
    NSArray *array = [self indexPathsForVisibleRows];
    for (int i = 0; i < array.count; i++) {
        NSIndexPath *path = [array objectAtIndex:i];
        UITableViewCell *cell = [self cellForRowAtIndexPath:path];
        cell.hidden = YES;
        NSArray *array = @[path, [NSNumber numberWithInt:animation]];
        [self performSelector:@selector(animationStart:) withObject:array afterDelay:0.1 * (i+1)];
    }
}

- (void)animationStart:(NSArray *)array{
    
    NSIndexPath *path = [array objectAtIndex:0];
    float i = [((NSNumber*)[array objectAtIndex:1]) floatValue] ;
    UITableViewCell *cell = [self cellForRowAtIndexPath:path];
    CGPoint originPoint = cell.center;
    
    // 从底部
    if (i == 0) {
        i = 0.5f;
    }
    cell.center = CGPointMake(cell.frame.size.width * i, originPoint.y);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         cell.center = CGPointMake(originPoint.x - i * kBOUNCE_DISTANCE, originPoint.y);
                         cell.hidden = NO;
                     }
                     completion:^(BOOL f) {
                         [UIView animateWithDuration:0.1 delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              cell.center = CGPointMake(originPoint.x + i * kBOUNCE_DISTANCE, originPoint.y);
                                          }
                                          completion:^(BOOL f) {
                                              [UIView animateWithDuration:0.1 delay:0
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   cell.center= originPoint;
                                                               }completion:NULL];
                                          }];
                     }];
    
    
}


@end
