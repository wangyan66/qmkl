//
//  ZWPhotoTool.m
//  Qimokaola
//
//  Created by Administrator on 2017/3/13.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWPhotoTool.h"
#import "ZWHUDTool.h"

@implementation ZWPhotoTool

+ (void)writeImageToAlbumWithImage:(UIImage *)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSString *resultContent = error ? @"保存失败" : @"保存成功";
    [[ZWHUDTool showPlainHUDWithText:resultContent] hideAnimated:YES afterDelay:kTimeIntervalShort];
}


@end
