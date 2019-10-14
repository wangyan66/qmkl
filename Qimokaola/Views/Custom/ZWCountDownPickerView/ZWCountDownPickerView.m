//
//  ZWCountDownPickerView.m
//  Qimokaola
//
//  Created by Administrator on 2017/2/21.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWCountDownPickerView.h"

#import "ZWHUDTool.h"
#import "NSDate+Extension.h"

static const CGFloat kDatePickerViewHeight = 216.f;
static const CGFloat kToolbarHeight = 45.f;
static const CGFloat kBottomViewHeight = kDatePickerViewHeight + kToolbarHeight;

static const NSTimeInterval kAnimationDuration = 0.3;


@interface ZWCountDownPickerView ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIView *toolbar;
@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UILabel *dateLabel;

@end

@implementation ZWCountDownPickerView


- (instancetype)initWithTime:(NSDate *)date {
    if (self = [self initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)]) {
        self.date = date ? date : [NSDate date];
        [self setupViews];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"CountDownPickerView dealloc");
}

- (void)setupViews {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:self.frame];
    topView.backgroundColor = RGB(46, 49, 50);
    topView.alpha  = 0.0;
    [topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)]];
    [self addSubview:topView];
    self.topView = topView;
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kToolbarHeight)];
    toolbar.backgroundColor = defaultPlaceHolderColor;
    [bottomView addSubview:toolbar];
    self.toolbar = toolbar;
    
    CGFloat buttonWidth = 60;
    UIFont *buttonFont = ZWFont(15);
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    finishBtn.frame = CGRectMake(kScreenW - buttonWidth, 0, buttonWidth, kToolbarHeight);
    finishBtn.titleLabel.font = buttonFont;
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget: self action:@selector(finishPickDate) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:finishBtn];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(0, 0, buttonWidth, kToolbarHeight);
    cancleButton.titleLabel.font = buttonFont;
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget: self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:cancleButton];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonWidth, 0, kScreenW - buttonWidth * 2.0, kToolbarHeight)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [toolbar addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolbarHeight, kScreenW, kDatePickerViewHeight)];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 5;
    datePicker.date = self.date;
    datePicker.minimumDate = [self getPropriateMinDate];
    [self datePickerValueChanged:datePicker];
    [bottomView addSubview:datePicker];
    self.datePicker = datePicker;
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    self.dateLabel.text = [datePicker.date dateStringForCountdown];
}

- (void)finishPickDate {
    NSDate *now = [NSDate date];
    // 选择器时间小于等于现在时间
    NSComparisonResult result = [self.datePicker.date compare:now];
    if (result == NSOrderedAscending) {
        [ZWHUDTool showPlainHUDInView:self text:@"所选时间不能小于当前时间"];
        self.datePicker.minimumDate = [self getPropriateMinDate];
        self.date = now;
        return;
    }
    if (self.completion) {
        self.completion(self.datePicker.date, self.dateLabel.text);
    }
    [self dismissSelf];
}

- (NSDate *)getPropriateMinDate {
    NSDate *date = [NSDate date];
    NSInteger minute = [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:date] % 10;
    date = [date dateByAddingTimeInterval:(minute < 5 ? 5 - minute : 10 - minute) * 60];
    return date;
}

- (void)dismissSelf {
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.topView.userInteractionEnabled = NO;
        self.topView.alpha = 0.0;
        self.bottomView.frame = CGRectMake(0, kScreenH, kScreenW, kBottomViewHeight);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show {
    [self layoutIfNeeded];
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomView.frame = CGRectMake(0, kScreenH - kBottomViewHeight, kScreenW, kBottomViewHeight);
        self.topView.alpha = 0.3;
        [self layoutIfNeeded];
    } completion:nil];
}

@end
