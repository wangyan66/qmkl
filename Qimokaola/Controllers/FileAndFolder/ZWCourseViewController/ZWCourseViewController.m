


//
//  ZWCourseViewController.m
//  Qimokaola
//
//  Created by Administrator on 16/9/10.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWCourseViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "ZWMineViewController.h"
#import "ZWNavigationController.h"
#import "WYTitleView.h"
#import <YYCategories/YYCategories.h>


static NSString *const kCollectedCoursesHeaderTitle = @"★ 我的课程";
static NSString *const kCollectedCourseIndex = @"★";
static NSString *const ROOT = @"/";
static NSString *const kCourseCellIdentifier = @"kCourseCellIdentifier";
static NSString *const KCourseHeaderIdentifier = @"KCourseHeaderIdentifier";
static NSString *const kCourseCacheName = @"CourseCache";
static NSString *const kRawDataArrayCacheKeyPrefix = @"RawDataArray-";
static NSString *const kCollectedCoursesDataFileName = @"CollectedCourses-%d.dat";

#define CreateCacheKey(Suffix) [kRawDataArrayCacheKeyPrefix stringByAppendingString: Suffix]


@interface ZWCourseViewController ()

@property (nonatomic, strong) UIView *schoolNameView;
@property (nonatomic, strong) WYTitleView *titleView;
@property (nonatomic, strong) UILabel *schoolNameLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) NSMutableArray *indexTitleArray;

@property (nonatomic, strong) NSArray *rawDataArray;

@property (nonatomic, strong) NSMutableArray *collectedCourses;

@property (nonatomic, strong) YYCache *cache;

@end

@implementation ZWCourseViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        NSLog(@"init %@ success", NSStringFromClass([self class]));
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self) weakSelf = self;
    
    self.hidesBottomBarWhenPushed = NO;
    
    self.dataArray = [NSMutableArray array];
    self.indexTitleArray = [NSMutableArray array];
    self.collectedCourses = [NSMutableArray array];
    
    [self fetchCacheData];
    
    // 设置索引背景为透明
//    self.tableView.frame=CGRectMake(0, 64, kScreenW,kScreenH);
    
    self.tableView.mj_header.backgroundColor = defaultBackgroundColor;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = defaultBlueColor;
    [self.tableView registerClass:[ZWCourseCell class] forCellReuseIdentifier:kCourseCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZWCourseHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:KCourseHeaderIdentifier];
    self.tableView.rowHeight = 50;
//    if (@available(iOS 11.0, *)) {
//
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//
//    } else {
//
//        self.automaticallyAdjustsScrollViewInsets = NO;
//
//    }
    
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.estimatedRowHeight = 0;
//        self.tableView.estimatedSectionHeaderHeight = 0;
//        self.tableView.estimatedSectionFooterHeight = 0;
//    }
    
    ((UISearchBar *)self.tableView.tableHeaderView).placeholder = @"直接搜索课程名";
//     self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //_schoolNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //_schoolNameView=[[WYTitleView alloc]init];
    
    
    
    //titleView包含schoolNameLabel和arrowView
    _titleView=[[WYTitleView alloc]init];
    _titleView.backgroundColor = [UIColor clearColor];
    [_titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popToSwitchSchool:)]];
    
    _schoolNameLabel = [[UILabel alloc] init];
    _schoolNameLabel.font = [[[UINavigationBar appearance] titleTextAttributes] objectForKey:NSFontAttributeName];
    _schoolNameLabel.textColor = [UIColor whiteColor];
    [self setSchoolNameLabelData];
    
    [_titleView addSubview:_schoolNameLabel];
    [_schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_titleView);

    }];
    
    _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_switch_school"]];
    [_titleView addSubview:_arrowView];
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
//make.left.equalTo(self.titleView.mas_right).with.offset(5);
    make.left.equalTo(self.schoolNameLabel.mas_right);
        make.right.equalTo(self.titleView.mas_right);
        make.centerY.equalTo(self.schoolNameLabel);
    }];
    self.navigationItem.titleView=_titleView;
    
    NSLog(@"navTitleView:%@,mytitleView%@",self.navigationItem.titleView,self.titleView);

    //_titleView.intrinsicContentSize=CGSizeMake(80, 44);
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
        
    
    
    
    
//    NSLog(@"titleView%@",self.navigationItem.titleView);
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadBtn addTarget:self action:@selector(tapUpload) forControlEvents:UIControlEventTouchUpInside];
    [uploadBtn setImage:[UIImage imageNamed:@"uploadFileIcon"] forState:UIControlStateNormal];
    [uploadBtn sizeToFit];
    UIBarButtonItem *uploadBtnItem = [[UIBarButtonItem alloc] initWithCustomView:uploadBtn];

//    UIBarButtonItem *uploadItem = [[UIBarButtonItem alloc] initWithTitle:@"上传资料" style:UIBarButtonItemStyleDone target:self action:@selector(tapUpload)];
    self.navigationItem.rightBarButtonItem = uploadBtnItem;
    
    
//    UIBarButtonItem *mineViewItem=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(showMineView)];
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(showMineView) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"mineViewIcon"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.leftBarButtonItem=settingBtnItem;
    
    if ([NSStringFromClass([self class]) isEqualToString:NSStringFromClass([ZWCourseViewController class])]) {
        [self checkAppUpdate];
    }
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserLoginSuccessNotification object:nil] subscribeNext:^(id x) {
        if (!weakSelf.tableView.mj_header.isRefreshing) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    }];
    // 注册手势驱动
    //    __weak typeof(self)weakSelf = self;
    // 第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个block为手势过程中我们希望做的操作
    [self cw_registerShowIntractiveWithEdgeGesture:YES transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        NSLog(@"direction = %ld", direction);
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            NSLog(@" 左侧滑出")
            [weakSelf showMineView];
        } //else if (direction == CWDrawerTransitionDirectionRight) { // 右侧滑出
        //            [weakSelf rightClick];
        //        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

#pragma mark - Normal Method


/**
 获取缓存
 */
- (void)fetchCacheData {
    
    ZWUser *user = [ZWUserManager sharedInstance].loginUser;
    NSLog(@"ZWCourseViewController从缓存中读取的user%@", user);
    
//    NSString *collegeId = self.isChooseCourseViewController ? user.collegeId.stringValue : user.currentCollegeId.stringValue;
    NSString *collegeName=self.isChooseCourseViewController ? user.collegeName : user.currentCollegeName;
    self.cache = [[YYCache alloc] initWithName:kCourseCacheName];
    
    //MD
    self.rawDataArray = (NSArray *)[self.cache objectForKey:CreateCacheKey(collegeName)];
    
    [self readCollectedCoursesData];
    [self dealDataWithRawDataArray];
    
    // 有数据时才加载
    if (self.rawDataArray.count != 0) {
        [self.tableView reloadData];
    }
}


- (void)readCollectedCoursesData{
    ZWUser *user = [ZWUserManager sharedInstance].loginUser;
    NSString *collegeId = self.isChooseCourseViewController ? user.collegeId.stringValue : user.currentCollegeId.stringValue;
    
    NSString *collegeName=self.isChooseCourseViewController ? user.collegeName : user.currentCollegeName;
    NSString *collectedCoursesDataFile = [[ZWPathTool collectedCourseDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:kCollectedCoursesDataFileName, collegeId.intValue]];
    [self.collectedCourses removeAllObjects];
    [self.collectedCourses addObjectsFromArray:(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:collectedCoursesDataFile]];
}

- (void)writeCollectedCoursesData{
    ZWUser *user = [ZWUserManager sharedInstance].loginUser;
    NSString *collegeId = self.isChooseCourseViewController ? user.collegeId.stringValue : user.currentCollegeId.stringValue;
    
    NSString *collectedCoursesDataFile = [[ZWPathTool collectedCourseDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:kCollectedCoursesDataFileName, collegeId.intValue]];
    [NSKeyedArchiver archiveRootObject:self.collectedCourses toFile:collectedCoursesDataFile];
}

/**
 设置缓存
 */
- (void)setCacheData {
    ZWUser *user = [ZWUserManager sharedInstance].loginUser;
    NSString *collegeId = self.isChooseCourseViewController ? user.collegeId.stringValue : user.currentCollegeId.stringValue;
    NSString *collegeName=self.isChooseCourseViewController ? user.collegeName : user.currentCollegeName;
    [self.cache setObject:self.rawDataArray forKey:CreateCacheKey(collegeName)];
}
- (void)showMineView{
    //    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:[[ZWMineViewController alloc] init] tabBarItemComponents:@[@"发现", @"icon_tab_discovery", @"icon_tab_discovery_selected"]];
    ZWMineViewController *vc=[[ZWMineViewController alloc]init];
    //    [self cw_showDefaultDrawerViewController:vc];
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0 scaleY:0 direction:CWDrawerTransitionFromLeft backImage:[UIImage imageNamed:@"login_register_background"]];
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:conf];
}
- (void)tapUpload {
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择上传方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *uploadByComputer = [UIAlertAction actionWithTitle:@"电脑上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openUploadMethodViewWithTitle:action.title assetName:@"pic_upload_method_computer"];
    }];
    
    UIAlertAction *uploadByPhone = [UIAlertAction actionWithTitle:@"手机上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openUploadMethodViewWithTitle:action.title assetName:@"pic_upload_method_phone"];
    }];
    [alertController addAction:cancleAction];
    [alertController addAction:uploadByComputer];
    [alertController addAction:uploadByPhone];

    

    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)openUploadMethodViewWithTitle:(NSString *)title assetName:(NSString *)assetName {
    ZWUploadMethodViewController *uploader = [[ZWUploadMethodViewController alloc] init];
    uploader.title = title;
    uploader.assetName = assetName;
    
    [self.navigationController pushViewController:uploader animated:YES];
}


/**
 检查更新
 */
- (void)checkAppUpdate {
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestAppInfo:^(id response, BOOL success) {
        if (success) {
            //通过version更新
            NSDictionary *info = [[response objectForKey:@"results"] objectAtIndex:0];
            
            NSString *serverVersion = [info objectForKey:@"version"];
            NSString *localVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSArray *serverArray = [serverVersion componentsSeparatedByString:@"."];
            NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
            NSInteger maxCount = MAX(serverArray.count, localArray.count);
            for (int i = 0; i < maxCount; i ++) {
                NSInteger v1 = serverArray.count - 1 >= i ? [serverArray[i] integerValue] : 0;
                NSInteger v2 = localArray.count - 1 >= i ? [localArray[i] integerValue] : 0;
                if (v1 > v2) {
                    
                    [weakSelf showUpdateAlertWithReleaseNotes:[info objectForKey:@"releaseNotes"]];
                    break;
                } else if (v2 > v1) {
                    break;
                }
            }
        }
    }];
}

- (void)showUpdateAlertWithReleaseNotes:(NSString *)releaseNotes {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSString *appLink = @"itms-apps://itunes.apple.com/app/id1054613325";
        if ([UIDevice systemVersion] < 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appLink]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appLink] options:@{} completionHandler:^(BOOL success) {
            }];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setSchoolNameLabelData {
    
    _schoolNameLabel.text = [ZWUserManager sharedInstance].loginUser.collegeName;
    [_schoolNameLabel sizeToFit];
    NSLog(@"schoolNameLabel.frame%@",_schoolNameLabel);
    NSLog(@"currentCollegeName%@",[ZWUserManager sharedInstance].loginUser.currentCollegeName);
    _titleView.frame=CGRectMake(0, 0,  _schoolNameLabel.width + 15,self.navigationController.navigationBar.frame.size.height);
    //_titleView.width = _schoolNameLabel.width + 15;
    
}

- (void)popToSwitchSchool:(UIGestureRecognizer *)sender {
    __weak __typeof(self) weakSelf = self;
    ZWSwitchSchollViewController *switchSchoolViewController = [[ZWSwitchSchollViewController alloc] init];
    switchSchoolViewController.switchSchoolCompletion = ^(NSString *collegeName, NSString *collegeID) {
        if ([weakSelf.schoolNameLabel.text isEqualToString:collegeName]) {
            return;
        }
        weakSelf.shouldEmptyViewShow = NO;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.indexTitleArray removeAllObjects];
        [weakSelf.tableView reloadData];
        
        [[ZWUserManager sharedInstance] updateCurrentCollegeId:@(collegeID.intValue) collegeName:collegeName];
        [weakSelf fetchCacheData];
        [weakSelf setSchoolNameLabelData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.shouldEmptyViewShow = YES;
            [weakSelf.tableView.mj_header beginRefreshing];
        });
    };
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:switchSchoolViewController];
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark 重写覆盖下拉刷新方法
- (void)freshHeaderStartFreshing {
    
    __weak __typeof(self) weakSelf = self;
    
    ZWUser *user = [ZWUserManager sharedInstance].loginUser;
    self.schoolNameLabel.text=user.collegeName;
        [ZWAPIRequestTool requestFileListInSchool:self.schoolNameLabel.text
                                             path:ROOT
                                            token:user.token
                                           result:^(id response, BOOL success) {
                                               
                                               if(success){
                                                   int code=[response[kHTTPResponseCodeKey] intValue];
                                                   
                                                   if (code==200) {
                                                       [weakSelf loadRemoteData:response[kHTTPResponseDataKey]];
                                                   }else if(code==202){
                                                       NSString *message=response[kHTTPResponseMsgKey];
                                                       [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:message] hideAnimated:YES afterDelay:kTimeIntervalShort];
                                                   }else if(code==404){
                                                       [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"出现错误"] hideAnimated:YES afterDelay:kTimeIntervalShort];
                                                   }

                                               }else{
                                                   
                                                   NSString *errDesc = [(NSError *)response code] == -1001 ? @"呀，连接不上服务器了" : @"出现错误，获取失败";
                                                   int errCode=(int)[(NSError *)response code];
                                                   if (errCode==-1001) {
                                                       errDesc=@"呀，连接不上服务器了";
                                                   }else if (errCode==-1009){
                                                       errDesc=@"已断开与互联网的连接";
                                                   }else{
                                                       errDesc=@"出现错误，获取失败";
                                                   }
                                                   
                                                   [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:errDesc] hideAnimated:YES afterDelay:kTimeIntervalShort];
                                               }
//                                               if (success&&[response[kHTTPResponseCodeKey] intValue]==200) {
//
//
//
//                                                   [weakSelf loadRemoteData:response[kHTTPResponseDataKey]];
//
//                                               } else {
//                                                   NSLog(@"下拉刷新response%@,success%@",response,success);
//
//                                                                                                          NSString *errDesc = [(NSError *)response code] == -1001 ? @"呀，连接不上服务器了" : @"出现错误，获取失败";
//                                                   [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:errDesc] hideAnimated:YES afterDelay:kTimeIntervalShort];
//                                               }
                                               
                                               [weakSelf.tableView.mj_header endRefreshing];
                                               
                                           }];
    
    
    
    NSLog(@"shit");
}

#pragma mark 处理接收到数据
- (void)loadRemoteData:(NSDictionary *)data {
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    if (data)
    for (NSString *key in [data allKeys]) {
        NSMutableDictionary *dict=[NSMutableDictionary new];
        [dict setValue:key forKey:@"name"];
        
        [array addObject:dict];
    }
    
    self.rawDataArray = [array linq_select:^id(NSDictionary *item) {
        return [ZWFolder yy_modelWithDictionary:item];
    }];
    
    [self setCacheData];
    
    [self dealDataWithRawDataArray];

    [self.tableView reloadData];
    
}

- (void)dealDataWithRawDataArray {
    
    [self.dataArray removeAllObjects];
    [self.indexTitleArray removeAllObjects];
    
    
    NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
    for (NSInteger i =0; i <28; i++) {
        //给临时数组创建28个数组作为元素，用来存放A-Z, #, 收藏的课程
        NSMutableArray * array = [[NSMutableArray alloc]init];
        [tmpArray addObject:array];
    }
    
    // 缓存A-Z分组中第一个元素的name字段与首字母的键值对
    NSMutableDictionary *firstWordDict = [NSMutableDictionary dictionary];
    
    for (ZWFolder *folder in self.rawDataArray) {
        if ([self.collectedCourses containsObject:folder.name]) {
            NSMutableArray *array = [tmpArray firstObject];
            [array addObject:folder];
        } else {
            //转化为首拼音并取首字母
            NSString * firstWord = [folder.name getFirstLetter];
            int intValueOfCharacter = [firstWord characterAtIndex:0];
            //把字典放到对应的数组中去
            if (intValueOfCharacter >= 65 && intValueOfCharacter <= 90) {
                //如果首字母是A-Z，直接放到对应数组
                NSMutableArray * array = tmpArray[intValueOfCharacter - 64]; // 65 - 1 多了一个放置收藏的数组
                if (array.count == 0) {
                    [firstWordDict setObject:firstWord forKey:folder.name];
                }
                [array addObject:folder];
            } else {
                //如果不是，就放到最后一个代表#的数组
                NSMutableArray * array = [tmpArray lastObject];
                [array addObject:folder];
            }
        }
    }
    
    //此时数据已按首字母排序并分组
    //遍历数组，删掉空数组
    
    for (NSInteger i = 0; i < 28; i ++) {
        NSMutableArray * mutArr = [tmpArray objectAtIndex:i];
        //如果数组不为空就添加到数据源当中
        if (mutArr.count != 0) {
            [self.dataArray addObject:mutArr];
            if (i >=1 && i <= 26) {
                ZWFolder *folder = mutArr[0];
                NSString *firstWord = [firstWordDict objectForKey:folder.name];
                int intValueOfCharacter = [firstWord characterAtIndex:0];
                if (intValueOfCharacter >= 65 && intValueOfCharacter <= 90) {
                    [self.indexTitleArray addObject:firstWord];
                }
            } else if (i == 0) {
                [self.indexTitleArray addObject:kCollectedCourseIndex];
            } else {
                [self.indexTitleArray addObject:@"#"];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        return self.filteredArray.count;
    } else {
        return [[self.dataArray objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:kCourseCellIdentifier];
    ZWFolder *folder = nil;
    if (self.searchController.active) {
        folder = [self.filteredArray objectAtIndex:indexPath.row];
    } else {
        folder = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    cell.folderName = folder.name;
    cell.collectButton.selected = [self.collectedCourses containsObject:folder.name];
    __weak __typeof(self) weakSelf = self;
    
    cell.collectBlock = ^(BOOL newCollectedStatus) {
        if (newCollectedStatus) {
            [weakSelf.collectedCourses addObject:folder.name];
            [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"该课程已收藏置顶"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        } else {
            [weakSelf.collectedCourses removeObject:folder.name];
        }
        [weakSelf writeCollectedCoursesData];
        [weakSelf dealDataWithRawDataArray];
        [weakSelf.tableView reloadData];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (self.searchController.active) {
        return nil;
    } else {
        if (self.indexTitleArray.count == 0) {
            return nil;
        }
        NSMutableArray *titles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        [titles addObjectsFromArray:self.indexTitleArray];
        return titles;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        return nil;
    } else {
        ZWCourseHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KCourseHeaderIdentifier];
        NSString *title = [self.indexTitleArray objectAtIndex:section];
        if ([title isEqualToString:kCollectedCourseIndex]) {
            header.titleLabel.text = kCollectedCoursesHeaderTitle;
        } else {
            header.titleLabel.text = title;
        }
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return 0;
    } else {
        return 20;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //    return index;
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        // [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        [tableView scrollToTopAnimated:NO];
        return NSNotFound;
    }
    else
    {
        //return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
        return index - 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
    NSString *path = nil;
    ZWFolder *folder = nil;
    if (self.searchController.active) {
        folder = [self.filteredArray objectAtIndex:indexPath.row];
    } else {
        folder = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    path = [[ROOT stringByAppendingPathComponent:folder.name] stringByAppendingString:@"/"];
    ZWFileAndFolderViewController *fileAndFolder = [[ZWFileAndFolderViewController alloc] init];
    fileAndFolder.path = path;
    fileAndFolder.course = folder.name;
    [self.navigationController pushViewController:fileAndFolder animated:YES];
}

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.filteredArray removeAllObjects];
    self.filteredArray = [ZWSearchTool searchFromArray:self.rawDataArray withSearchText:searchController.searchBar.text withSearhPredicateString:@"name CONTAINS[c] %@"];
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    searchController.searchBar.searchBarStyle = UIBarStyleDefault;
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
    
    self.tableView.mj_header.hidden = YES;
    
    searchController.searchBar.placeholder = @"输入课程名";
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.tabBarController.tabBar.hidden = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header.hidden = NO;
    
    searchController.searchBar.placeholder = @"直接搜索课程名";
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














