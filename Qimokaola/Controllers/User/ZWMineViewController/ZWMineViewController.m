//
//  ZWMineViewController.m
//  Qimokaola
//
//  Created by Administrator on 2017/3/2.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWMineViewController.h"

#import "ZWUserManager.h"
#import "ZWHUDTool.h"
#import "ZWBrowserTool.h"
#import "ZWSettingViewController.h"
#import "ZWCountDownListViewController.h"
//#import "ZWFeedTableViewController.h"
//#import "ZWUserCommentsViewController.h"
//#import "ZWUserLikesViewController.h"
#import "MJRefresh.h"
#import "ZWUserInfoViewController.h"
#import "ZWMineHeaderView.h"
#import "WYCommentViewController.h"
#import "WYZanViewController.h"
#import "WYMyCommentViewController.h"
//#import <UMCommunitySDK/UMComSession.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIViewController+CWLateralSlide.h"
#import <YYCategories/YYCategories.h>
#import "ZWHUDTool.h"
@interface ZWMineViewController ()

@property (nonatomic, strong) ZWMineHeaderView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableViewCell *commentCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *favoriteCell;

@end

@implementation ZWMineViewController

- (instancetype)init
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    NSLog(@"init %@ success", NSStringFromClass([self class]));
    return (ZWMineViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ZWMineViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableHeaderView = self.tableHeaderView;
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchData)];
//    self.tableView.mj_header = header;
    [self fetchData];
    __weak __typeof(self) weakSelf = self;
    [RACObserve([ZWUserManager sharedInstance], unreadCommentCount) subscribeNext:^(id x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isViewLoaded) {
            [strongSelf updateTableViewCell:strongSelf.commentCell forCount:[x integerValue]];
        }
    }];
    
    [RACObserve([ZWUserManager sharedInstance], unreadLikeCount) subscribeNext:^(id x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isViewLoaded) {
            [strongSelf updateTableViewCell:strongSelf.favoriteCell forCount:[x integerValue]];
        }
    }];
    
}

- (ZWMineHeaderView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [ZWMineHeaderView mineHeaderViewInstance];
        _tableHeaderView.userInteractionEnabled = YES;
        [_tableHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTableHeaderView)]];
        _tableHeaderView.user = [ZWUserManager sharedInstance].loginUser;
    }
    return _tableHeaderView;
}

- (void)updateTableViewCell:(UITableViewCell *)cell forCount:(NSUInteger)count
{
    // Count > 0, show count
    if (count > 0) {
        
        // Create label
        CGFloat fontSize = 13;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        
        // Add count to label and size to fit
        label.text = [NSString stringWithFormat:@"%@", @(count)];
        [label sizeToFit];
        
        // Adjust frame to be square for single digits or elliptical for numbers > 9
        CGRect frame = label.frame;
        frame.size.height += (int)(0.2*fontSize);
        frame.size.width = (count <= 9) ? frame.size.height : frame.size.width + (int)fontSize;
        label.frame = frame;
        
        // Set radius and clip to bounds
        label.layer.cornerRadius = frame.size.height/2.0;
        label.clipsToBounds = true;
        
        // Show label in accessory view and remove disclosure
        cell.accessoryView = label;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Count = 0, show disclosure
    else {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 设置header的高度
    //self.tableHeaderView.frame = CGRectMake(0, 0, kScreenW, kScreenH * 0.15);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Methods

- (void)fetchData {
    NSLog(@"fetchData");
    __weak __typeof(self) weakSelf = self;
    NSDictionary *params=@{@"token":[ZWUserManager sharedInstance].loginUser.token};
    if (![ZWUserManager sharedInstance].loginUser.token) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserNeedLoginNotification object:nil];
    }else{
        [ZWAPIRequestTool requestLoginInfoWithParameters:params result:^(id response, BOOL success) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView.mj_header endRefreshing];
            if (success && [[response objectForKey:kHTTPResponseCodeKey] intValue] == 200) {
                ZWUser *user = [ZWUser yy_modelWithDictionary:[response objectForKey:kHTTPResponseDataKey]];
                user.token=[ZWUserManager sharedInstance].loginUser.token;
                if (user) {
                    [ZWUserManager sharedInstance].loginUser = user;
                    strongSelf.tableHeaderView.user = user;
                }
            }
//            else {
//
//                [[ZWHUDTool showPlainHUDInView:weakSelf.view text:@"出现错误"] hideAnimated:YES afterDelay:kTimeIntervalShort];
//            }
        }];
    }
    
}

- (void)tappedTableHeaderView {
    ZWUserInfoViewController *userInfoViewController = [[ZWUserInfoViewController alloc] init];
    [self cw_pushViewController:userInfoViewController];
    //[self.navigationController pushViewController:userInfoViewController animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
//                ZWFeedTableViewController *feedTabelViewController = [[ZWFeedTableViewController alloc] init];
//                feedTabelViewController.feedType = ZWFeedTableViewTypeAboutUser;
////                feedTabelViewController.user = [UMComSession sharedInstance].loginUser;
//                [self.navigationController pushViewController:feedTabelViewController animated:YES];
//                [[ZWHUDTool showPlainHUDInView:[UIApplication sharedApplication].keyWindow text:@"趣聊正在紧张刺激地开发中，敬请期待～"] hideAnimated:YES afterDelay:kTimeIntervalShort];
                WYCommentViewController *vc=[[WYCommentViewController alloc]init];
                vc.identifier=1;
                vc.hidesBottomBarWhenPushed=YES;
                [self cw_pushViewController:vc];
            }
                break;
                
            case 1: {
                //收藏
//                ZWFeedTableViewController *feedTableViewController = [[ZWFeedTableViewController alloc] init];
//                feedTableViewController.feedType = ZWFeedTableViewTypeAboutCollection;
//                [self.navigationController pushViewController:feedTableViewController animated:YES];
                WYCommentViewController *vc=[[WYCommentViewController alloc]init];
                vc.identifier=2;
                vc.hidesBottomBarWhenPushed=YES;
                [self cw_pushViewController:vc];
//                [[ZWHUDTool showPlainHUDInView:[UIApplication sharedApplication].keyWindow text:@"趣聊正在紧张刺激地开发中，敬请期待～"] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }
                
                break;
                
            case 2: {
                WYMyCommentViewController *vc=[[WYMyCommentViewController alloc]init];
                [self cw_pushViewController:vc];
//[[ZWHUDTool showPlainHUDInView:[UIApplication sharedApplication].keyWindow text:@"趣聊正在紧张刺激地开发中，敬请期待～"] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }
                break;
                
            case 3: {
//                [[ZWHUDTool showPlainHUDInView:[UIApplication sharedApplication].keyWindow text:@"趣聊正在紧张刺激地开发中，敬请期待～"] hideAnimated:YES afterDelay:kTimeIntervalShort];

               WYZanViewController *vc=[[WYZanViewController alloc]init];

            [self cw_pushViewController:vc];

            }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        ZWCountDownListViewController *controller = [[ZWCountDownListViewController alloc] init];
        [self cw_pushViewController:controller];
//        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 2 && indexPath.row != 2) {
        NSString *title = indexPath.row == 0 ? @"意见反馈" : @"加入我们";
        NSString *urlString = indexPath.row == 0 ? @"http://cn.mikecrm.com/LGpy5Kn" : @"http://cn.mikecrm.com/6lMhybb";
        [ZWBrowserTool openWebAddress:urlString fixedTitle:title];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        ZWSettingViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"setting"];
        //ZWSettingViewController *vc=[[ZWSettingViewController alloc]init];
        [self cw_pushViewController:vc];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
