//
//  WYOnlineWatchView.h
//  Qimokaola
//
//  Created by 王焱 on 2018/11/20.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WYOnlineWatchViewDelegate <NSObject>
@optional
- (void)didOnlineWatchButton;
@end

@interface WYOnlineWatchView : UIView
@property (nonatomic,weak) id <WYOnlineWatchViewDelegate> delegate;
@end
