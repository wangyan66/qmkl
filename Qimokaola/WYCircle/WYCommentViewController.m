//
//  WYCommentViewController.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/19.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYCommentViewController.h"
#import "ZWAPIRequestTool.h"
#import "ZWUserManager.h"
#import "WYCommentCell.h"
#import "WYDetailCommentViewController.h"
#import "WYSendPostViewController.h"
#import "MJRefresh.h"
@interface WYCommentViewController ()<UITableViewDelegate,UITableViewDataSource,WYCommentCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, assign) BOOL ifZan;

@end

@implementation WYCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.identifier==1) {
        
        self.title=@"我的动态";
        self.hidesBottomBarWhenPushed = YES;
    }else if (self.identifier==2){
        self.title=@"我的收藏";
        self.hidesBottomBarWhenPushed = YES;
    }else{
        self.title=@"学生圈";
        self.hidesBottomBarWhenPushed = NO;
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"说说" style:UIBarButtonItemStylePlain target:self action:@selector(gotoPost)];
    }
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.page=1;
    self.commentList=[[NSMutableArray alloc]init];
    
    [self fetchCommentList];
    [self setupTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -method
- (instancetype)init{
    self=[super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        self.identifier=0;
        
    }
    return self;
}
- (void)fetchCommentList{
    self.page=1;
    self.commentList=[NSMutableArray array];
    NSString *page=[NSString stringWithFormat:@"%ld",(long)self.page];
    __weak __typeof(self) weakSelf = self;
    if (self.identifier==1) {//我的动态
        [ZWAPIRequestTool requestMyPostWithToken:[ZWUserManager sharedInstance].loginUser.token page:page number:kNumOfPage result:^(id response, BOOL success) {
            if (success) {
                
                NSArray *data=response[kHTTPResponseDataKey];
                for (int i=0; i<data.count;i++) {
                    
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *comment=data[i];
                    model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名童鞋";
                    model.content=comment[@"content"];
                    model.time=comment[@"createTime"];
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    NSNumber *temp=comment[@"userId"];
                    NSNumber *t=comment[@"id"];
                    model.ID=temp.stringValue;
                    model.postID=t.stringValue;
                    [weakSelf.commentList addObject:model];
                    
                }
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }else if(self.identifier==2){//我的收藏
        [ZWAPIRequestTool requestMyCollectionWithToken:[ZWUserManager sharedInstance].loginUser.token page:page number:kNumOfPage result:^(id response, BOOL success) {
            if (success) {
                NSLog(@"收藏的response%@",response);
                NSArray *data=response[kHTTPResponseDataKey];
                for (int i=0; i<data.count;i++) {
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *result=data[i];
                    NSDictionary *comment=result[@"postResult"];
                    model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名童鞋";
                    model.content=comment[@"content"];
                    model.time=comment[@"createTime"];
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    NSNumber *temp=comment[@"userId"];
                    NSNumber *t=comment[@"id"];
                    model.ID=temp.stringValue;
                    model.postID=t.stringValue;
                    [weakSelf.commentList addObject:model];
                    
                }
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }else if (_identifier==0){//学生圈
        [ZWAPIRequestTool requestCommentListWithToken:[ZWUserManager sharedInstance].loginUser.token number:kNumOfPage page:page result:^(id response, BOOL success) {
            NSLog(@"学生圈获取帖子列表%@",response);
            if (success) {
                
                NSArray *data=response[kHTTPResponseDataKey];
                for (int i=0; i<data.count;i++) {
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *comment=data[i];
                    model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名童鞋";
                    model.content=comment[@"content"];
                    model.time=comment[@"createTime"];
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    NSNumber *temp=comment[@"userId"];
                    NSNumber *t=comment[@"id"];
                    model.ID=temp.stringValue;
                    model.postID=t.stringValue;
                    [weakSelf.commentList addObject:model];
                    
                }
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }
   
    
}
- (void)fetchMoreComment{
    
    self.page++;
    NSString *page=[NSString stringWithFormat:@"%ld",(long)self.page];
    __weak __typeof(self) weakSelf = self;
    if (_identifier==0) {
        [ZWAPIRequestTool requestCommentListWithToken:[ZWUserManager sharedInstance].loginUser.token number:kNumOfPage page:page result:^(id response, BOOL success) {
            NSLog(@"学生圈获取帖子列表%@",response);
            if (success) {
                
                NSArray *data=response[kHTTPResponseDataKey];
                
                if (data) {
                    for (int i=0; i<data.count;i++) {
                        WYCommentModel *model=[[WYCommentModel alloc]init];
                        NSDictionary *comment=data[i];
                        model.nickname=comment[@"nickName"];
                        
                        model.content=comment[@"content"];
                        model.time=comment[@"createTime"];
                        model.likeNum=comment[@"likeNum"];
                        model.commentNum=comment[@"commentNum"];
                        NSNumber *temp=comment[@"userId"];
                        NSNumber *t=comment[@"id"];
                        model.ID=temp.stringValue;
                        model.postID=t.stringValue;
                        [weakSelf.commentList addObject:model];
                        
                    }
                    [weakSelf.tableView reloadData];
                }
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }else if (_identifier==1){
        [ZWAPIRequestTool requestMyPostWithToken:[ZWUserManager sharedInstance].loginUser.token page:page number:kNumOfPage result:^(id response, BOOL success) {
            if (success) {
                
                NSArray *data=response[kHTTPResponseDataKey];
                for (int i=0; i<data.count;i++) {
                    
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *comment=data[i];
                    model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名童鞋";
                    model.content=comment[@"content"];
                    model.time=comment[@"createTime"];
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    NSNumber *temp=comment[@"userId"];
                    NSNumber *t=comment[@"id"];
                    model.ID=temp.stringValue;
                    model.postID=t.stringValue;
                    [weakSelf.commentList addObject:model];
                    
                }
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }else if(self.identifier==2){//我的收藏
        [ZWAPIRequestTool requestMyCollectionWithToken:[ZWUserManager sharedInstance].loginUser.token page:page number:kNumOfPage result:^(id response, BOOL success) {
            if (success) {
                NSLog(@"收藏的response%@",response);
                NSArray *data=response[kHTTPResponseDataKey];
                for (int i=0; i<data.count;i++) {
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *result=data[i];
                    NSDictionary *comment=result[@"postResult"];
                    model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名童鞋";
                    model.content=comment[@"content"];
                    model.time=comment[@"createTime"];
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    NSNumber *temp=comment[@"userId"];
                    NSNumber *t=comment[@"id"];
                    model.ID=temp.stringValue;
                    model.postID=t.stringValue;
                    [weakSelf.commentList addObject:model];
                    
                }
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchCommentList)];
    tableView.mj_footer=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreComment)];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.estimatedRowHeight = 170;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    tableView.tableFooterView = [UIView new];
//    tableView.tableHeaderView = self.tableHeaderView;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
}
- (void)gotoPost{
    [ZWAPIRequestTool requestTest];
//    __weak __typeof(self) weakSelf = self;
//    WYSendPostViewController *sendVC=[[WYSendPostViewController alloc]init];
//    sendVC.completion = ^{
//        [weakSelf fetchCommentList];
//        
//    };
//    [self.navigationController pushViewController:sendVC animated:YES];
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   // NSLog(@"行数%lu",(unsigned long)[self.commentList count]);
    return [self.commentList count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"WYCommentCell";
    WYCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[WYCommentCell loadCommentCell];
    }
//    NSLog(@"即将渲染第%ld个cell",(long)indexPath.row+1);
//    NSLog(@"list个数%lu",(unsigned long)_commentList.count);
    
    WYCommentModel *model=self.commentList[indexPath.row];
   // NSLog(@"获得第%ld个model",(long)indexPath.row+1);
  
//    cell.isCommentButtonHidden=YES;
//    cell.isSeperatorViewHidden=YES;
//    cell.isZanButtonHidden=YES;
    [cell hideViews];
    cell.model=model;
    cell.delegate=self;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    WYDetailCommentViewController *detailVC=[[WYDetailCommentViewController alloc]init];
    detailVC.model=self.commentList[indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 300;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    WYCommentModel *model=self.commentList[indexPath.row];
//   // NSLog(@"rowheight%f",model.rowHeight);
//    return model.rowHeight;
//
//}
#pragma mark -cellDelegate
- (void)didZanButton:(NSString *)postId{
    
    if (postId) {
        [ZWAPIRequestTool requestZanWithToken:[ZWUserManager sharedInstance].loginUser.token postId:postId result:^(id response, BOOL success) {
            if (success) {
                NSLog(@"点赞成功");
            }
        }];
    }
}
- (void)didCollectionButtonWithPostId:(NSString *)postId{
    if (postId) {
        [ZWAPIRequestTool requestAddCollectionWithToken:[ZWUserManager sharedInstance].loginUser.token postId:postId result:^(id response, BOOL success) {
            if (success) {
                NSLog(@"收藏成功");
            }
        }];
    }
}
@end
