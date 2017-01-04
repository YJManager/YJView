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

@end

@implementation YJFormView

- (instancetype)initWithFrame:(CGRect)frame columnRatios:(NSArray <NSNumber *>*)columnRatios{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUpInitWithFrame:frame columnRatios:columnRatios];
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

- (void)addRecord: (NSArray*)record {
    if(record.count != self.columnWidths.count){
        NSLog(@"!!! Number of items does not match number of columns. !!!");
        return;
    }
    uint rowHeight = 30;
    uint dx = 0;
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    //CREATE THE ITEMS/COLUMNS OF THE ROW
    for(uint i=0; i<record.count; i++){
        float colWidth = [[self.columnWidths objectAtIndex:i] floatValue];//colwidth as given at setup
        CGRect rect = CGRectMake(dx, self.dy, colWidth, rowHeight);
        //ADJUST X FOR BORDER OVERLAPPING BETWEEN COLUMNS
        if(i>0){
            rect.origin.x -= i;
        }
        //--------------------------------------------
        UILabel* col1 = [[UILabel alloc] init];
        [col1.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
        [col1.layer setBorderWidth:1.0];
        col1.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        col1.frame = rect;
        //SET LEFT RIGHT MARGINS & ALIGNMENT FOR THE LABEL
        NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentNatural;
        style.headIndent = 10;
        style.firstLineHeadIndent = 10.0;
        style.tailIndent = -10.0;
        //SPECIAL TREATMENT FOR THE FIRST ROW
        if(self.rows == 0){
            style.alignment = NSTextAlignmentCenter;
            col1.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        }
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[record objectAtIndex:i] attributes:@{NSParagraphStyleAttributeName : style}];
        col1.lineBreakMode = NSLineBreakByCharWrapping;
        col1.numberOfLines = 0;
        col1.attributedText = attrText;
        [col1 sizeToFit];
        //USED TO FIND HEIGHT OF LONGEST LABEL
        CGFloat h = col1.frame.size.height + 10;
        if(h > rowHeight){
            rowHeight = h;
        }
        //MAKE THE LABEL WIDTH SAME AS COLUMN'S WIDTH
        rect.size.width = colWidth;
        col1.frame = rect;
        [labels addObject:col1];
        //USED FOR SETTING THE NEXT COLUMN X POSITION
        dx += colWidth;
    }
    //MAKE ALL THE LABELS OF SAME HEIGHT AND THEN ADD TO VIEW
    for(uint i=0; i<labels.count; i++){
        UILabel* tempLabel = (UILabel*)[labels objectAtIndex:i];
        CGRect tempRect = tempLabel.frame;
        tempRect.size.height = rowHeight;
        tempLabel.frame = tempRect;
        [self addSubview:tempLabel];
    }
    self.rows++;
    //ADJUST y FOR BORDER OVERLAPPING BETWEEN ROWS
    self.dy += rowHeight-1;
    //RESIZE THE MAIN VIEW TO FIT THE ROWS
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
