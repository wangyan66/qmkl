//
//  ZWDataBaseTool.h
//  Qimokaola
//
//  Created by Administrator on 2016/9/20.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWDownloadedInfo.h"

@interface ZWDataBaseTool : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFileDownloaded:(NSString *)fileIdentifier;

- (NSString *)storage_nameWithIdentifier:(NSString *)identifier;

- (BOOL)addFileDownloadInfo:(ZWFile *)file
                    storage_name:(NSString *)storage_name
                    inSchool:(NSString *)school
                    inCourse:(NSString *)course;

- (BOOL)deleteFileDownloadInfo:(NSString *)identifier;

- (BOOL)updateLastAccessTimeWithIdentifier:(NSString *)identifier;

- (NSMutableArray<ZWDownloadedInfo *> *)fetchDonwloadedInfos;

@end
