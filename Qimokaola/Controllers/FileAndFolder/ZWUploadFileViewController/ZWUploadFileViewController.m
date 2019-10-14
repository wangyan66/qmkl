//
//  ZWUploadFileViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/17.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWUploadFileViewController.h"
#import "ZWFileTool.h"
#import "ZWChooseCourseViewController.h"
#import "ZWAPIRequestTool.h"
@interface ZWUploadFileViewController ()

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *uploadCourse;

@property (weak, nonatomic) IBOutlet UIImageView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadCourseLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseCourseButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIButton *AnonymousButton;


@property (nonatomic, strong) NSURLSessionDataTask *uploadTask;

// 标记是否应该在 viewWillDisappear 时删除数据
@property (nonatomic, assign) BOOL canAutomaticallyDelete;

@end

@implementation ZWUploadFileViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (NSString *)nibName {
    return @"ZWUploadFileViewController";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[_fileUrl path]] && self.canAutomaticallyDelete) {
        NSLog(@"remove file");
        [[NSFileManager defaultManager] removeItemAtURL:_fileUrl error:NULL];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传文件";
    
    self.canAutomaticallyDelete = YES;
    
//    [_AnonymousButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
//    [_AnonymousButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    _filename = [_fileUrl lastPathComponent];
    _typeView.image = [UIImage imageNamed:[ZWFileTool fileTypeFromFileName:_filename]];
    _nameLabel.text = _filename;
    
    RACSignal *uploadCourseSignal = RACObserve(self, uploadCourse);
    
    RAC(self.uploadCourseLabel, text) = [[uploadCourseSignal filter:^BOOL(id value) {
        return value != nil;
    }] map:^id(id value) {
        return [NSString stringWithFormat:@"上传至：%@", value];
    }];
    
    RACSignal *uploadCourseValidSignal = [uploadCourseSignal map:^id(NSString *value) {
        return @(value && value.length > 0);
    }];
    
    RAC(self.chooseCourseButton.titleLabel, text) = [uploadCourseValidSignal map:^id(NSNumber *value) {
        if (value.boolValue) {
            return @"重选文件所属课程";
        } else {
            return @"选择文件所属课程";
        }
    }];
    
    __weak __typeof(self) weakSelf = self;
    RAC(self.uploadButton, backgroundColor) = [uploadCourseValidSignal map:^id(NSNumber *value) {
        if (value.boolValue) {
            return weakSelf.chooseCourseButton.backgroundColor;
        } else {
            return [UIColor lightGrayColor];
        }
    }];
    
    RAC(self.uploadButton, enabled) = uploadCourseValidSignal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosUploadcourse:(UIButton *)sender {
    __weak __typeof(self) weakSelf = self;
    ZWChooseCourseViewController *chooser = [[ZWChooseCourseViewController alloc] init];
    self.canAutomaticallyDelete = NO;
    chooser.chooseCourseCompletion = ^(NSString *course) {
        weakSelf.uploadCourse = course;
        weakSelf.canAutomaticallyDelete = YES;
    };
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:chooser];
    [self presentViewController:navc animated:YES completion:nil];
}
- (IBAction)changeState:(id)sender {
    _AnonymousButton.selected=!_AnonymousButton.selected;
}

- (IBAction)uploadFile:(UIButton *)sender {
    __weak __typeof(self) weakSelf = self;
    sender.userInteractionEnabled = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"上传中...";
    [hud.button setTitle:@"取消" forState:UIControlStateNormal];
    [hud.button addTarget:self action:@selector(cancleUploading) forControlEvents:UIControlEventTouchUpInside];
    hud.square = YES;
    //[NSString stringWithFormat:[ZWAPITool uploadFileAPI], [ZWUserManager sharedInstance].loginUser.collegeId.intValue]
    NSLog(@"上传文件的userId:%@,spath:%@,是否匿名%@",[ZWUserManager sharedInstance].loginUser.uid,[NSString stringWithFormat:@"/%@/%@", self.uploadCourse, self.filename],_AnonymousButton.isSelected?@1:@0);
    self.uploadTask = [ZWNetworkingManager postWithURLString:@"http://120.77.32.233/finalexam/app/upfile"
                                                      params:@{@"userId" : [ZWUserManager sharedInstance].loginUser.uid, @"spath" : [NSString stringWithFormat:@"/%@/", self.uploadCourse],@"anonymous":_AnonymousButton.isSelected?@1:@0}
                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                     NSLog(@"fileURL%@",weakSelf.fileUrl);
                     [formData appendPartWithFileURL:weakSelf.fileUrl
                                                name:@"file"
                                            fileName:weakSelf.filename
                                            mimeType:@"*/*"
                                               error:NULL];
                 }
                                  progress:^(NSProgress *progress) {
                                      NSLog(@"progress%@",progress); dispatch_async(dispatch_get_main_queue(), ^{
                                          hud.progress = progress.fractionCompleted;
                                      });
                                  }
                                   success:^(NSURLSessionDataTask *task, id responseObject) {

                                       NSLog(@"上传成功的response%@",responseObject);
                                       hud.mode = MBProgressHUDModeText;
                                       hud.label.text = @"上传成功，感谢您的贡献";
                                       hud.square = NO;
                                       hud.button.hidden = YES;
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalMid * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [hud hideAnimated:YES];
                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                       });
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {

                                       NSLog(@"上传文件failure%@",error);
                                       hud.mode = MBProgressHUDModeText;
                                       hud.button.hidden = YES;
                                       hud.label.text = @"上传出现错误，请重试";
                                       [hud hideAnimated:YES afterDelay:kTimeIntervalMid];
                                   }];

    
}


- (void)cancleUploading {
    if (self.uploadTask) {
        [self.uploadTask cancel];
        self.uploadTask = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[_fileUrl path]] && self.canAutomaticallyDelete) {
            NSLog(@"remove file");
            [[NSFileManager defaultManager] removeItemAtURL:_fileUrl error:NULL];
        }
        MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
        [hud hideAnimated:YES afterDelay:kTimeIntervalMid];
    }
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
