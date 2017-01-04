//
//  YJFormView.m
//  YJView
//
//  Created by YJHou on 2017/1/4.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJFormView.h"

// https://github.com/neeks/ios-labels-matrix-view-swift

@interface YJFormView ()

@property (nonatomic, strong) NSMutableArray *columnWidths; /**< 列宽 */
@property (nonatomic, assign) NSUInteger rows; /**< 共行数 */
@property (nonatomic, assign) NSUInteger dy; /**< 纵向起点 */
@property (nonatomic, strong) NSArray *currentDataSource; /**< 当前数据源 */

@end

@implementation YJFormView

- (instancetype)initWithFrame:(CGRect)frame columnRatios:(NSArray <NSNumber *>*)columnRatios{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUpInitWithFrame:frame columnRatios:columnRatios];
        self.borderLineColor = [UIColor colorWithWhite:0.821 alpha:1.000];
        self.borderLineWidth = 1.0f;
    }
    return self;
}

- (void)_setUpInitWithFrame:(CGRect)frame columnRatios:(NSArray <NSNumber *>*)columnRatios{
    
    if (self.columnWidths.count > 0) {
        [self.columnWidths removeAllObjects];
    }
    for (NSNumber *value in columnRatios) {
        CGFloat contentW = frame.size.width;
        [self.columnWidths addObject:[NSNumber numberWithDouble:(contentW * value.doubleValue)]];
    }
    
    self.rows = 0;
    self.dy = 0;
}

- (NSArray *)formDataSource{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(formViewWithFormDataSource:)]) {
        return [self.dataSource formViewWithFormDataSource:self];
    }else{
        return nil;
    }
}

- (void)reload{
    
    NSArray *formDatasource = [self formDataSource];
    if ([self.currentDataSource isEqualToArray:formDatasource]) {
        return;
    }else{
        self.currentDataSource = formDatasource;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (NSArray *records in formDatasource) {
        
        if (records.count == 0) continue;

        NSMutableArray *contents = [NSMutableArray arrayWithArray:records];
        // 容错处理
        NSInteger distanceCount = self.columnWidths.count - contents.count;
        
        if (distanceCount > 0) { // 数据不够
            for (NSInteger i = 0; i < distanceCount; i++) {
                [contents addObject:@""];
            }
        }else if (distanceCount < 0){ // 数据超了
            [contents removeObjectsInRange:NSMakeRange(self.columnWidths.count, -distanceCount)];
        }

        [self reloadFormViewWithRecord:contents];
    }
}

- (void)reloadFormViewWithRecord:(NSArray *)records{
    
    uint rowHeight = 30;
    uint dx = 0;
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < records.count; i++){
        // 取出列宽
        float colWidth = [[self.columnWidths objectAtIndex:i] floatValue];
        CGRect rect = CGRectMake(dx, self.dy, colWidth, rowHeight);
        
        // 调整线宽为重叠
        if(i > 0){
            rect.origin.x -= i * self.borderLineWidth;
        }
        
        UILabel *col1 = [[UILabel alloc] init];
        [col1.layer setBorderColor:self.borderLineColor.CGColor];
        [col1.layer setBorderWidth:self.borderLineWidth];
        col1.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        col1.frame = rect;
        
        NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentNatural;
        style.headIndent = 10;
        style.firstLineHeadIndent = 10.0;
        style.tailIndent = -10.0;
        
        if(self.rows == 0){
            style.alignment = NSTextAlignmentCenter;
            col1.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        }
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[records objectAtIndex:i] attributes:@{NSParagraphStyleAttributeName : style}];
        col1.lineBreakMode = NSLineBreakByCharWrapping;
        col1.numberOfLines = 0;
        col1.attributedText = attrText;
        [col1 sizeToFit];
        
        // 找到最长内容的高度
        CGFloat h = col1.frame.size.height + 10;
        if(h > rowHeight){
            rowHeight = h;
        }
        
        // 使宽度相同
        rect.size.width = colWidth;
        col1.frame = rect;
        [labels addObject:col1];
        
        // 下一个的x
        dx += colWidth;
    }
    
    // 使每个高度相同
    for(uint i = 0; i < labels.count; i++){
        UILabel *tempLabel = (UILabel*)[labels objectAtIndex:i];
        CGRect tempRect = tempLabel.frame;
        tempRect.size.height = rowHeight;
        tempLabel.frame = tempRect;
        [self addSubview:tempLabel];
    }
    self.rows++;
    
    // 纵向处理边缘
    self.dy += rowHeight-self.borderLineWidth;
    
    // 重新计算最终的frame
    CGRect tempRect = self.frame;
    tempRect.size.height = self.dy;
    self.frame = tempRect;
}


#pragma mark - Lazy
- (NSMutableArray *)columnWidths{
    if (_columnWidths == nil) {
        _columnWidths = [NSMutableArray array];
    }
    return _columnWidths;
}

@end
