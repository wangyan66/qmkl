//
//  WYModifySchoolViewController.m
//  Qimokaola
//
//  Created by 1WANGYAN on 2018/8/1.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYModifySchoolViewController.h"
#import "ZWAPIRequestTool.h"
#import "ZWUserManager.h"
#import "ZWHUDTool.h"
@interface WYModifySchoolViewController ()<UITableViewDelegate, UITableViewDataSource> {
    // 记录原本的学院位置
    NSIndexPath *preAcademyIndexPath;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *academies;
@property (nonatomic, strong) NSString *presentAcademyName;
@end

@implementation WYModifySchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = defaultBackgroundColor;
    self.title = @"学院";
    
    _presentAcademyName = [ZWUserManager sharedInstance].loginUser.collegeName;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tintColor = [UIColor redColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    [ZWHUDTool showInView:self.navigationController.view];
    
    NSString *token=[ZWUserManager sharedInstance].loginUser.token;
    [ZWAPIRequestTool requestListSchool:^(id response, BOOL success) {
        
        if (success && [[response objectForKey:kHTTPResponseCodeKey] intValue] == 200) {
            [ZWHUDTool dismissInView:weakSelf.navigationController.view];
            weakSelf.academies = [response objectForKey:kHTTPResponseDataKey];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"response:%@",response);
            [ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"加载学校失败 请重试"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZWHUDTool dismissInView:weakSelf.navigationController.view];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.academies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    cell.textLabel.text=[self.academies objectAtIndex:indexPath.row];
//    NSLog(@"_presentAcademyName:%@,[self.academies objectAtIndex:indexPath.row]%@",_presentAcademyName,[self.academies objectAtIndex:indexPath.row]);
    if ([_presentAcademyName isEqualToString:[self.academies objectAtIndex:indexPath.row]]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        preAcademyIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
    if (indexPath.row != preAcademyIndexPath.row) {
        if(preAcademyIndexPath){
            [tableView reloadRowsAtIndexPaths:@[indexPath, preAcademyIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        __weak __typeof(self) weakSelf = self;
        [ZWHUDTool showInView:self.navigationController.view];
        //        [[ZWUserManager sharedInstance] modifyUserAcademyId:_presentAcademyId result:^(id response, BOOL success)
        NSLog(@"shit");
        _presentAcademyName=_academies[indexPath.row];
        [[ZWUserManager sharedInstance] modifyUserSchoolName:_presentAcademyName result:^(id response, BOOL success){
            NSLog(@"修改学校的response%@",response);
            if (success && [[response objectForKey:kHTTPResponseCodeKey] intValue] == 200) {
                [ZWHUDTool dismissInView:weakSelf.navigationController.view];
                NSNumber *num=[NSNumber numberWithInt:1];
                [[ZWUserManager sharedInstance] updateCurrentCollegeId:num collegeName:_presentAcademyName];
                if (weakSelf.completion) {
                    weakSelf.completion();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"response%@",response);
                [ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"修改失败,请重试"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZWHUDTool dismissInView:weakSelf.navigationController.view];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

@end
