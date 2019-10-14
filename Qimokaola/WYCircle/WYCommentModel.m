//
//  WYCommentModel.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/19.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYCommentModel.h"

@implementation WYCommentModel
-(void)showModel{
    NSLog(@"_nickname:%@,_content%@,_time%@,_ID%@,_rowHeight%f,zannum%@,commentNum%@",_nickname,_content,_time,_ID,_rowHeight,_likeNum,_commentNum);
}
@end
