//
//  ZWFolderCell.m
//  Qimokaola
//
//  Created by Administrator on 16/9/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWFolderCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface ZWFolderCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ZWFolderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self zw_addSubViews];
    }
    return self;
}

- (void)zw_addSubViews {
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"folder"];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.numberOfLines = 1;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = ZWFont(18);
    
    [self.contentView sd_addSubviews:@[_iconView, _nameLabel]];
    
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
    .centerYEqualToView(contentView)
    .autoHeightRatio(0);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
}

- (void)setFolderName:(NSString *)folderName {
    _folderName = folderName;
    _nameLabel.text = folderName;
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
