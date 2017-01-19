//
//  GridViewController.m
//  YJView
//
//  Created by YJHou on 2017/1/19.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "GridViewController.h"

@interface GridViewController ()

@end

@implementation GridViewController

- (id)init{
    self = [super init];
    if (self) {
        for(int row = 0; row < 9; row++){
            for(int col = 0; col < 9; col++){
                YJGridViewCell *cell = [[YJGridViewCell alloc] init];
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d-%d.jpeg",row,col]];
                
                UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                [iv setContentMode:UIViewContentModeScaleAspectFill];
                iv.clipsToBounds = YES;
                [iv setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell addSubview:iv];
                [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[iv]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(iv)]];
                [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[iv]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(iv)]];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:cell forKey:@"Cell"];
                [dict setObject:[NSNumber numberWithInt:row] forKey:@"Row"];
                [dict setObject:[NSNumber numberWithInt:col] forKey:@"Column"];
                [self.cells addObject:dict];
                
            }
        }
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}

#pragma mark - GridView datasource
-(NSInteger)numberOfColumnsInGridView:(YJGridView *)gridView{
    return 8;
}

-(NSInteger)numberOfRowsInGridView:(YJGridView *)gridView{
    return 8;
}

-(NSInteger)numberOfVisibleRowsInGridView:(YJGridView *)gridView{
    return 3;
}

-(NSInteger)numberOfVisibleColumnsInGridView:(YJGridView *)gridView{
    return 4;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
