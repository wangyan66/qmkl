//
//  NSDate+CommomDate.h
//  Qimokaola
//
//  Created by Administrator on 15/10/12.
//  Copyright © 2015年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

- (NSNumber *)timeStamp;
- (NSString *)timeIntervalStringSincNow;
- (NSString *)dateStringForCountdown;
+ (NSString *)currentSimpleString;
+ (NSString *)secondsSince1970;
+ (NSString *)timeIntervalDescriptionWithPast:(NSString *)past;
+ (NSString *)dateStringFromTimestamp:(NSString *)timestamp;

@end
