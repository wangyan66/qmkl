//
//  ZWSelectSchoolViewController.m
//  Qimokaola
//
//  Created by Administrator on 16/7/14.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWSelectSchoolViewController.h"
#import "ZWAPIRequestTool.h"
#import "ZWHUDTool.h"
#import <YYCategories/YYCategories.h>

typedef NS_ENUM(NSUInteger, ZWSelectSchoolViewControllerCurrentType) {
    ZWSelectSchoolViewControllerCurrentTypeSchool,
    ZWSelectSchoolViewControllerCurrentTypeAcademy,
    ZWSelectSchoolViewControllerCurrentTypeEnterYear,
};

@interface ZWSelectSchoolViewController ()

@property (nonatomic, strong) NSArray *schools;
@property (nonatomic, strong) NSArray *academies;
@property (nonatomic, strong) NSDictionary *selectedSchool;
@property (nonatomic, strong) NSString *selectedSchoolName;
@property (nonatomic, strong) NSDictionary *selectedAcademy;
@property (nonatomic, strong) NSString *selectedAcademyName;
@property (nonatomic, strong) UIBarButtonItem *chooseSchool;
@property (nonatomic, strong) UIBarButtonItem *chooseAcademy;
@property (nonatomic, strong) NSArray *enterYearArray;
@property (nonatomic, assign) ZWSelectSchoolViewControllerCurrentType type;

@end

@implementation ZWSelectSchoolViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableView分割线只在数据条目显示
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    self.chooseSchool = [[UIBarButtonItem alloc] initWithTitle:@"换个学校" style:UIBarButtonItemStyleDone target:self action:@selector(fetchSchoolList)];
    self.chooseAcademy = [[UIBarButtonItem alloc] initWithTitle:@"换个学院" style:UIBarButtonItemStyleDone target:self action:@selector(fetchAcademiesList)];
    NSInteger currentYear = [[NSDate date] year];
    self.enterYearArray = @[@(currentYear), @(currentYear - 1), @(currentYear - 2), @(currentYear - 3), @(currentYear - 4)];
    // 开始时加载学校列表
    [self fetchSchoolList];
}


- (void)fetchSchoolList {
    _type = ZWSelectSchoolViewControllerCurrentTypeSchool;
    self.title = @"选择学校";
    [ZWAPIRequestTool requestListSchool:^(id response, BOOL success) {
         NSLog(@"选择学校的response%@",response);
        if (success) {
           
            self.navigationItem.rightBarButtonItem = nil;
            self.schools = [response objectForKey:kHTTPResponseDataKey];
            [self.tableView reloadData];
        }
    }];
}

- (void)fetchAcademiesList {
    _type = ZWSelectSchoolViewControllerCurrentTypeAcademy;
//    self.title = [self.selectedSchool objectForKey:@"name"];
    self.title=self.selectedSchoolName;
    NSLog(@"查询专业detoken:%@",self.token);
    
    [ZWAPIRequestTool requestListAcademyWithParameter:@{@"collegeName" : self.selectedSchoolName,@"token":self.token} result:^(id response, BOOL success) {
        if (success&&[response[kHTTPResponseCodeKey] intValue]==200) {
            
                self.navigationItem.rightBarButtonItem = self.chooseSchool;
                self.academies = [(NSDictionary *)response objectForKey:kHTTPResponseDataKey];
                [self.tableView reloadData];
            }else{
                [ZWHUDTool showFailureInView:self.navigationController.view text:@"获取学院列表失败,请再试一下"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalLong * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZWHUDTool dismissInView:self.navigationController.view];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc select school");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == ZWSelectSchoolViewControllerCurrentTypeSchool) {
        return self.schools.count;
    } else if (_type == ZWSelectSchoolViewControllerCurrentTypeAcademy) {
        return self.academies.count;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (_type == ZWSelectSchoolViewControllerCurrentTypeSchool || _type == ZWSelectSchoolViewControllerCurrentTypeAcademy) {
//        NSDictionary *dict = _type == ZWSelectSchoolViewControllerCurrentTypeSchool ? [self.schools objectAtIndex:indexPath.row] : [self.academies objectAtIndex:indexPath.row];
        //cell.textLabel.text = [dict objectForKey:@"name"];
        cell.textLabel.text=_type == ZWSelectSchoolViewControllerCurrentTypeSchool ? [self.schools objectAtIndex:indexPath.row] : [self.academies objectAtIndex:indexPath.row];
    } else {
        NSNumber *enterYear = [self.enterYearArray objectAtIndex:indexPath.row];
        cell.textLabel.text = enterYear.stringValue;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_type == ZWSelectSchoolViewControllerCurrentTypeSchool) {
        [self dealWithSelectSchoolInIndexPath:indexPath];
    } else if (_type == ZWSelectSchoolViewControllerCurrentTypeAcademy) {
//        self.selectedAcademy = [self.academies objectAtIndex:indexPath.row];
        self.selectedAcademyName=[self.academies objectAtIndex:indexPath.row];
        self.title = self.selectedAcademyName;
        _type = ZWSelectSchoolViewControllerCurrentTypeEnterYear;
        self.navigationItem.rightBarButtonItem = self.chooseAcademy;
        [self.tableView reloadData];
    } else {
        if (_completionBlock) {
            NSNumber *selectedEnterYear = [self.enterYearArray objectAtIndex:indexPath.row];
            NSDictionary *result = [NSDictionary dictionaryWithObjects:@[self.selectedSchoolName, self.selectedAcademyName, selectedEnterYear] forKeys:@[@"school", @"academy", @"enterYear"]];
            NSLog(@"selected school, academy, enterYear info: %@", result);
            _completionBlock(result);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
    
}

- (void)dealWithSelectSchoolInIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"特别提醒" message:[NSString stringWithFormat:@"注册后无法更改学校，您当前选择的是\"%@\", 请确认", self.schools[indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:nil];
    [alerController addAction:cancleAction];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"就是这个" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectedSchool = [self.schools objectAtIndex:indexPath.row];
        self.selectedSchoolName=[self.schools objectAtIndex:indexPath.row];
        [self fetchAcademiesList];
    }];
    [alerController addAction:confirmAction];
    [self presentViewController:alerController animated:YES completion:nil];
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
