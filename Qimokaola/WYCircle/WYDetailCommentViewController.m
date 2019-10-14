//
//  WYDetailCommentViewController.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/20.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYDetailCommentViewController.h"
#import "WYCommentCell.h"
#import "WYDetailCommentCell.h"
#import "WYPrivateCommentCell.h"
#import "ZWUserManager.h"
#import "ZWAPIRequestTool.h"

#import "XHInputView.h"
#import "ZWHUDTool.h"
#import "MJRefresh.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface WYDetailCommentViewController ()<UITableViewDelegate,UITableViewDataSource,WYCommentCellDelegate,XHInputViewDelagete>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *detailComment;
@property (nonatomic, strong) NSMutableArray *publicComment;
@property (nonatomic, strong) NSMutableArray *privateComment;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL needInsertRow;//是否只需要单行刷新
@property (nonatomic, assign) BOOL IsInsertPrivate;//是否为私密评论刷新
@end

@implementation WYDetailCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needInsertRow = false;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue<=11.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title=@"详情";
    self.page=1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailComment=[[NSMutableArray alloc]init];

//    if (_isNeedModel) {
////从赞我的点入帖子详情需要
//        NSLog(@"postid,%@",self.model.postID);
//
//        [self fetchModel];
//    }
    [self fetchDetailComment];
    [self setupTableView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma method
- (instancetype)init{
    self=[super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isNeedModel=NO;
    }
    return self;
}
- (void)ifZan{
    
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestIfZanWithToken:[ZWUserManager sharedInstance].loginUser.token postId:self.model.postID result:^(id response, BOOL success) {
        int resultCode = [response[kHTTPResponseCodeKey] intValue];
        if (resultCode==200) {
            int isZan=[response[kHTTPResponseDataKey] intValue];
            if (isZan) {
                NSLog(@"后端返回数据显示该帖子已经点赞");
                weakSelf.model.isZan=YES;
            }else{
                NSLog(@"后端返回数据显示该帖子未点赞");
                weakSelf.model.isZan=NO;
            }
            //[weakSelf.tableView reloadData];
        }else{
            [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"出现错误,请重试"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
    }];
    
}
- (void)ifCollected{
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestIfCollectedWithToken:[ZWUserManager sharedInstance].loginUser.token postId:self.model.postID result:^(id response, BOOL success) {
        
        int resultCode = [response[kHTTPResponseCodeKey] intValue];
        if (resultCode==200) {
            int isCollected=[response[kHTTPResponseDataKey] intValue];
            if (isCollected) {
                NSLog(@"后端返回数据显示该帖子已经收藏");
                weakSelf.model.isCollection=YES;
            }else{
                NSLog(@"后端返回数据显示该帖子未收藏");
                weakSelf.model.isCollection=NO;
            }
            //[weakSelf.tableView reloadData];
        }else{
            [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"出现错误,请重试"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
    }];
}
//获取帖子信息
- (void)fetchModel{
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestPostInfoWithPostId:self.model.postID token:[ZWUserManager sharedInstance].loginUser.token result:^(id response, BOOL success) {
        if (success) {
            weakSelf.isNeedModel=NO;
            NSDictionary *comment=response[kHTTPResponseDataKey];
            _model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名同学";
            _model.content=comment[@"content"];
            _model.time=comment[@"createTime"];
            _model.likeNum=comment[@"likeNum"];
            _model.commentNum=comment[@"commentNum"];
            NSNumber *temp=comment[@"userId"];
            NSNumber *t=comment[@"id"];
            _model.ID=temp.stringValue;
            _model.postID=t.stringValue;
            //[weakSelf.tableView reloadData];

        }
        

    }];
}
- (void)fetchDetailComment{
    self.detailComment = [NSMutableArray array];
    self.publicComment = [NSMutableArray array];
    self.privateComment = [NSMutableArray array];
    self.page=1;
     NSString *page=[NSString stringWithFormat:@"%ld",(long)self.page];
    __weak __typeof(self) weakSelf = self;
    [self fetchModel];
    [self ifZan];
    [self ifCollected];
    
    [ZWAPIRequestTool requestDetailCommentWithToken:[ZWUserManager sharedInstance].loginUser.token posetId:self.model.postID page:page number:kNumOfPage result:^(id response, BOOL success) {
        if (success) {
            
            NSDictionary *dataDic = response[kHTTPResponseDataKey];
            NSArray *publicCommentArray = dataDic[@"comment"];
            NSArray *privateCommentArray = dataDic[@"privateComment"];
            NSLog(@"%@",dataDic);
            if (publicCommentArray) {
                for (int i=0; i<publicCommentArray.count; i++) {
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *comment=publicCommentArray[i];
                    model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名同学";
                    model.content=comment[@"content"];
                    model.time=comment[@"createTime"];
                    model.tonickname=comment[@"nickName2"];
                    NSNumber *temp=comment[@"userId"];
                    model.ID=temp.stringValue;
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    [weakSelf.publicComment addObject:model];
                }
                
            }
            if (privateCommentArray) {
                for (int i=0; i<privateCommentArray.count; i++) {
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *comment=privateCommentArray[i];
                    model.nickname=comment[@"nickName1"]?comment[@"nickName1"]:@"匿名同学";
                    model.content=comment[@"content"];
                    model.time=comment[@"date"];
                    model.tonickname=comment[@"nickName2"];
                    NSNumber *temp=comment[@"userId1"];
                    model.ID=temp.stringValue;
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    [weakSelf.privateComment addObject:model];
                }
                
            }
            if (weakSelf.needInsertRow) {
                [weakSelf.tableView beginUpdates];
                
                if (weakSelf.IsInsertPrivate) {
                    [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    NSLog(@"%lu",(unsigned long)weakSelf.privateComment.count);
                    
                    [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1+weakSelf.privateComment.count inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                [weakSelf.tableView endUpdates];
                weakSelf.needInsertRow = false;
            }else{
                [weakSelf.tableView reloadData];
            }
        }
        if (!weakSelf.needInsertRow) {
            [weakSelf.tableView.mj_header endRefreshing];
        }

    }];
}
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchDetailComment)];
    tableView.mj_footer=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreDetailComment)];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.estimatedRowHeight = 180;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    tableView.tableFooterView = [UIView new];
    //    tableView.tableHeaderView = self.tableHeaderView;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}
#pragma mark - method
- (void)fetchMoreDetailComment{
    self.page++;
    NSString *page=[NSString stringWithFormat:@"%ld",(long)self.page];
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestDetailCommentWithToken:[ZWUserManager sharedInstance].loginUser.token posetId:self.model.postID page:page number:kNumOfPage result:^(id response, BOOL success) {
        if (success) {
            NSDictionary *dataDic = response[kHTTPResponseDataKey];
            NSArray *publicCommentArray = dataDic[@"comment"];
            NSArray *privateCommentArray = dataDic[@"privateCommnet"];
            
            if (publicCommentArray) {
                for (int i=0; i<publicCommentArray.count; i++) {
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                   NSDictionary *comment=publicCommentArray[i];
                    
                    model.nickname=comment[@"nickName"]?comment[@"nickName"]:@"匿名同学";
                    model.tonickname=comment[@"nickName2"];
                    model.content=comment[@"content"];
                    model.time=comment[@"createTime"];
                    NSNumber *temp=comment[@"userId"];
                    model.ID=temp.stringValue;
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    [weakSelf.publicComment addObject:model];
                }
                
            }
            if (privateCommentArray) {
                for (int i=0; i<privateCommentArray.count; i++) {
                    WYCommentModel *model=[[WYCommentModel alloc]init];
                    NSDictionary *comment=privateCommentArray[i];
                    model.nickname=comment[@"nickName1"]?comment[@"nickName1"]:@"匿名同学";
                    model.content=comment[@"content"];
                    model.time=comment[@"date"];
                    model.tonickname=comment[@"nickName2"];
                    NSNumber *temp=comment[@"userId1"];
                    model.ID=temp.stringValue;
                    model.likeNum=comment[@"likeNum"];
                    model.commentNum=comment[@"commentNum"];
                    [weakSelf.privateComment addObject:model];
                }
                
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


/**
 判断是否位于私密评论和帖子范围

 @param index 索引
 @return 位于私密评论范围返回YES
 */
- (BOOL)isIndexInPrivate:(NSInteger)index {
    return index <= self.privateComment.count;
}
#pragma mark - YCBar delegate
-(void)sendButtonClick:(NSString *)text userId:(NSString *)userId nickName:(NSString *)nickName isPrivate:(BOOL *)isPrivate
{
    __weak __typeof(self) weakSelf = self;
//    NSString *sendText;
//    if (userId==_model.ID) {
//        sendText = text;
//    }else{
//        NSString *str = [NSString stringWithFormat:@"@%@:",nickName];
//        sendText = [str stringByAppendingString:text];
//    }
    if (isPrivate) {
        [ZWAPIRequestTool requestAddPrivateCommentWithToken:[ZWUserManager sharedInstance].loginUser.token postId:_model.postID userId:userId content:text result:^(id response, BOOL success) {
            if (success) {
                weakSelf.needInsertRow = YES;
                weakSelf.IsInsertPrivate = YES;
                [weakSelf fetchDetailComment];
                
            }
        }];
    }else{
        [ZWAPIRequestTool requestAddCommentWithToken:[ZWUserManager sharedInstance].loginUser.token postId:_model.postID comment:text userId:userId result:^(id response, BOOL success) {
            if (success) {
                weakSelf.needInsertRow = YES;
                weakSelf.IsInsertPrivate = false;
                [weakSelf fetchDetailComment];
               
                
            }
        }];
    }
    
    NSLog(@"你的评论：%@",text);
}
-(void)whenHide
{
    
    NSLog(@"收起键盘");
}
- (void)didZanButton:(NSString *)postId{
    
    if (postId) {
        [ZWAPIRequestTool requestZanWithToken:[ZWUserManager sharedInstance].loginUser.token postId:postId result:^(id response, BOOL success) {
            if (success) {
                NSLog(@"点赞成功");
            }
        }];
    }
}
//XHInputView 将要显示
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

//XHInputView 将要影藏
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}


#pragma mark tableview
- (void)didCollectionButtonWithPostId:(NSString *)postId{
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestAddCollectionWithToken:[ZWUserManager sharedInstance].loginUser.token postId:postId result:^(id response, BOOL success) {
        int resultCode = [response[kHTTPResponseCodeKey] intValue];
//        if (resultCode==200) {
//            int isCollected=[response[kHTTPResponseDataKey] intValue];
//            if (isCollected) {
//                weakSelf.model.isCollection=YES;
//            }else{
//
//                weakSelf.model.isCollection=NO;
//            }
//            [weakSelf.tableView reloadData];
//        }else{
//            [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"出现错误,请重试"] hideAnimated:YES afterDelay:kTimeIntervalShort];
//        }
        NSLog(@"收藏请求的返回msg为%@",response[kHTTPResponseMsgKey]);
 
    }];
}
- (void)didCommentButton{
    [self didCommentButtonWithUserId:_model.ID nickName:@""];
}
- (void)didCommentButtonWithUserId:(NSString *)userId nickName:(NSString *)nickName{
    NSLog(@"didcommentbutton!!!");
    
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */

        /** 代理 */
        inputView.delegate = self;

        /** 占位符文字 */
        inputView.placeholder = @"请输入评论文字...";
        /** 设置最大输入字数 */
        inputView.maxCount = 50;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
    } sendBlock:^BOOL(NSString *text,BOOL *isPrivate) {
        if(text.length){
            
        [self sendButtonClick:text userId:userId nickName:nickName isPrivate:isPrivate];
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-请输入要评论的的内容");
            return NO;//return NO,不收键盘
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"rows%lu",self.detailComment.count+1);
    return 1+self.privateComment.count+self.publicComment.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        static NSString *reuseIdentifier = @"WYCommentCell";
        WYCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell=[WYCommentCell loadCommentCell];
        }
        cell.model=self.model;
        
        cell.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if([self isIndexInPrivate:indexPath.row]){
        static NSString  *privateIdentifier=@"WYPrivateCommentCell";
        
        WYPrivateCommentCell *privateCell = [tableView dequeueReusableCellWithIdentifier:privateIdentifier];
        if (!privateCell) {
            privateCell = [WYPrivateCommentCell loadCommentCell];
        }
        
        WYCommentModel *model = self.privateComment[indexPath.row-1];
        [model showModel];
        privateCell.model = model;
        [privateCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        return privateCell;
    }else{
        static NSString  *detailIdentifier=@"WYDetailCommentCell";
        WYDetailCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:detailIdentifier];
        if (!cell) {
            cell=[WYDetailCommentCell loadCommentCell];
        }
        
        WYCommentModel *model=self.publicComment[indexPath.row-1-self.privateComment.count];
        cell.model=model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
    if (indexPath.row!=0) {
        if ([self isIndexInPrivate:indexPath.row]) {
            WYCommentModel *model = self.privateComment[indexPath.row-1];
            [self didCommentButtonWithUserId:model.ID nickName:model.nickname];
        }else{
            WYCommentModel *model=self.publicComment[indexPath.row-1-self.privateComment.count];
            [self didCommentButtonWithUserId:model.ID nickName:model.nickname];
        }
    }
    
}
@end
