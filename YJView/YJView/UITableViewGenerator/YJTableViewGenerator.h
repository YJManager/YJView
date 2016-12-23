//
//  YJTableViewGenerator.h
//  YJView
//
//  Created by YJHou on 2016/12/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTableViewGenerator : NSObject

typedef void(^SelectedHandle)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^ScrollHandle)(UIScrollView *scrollView, CGPoint contentOffset);

+ (UITableView *)createRandomTableViewAtController:(UIViewController *)controller
                                 didSelectedHandle:(SelectedHandle)selectedHandle
                                   didScrollHandle:(ScrollHandle)scrollHandle;


@end
