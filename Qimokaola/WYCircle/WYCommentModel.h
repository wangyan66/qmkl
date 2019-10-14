//
//  WYCommentModel.h
//  Qimokaola
//
//  Created by 王焱 on 2018/8/19.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYCommentModel : NSObject
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *tonickname;

@property (nonatomic,strong) NSNumber *likeNum;
@property (nonatomic,strong) NSNumber *commentNum;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,copy) NSString *postID;
@property (nonatomic, assign) BOOL isZan;
@property (nonatomic, assign) BOOL isCollection;
- (void)showModel;
@end
