//
//  ZWPrintOrderCell.h
//  Qimokaola
//
//  Created by Administrator on 2017/6/1.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWPrintOrderCell;
@class ZWPrintOrder;
@class ZWPrintOrder;

@protocol ZWPrintOrderCellDelegate <NSObject>

- (void)cell:(ZWPrintOrderCell *)cell didClickToPayWithPrintOrder:(ZWPrintOrder *)printOrder;

@end

extern NSString *const kPrintOderStatePaying;
extern NSString *const kPrintOderStateShipping;
extern NSString *const kPrintOderStateSuccess;
extern NSString *const kPrintOderStateClosed;

@interface ZWPrintOrderCell : UITableViewCell

@property (nonatomic, strong) ZWPrintOrder *printOrder;
@property (nonatomic, weak) id<ZWPrintOrderCellDelegate> delegate;

@end
