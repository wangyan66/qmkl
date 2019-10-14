//
//  ZWCountDownListViewController.m
//  Qimokaola
//
//  Created by Administrator on 2017/2/19.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWCountDownListViewController.h"

#import "ZWCountDownCell.h"
#import "ZWAddCountDownViewController.h"
#import "ZWCountdownDatabaseManager.h"
#import "ZWHUDTool.h"
#import "NSDate+Extension.h"

#import <YYCategories/YYCategories.h>

#define kCountDownCellReuseIdentifier @"kCountDownCellReuseIdentifier"

@interface ZWCountDownListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *countdowns;

@end

@implementation ZWCountDownListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"考试倒计时";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = defaultPlaceHolderColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"ZWCountDownCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCountDownCellReuseIdentifier];
    
    self.countdowns = [[ZWCountdownDatabaseManager defaultManager] fetchCountdownList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)nibName {
    return NSStringFromClass([self class]);
}

#pragma mark - Common Methods

- (IBAction)addCountDown:(id)sender {
    __weak __typeof(self) weakSelf = self;
    ZWAddCountDownViewController *controller = [ZWAddCountDownViewController addCountdownViewControllerInstance];
    controller.completion = ^(ZWCountdown *countdown) {
        [weakSelf addLocalNotificationWithCountdown:countdown];
        [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"添加成功"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        weakSelf.countdowns = [[ZWCountdownDatabaseManager defaultManager] fetchCountdownList];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}


// 为保证代码一致性 将倒计时通知的增添删除修改代码移到此处


/**
 添加通知

 @param countdown 倒计时
 */
- (void)addLocalNotificationWithCountdown:(ZWCountdown *)countdown {
    // 若当前时间晚于通知时间 则不通知
    if ([[NSDate date] compare:countdown.alarmDate] == NSOrderedDescending) {
        return;
    }
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = countdown.alarmDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertTitle = @"您有一门考试即将开始";
    localNotification.alertBody = [NSString stringWithFormat:@"《%@》考试将于%@(%@后)在%@进行，请及时做好准备。", countdown.examName, [countdown.examDate dateStringForCountdown], [countdown.timeOfAhead substringFromIndex:2], countdown.examLocation];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = @{@"identifier": countdown.identifier};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


/**
 更新通知 先删除旧通知再添加通知

 @param countdown 倒计时
 */
- (void)updateLocationNotificationWithCountdown:(ZWCountdown *)countdown {
    [self deleteLocationNotificationWithCountdown:countdown];
    [self addLocalNotificationWithCountdown:countdown];
}


/**
 删除通知

 @param countdown 倒计时
 */
- (void)deleteLocationNotificationWithCountdown:(ZWCountdown *)countdown {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *locationNotification in localNotifications) {
        NSDictionary *userInfo = locationNotification.userInfo;
        NSString *key = @"identifier";
        if (userInfo && [userInfo containsObjectForKey:key]) {
            if ([userInfo[key] isEqualToString:countdown.identifier]) {
                [[UIApplication sharedApplication] cancelLocalNotification:locationNotification];
                break;
            }
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countdowns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWCountDownCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountDownCellReuseIdentifier];
    cell.countdown = self.countdowns[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    __weak __typeof(self) weakSelf = self;
    ZWAddCountDownViewController *controller = [ZWAddCountDownViewController addCountdownViewControllerInstance];
    controller.countdown = self.countdowns[indexPath.row];
    controller.completion = ^(ZWCountdown *countdown) {
        [weakSelf updateLocationNotificationWithCountdown:countdown];
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"修改成功"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        weakSelf.countdowns = [[ZWCountdownDatabaseManager defaultManager] fetchCountdownList];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZWCountdown *countdown = self.countdowns[indexPath.row];
        [[ZWCountdownDatabaseManager defaultManager] deleteCountdown:countdown];
        [self deleteLocationNotificationWithCountdown:countdown];
        [self.countdowns removeObjectAtIndex:indexPath.row];
        [tableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - DZEmptyDataSet

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView   {
    return [UIImage imageNamed:@"pic_none_hint_gray"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointZero;
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
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
