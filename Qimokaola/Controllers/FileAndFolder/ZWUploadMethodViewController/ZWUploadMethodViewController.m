//
//  ZWUploadMethodViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/17.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWUploadMethodViewController.h"

@interface ZWUploadMethodViewController ()

@property (nonatomic, strong) UIImageView *methodDemoView;

@end

@implementation ZWUploadMethodViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *assetPath = [[NSBundle mainBundle] pathForResource:_assetName ofType:@"png"];
    NSData *assetData = [NSData dataWithContentsOfFile:assetPath];
    UIImage *demoImage = [UIImage imageWithData:assetData];
    _methodDemoView = [[UIImageView alloc] initWithImage:demoImage];
    [self.view addSubview:_methodDemoView];
    
    CGFloat maxWidth = kScreenW;
    CGFloat maxHeight = kScreenH;
    CGFloat width = demoImage.size.width;
    CGFloat height = demoImage.size.height;

    //如果图片尺寸大于view尺寸，按比例缩放
    if (width > maxWidth || height > width){
        CGFloat ratio = height / width;
        CGFloat maxRatio = maxHeight / maxWidth;
        if(ratio < maxRatio){
            width = maxWidth;
            height = width*ratio;
        }else{
            height = maxHeight;
            width = height / ratio;
        }
    } else {
        CGFloat ratio = height / width;
        width = maxWidth;
        height = width * ratio;
    }
    _methodDemoView.frame = CGRectMake((maxWidth-width) / 2, (maxHeight-height) /2 + 32 , width, height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
