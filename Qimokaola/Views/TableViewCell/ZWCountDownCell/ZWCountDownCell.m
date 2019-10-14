//
//  ZWCountDownCell.m
//  Qimokaola
//
//  Created by Administrator on 2017/2/19.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWCountDownCell.h"

#import "NSDate+Extension.h"

@interface ZWCountDownCell ()


@property (weak, nonatomic) IBOutlet UILabel *examNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *examDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *examLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOfAheadLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownFinishedLabel;

@end

@implementation ZWCountDownCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCountdown:(ZWCountdown *)countdown {
    _countdown = countdown;
    
    _examNameLabel.text = _countdown.examName;
    _examDateLabel.text = [_countdown.examDate dateStringForCountdown];
    _examLocationLabel.text = _countdown.examLocation;
    _timeOfAheadLabel.text = _countdown.timeOfAhead;
    
    if ([[NSDate date] compare:_countdown.examDate] == NSOrderedDescending) {
        [self dealWithCountdownWithIsFinish:YES];
    } else {
        [self dealWithCountdownWithIsFinish:NO];
        _timeLeftLabel.text = [_countdown.examDate timeIntervalStringSincNow];
    }
}

- (void)dealWithCountdownWithIsFinish:(BOOL)finish {
    _leftHintLabel.hidden = _timeLeftLabel.hidden = finish;
    _countdownFinishedLabel.hidden = !finish;
}

@end
