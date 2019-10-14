//
//  ZWSettingViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/11/30.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWSettingViewController.h"

#import "ZWResetPasswordViewController.h"

#import "ZWUserManager.h"
#import "ZWHUDTool.h"
#import "ZWAccount.h"
#import "ZWFileTool.h"

#import <YYWebImage/YYWebImage.h> 

@interface ZWSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;

@end

@implementation ZWSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    YYImageCache *imageCache = [YYWebImageManager sharedManager].cache;
    self.cacheSizeLabel.text = imageCache.diskCache.totalCost > 0 ? [ZWFileTool sizeWithDouble:imageCache.diskCache.totalCost] : @"0KB";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Methods

- (void)askForRemovingCache {
    YYImageCache *imageCache = [YYWebImageManager sharedManager].cache;
    if (imageCache.diskCache.totalCost == 0) {
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"暂无缓存可清理"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        return;
    }
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alerController addAction:cancle];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *removalAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeCache];
    }];
    [alerController addAction:removalAction];
    [self presentViewController:alerController animated:YES completion:nil];
}

- (void)removeCache {
    YYImageCache *imageCache = [YYWebImageManager sharedManager].cache;
    [imageCache.memoryCache removeAllObjects];
    [ZWHUDTool showInView:self.navigationController.view text:@"正在清理..."];
    __weak __typeof(self) weakSelf = self;
    [imageCache.diskCache removeAllObjectsWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [ZWHUDTool dismissInView:strongSelf.navigationController.view];
            strongSelf.cacheSizeLabel.text = @"0KB";
        });
    }];
}

- (void)logout {
    [ZWHUDTool showInView:self.navigationController.view text:@"正在退出登录"];
    __weak __typeof(self) weakSelf = self;
    [[ZWUserManager sharedInstance] userLogout:^(id response, BOOL success) {
        if (success) {
            NSLog(@">>>");
            [ZWHUDTool dismissInView:weakSelf.navigationController.view];
            ZWAccount *account = [[ZWAccount alloc] init];
            account.account = [ZWUserManager sharedInstance].loginUser.username;
            [account writeData];
            [ZWUserManager sharedInstance].loginUser = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSuccessNotification object:nil];
        } else {
            NSLog(@"<<<");
            [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"出现错误，退出登录失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
    }];
}

- (void)changePwd {
    ZWResetPasswordViewController *resetViewController = [[ZWResetPasswordViewController alloc] init];
    resetViewController.enterPhoneNumber = [ZWUserManager sharedInstance].loginUser.username;
    NSLog(@"啦啦啦%@",[ZWUserManager sharedInstance].loginUser.username);
    resetViewController.title = @"修改密码";
    [self.navigationController pushViewController:resetViewController animated:YES];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self askForRemovingCache];
        } else {
            [self changePwd];
        }
    } else {
        
        [self logout];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
