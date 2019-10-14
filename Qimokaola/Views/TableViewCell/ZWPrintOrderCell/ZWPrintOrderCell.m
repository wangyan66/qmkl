//
//  ZWPrintOrderCell.m
//  Qimokaola
//
//  Created by Administrator on 2017/6/1.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWPrintOrderCell.h"
#import "ZWPrintOrder.h"

#import "NSDate+Extension.h"
#import "UIColor+Extension.h"


#import "ZWGoodTool.h"

#import <YYWebImage/YYWebImage.h>

NSString *const kPrintOderStatePaying = @"Paying";
NSString *const kPrintOderStateShipping = @"Shipping";
NSString *const kPrintOderStateSuccess = @"Success";
NSString *const kPrintOderStateClosed = @"Closed";

@interface ZWPrintOrderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCreatedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencySymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

static NSDictionary *statuses;

@implementation ZWPrintOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statuses = @{
                     kPrintOderStatePaying : @"待付款",
                     kPrintOderStateShipping : @"等待配送",
                     kPrintOderStateSuccess : @"已送达",
                     kPrintOderStateClosed : @"交易关闭"
                     };
        
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPrintOrder:(ZWPrintOrder *)printOrder {
    _printOrder = printOrder;
    
    if (_printOrder.goodList && _printOrder.goodList.count > 0) {
        [self.orderImageView yy_setImageWithURL:[NSURL URLWithString:_printOrder.goodList[0].imageUrl] options:YYWebImageOptionProgressive];
        self.orderTitleLabel.text = _printOrder.goodList[0].title;
    } else {
        //[self.orderImageView yy_setImageWithURL:[NSURL URLWithString:_printOrder.goodList[0].imageUrl] options:YYWebImageOptionProgressive];
        self.orderTitleLabel.text = @"获取中...";
    }
    self.orderCreatedTimeLabel.text = [NSDate dateStringFromTimestamp:_printOrder.createTime];
    self.orderStatusLabel.text = statuses[_printOrder.state];
    
    BOOL isPaying = [_printOrder.state isEqualToString:@"Paying"];
    self.currencySymbolLabel.hidden = self.totalPriceLabel.hidden = self.payButton.hidden = !isPaying;
    self.orderStatusLabel.textColor = isPaying ? [UIColor redColor] : [UIColor orangeColor];
    if (isPaying) {
        self.totalPriceLabel.text = [ZWGoodTool convertPriceFromPriceInCent:_printOrder.totalPrice];
    }
}

- (IBAction)payOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:didClickToPayWithPrintOrder:)]) {
        [self.delegate cell:self didClickToPayWithPrintOrder:self.printOrder];
    }
}

@end
