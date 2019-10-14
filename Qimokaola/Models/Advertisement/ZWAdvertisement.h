//
//  ZWAdvertisement.h
//  Qimokaola
//
//  Created by Administrator on 16/8/10.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWAdvertisement : NSObject

@property (nonatomic, assign) NSUInteger version;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *fallback;

@property (nonatomic, assign) BOOL enabled;

@end
