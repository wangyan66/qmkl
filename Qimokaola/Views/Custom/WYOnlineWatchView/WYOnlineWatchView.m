//
//  WYOnlineWatchView.m
//  Qimokaola
//
//  Created by 王焱 on 2018/11/20.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYOnlineWatchView.h"
#import "UIColor+Extension.h"
#import "Masonry/Masonry.h"
@interface WYOnlineWatchView()
@property (nonatomic,weak) UIButton *button;
@property (nonatomic,weak) UILabel *label;
@end

@implementation WYOnlineWatchView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
        UIFont *buttonTitleFont = [UIFont systemFontOfSize:15];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:buttonTitleFont];
        [button setTitle:@"在线预览" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onlineWatchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        //要使用系统的变灰，只需设置BackgroundImage即可
        [button setBackgroundImage:[[UIColor whiteColor] parseToImage] forState:UIControlStateNormal];
        
        //变化后标题的颜色设置需设置状态为UIControlStateHighlighted
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        //
        //[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //[button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];

        self.button=button;
        [self addSubview:self.button];
        
        UILabel *label = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:15];
        label.font = font;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text=@"该文件支持";
        self.label=label;
        [self addSubview:label];
    }
    return  self;
}
- (void)onlineWatchButtonClicked{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didOnlineWatchButton)]) {
        [self.delegate didOnlineWatchButton];
    }
}
-(void)layoutSubviews{

    [super layoutSubviews];
    [self.button sizeToFit];
    [self.label sizeToFit];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        //make.top.mas_equalTo(self);
        //make.bottom.mas_equalTo(self);
        
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.baseline.mas_equalTo(self.label.mas_baseline);
        make.left.mas_equalTo(self.label.mas_right);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}
@end
