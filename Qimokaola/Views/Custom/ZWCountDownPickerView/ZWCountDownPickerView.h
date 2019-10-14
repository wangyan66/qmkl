//
//  ZWCountDownPickerView.h
//  Qimokaola
//
//  Created by Administrator on 2017/2/21.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWCountDownPickerView : UIView

- (instancetype)initWithTime:(NSDate *)date;

- (void)show;

@property (nonatomic, copy) void (^completion)(NSDate * date, NSString *dateString);

@end
