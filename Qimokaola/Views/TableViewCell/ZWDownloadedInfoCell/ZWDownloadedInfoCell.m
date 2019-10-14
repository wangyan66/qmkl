//
//  ZWDownloadedInfoCell.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/8.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWDownloadedInfoCell.h"
#import "ZWFileTool.h"
#import "NSDate+Extension.h"

@interface ZWDownloadedInfoCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *courseLabel;
@property (nonatomic, strong) UILabel *lastAccessTimeLabel;

@end

@implementation ZWDownloadedInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    _iconView = [[UIImageView alloc] init];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = ZWFont(18);
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.numberOfLines = 1;
    
    _lastAccessTimeLabel = [[UILabel alloc] init];
    _lastAccessTimeLabel.font = ZWFont(14);
    _lastAccessTimeLabel.numberOfLines = 1;
    _lastAccessTimeLabel.textColor = [UIColor lightGrayColor];
    _lastAccessTimeLabel.textAlignment = NSTextAlignmentRight;
    
    _courseLabel = [[UILabel alloc] init];
    _courseLabel.font = ZWFont(13);
    _courseLabel.numberOfLines = 1;
    _courseLabel.text = @"已下载";
    _courseLabel.textColor = [UIColor lightGrayColor];
    _courseLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView sd_addSubviews:@[_iconView, _nameLabel, _courseLabel, _lastAccessTimeLabel]];
    
    CGFloat margin = 10;
    CGFloat iconViewSize = 45.f;
    UIView *contentView = self.contentView;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .centerYEqualToView(contentView)
    .heightIs(iconViewSize)
    .widthEqualToHeight();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .rightSpaceToView(contentView, margin)
    .topEqualToView(_iconView)
    .heightIs(20);
    
    _lastAccessTimeLabel.sd_layout
    .rightEqualToView(_nameLabel)
    .bottomEqualToView(_iconView)
    .heightIs(20);
    [_lastAccessTimeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _courseLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_iconView)
    .heightIs(20);
    [_courseLabel setSingleLineAutoResizeWithMaxWidth:100];
}

- (void)setDownloadInfo:(ZWDownloadedInfo *)downloadInfo {
    _downloadInfo = downloadInfo;
    
    _iconView.image = [UIImage imageNamed:[ZWFileTool fileTypeFromFileName:_downloadInfo.file.name]];
    _nameLabel.text = _downloadInfo.file.name;
    _courseLabel.text = _downloadInfo.course;
    _lastAccessTimeLabel.text = [NSDate timeIntervalDescriptionWithPast:_downloadInfo.lastAccessTime];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
