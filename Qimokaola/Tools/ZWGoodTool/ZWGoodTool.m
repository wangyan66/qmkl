//
//  ZWGoodTool.m
//  Qimokaola
//
//  Created by Administrator on 2017/5/31.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWGoodTool.h"

@implementation ZWGoodTool

+ (NSString *)convertPriceFromPriceInCent:(CGFloat)priceInCent {
    return [NSString stringWithFormat:@"%.2f", priceInCent * 0.01];
}

@end
