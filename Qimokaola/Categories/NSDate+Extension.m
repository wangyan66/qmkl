//
//  NSDate+CommomDate.m
//  Qimokaola
//
//  Created by Administrator on 15/10/12.
//  Copyright © 2015年 Administrator. All rights reserved.
//

#import "NSDate+Extension.h"

static NSDateFormatter *formatter;


@implementation NSDate (Extension)

+ (NSString *)currentSimpleString  {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    });
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)dateStringFromTimestamp:(NSString *)timestamp {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    });
    return [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp.doubleValue / 1000.f]];
}

- (NSNumber *)timeStamp {
    return @([self timeIntervalSince1970]);
}

- (NSString *)timeIntervalStringSincNow {
    NSString *result;
    long interval = (long)[self timeIntervalSinceDate:[NSDate date]];
    if (interval < 3600 - 60) {
        result = [NSString stringWithFormat:@"%ld分钟", interval / 60 + 1];
    } else if (interval < 86400 - 3600) {
        result = [NSString stringWithFormat:@"%ld小时", interval / 3600 + 1];
    } else {
        result = [NSString stringWithFormat:@"%ld天", interval / 86400 + 1];
    }
    return [result copy];
}

- (NSString *)dateStringForCountdown {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd EEEE HH:mm"];
    });
    return [formatter stringFromDate:self];
}

+ (NSString *)secondsSince1970 {
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

+ (NSString *)timeIntervalDescriptionWithPast:(NSString *)past {
    NSString *result = nil;
    int interval = (int)[[self date] timeIntervalSince1970] - past.intValue;
    if (interval <= 60) {
        result = @"1分钟前";
    } else if (interval <= 60 * 60) {
        result = [NSString stringWithFormat:@"%d分钟前", interval / 60];
    } else if (interval <= 60 * 60 * 24) {
        result = [NSString stringWithFormat:@"%d小时前", interval / (60 * 60)];
    } else if (interval <= 60 * 60 * 24 * 30) {
        result = [NSString stringWithFormat:@"%d天前", interval / (60 * 60 * 24)];;
    } else if (interval <= 60 * 60 * 24 * 30 * 12) {
        result = [NSString stringWithFormat:@"%d个月前", interval / (60 * 60 * 24 * 30)];
    } else {
        result = [NSString stringWithFormat:@"%d年前", interval / (60 * 60 * 24 * 30 * 12)];
    }
    return result;
}

@end
