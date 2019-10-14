//
//  ZWPasswordField.m
//  Qimokaola
//
//  Created by Administrator on 2016/11/29.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWPasswordField.h"

static const CGFloat kButtonWidth = 30.;

@interface ZWPasswordField ()

@property (nonatomic, strong) UIButton *showPwdButtoon;

@end

@implementation ZWPasswordField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
    
    
}

- (void)setup {
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.secureTextEntry = YES;
    
    self.showPwdButtoon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showPwdButtoon setImage:[UIImage imageNamed:@"icon_hide_pwd"] forState:UIControlStateNormal];
    [self.showPwdButtoon setImage:[UIImage imageNamed:@"icon_show_pwd"] forState:UIControlStateSelected];
    [self.showPwdButtoon addTarget:self action:@selector(showPwdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showPwdButtoon];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.showPwdButtoon.frame = CGRectMake(self.width - kButtonWidth, 0, kButtonWidth, self.height);
}

- (void)showPwdButtonClicked:(UIButton *)button {
    button.selected = !button.selected;
    self.secureTextEntry = !self.secureTextEntry;
    if (self.text.length == 0) {
        return;
    }
    NSString *text1 = self.text;
    self.text = @"";
    self.text = text1;
}


-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectOffset([super clearButtonRectForBounds:bounds], -kButtonWidth, 0);
}


-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = bounds;
    rect.size.width -= kButtonWidth * 2;
    return rect;
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = bounds;
    rect.size.width -= kButtonWidth * 2;
    return rect;
}

@end
