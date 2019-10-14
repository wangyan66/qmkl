//
//  ZWAdvertisementView.m
//  Qimokaola
//
//  Created by Administrator on 16/7/12.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWAdvertisementView.h"
#import "UIImageView+WebCache.h"

#import "ZWAPITool.h"

@interface ZWAdvertisementView() {
    int count;
}

@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ZWAdvertisement *advertisement;

@end

@implementation ZWAdvertisementView

//广告页面占总页面高度的比例
static CGFloat adViewRate = 1.f;
static int const showTime = 3;

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    if (self) {
        
        [window makeKeyAndVisible];
        
        self.backgroundColor = [UIColor whiteColor];
        
        //广告图片
        self.adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH * adViewRate)];
        self.adView.contentMode = UIViewContentModeScaleToFill;
        // self.adView.clipsToBounds = YES;
        self.adView.userInteractionEnabled = YES;
        [self.adView addGestureRecognizer:[[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(clickToAdvertisement)]];
        
        //self.adView.image = [UIImage imageNamed:@"happy"];
        
        //跳过按钮
        CGFloat btnWidth = 40;
        CGFloat btnHeight = btnWidth;
        self.countBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - btnWidth * 1.5, btnHeight * 0.8, btnWidth, btnHeight)];
        [self.countBtn addTarget:self action:@selector(dismissAdView) forControlEvents:UIControlEventTouchUpInside];
        [self.countBtn setTitle:[NSString stringWithFormat:@"跳过 %d", showTime] forState:UIControlStateNormal];
        self.countBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        self.countBtn.layer.cornerRadius = btnWidth / 2;
        
        [self addSubview:self.adView];
        [self addSubview:self.countBtn];
    }
    return self;
}

- (void)checkAD {
}

- (void)showAdvertisement:(ZWAdvertisement *)advertisement {
    self.advertisement = advertisement;
    [self.adView sd_setImageWithURL:[NSURL URLWithString:advertisement.url]];
//    NSLog(@"启动广告的图片为url为:%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [ZWAPITool base], advertisement.pic]]);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self startTimer];
}

- (void)startTimer {
    count = showTime;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)clickToAdvertisement {
    [self dismissAdView];
    NSLog(@"self.advertisement.fallback%@",self.advertisement.fallback);
    if (self.advertisement.fallback.length!=0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowAdNotification object:nil userInfo:@{@"url" :self.advertisement.fallback}];
    }
    
    
    //self.advertisement.url
}

- (void)countDown {
    if (-- count == 0) {
        [self dismissAdView];
    } else {
        [self.countBtn setTitle:[NSString stringWithFormat:@"跳过 %d", count] forState:UIControlStateNormal];
    }
}

- (void)dismissAdView {
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:.8f animations:^{
        self.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(4.f, 4.f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
