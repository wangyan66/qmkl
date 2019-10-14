//
//  UIViewController+Logging.m
//  Qimokaola
//
//  Created by Administrator on 16/7/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>
//#import <UMMobClick/MobClick.h>

@implementation UIViewController (Extension)

- (void)swizzledViewWillAppear:(BOOL)animated {
    [self swizzledViewWillAppear:animated];
    
    #ifndef DEBUG
    if (self.title) {
        //[MobClick beginLogPageView:self.title];
    }
    #endif
    
}

- (void)swizzledViewWillDisappear:(BOOL)animated {
    [self swizzledViewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    #ifndef DEBUG
        if (self.title) {
          //  [MobClick endLogPageView:self.title];
        }
    #endif
}


void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    swizzleMethod([self class], @selector(viewWillAppear:), @selector(swizzledViewWillAppear:));
    swizzleMethod([self class], @selector(viewWillDisappear:), @selector(swizzledViewWillDisappear:));
}

@end
