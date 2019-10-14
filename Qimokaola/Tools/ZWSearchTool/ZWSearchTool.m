//
//  ZWSearchTool.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/21.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWSearchTool.h"

@implementation ZWSearchTool

+ (NSMutableArray *)searchFromArray:(NSArray *)array withSearchText:(NSString *)searchText withSearhPredicateString:(NSString *)searchPredicateString {
    NSMutableSet *resultsSet = [NSMutableSet set];
    BOOL resultsSetInit = YES;
    for (NSInteger i = 0; i < searchText.length; i ++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:searchPredicateString, [searchText substringWithRange:NSMakeRange(i, 1)]];
        NSArray *result = [array filteredArrayUsingPredicate:predicate];
        if (!resultsSetInit) {
            [resultsSet intersectSet:[NSSet setWithArray:result]];
        } else {
            [resultsSet addObjectsFromArray:result];
            resultsSetInit = NO;
        }
    }
    return [[resultsSet allObjects] mutableCopy];
}

@end
