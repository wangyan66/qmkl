//
//  ZWAddCountDownViewController.m
//  Qimokaola
//
//  Created by Administrator on 2017/2/20.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWAddCountDownViewController.h"

#import "ZWCountDownPickerView.h"
#import "ZWCountdownDatabaseManager.h"
#import "ZWHUDTool.h"

#import "NSDate+Extension.h"
#import "NSString+Extension.h"

@interface ZWAddCountDownViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eaxmNameField;
@property (weak, nonatomic) IBOutlet UITextField *examLocationField;
@property (weak, nonatomic) IBOutlet UIButton *alarmTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *examTimeBtn;

// 提醒时间选型
@property (nonatomic, strong) NSArray *alarmTimeOptions;
// 提醒时间对应的interval
@property (nonatomic, strong) NSArray *alarmTimeIntervals;

@end

@implementation ZWAddCountDownViewController

+ (instancetype)addCountdownViewControllerInstance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return (ZWAddCountDownViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ZWAddCountDownViewController"];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishTheCountdown)];
    self.navigationItem.rightBarButtonItem = finishItem;
    
    [self.examTimeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.examTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.countdown) {
        [self loadCountdownView];
    } else {
        self.countdown = [[ZWCountdown alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Loading

- (NSArray *)alarmTimeOptions {
    if (_alarmTimeOptions == nil) {
        _alarmTimeOptions = @[@"提前半小时", @"提前1小时", @"提前2小时", @"提前1天", @"提前2天", @"提前3天", @"提前5天", @"提前7天"];
    }
    return _alarmTimeOptions;
}

- (NSArray *)alarmTimeIntervals {
    if (_alarmTimeIntervals == nil) {
        // 分别对应 半小时 一小时 两小时 一天 两天 三天 五天 七天 的秒数
        _alarmTimeIntervals = @[@(1800), @(3600), @(7200), @(86400), @(172800),
                                @(259200), @(43200), @(604800)];
    }
    return _alarmTimeIntervals;
}

#pragma mark - Actions

#pragma mark 选择提醒时间

- (IBAction)chooseAlarmTime:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"设置提醒时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 取消更改
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alerController addAction:cancleAction];
    // 提醒时间
    __weak __typeof(self) weakSelf = self;
    [self.alarmTimeOptions enumerateObjectsUsingBlock:^(id  _Nonnull alarmTime, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alertTimeAction = [UIAlertAction actionWithTitle:alarmTime style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.alarmTimeBtn setTitle:alarmTime forState:UIControlStateNormal];
        }];
        [alerController addAction:alertTimeAction];
    }];
    [self presentViewController:alerController animated:YES completion:nil];
}

- (IBAction)chooseCountdownTime:(id)sender {
    [self.view endEditing:YES];
    ZWCountDownPickerView *pickerView = [[ZWCountDownPickerView alloc] initWithTime:self.countdown.examDate];
    __weak __typeof(self) weakSelf = self;
    pickerView.completion = ^(NSDate *date, NSString *dateString) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.examTimeBtn setTitle:dateString forState:UIControlStateNormal];
        strongSelf.examTimeBtn.selected = YES;
        strongSelf.countdown.examDate = date;
    };
    [pickerView show];
}


#pragma mark - Common Methods

- (void)finishTheCountdown {
    [self.view endEditing:YES];
    if ([self.eaxmNameField.text stringByTrim].length == 0 || [self.examLocationField.text stringByTrim].length == 0) {
        [ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"请填写相关信息"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZWHUDTool dismissInView:self.navigationController.view];
            if ([self.eaxmNameField.text stringByTrim].length == 0) {
                [self.eaxmNameField becomeFirstResponder];
            } else {
                [self.examLocationField becomeFirstResponder];
            }
        });
        return;
    }
    if (!self.examTimeBtn.selected) {
        [ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"请选择考试时间"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZWHUDTool dismissInView:self.navigationController.view];
            [self chooseCountdownTime:nil];
        });
        return;
    }
    
    // 设置更新倒计时参数
    __block NSInteger index;
    __weak __typeof(self) weakSelf = self;
    [self.alarmTimeOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakSelf.alarmTimeBtn.titleLabel.text isEqualToString:obj]) {
            index = idx;
            *stop = YES;
        }
    }];
    NSNumber *interval = self.alarmTimeIntervals[index];
    self.countdown.alarmDate = [NSDate dateWithTimeInterval:-interval.doubleValue sinceDate:self.countdown.examDate];
    self.countdown.examName = self.eaxmNameField.text;
    self.countdown.examLocation = self.examLocationField.text;
    self.countdown.timeOfAhead = self.alarmTimeBtn.titleLabel.text;
    
    if (!self.countdown.identifier) {
        // 添加新的提醒
        self.countdown.identifier = [NSDate secondsSince1970];
        [[ZWCountdownDatabaseManager defaultManager] addCountdown:self.countdown];
    } else {
        // 更新提醒参数
        [[ZWCountdownDatabaseManager defaultManager] updateCountdown:self.countdown];
    }
    
    if (self.completion) {
        self.completion(self.countdown);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCountdownView {
    self.eaxmNameField.text = self.countdown.examName;
    self.examLocationField.text = self.countdown.examLocation;
    [self.examTimeBtn setTitle:[self.countdown.examDate dateStringForCountdown] forState:UIControlStateNormal];
    self.examTimeBtn.selected = YES;
    [self.alarmTimeBtn setTitle:self.countdown.timeOfAhead forState:UIControlStateNormal];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
//}

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
