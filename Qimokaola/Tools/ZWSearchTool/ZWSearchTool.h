//
//  ZWSearchTool.h
//  Qimokaola
//
//  Created by Administrator on 2016/10/21.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWSearchTool : NSObject

+ (NSMutableArray *)searchFromArray:(NSArray *)array withSearchText:(NSString *)searchText withSearhPredicateString:(NSString *)searchPredicateString;

@end
