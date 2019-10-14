//
//  ZWModifyGenderViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/9/17.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWModifyGenderViewController.h"
#import "ZWUserManager.h"
#import "ZWHUDTool.h"

//#import <UMCommunitySDK/UMComDataRequestManager.h>

@interface ZWModifyGenderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *genderArray;
@property (nonatomic, strong) NSString *presentGender;

@end

@implementation ZWModifyGenderViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = defaultBackgroundColor;
    self.title = @"性别";
    
    _genderArray = @[@"男", @"女"];
    _presentGender = [ZWUserManager sharedInstance].loginUser.gender;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tintColor = [UIColor redColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _genderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *gender = [_genderArray objectAtIndex:indexPath.row];
    cell.textLabel.text = gender;
    if ([gender isEqualToString:_presentGender]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    NSString *selectedGender = [_genderArray objectAtIndex:indexPath.row];
    if ([selectedGender isEqualToString:_presentGender]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        _presentGender = selectedGender;
        [tableView reloadData];
        __weak __typeof(self) weakSelf = self;
        // 执行修改请求
        [ZWHUDTool showInView:self.navigationController.view];
        [[ZWUserManager sharedInstance] modifyUserGender:_presentGender result:^(id response, BOOL success) {
            if (success && [[response objectForKey:kHTTPResponseCodeKey] intValue] == 200) {
                [ZWHUDTool dismissInView:weakSelf.navigationController.view];
                [[ZWUserManager sharedInstance] updateGender:_presentGender];
                ZWUser *user = [ZWUserManager sharedInstance].loginUser;
//                [[UMComDataRequestManager defaultManager] updateProfileWithName:user.nickname
//                                                                            age:0
//                                                                         gender:[user.gender isEqualToString:@"男"] ? @1 : @0
//                                                                         custom:user.collegeName
//                                                                   userNameType:userNameNoRestrict
//                                                                 userNameLength:userNameLengthNoRestrict
//                                                                     completion:^(NSDictionary *responseObject, NSError *error) {
//                                                                         
//                                                                     }];
                if (self.comletion) {
                    self.comletion();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"发生错误"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZWHUDTool dismissInView:weakSelf.navigationController.view];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
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
