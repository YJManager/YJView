//
//  YJTableViewGenerator.h
//  YJView
//
//  Created by YJHou on 2016/12/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectRowHandleBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^didScrollHandleBlock)(UIScrollView *tableView, CGPoint contentOffset);

@interface YJTableViewGenerator : NSObject


/** 创建tableView */
- (UITableView *)createTableViewWithDataSource:(NSArray *)dataSource
                                     rowHeight:(CGFloat)rowHeight
                                  inController:(UIViewController *)controller
                             didSelectRowBlock:(didSelectRowHandleBlock)didSelectRowBlock
                                didScrollBlock:(didScrollHandleBlock)didScrollBlock;


@end
