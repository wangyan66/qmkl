//
//  ZWFileTool.m
//  Qimokaola
//
//  Created by Administrator on 16/8/23.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWFileTool.h"

@implementation ZWFileTool

+ (NSString *)parseTypeWithString:(NSString *)type {
    
    type = [type lowercaseString];
    
    if (array == nil) {
        array = @[@"7z", @"doc", @"docx", @"jpg", @"pdf", @"png",
                  @"ppt", @"pptx", @"rar", @"txt", @"video",
                  @"xls", @"zip", @"rtf", @"wps", @"dps", @"et", @"xlt", @"xlsx"];
    }
    
    if ([array containsObject:type]) {
        return type;
    }
    
    return @"other";
}

+ (NSString *)typeWithName:(NSString *)name {
    NSRange range = [name rangeOfString:@"." options:NSBackwardsSearch];
    NSString *type = [name substringWithRange:NSMakeRange(range.location + 1, [name length] - range.location - 1)];
    return type;
}

+ (NSString *)fileTypeFromFileName:(NSString *)fileName {
    return [self parseTypeWithString:[self typeWithName:fileName]];
}

+ (NSString *)sizeWithString:(NSString *)sizeString {
    return [self sizeWithDouble:[sizeString doubleValue]];
}

+ (NSString *)sizeWithDouble:(double)size {
    NSString *sizeContent = nil;
    size /= 1024.;
    //最大允许至GB级别
    if (size < 1024) {
        sizeContent = [NSString stringWithFormat:@"%.2fKB", size];
    } else if (size < 1024 * 1024) {
        sizeContent = [NSString stringWithFormat:@"%.2fMB", size / 1024.0];
    } else {
        sizeContent = [NSString stringWithFormat:@"%.2fGB", size / 1024.0 / 1024.0];
    }
    
    return sizeContent;
}

@end
