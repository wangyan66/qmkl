//
//  CALayer+BorderColorFromUIColor.m
//  Qimokaola
//
//  Created by Administrator on 16/7/20.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)

- (void)setBorderColorFromUIColor:(UIColor *)borderColorFromUIColor {
    self.borderColor = borderColorFromUIColor.CGColor;
}

- (UIColor *)borderColorFromUIColor {
    return [[UIColor alloc] initWithCGColor:self.borderColor];
}

@end
