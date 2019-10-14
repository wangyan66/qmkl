//
//  ZWRegisterView.m
//  Qimokaola
//
//  Created by Administrator on 2017/3/12.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWRegisterView.h"

@interface ZWRegisterView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTrailling;


@end

@implementation ZWRegisterView

+ (instancetype)loadRegisterViewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.btnTrailling.constant -= 0.5 / self.contentScaleFactor;
}

@end
