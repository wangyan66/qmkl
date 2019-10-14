//
//  ZWModifySchollViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/13.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWSwitchSchollViewController.h"
#import "ZWAPIRequestTool.h"
#import "ZWHUDTool.h"

@interface ZWSwitchSchollViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZWSwitchSchollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换学校";
    
    UIBarButtonItem *exitItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(exit)];
    self.navigationItem.leftBarButtonItem = exitItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Override

- (void)freshHeaderStartFreshing {
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestListSchool:^(id response, BOOL success) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"response!%@",response);
        if(success){
            int code=[response[kHTTPResponseCodeKey] intValue];
            
            if (code==200) {
                weakSelf.dataArray = [response objectForKey:kHTTPResponseDataKey];
                [weakSelf.tableView reloadData];
            }else if(code==202){
                NSString *message=response[kHTTPResponseMsgKey];
                [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:message] hideAnimated:YES afterDelay:kTimeIntervalShort];
                
            }else if(code==404){
                [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"获取数据失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }
            
        }else{
            
            NSString *errDesc;
            int errCode=(int)[(NSError *)response code];
            if (errCode==-1001) {
                errDesc=@"呀，连接不上服务器了";
            }else if (errCode==-1009){
                errDesc=@"已断开与互联网的连接";
            }else{
                errDesc=@"获取数据失败";
            }
            
            [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:errDesc] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
//        if (success && [[response objectForKey:kHTTPResponseCodeKey] intValue] == 200) {
//            weakSelf.dataArray = [response objectForKey:kHTTPResponseDataKey];
//            [weakSelf.tableView reloadData];
//        } else {
//            [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"获取数据失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
//        }
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
//MTC
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    NSDictionary *selectedSchoolData = [self.dataArray objectAtIndex:indexPath.row];
    NSString *selectedSchoolName=[self.dataArray objectAtIndex:indexPath.row];
    if (self.switchSchoolCompletion) {
        self.switchSchoolCompletion(selectedSchoolName,nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
