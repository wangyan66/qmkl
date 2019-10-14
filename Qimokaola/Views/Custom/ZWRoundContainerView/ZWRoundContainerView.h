//
//  ZWRoundContainerView.h
//  Qimokaola
//
//  Created by Administrator on 2017/3/12.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZWRoundContainerView : UIView

@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic, strong) IBInspectable UIColor *separatorColor;
@property (nonatomic, assign) IBInspectable NSUInteger column;
@property (nonatomic, assign) IBInspectable CGFloat radius;

@end
