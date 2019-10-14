//
//  ZWFileCell.m
//  Qimokaola
//
//  Created by Administrator on 16/9/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWFileCell.h"
#import "ZWFileTool.h"

#import <SDAutoLayout/SDAutoLayout.h>

@interface ZWFileCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *isDownloadLabel;

@end

@implementation ZWFileCell

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
    
    _sizeLabel = [[UILabel alloc] init];
    _sizeLabel.font = ZWFont(14);
    _sizeLabel.numberOfLines = 1;
    _sizeLabel.textColor = [UIColor lightGrayColor];
    _sizeLabel.textAlignment = NSTextAlignmentRight;
    
    _isDownloadLabel = [[UILabel alloc] init];
    _isDownloadLabel.font = ZWFont(13);
    _isDownloadLabel.numberOfLines = 1;
    _isDownloadLabel.text = @"已下载";
    _isDownloadLabel.textColor = [UIColor lightGrayColor];
    _isDownloadLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView sd_addSubviews:@[_iconView, _nameLabel, _sizeLabel, _isDownloadLabel]];
    
    CGFloat margin = 10;
    CGFloat iconViewSize = 45.f;
    UIView *contentView = self.contentView;
    
    //宽高为45 centerY对齐 距离左边为10
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .centerYEqualToView(contentView)
    .heightIs(iconViewSize)
    .widthEqualToHeight();
    
    //高20 左右固定 顶部对齐iconview
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .rightSpaceToView(contentView, margin)
    .topEqualToView(_iconView)
    .heightIs(20);
    
    //高底部右边固定 设置自适应的文本框长度(左边在变)
    _sizeLabel.sd_layout
    .rightEqualToView(_nameLabel)
    .bottomEqualToView(_iconView)
    .heightIs(20);
    [_sizeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    //高底左固定 向右自适应
    _isDownloadLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_iconView)
    .heightIs(20);
    [_isDownloadLabel setSingleLineAutoResizeWithMaxWidth:100];
}

- (void)setFile:(ZWFile *)file {
    _file = file;
    
    _iconView.image = [UIImage imageNamed:[ZWFileTool fileTypeFromFileName:file.name]];
    _nameLabel.text = file.name;
    _sizeLabel.text = file.size;
    //[ZWFileTool sizeWithString:file.size]
    _isDownloadLabel.hidden = !file.hasDownloaded;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
