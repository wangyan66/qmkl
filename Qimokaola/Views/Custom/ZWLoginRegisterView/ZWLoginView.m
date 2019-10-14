//
//  ZWLoginView.m
//  Qimokaola
//
//  Created by Administrator on 2017/3/12.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWLoginView.h"

@implementation ZWLoginView

+ (instancetype)loadLoginViewFormXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}


@end
