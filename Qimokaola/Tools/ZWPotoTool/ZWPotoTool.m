//
//  ZWPotoTool.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/21.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWPotoTool.h"
#import "ZWHUDTool.h"

@implementation ZWPotoTool

+ (void)writeImageToAlbumWithImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [[ZWHUDTool successHUDInView:[UIApplication sharedApplication].keyWindow withMessage:@"保存成功"] hideAnimated:YES afterDelay:kShowHUDShort];
    } else {
        [ZWHUDTool showHUDInView:[UIApplication sharedApplication].keyWindow withTitle:@"保存失败" message:nil duration:kShowHUDShort];
    }
}

@end
