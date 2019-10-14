//
//  ZWGoodCell.h
//  Qimokaola
//
//  Created by Administrator on 2017/5/6.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWGoodCell;
@class ZWGood;

@protocol ZWGoodCellDelegate <NSObject>

- (void)goodCell:(ZWGoodCell *)goodCell didClickBuyButtonWithGood:(ZWGood *)good;

@end

@interface ZWGoodCell : UITableViewCell

@property (nonatomic, strong) ZWGood *good;

@property (nonatomic, weak) id<ZWGoodCellDelegate> delegate;

/**
 是否可以购买
 */
@property (nonatomic, assign) BOOL canBuy;

@end
