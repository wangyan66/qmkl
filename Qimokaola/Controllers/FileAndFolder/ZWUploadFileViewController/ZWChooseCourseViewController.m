//
//  ZWChooseCourseViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/17.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWChooseCourseViewController.h"

@interface ZWChooseCourseViewController ()

@end

@implementation ZWChooseCourseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isChooseCourseViewController = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择课程";
    self.navigationItem.leftBarButtonItems = self.navigationItem.rightBarButtonItems = nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(exit)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
    ZWFolder *folder = nil;
    if (self.searchController.active) {
        folder = [self.filteredArray objectAtIndex:indexPath.row];
        [self.searchController setActive:NO];
    } else {
        folder = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    self.chooseCourseCompletion(folder.name);
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
