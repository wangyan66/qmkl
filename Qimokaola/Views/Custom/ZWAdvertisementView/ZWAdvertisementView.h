//
//  ZWAdvertisementView.h
//  Qimokaola
//
//  Created by Administrator on 16/7/12.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWAdvertisement.h"

@interface ZWAdvertisementView : UIView

- (instancetype)initWithWindow:(UIWindow *)window;

- (void)showAdvertisement:(ZWAdvertisement *)advertisement;

- (void)checkAD;

@end
