//
//  WYCommentCell.h
//  Qimokaola
//
//  Created by 王焱 on 2018/8/19.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCommentModel.h"

@protocol WYCommentCellDelegate <NSObject>
@optional
- (void)didCommentButton;
- (void)didZanButton:(NSString *)postId;
- (void)didCollectionButtonWithPostId:(NSString *)postId;
@end
@interface WYCommentCell : UITableViewCell
@property (nonatomic,strong) WYCommentModel *model;
@property (nonatomic,assign) CGFloat rowHeight;
//@property (nonatomic, assign) BOOL isCommentButtonHidden;
//@property (nonatomic, assign) BOOL isSeperatorViewHidden;
//@property (nonatomic, assign) BOOL isZanButtonHidden;
@property (nonatomic,weak) id <WYCommentCellDelegate> delegate;
+ (instancetype)loadCommentCell;
- (void)hideViews;
@end
