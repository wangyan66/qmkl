//
//  ZWZWOauthLoginViewModel.h
//  Qimokaola
//
//  Created by Administrator on 2017/3/20.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;
@interface ZWZWOauthLoginViewModel : NSObject

@property (nonatomic, strong) RACCommand *oauthLoginCommand;

@end
