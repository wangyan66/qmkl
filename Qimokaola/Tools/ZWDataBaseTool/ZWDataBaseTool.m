//
//  ZWDataBaseTool.m
//  Qimokaola
//
//  Created by Administrator on 2016/9/20.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWDataBaseTool.h"
#import "ZWPathTool.h"
#import <FMDB/FMDB.h>
#import "NSDate+Extension.h"

@interface ZWDataBaseTool ()

@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) NSMutableDictionary *downloadsDict;

@end

@implementation ZWDataBaseTool

// 数据库操作语句


// 创建数据库
NSString *const sql_create_table = @"CREATE TABLE IF NOT EXISTS downloads (id INTEGER PRIMARY KEY AUTOINCREMENT, storage_name TEXT, name TEXT, ctime TEXT, creator TEXT, uid TEXT, size TEXT, identifier TEXT, school TEXT, course TEXT, lastAccessTime TEXT, extra TEXT)";

// 查询下载数据
NSString *const sql_query_all_download_info = @"SELECT storage_name, name, ctime, creator, uid, size, identifier, school, course, lastAccessTime FROM downloads ORDER BY lastAccessTime DESC";

// 查询下载数据 只查询storage_name identifier 用来检测文件的下载与否
NSString *const sql_query_download_info_identifier = @"SELECT storage_name, identifier FROM downloads";

// 添加下载数据
NSString *const sql_add_download_info = @"INSERT INTO downloads (storage_name, name, ctime, creator, uid, size, identifier, school, course, lastAccessTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

// 删除下载数据
NSString *const sql_delete_download_info = @"DELETE FROM downloads WHERE identifier = '%@'";

// 更新某个文件的最新打开时间
NSString *const sql_update_last_access_time = @"UPDATE downloads SET lastAccessTime = '%@' WHERE identifier = '%@'";

- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建数据库
        _db = [FMDatabase databaseWithPath:[[ZWPathTool dbDirectory] stringByAppendingPathComponent:@"downloads.db"]];
        
        // 建立已下载查询字典
        _downloadsDict = [NSMutableDictionary dictionary];
        if ([_db open]) {
            BOOL res = [_db executeUpdate:sql_create_table];
            if (res) {//如果创建成功
                FMResultSet *results = [_db executeQuery:sql_query_download_info_identifier];
                while ([results next]) {
                    NSString *storage_name = [results stringForColumnIndex:0];
                    NSString *identifier = [results stringForColumnIndex:1];
                    [self.downloadsDict setObject:storage_name forKey:identifier];
                }
            }
        }
    }
    return self;
}

+ (instancetype)sharedInstance {
    static ZWDataBaseTool *databaseTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseTool = [[ZWDataBaseTool alloc] init];
    });
    return databaseTool;
}

- (BOOL)isFileDownloaded:(NSString *)fileIdentifier {
    return [[self.downloadsDict allKeys] containsObject:fileIdentifier];
}

//增
- (BOOL)addFileDownloadInfo:(ZWFile *)file storage_name:(NSString *)storage_name inSchool:(NSString *)school inCourse:(NSString *)course {
    NSString *now = [NSDate secondsSince1970];
    NSArray *argsArray = @[storage_name, file.name, file.ctime, file.creator, file.uid, file.size, file.md5, school, course, now];
    BOOL res = [_db executeUpdate:sql_add_download_info withArgumentsInArray:argsArray];
    if (res) {
        [self.downloadsDict setObject:storage_name forKey:file.md5];
    }
    return res;
}

- (BOOL)deleteFileDownloadInfo:(NSString *)identifier {
    BOOL res = [_db executeUpdate:[NSString stringWithFormat:sql_delete_download_info, identifier]];
    if (res) {
        [self.downloadsDict removeObjectForKey:identifier];
    }
    return res;
}

- (BOOL)updateLastAccessTimeWithIdentifier:(NSString *)identifier {
    return [_db executeUpdate:[NSString stringWithFormat:sql_update_last_access_time, [NSDate secondsSince1970], identifier]];
}

- (NSString *)storage_nameWithIdentifier:(NSString *)identifier {
    return [self.downloadsDict objectForKey:identifier];
}

- (NSMutableArray<ZWDownloadedInfo *> *)fetchDonwloadedInfos {
    NSMutableArray *res = [NSMutableArray array];
    if ([_db open]) {
        FMResultSet *results = [_db executeQuery:sql_query_all_download_info];
        while ([results next]) {
            @autoreleasepool {
                NSString *storage_name = [results stringForColumnIndex:0];
                NSString *name = [results stringForColumnIndex:1];
                NSString *ctime = [results stringForColumnIndex:2];
                NSString *creator = [results stringForColumnIndex:3];
                NSString *uid = [results stringForColumnIndex:4];
                NSString *size = [results stringForColumnIndex:5];
                NSString *identifier = [results stringForColumnIndex:6];
                NSString *school = [results stringForColumnIndex:7];
                NSString *course = [results stringForColumnIndex:8];
                NSString *lastAccessTime = [results stringForColumnIndex:9];
                
                ZWDownloadedInfo *downloadInfo = [[ZWDownloadedInfo alloc] init];
                ZWFile *file = [[ZWFile alloc] init];
                file.name = name;
                file.ctime = ctime;
                file.creator = creator;
                file.uid = uid;
                file.size = size;
                file.md5 = identifier;
                file.hasDownloaded = YES;
                downloadInfo.file = file;
                downloadInfo.storage_name = storage_name;
                downloadInfo.school = school;
                downloadInfo.course = course;
                downloadInfo.lastAccessTime = lastAccessTime;
                [res addObject:downloadInfo];
            }
        }
    }
    return res;
}

- (void)dealloc
{
    if ([_db open]) {
        [_db close];
    }
}

@end
