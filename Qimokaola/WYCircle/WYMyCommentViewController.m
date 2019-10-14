//
//  WYMyCommentViewController.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/27.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYMyCommentViewController.h"
#import "ZWAPIRequestTool.h"
#import "ZWUserManager.h"
#import "WYDetailCommentCell.h"
#import "WYDetailCommentViewController.h"
#import "WYZanTableViewCell.h"
#import "MJRefresh.h"
@interface WYMyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelList;
@property (nonatomic,assign) NSInteger page;
@end

@implementation WYMyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title=@"我发出的评论";
    self.page=1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.modelList=[[NSMutableArray alloc]init];
    [self fetchData];
    [self setuptableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -method
- (void)fetchData{
    self.page=1;
    self.modelList=[NSMutableArray array];
    NSString *page=[NSString stringWithFormat:@"%ld",(long)self.page];
    __weak __typeof(self) weakSelf = self;
    
    [ZWAPIRequestTool requestMyCommentWithToken:[ZWUserManager sharedInstance].loginUser.token page:page number:kNumOfPage result:^(id response, BOOL success) {
        if (success) {
            NSLog(@"我的评论response%@",response);
            NSArray *data=response[kHTTPResponseDataKey];
            for (int i=0; i<data.count;i++) {
                
                WYCommentModel *model=[[WYCommentModel alloc]init];
                NSDictionary *comment=data[i];
                model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名童鞋";
                model.content=comment[@"content"];
                model.time=comment[@"createTime"];
                NSNumber *temp=comment[@"userId"];
                NSNumber *t=comment[@"postId"];
                model.ID=temp.stringValue;
                model.postID=t.stringValue;
                [weakSelf.modelList addObject:model];
                
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)fetchMoreData{
    self.page++;
    NSString *page=[NSString stringWithFormat:@"%ld",(long)self.page];
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestMyCommentWithToken:[ZWUserManager sharedInstance].loginUser.token page:page number:kNumOfPage result:^(id response, BOOL success) {
        if (success) {
            NSLog(@"我的评论response%@",response);
            NSArray *data=response[kHTTPResponseDataKey];
            for (int i=0; i<data.count;i++) {
                
                WYCommentModel *model=[[WYCommentModel alloc]init];
                NSDictionary *comment=data[i];
                model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名童鞋";
                model.content=comment[@"content"];
                model.time=comment[@"createTime"];
                NSNumber *temp=comment[@"userId"];
                NSNumber *t=comment[@"postId"];
                model.ID=temp.stringValue;
                model.postID=t.stringValue;
                [weakSelf.modelList addObject:model];
                
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)setuptableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchData)];
        tableView.mj_footer=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreData)];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.estimatedRowHeight = 109.5;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}
#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.modelList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"WYDetailCommentCell";
    WYDetailCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[WYDetailCommentCell loadCommentCell];
    }
    WYCommentModel *model=self.modelList[indexPath.row];
    // NSLog(@"获得第%ld个model",(long)indexPath.row+1);
    
    
    cell.model=model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    WYDetailCommentViewController *detailVC=[[WYDetailCommentViewController alloc]init];
    detailVC.model=self.modelList[indexPath.row];
    detailVC.isNeedModel=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
