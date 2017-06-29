//
//  YJTableViewGenerator.h
//  YJView
//
//  Created by YJHou on 2016/2/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectRowHandleBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^didScrollHandleBlock)(UIScrollView *tableView, CGPoint contentOffset);

@interface YJTableViewGenerator : NSObject

+ (YJTableViewGenerator *)shareInstance;

/** 创建tableView */
- (UITableView *)createTableViewWithDataSource:(NSArray *)dataSource
                                     cellClass:(Class)cellClass
                                     rowHeight:(CGFloat)rowHeight
                                  inController:(UIViewController *)controller
                             didSelectRowBlock:(didSelectRowHandleBlock)didSelectRowBlock
                                didScrollBlock:(didScrollHandleBlock)didScrollBlock;


@end
