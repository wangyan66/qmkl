//
//  ZWLoginViewModel.h
//  Qimokaola
//
//  Created by Administrator on 16/9/3.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface ZWLoginViewModel : NSObject

@property (nonatomic, strong) NSString *account;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RACCommand *loginCommand;


@end
