//
//  YJTouchLabel.m
//  YJView
//
//  Created by YJHou on 2014/11/23.
//  Copyright © 2014年 YJHou. All rights reserved.
//

#import "YJTouchLabel.h"
#import <CoreText/CoreText.h>

@interface YJTouchLabel ()

@end

@implementation YJTouchLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.highlightedRange = NSMakeRange(NSNotFound, 0);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.highlightedRange = NSMakeRange(NSNotFound, 0);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point{
    
    NSMutableAttributedString *optimizedAttributedText = [self.attributedText mutableCopy];
    
    // 统一换行模式
    [self.attributedText enumerateAttribute:(NSString *)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, optimizedAttributedText.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle *paragraphStyle = [value mutableCopy];
        
        if (paragraphStyle.lineBreakMode == NSLineBreakByTruncatingTail) {
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        }
        
        [optimizedAttributedText removeAttribute:(NSString *)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString *)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        
    }];
    
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRectValue];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // 求出触摸点和文本显示的坐标点
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0?MIN(self.numberOfLines, CFArrayGetCount(lines)):CFArrayGetCount(lines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

#pragma mark - SettingSupport
- (CGRect)textRectValue{
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height) * 0.5;
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width) * 0.5;
    }else if (self.textAlignment == NSTextAlignmentRight){
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    return textRect;
}

#pragma mark -- Action
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchLabel:toucheBegan:onCharacterAtIndex:)]) {
        [self.delegate touchLabel:self toucheBegan:touch onCharacterAtIndex:index];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchLabel:toucheMoved:onCharacterAtIndex:)]) {
        [self.delegate touchLabel:self toucheMoved:touch onCharacterAtIndex:index];
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchLabel:toucheEnded:onCharacterAtIndex:)]) {
        [self.delegate touchLabel:self toucheEnded:touch onCharacterAtIndex:index];
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchLabel:toucheCancelled:onCharacterAtIndex:)]) {
        [self.delegate touchLabel:self toucheCancelled:touch onCharacterAtIndex:index];
    }
    [super touchesCancelled:touches withEvent:event];
}

@end
