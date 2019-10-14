//
//  ZWGoodCell.m
//  Qimokaola
//
//  Created by Administrator on 2017/5/6.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWGoodCell.h"
#import "ZWGood.h"

#import "ZWGoodTool.h"
#import "UIColor+Extension.h"

#import "YYWebImage.h"

@interface ZWGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *printButton;


@end

@implementation ZWGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.printButton setBackgroundImage:[RGB(80.f, 140.f, 238.f) parseToImage] forState:UIControlStateNormal];
    [self.printButton setBackgroundImage:[[UIColor lightGrayColor] parseToImage] forState:UIControlStateDisabled];
    self.printButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGood:(ZWGood *)good {
    _good = good;
    [self.goodImageView yy_setImageWithURL:[NSURL URLWithString:_good.imageUrl] options:YYWebImageOptionProgressive];
    [self.titleLabel setText:_good.title];
    [self.priceLabel setText:[ZWGoodTool convertPriceFromPriceInCent:self.good.price]];
}

- (IBAction)buyButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goodCell:didClickBuyButtonWithGood:)]) {
        [self.delegate goodCell:self didClickBuyButtonWithGood:self.good];
    }
}

- (void)setCanBuy:(BOOL)canBuy {
    _canBuy = canBuy;
    self.printButton.enabled = _canBuy;
}

@end
