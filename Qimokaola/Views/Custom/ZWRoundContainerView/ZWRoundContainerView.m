//
//  ZWRoundContainerView.m
//  Qimokaola
//
//  Created by Administrator on 2017/3/12.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWRoundContainerView.h"

@implementation ZWRoundContainerView

- (void)makeDefaultValues {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    _borderColor = [UIColor whiteColor];
    _fillColor = [UIColor whiteColor];
    _separatorColor = RGB(240, 240, 240);
    _column = 2;
    _radius = 5.f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self makeDefaultValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self makeDefaultValues];
    }
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self layoutIfNeeded];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self layoutIfNeeded];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    [self layoutIfNeeded];
}

- (void)setColumn:(NSUInteger)column {
    _column = column;
    [self layoutIfNeeded];
}



- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self layoutIfNeeded];
}


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1.0 / self.contentScaleFactor, 1.0 / self.contentScaleFactor) cornerRadius:self.radius];
    roundRectPath.lineWidth = 0.5 / self.contentScaleFactor;
    [self.borderColor setStroke];
    [roundRectPath stroke];
    [self.fillColor setFill];
    [roundRectPath fill];
    
    if (self.column <= 0) {
        return;
    }
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 0.5;
    CGFloat columnHeight = rect.size.height / self.column;
    for (NSUInteger i = 0; i < self.column - 1; i ++) {
        CGFloat yOffset = columnHeight * (i + 1);
        CGFloat fixedOffset = linePath.lineWidth / self.contentScaleFactor;
        [linePath moveToPoint:CGPointMake(fixedOffset, yOffset - fixedOffset)];
        [linePath addLineToPoint:CGPointMake(rect.size.width - fixedOffset, yOffset - fixedOffset)];
    }
    [self.separatorColor setStroke];
    [linePath stroke];
}


@end
