//
//  WYEmptyViewController.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/30.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYEmptyViewController.h"
#import "ZWPhotoTool.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
@interface WYEmptyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *weixin;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation WYEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"趣聊";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *imgs = @[
                      @"pic0.png",
                      @"pic1.png",
                      @"pic2.png",
                      @"pic3.jpg",
                      @"pic4.png",
                      @"pic5.png"];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenW / 1.599) shouldInfiniteLoop:YES imageNamesGroup:imgs];
    //self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 5;
    [self.view addSubview:self.cycleScrollView];
    _weixin.userInteractionEnabled=YES;
    [_weixin setImage:[UIImage imageNamed:@"公众号"]];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert)];
    [_weixin addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showAlert{
    
    //__weak __typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveToAlbumAction = [UIAlertAction actionWithTitle:@"保存至相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ZWPhotoTool writeImageToAlbumWithImage:[UIImage imageNamed:@"公众号"]];
    }];
    [alertController addAction:saveToAlbumAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
