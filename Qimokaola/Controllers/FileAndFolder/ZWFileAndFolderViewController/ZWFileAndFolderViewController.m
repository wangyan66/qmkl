//
//  ZWFileAndFolderViewController.m
//  Qimokaola
//
//  Created by Administrator on 16/9/9.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWFileAndFolderViewController.h"
#import "ZWFileCell.h"
#import "ZWFolderCell.h"
#import "ZWFileDetailViewController.h"
#import "ZWDataBaseTool.h"

#import "LinqToObjectiveC/LinqToObjectiveC.h"

#import "YYCategories/YYCategories.h"

@interface ZWFileAndFolderViewController ()



@end

@implementation ZWFileAndFolderViewController

static NSString *const kFileCellIdentifier = @"kFileCellIdentifier";
static NSString *const kFolderCellIdentifier = @"kFolderCellIdentifier";

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.path lastPathComponent];
    
    self.tableView.rowHeight = 55;
    
    
    [self.tableView registerClass:[ZWFileCell class] forCellReuseIdentifier:kFileCellIdentifier];
    [self.tableView registerClass:[ZWFolderCell class] forCellReuseIdentifier:kFolderCellIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Normal Method

/**
 *  @author Administrator, 16-09-09 21:09:25
 *
 *  下拉刷新时调用此方法
 */
- (void)freshHeaderStartFreshing {
    __weak __typeof(self) weakSelf = self;

    
    [ZWAPIRequestTool requestFileListInSchool:[ZWUserManager sharedInstance].loginUser.collegeName path:self.path token:[ZWUserManager sharedInstance].loginUser.token result:^(id response, BOOL success) {
        
        //NSLog(@"返回的文件列表%@",response);
        [weakSelf.tableView.mj_header endRefreshing];
        if (success) {
            NSDictionary *res=response[kHTTPResponseDataKey];
            [weakSelf loadRemoteData:res];
        }
    }];
}
- (BOOL)isFolder:(NSString *)name{
    if ([name containsString:@"."]) {
        //NSLog(@"%@不是文件夹",name);
        return false;
    } else {
        return YES;
    }
}

//MTC
- (void)loadRemoteData:(NSDictionary *)data {
    //暂时这样乱改 等我大二牛逼了就回来
    NSMutableArray *files=[[NSMutableArray alloc]init];
    NSMutableArray *folers=[[NSMutableArray alloc]init];
   
    for (NSString *key in [data allKeys]) {
        NSMutableDictionary *dict=[NSMutableDictionary new];
        if ([self isFolder:key]) {
            [dict setValue:key forKey:@"name"];
            [folers addObject:dict];
        }else{
            [dict setValue:key forKey:@"name"];
            [dict setValue:data[key] forKey:@"size"];
            [files addObject:dict];
        }
        
        
    }
    //一个数组,数组内每个元素都是字典
    self.files = [[files linq_select:^id(NSDictionary *item) {
        ZWFile *file = [ZWFile yy_modelWithDictionary:item];
        
        file.hasDownloaded = [[ZWDataBaseTool sharedInstance] isFileDownloaded:file.md5];
        return file;
    }] mutableCopy];
    
    self.folders = [[folers linq_select:^id(NSDictionary *item) {
        return [ZWFolder yy_modelWithDictionary:item];
    }] mutableCopy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/**
 *  @author Administrator, 16-09-10 23:09:01
 *
 *  判断是否位于文件范围
 *
 *  @param index 索引
 *
 *  @return 是否
 */
- (BOOL)isIndexInFiles:(NSInteger)index {
    return index < self.files.count;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count + self.folders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isIndexInFiles:indexPath.row]) {
        
        
        ZWFile *file = [self.files objectAtIndex:indexPath.row];
        ZWFileCell *cell = [tableView dequeueReusableCellWithIdentifier:kFileCellIdentifier];
        
        cell.file = file;
        return cell;
    } else {
        
       
        ZWFolder *folder = [self.folders objectAtIndex:(indexPath.row - self.files.count)];
        ZWFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:kFolderCellIdentifier];
        cell.folderName = folder.name;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
    if ([self isIndexInFiles:indexPath.row]) {
         __weak __typeof(self) weakSelf = self;
        ZWFile *file = [self.files objectAtIndex:indexPath.row];
        [ZWAPIRequestTool requestDetailInfoOfFileInPath:[self.path stringByAppendingString:file.name] college:[ZWUserManager sharedInstance].loginUser.collegeName   token:[ZWUserManager sharedInstance].loginUser.token result:^(id response, BOOL success) {
            if (success) {
                NSLog(@"返回的文件信息%@",response);
                NSDictionary *resDic=response[kHTTPResponseDataKey];
                ZWFile *detailFile=[ZWFile yy_modelWithDictionary:resDic];
                ZWFileDetailViewController *fileDetail = [[ZWFileDetailViewController alloc] init];
                detailFile.hasDownloaded = [[ZWDataBaseTool sharedInstance] isFileDownloaded:detailFile.md5];
                
                fileDetail.fileId=[NSString stringWithFormat:@"%@",resDic[@"id"]];
                fileDetail.zanNum=[NSString stringWithFormat:@"%@",resDic[@"likeNum"]];
                fileDetail.caiNum=[NSString stringWithFormat:@"%@",resDic[@"dislikeNum"]];
                
                //NSLog(@"hasdownloaded:%@",detailFile.hasDownloaded);
                if (detailFile.hasDownloaded) {
                    NSLog(@"已下载");
                }
                detailFile.name=file.name;
                //detailFile.uid=@"69";
                NSLog(@"detailFile:%@",detailFile);
                NSLog(@"ZanNum%@,CaiNum%@",resDic[@"likeNum"],resDic[@"dislikeNum"]);
                fileDetail.file = detailFile;
                NSLog(@"path:%@",weakSelf.path);
                fileDetail.path = weakSelf.path;
                fileDetail.course = weakSelf.course;
                fileDetail.hasDownloaded = detailFile.hasDownloaded;
                
                //MTC
                if (!detailFile.hasDownloaded) {
                    fileDetail.downloadCompletion = ^() {
                        detailFile.hasDownloaded=YES;
                        file.hasDownloaded = YES;
                        [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                    };
                }
                [weakSelf.navigationController pushViewController:fileDetail animated:YES];
            }
        }];
        
    } else {
        ZWFolder *folder = [self.folders objectAtIndex:(indexPath.row - self.files.count)];
        ZWFileAndFolderViewController *fileAndFolder = [[ZWFileAndFolderViewController alloc] init];
        // 安全系统工程/预先危险性/
        fileAndFolder.path = [[self.path stringByAppendingPathComponent:folder.name] stringByAppendingString:@"/"];
        
        fileAndFolder.course = self.course;
        [self.navigationController pushViewController:fileAndFolder animated:YES];
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
