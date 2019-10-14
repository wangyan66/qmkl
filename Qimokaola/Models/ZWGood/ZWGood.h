//
//  ZWGood.h
//  Qimokaola
//
//  Created by Administrator on 2017/5/6.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWGood : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign) NSUInteger gid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSInteger count;
@end
