//
//  ZWCountdownDatabaseManager.m
//  Qimokaola
//
//  Created by Administrator on 2017/2/23.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWCountdownDatabaseManager.h"

#import <FMDB/FMDB.h>

#import "ZWPathTool.h"
#import "NSDate+Extension.h"

@interface ZWCountdownDatabaseManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ZWCountdownDatabaseManager

// 创建数据库
NSString *const sql_create_countdown_table = @"CREATE TABLE IF NOT EXISTS countdowns (identifier TEXT PRIMARY KEY, examName TEXT, examDate REAL, examLocation TEXT, alarmDate REAL, timeOfAhead TEXT)";

// 查询倒计时数据
NSString *const sql_query_all_countdown = @"SELECT * FROM countdowns ORDER BY examDate DESC";

// 查询特定的countdown是否存在
NSString *const sql_query_countdown_exists = @"SELECT * FROM countdowns WHERE identifier = '%@'";

// 添加下载数据
NSString *const sql_add_countdown = @"INSERT INTO countdowns VALUES (?, ?, ?, ?, ?, ?)";

// 删除倒计时
NSString *const sql_delete_countdown = @"DELETE FROM countdowns WHERE identifier = '%@'";

// 更新倒计时相关参数
NSString *const sql_update_countdown = @"UPDATE countdowns SET examName = ?, examDate = ?, examLocation = ?, alarmDate = ?, timeOfAhead = ? WHERE identifier = ?";


+ (instancetype)defaultManager {
    static ZWCountdownDatabaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZWCountdownDatabaseManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _db = [FMDatabase databaseWithPath:[[ZWPathTool dbDirectory] stringByAppendingPathComponent:@"countdowns.db"]];
        if ([_db open]) {
            [_db executeUpdate:sql_create_countdown_table];
        }
    }
    return self;
}

- (void)dealloc
{
    if ([_db open]) {
        [_db close];
    }
}

- (NSMutableArray *)fetchCountdownList {
    NSMutableArray *countdownList = [NSMutableArray array];
    if ([_db open]) {
        FMResultSet *result = [_db executeQuery:sql_query_all_countdown];
        while ([result next]) {
            @autoreleasepool {
                ZWCountdown *countdown = [[ZWCountdown alloc] init];
                countdown.identifier = [result stringForColumnIndex:0];
                countdown.examName = [result stringForColumnIndex:1];
                countdown.examDate = [NSDate dateWithTimeIntervalSince1970:[result doubleForColumnIndex:2]];
                countdown.examLocation = [result stringForColumnIndex:3];
                countdown.alarmDate = [NSDate dateWithTimeIntervalSince1970:[result doubleForColumnIndex:4]];
                countdown.timeOfAhead = [result stringForColumnIndex:5];
                // 查询到的数据按照考试时间递减排列 循环分析每个考试时间 考试时间大于当前时间的插入队列第一个 小于的插入到队列后方 使得考试时间较早的排前面 以结束的在后面
                if ([countdown.examDate compare:[NSDate date]] == NSOrderedDescending) {
                    [countdownList insertObject:countdown atIndex:0];
                } else {
                    [countdownList addObject:countdown];
                }
            }
        }
    }
    return [countdownList mutableCopy];
}

- (BOOL)addCountdown:(ZWCountdown *)countdown {
    BOOL result = NO;
    if ([_db open]) {
        NSArray *arguments =@[countdown.identifier, countdown.examName, [countdown.examDate timeStamp], countdown.examLocation, [countdown.alarmDate timeStamp], countdown.timeOfAhead];
        result = [_db executeUpdate:sql_add_countdown withArgumentsInArray:arguments];
    }
    return result;
}

- (BOOL)deleteCountdown:(ZWCountdown *)countdown {
    BOOL result = NO;
    if ([_db open]) {
        result = [_db executeUpdate:[NSString stringWithFormat:sql_delete_countdown, countdown.identifier]];
    }
    return result;
}

- (BOOL)isCountdownExist:(ZWCountdown *)countdown {
    BOOL result = NO;
    if ([_db open]) {
        result = [[_db executeQuery:[NSString stringWithFormat:sql_query_countdown_exists, countdown.identifier]] next];
    }
    return result;
}

- (BOOL)updateCountdown:(ZWCountdown *)countdown {
    BOOL result = NO;
    if ([self isCountdownExist:countdown]) {
        NSArray *arguments = @[countdown.examName, [countdown.examDate timeStamp], countdown.examLocation, [countdown.alarmDate timeStamp], countdown.timeOfAhead, countdown.identifier];
        result = [_db executeUpdate:sql_update_countdown withArgumentsInArray:arguments];
    }
    return result;
}

@end
