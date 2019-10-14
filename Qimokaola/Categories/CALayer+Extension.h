//
//  CALayer+BorderColorFromUIColor.h
//  Qimokaola
//
//  Created by Administrator on 16/7/20.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface CALayer (Extension)

@property (nonatomic, strong)  UIColor *borderColorFromUIColor;

@end
