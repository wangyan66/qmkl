//
//  ZWBaseTableViewHeaderFooter.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/14.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWBaseTableViewHeaderFooter.h"

@implementation ZWBaseTableViewHeaderFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.width = kScreenW;
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
}
@end
