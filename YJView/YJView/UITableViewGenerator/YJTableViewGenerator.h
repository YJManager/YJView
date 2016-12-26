//
//  YJTableViewGenerator.h
//  YJView
//
//  Created by YJHou on 2016/12/23.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectRowHandleBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^didScrollHandleBlock)(UITableView *tableView, CGPoint contentOffset);

@interface YJTableViewGenerator : NSObject


+ (UITableView *)createRandomTableViewAtController:(UIViewController *)controller
                                 didSelectedHandle:(SelectedHandle)selectedHandle
                                   didScrollHandle:(ScrollHandle)scrollHandle;


@end
