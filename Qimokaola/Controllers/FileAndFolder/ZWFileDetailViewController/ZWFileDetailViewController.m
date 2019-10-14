//
//  ZWFileDetailViewController.m
//  Qimokaola
//
//  Created by Administrator on 16/9/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWFileDetailViewController.h"
#import "UIColor+Extension.h"
#import "ZWFileTool.h"
#import "ZWAPITool.h"
#import "ZWNetworkingManager.h"
#import "ZWUserManager.h"
#import "ZWPathTool.h"
#import "ZWDataBaseTool.h"
#import "ZWHUDTool.h"
#import "ZWBrowserTool.h"
#import "ZWFileTool.h"
#import "WYOnlineWatchView.h"
#import "NSString+Extension.h"

#import "Masonry/Masonry.h"
//#import <UMMobClick/MobClick.h>
//#import <UMSocialCore/UMSocialCore.h>
#import <UMShare/UMShare.h>
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "CatZanButton.h"

@interface ZWFileDetailViewController () <UIDocumentInteractionControllerDelegate,UITextViewDelegate,WYOnlineWatchViewDelegate>



// 分享UI
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
// 底部条栏
@property (nonatomic, strong) UITabBar *bottomBar;
// 文件类型图像
@property (nonatomic, strong) UIImageView *typeImageView;
// 文件名标签
@property (nonatomic, strong) UILabel *nameLabel;
// 文件大小标签
@property (nonatomic, strong) UILabel *sizeLabel;
// 文件上传时间
@property (nonatomic, strong) UILabel *uploadTimeLabel;
// 文件上传者标签
@property (nonatomic, strong) UILabel *uploaderLabel;
// 打开、下载按钮
@property (nonatomic, strong) UIButton *downloadOrOpenButton;
// 分享按钮
@property (nonatomic, strong) UIButton *shareButton;
// 下载进度提示文本
@property (nonatomic, strong) UILabel *progressLabel;
// 下载进度条
@property (nonatomic, strong) UIProgressView *progressView;
// 打开文件提醒
@property (nonatomic, strong) UILabel *openHintLabel;
// 取消下载按钮
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) WYOnlineWatchView *OnlineWatchView;
//点赞按钮
@property (nonatomic, strong) CatZanButton *zanBtn;
@property (nonatomic, strong) CatZanButton *caiBtn;
@property (nonatomic, strong) UILabel *zanlabel;
@property (nonatomic, strong) UILabel *caiLabel;
@property (nonatomic, assign) BOOL isZan;
@property (nonatomic, assign) BOOL isCai;
//在线预览
@property (nonatomic,strong) UIButton *OnlineWatchButton;
@property (nonatomic, strong) AFHTTPSessionManager *downloadManager;
@property (nonatomic, strong) UITextView *OnlineWatchTextView;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;



@end

@implementation ZWFileDetailViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"文件详情";
    //CGRectMake(kScreenW/2.0-kScreenW*0.1, kScreenH*0.7, kScreenW*0.1, kScreenW*0.1)
//    self.zanBtn=[[CatZanButton alloc]initWithFrame:CGRectZero zanImage:[UIImage imageNamed:@"zan"] unZanImage:[UIImage imageNamed:@"unzan"]];
//
//    self.caiBtn=[[CatZanButton alloc]initWithFrame:CGRectZero zanImage:[UIImage imageNamed:@"cai"] unZanImage:[UIImage imageNamed:@"uncai"]];
    NSLog(@"fileID%@",_fileId);
    [self zw_addSubViews];
    //[self OnlineWatchTextViewSetting];
    if(_fileId){
        [ZWAPIRequestTool requestIfZanWithFileId:_fileId result:^(id response, BOOL success) {
            NSLog(@"response%@",response);
            NSDictionary *res=(NSDictionary *)response;
            int code=[res[kHTTPResponseDataKey] intValue];
            if (code==1) {
                NSLog(@"true");
                _zanBtn.isZan=true;
                _isZan=true;
            }else{
                _zanBtn.isZan=false;
                _isZan=false;
            }
        }];
        [ZWAPIRequestTool requestIfCaiWithFileId:_fileId result:^(id response, BOOL success) {
            NSLog(@"cairesponse%@",response);
            NSDictionary *res=(NSDictionary *)response;
            int code=[res[kHTTPResponseDataKey] intValue];
            if (code==1) {
                NSLog(@"matk");
                _caiBtn.isZan=true;
                _isCai=true;
            }else{
                _caiBtn.isZan=false;
                _isCai=false;
            }
        }];
    }
    
    
    __weak typeof(self) weakself = self;
    [self.zanBtn setClickHandler:^(CatZanButton *zanButton) {
        if (zanButton.isZan) {
            int i=[weakself.zanlabel.text intValue];
            i++;
            weakself.zanlabel.text=[NSString stringWithFormat:@"%d",i];
        }else{
            int i=[weakself.zanlabel.text intValue];
            i--;
            weakself.zanlabel.text=[NSString stringWithFormat:@"%d",i];
        }
    }];
    [self.caiBtn setClickHandler:^(CatZanButton *caiButton) {
        if (caiButton.isZan) {
            int i=[weakself.caiLabel.text intValue];
            i++;
            weakself.caiLabel.text=[NSString stringWithFormat:@"%d",i];
        }else{
            int i=[weakself.caiLabel.text intValue];
            i--;
            weakself.caiLabel.text=[NSString stringWithFormat:@"%d",i];
        }
    }];
//    if (_fileId) {
//        [self.view addSubview:self.zanBtn];
//        [self.view addSubview:self.caiBtn];
//    }
    
    
    
    [self setFileInfo];
    
    // 构建文件标识符
    // 如果文件已经下载 则取出文件存于磁盘中的名字
    if (self.hasDownloaded && self.storage_name == nil) {
        self.storage_name = [[ZWDataBaseTool sharedInstance] storage_nameWithIdentifier:self.file.md5];
    }
    
    self.documentController = [[UIDocumentInteractionController alloc] init];
    self.documentController.delegate = self;
    
    RAC(self.downloadOrOpenButton, selected) = RACObserve(self, hasDownloaded);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    if (self.fileId) {
        if (self.zanBtn.isZan!=_isZan) {
            
            
            [ZWAPIRequestTool requestZanWithFileId:_fileId result:^(id response, BOOL success) {
                if (success) {
                    NSLog(@"zan%@",response[kHTTPResponseMsgKey]);
                }
            }];
        }
        if (self.caiBtn.isZan!=_isCai) {
            [ZWAPIRequestTool requestCaiWithFileId:_fileId result:^(id response, BOOL success) {
                NSLog(@"cai%@",response[kHTTPResponseMsgKey]);
            }];
        }
    }
    
 //   });
    [self cancelDownload];
}


#pragma mark - Lazy Loading

- (AFHTTPSessionManager *)downloadManager {
    if (_downloadManager == nil) {
        _downloadManager = [AFHTTPSessionManager manager];
        _downloadManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _downloadManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", @"audio/wav", @"application/octet-stream", nil];
    }
    
    return _downloadManager;
}

#pragma mark - Common Methods
- (void)didOnlineWatchButton{
    
    [self OnlineWatch];
}
- (void)OnlineWatch{
    //pdf jpg png用自己的
    //http://www.finalexam.cn/qmkl1.0.0/dir/online/file/{md5}/{id}/{view}
//
//    NSString *url=@"https://view.officeapps.live.com/op/view.aspx?src=http://www.finalexam.cn/qmkl1.0.0/dir/online/file";
//    NSString *urlStr=[[[url stringByAppendingString:[NSString stringWithFormat:@"/%@",_file.md5]] stringByAppendingString:[NSString stringWithFormat:@"/%@",_fileId]] stringByAppendingString:[NSString stringWithFormat:@"/%@",_file.name]];
    NSString *urlstr=[self GetOnlineWatchUrl];
    NSString *newStr =[NSString stringWithCString:[urlstr UTF8String] encoding:NSUnicodeStringEncoding];
    NSLog(@"newstr%@",newStr);
    NSString *urlString= [self GetOnlineWatchUrl];
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    [ZWBrowserTool openWebAddress:encodedString fixedTitle:_file.name];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setFileInfo {
    _typeImageView.image = [UIImage imageNamed:[ZWFileTool fileTypeFromFileName:_file.name]];
    
    _nameLabel.text = _file.name;
    
    _uploaderLabel.text = [NSString stringWithFormat:@"分享者：@%@", _file.creator];
    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[_file.ctime doubleValue] / 1000];
//    NSString *dateString = [formatter stringFromDate:datea];
    _uploadTimeLabel.text = [NSString stringWithFormat:@"%@",_file.ctime];
    NSLog(@"!!!!!!!!!file.size%@",self.file.size);
    //self.sizeLabel.text=[ZWFileTool sizeWithString:self.file.size];
    _sizeLabel.text =_file.size;
}

- (void)zw_addSubViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.bottomBar = ({
        UITabBar *bar = [[UITabBar alloc] init];
        [self.view addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.height.mas_equalTo(55);
        }];
        bar;
    });
    
    
    
    self.openHintLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        label.text = @"请选择合适方式打开文件";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor lightGrayColor];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.bottomBar.mas_top);
            make.height.mas_equalTo(40);
        }];
        label;
        
    });
    
    self.typeImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(kScreenH * 0.05);
            make.height.width.mas_equalTo(100);
        }];
        imageView;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:18];
        label.font = font;
        label.numberOfLines = 0;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.typeImageView.mas_bottom).with.offset(kScreenH * 0.04);
            
        }];
        label;
    });
    
    _uploaderLabel = [[UILabel alloc] init];
    _uploaderLabel.font = ZWFont(16);
    _uploaderLabel.textColor = [UIColor blueColor];
    _uploaderLabel.textAlignment = NSTextAlignmentCenter;
    _uploaderLabel.numberOfLines = 1;
    [self.view addSubview:_uploaderLabel];
    [_uploaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom);
    }];
    
    _uploadTimeLabel = [[UILabel alloc] init];
    _uploadTimeLabel.textColor = [UIColor lightGrayColor];
    _uploadTimeLabel.font = ZWFont(16);
    _uploadTimeLabel.numberOfLines = 0;
    _uploadTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_uploadTimeLabel];
    [_uploadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.uploaderLabel.mas_bottom).offset(40);
    }];
    
    self.sizeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:16];
        label.font = font;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.uploadTimeLabel.mas_bottom).with.offset(10);
            
        }];
        label;
    });
    
    
    if (_fileId) {
        self.zanBtn =({
            CatZanButton *btn=[[CatZanButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW*0.1, kScreenW*0.1) zanImage:[UIImage imageNamed:@"zan"] unZanImage:[UIImage imageNamed:@"unzan"]];
            [self.view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(kScreenW*0.1);
                make.top.mas_equalTo(self.sizeLabel.mas_bottom).with.offset(20);
                make.left.mas_equalTo(self.view).with.offset(kScreenW/2.0-kScreenW*0.2);
                
            }];
            btn;
        });
        self.caiBtn =({
            CatZanButton *btn=[[CatZanButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW*0.1, kScreenW*0.1) zanImage:[UIImage imageNamed:@"cai"] unZanImage:[UIImage imageNamed:@"uncai"]];
            [self.view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(kScreenW*0.1);
                make.top.mas_equalTo(self.sizeLabel.mas_bottom).with.offset(20);
                make.left.mas_equalTo(self.view).with.offset(kScreenW/2.0+kScreenW*0.1);
                
            }];
            btn;
        });
        self.zanlabel=({
            
            UILabel *label=[[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 1;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor blackColor];
            label.text=_zanNum;
            [self.view addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.left.mas_equalTo(kScreenW/2.0-kScreenW*0.1);
                make.left.mas_equalTo(self.view).offset(kScreenW/2.0-kScreenW*0.2);
                make.top.mas_equalTo(self.zanBtn.mas_bottom);
                make.width.mas_equalTo(kScreenW*0.1);
                make.height.mas_equalTo(kScreenW*0.05);
            }];
            label;
        });
        self.caiLabel=({
            UILabel *label=[[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 1;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor blackColor];
            label.text=_caiNum;
            if (_fileId) {
                [self.view addSubview:label];
            }
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(self.view).offset(kScreenW/2.0+kScreenW*0.1);
                make.top.mas_equalTo(self.caiBtn.mas_bottom);
                make.width.mas_equalTo(kScreenW*0.1);
                make.height.mas_equalTo(kScreenW*0.05);
            }];
            label;
        });
    }
    int margin =20;
    float cornerRadius = 5.0f;
    UIFont *buttonTitleFont = [UIFont systemFontOfSize:15];
    UIColor *tintColor = RGB(26, 182, 238);
    if([self isOnlineWatchAvailable]&&_fileId){
        self.OnlineWatchView=[[WYOnlineWatchView alloc]initWithFrame:CGRectZero];
        self.OnlineWatchView.delegate=self;
        [self.view addSubview:self.OnlineWatchView];
        [self.OnlineWatchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.sizeLabel.mas_bottom).with.offset(25+kScreenW*0.15);
        }];
    }
    
    
    
    self.downloadOrOpenButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:buttonTitleFont];
        [button setTitle:@"下载文件" forState:UIControlStateNormal];
        [button setTitle:@"打开文件" forState:UIControlStateSelected];
        [button setBackgroundImage:[defaultBlueColor parseToImage] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
        [self.bottomBar addSubview:button];
        [button addTarget:self action:@selector(downloadOrOpenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    
    self.shareButton = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[[UIColor whiteColor] parseToImage] forState:UIControlStateNormal];
       // [button setBackgroundImage:[[UIColor whiteColor] parseToImage] forState:UIControlStateDisabled];
        [button setTitle:@"发送至电脑" forState: UIControlStateNormal];
        [button setTitleColor:tintColor forState:UIControlStateNormal];
        [button.titleLabel setFont:buttonTitleFont];
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = tintColor.CGColor;
        button.layer.borderWidth = 1.0;
        [self.bottomBar addSubview:button];
        
        [button addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    [self.downloadOrOpenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.bottomBar);
        make.height.mas_equalTo(self.bottomBar).multipliedBy(0.8);
        make.left.mas_equalTo(self.bottomBar.mas_left).with.offset(margin);
        make.right.mas_equalTo(self.shareButton.mas_left).with.offset(- margin * 2);
        make.width.mas_equalTo(self.shareButton);
    }];

    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomBar);
        make.height.mas_equalTo(self.downloadOrOpenButton);
        make.right.mas_equalTo(self.bottomBar.mas_right).with.offset(- margin);
        make.left.mas_equalTo(self.downloadOrOpenButton.mas_right).with.offset(margin * 2);
        make.width.mas_equalTo(self.downloadOrOpenButton);
    }];
    
    self.progressLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor grayColor];
        [self.bottomBar addSubview:label];
        label.hidden = YES;
        label.text  = @"正在准备下载...";
        label;
    });
    
    self.progressView = ({
        UIProgressView *progress = [[UIProgressView alloc] init];
        progress.trackTintColor = RGB(229, 229, 229);
        progress.progressTintColor = RGB(101, 213, 33);
        progress.progress = 0.0;
        [self.bottomBar addSubview:progress];
        progress.hidden = YES;
        progress;
    });
    
    self.cancelButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [self.bottomBar addSubview:button];
        button.hidden = YES;
        [button addTarget:self action:@selector(cancelDownload) forControlEvents:UIControlEventTouchUpInside];
        button;
        
    });
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.progressView);
        make.top.mas_equalTo(self.bottomBar);
        make.bottom.mas_equalTo(self.progressView);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {        make.left.mas_equalTo(self.bottomBar).with.offset(margin / 2);
        make.right.mas_equalTo(self.bottomBar).with.offset(- margin * 2);
        make.bottom.mas_equalTo(self.bottomBar).with.offset(- margin * 0.5);
        make.height.mas_equalTo(3);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.centerY.mas_equalTo(self.bottomBar);
        make.right.mas_equalTo(self.bottomBar);
        make.height.width.mas_equalTo(40);
        
    }];
//    self.OnlineWatchTextView = ({
//        UITextView *textView =[[UITextView alloc]initWithFrame:CGRectZero];
//        [self.view addSubview:textView];
//        textView;
//    });
//    [self.OnlineWatchTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.mas_equalTo(self.sizeLabel.mas_bottom).with.offset(5);
//    }];
}
- (BOOL)isOnlineWatchAvailable{
    NSRange range=[_file.size rangeOfString:@"MB"];
    NSString *sizeNum=[[NSString alloc]init];
    if (range.location!=NSNotFound) {
        sizeNum=[_file.size substringToIndex:range.location];
    }
    NSLog(@"文件大小!!!!%@",sizeNum);
    NSString *fileType =[ZWFileTool fileTypeFromFileName:_file.name];
    NSLog(@"该文件类型是%@",fileType);
    if ([fileType containsString:@"zip"]||[fileType containsString:@"7z"]||(range.location!=NSNotFound&&[sizeNum intValue]>10)) {
        NSLog(@"不支持在线预览");
        return false;
    }else return YES;
    
}
- (NSString *)GetOnlineWatchUrl{
    NSString *fileType =[ZWFileTool fileTypeFromFileName:_file.name];
    NSString *preUrl=@"https://view.officeapps.live.com/op/view.aspx?src=http://www.finalexam.cn/qmkl1.0.0/dir/online/file";
    NSString *baseUrl=@"http://www.finalexam.cn/qmkl1.0.0/dir/online/file";
    
    if ([fileType containsString:@"jpg"]||[fileType containsString:@"png"]||[fileType containsString:@"pdf"]) {
        NSString *jpgUrl=[[[baseUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",_file.md5]] stringByAppendingString:[NSString stringWithFormat:@"/%@",_fileId]] stringByAppendingString:[NSString stringWithFormat:@"/%@",_file.name]];
        NSLog(@"jpgUrl%@",jpgUrl);
        return jpgUrl;
    }else{
        NSString *pptUrl=[[[preUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",_file.md5]] stringByAppendingString:[NSString stringWithFormat:@"/%@",_fileId]] stringByAppendingString:[NSString stringWithFormat:@"/%@",_file.name]];
        NSLog(@"pptUrl%@",pptUrl);
        return pptUrl;
    }
}
- (void)OnlineWatchTextViewSetting{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意该软件的用户协议和隐私政策"];
    //NSLog(@"%@>>>",[self GetOnlineWatchUrl]);
    NSString *url=[self GetOnlineWatchUrl];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:[NSURL URLWithString:@"http://120.77.32.233/qmkl1.0.0/dir/protocol/agreement"]
                             range:[[attributedString string] rangeOfString:@"用户协议"]];
//    [attributedString addAttribute:NSLinkAttributeName
//                             value:[NSURL URLWithString:@"http://120.77.32.233/qmkl1.0.0/dir/protocol/policy"]
//                             range:[[attributedString string] rangeOfString:@"隐私政策"]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:[NSURL URLWithString:@"www.baidu.com"]
                             range:[[attributedString string] rangeOfString:@"隐私政策"]];
    
    _OnlineWatchTextView.attributedText = attributedString;
    _OnlineWatchTextView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                         NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    _OnlineWatchTextView.delegate = self;
    _OnlineWatchTextView.editable = NO; //必须禁止输入，否则点击将弹出输入键盘
    _OnlineWatchTextView.scrollEnabled = NO;
}
- (void)cancelDownload {
    [self setDownloadState:NO];
    if (self.downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
}

- (void)downloadOrOpenButtonClicked:(UIButton *)sender {
    if (!self.hasDownloaded) {
        [self downloadFile];
    } else {
        [self openDocumentInThirdPartyApp];
    }
}

- (void)downloadFile {
    
//    [MobClick event:kDownloadFileEventID];
    
    __weak __typeof(self) weakSelf = self;
    [self setDownloadState:YES];
    
    [ZWAPIRequestTool requestDownloadUrlWithCollegeName:[ZWUserManager sharedInstance].loginUser.collegeName path:[_path stringByAppendingString:_file.name] token:[ZWUserManager sharedInstance].loginUser.token result:^(id response, BOOL success){
                                              __strong __typeof(weakSelf) strongSelf = weakSelf;
                                              if (success && [response[kHTTPResponseCodeKey] intValue] == 200) {
                                                  NSString *urlString = [[response objectForKey:kHTTPResponseDataKey] objectForKey:@"url"];
                                                  
                                                  [strongSelf downloadFileWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
                                              } else {
                                                  [strongSelf setDownloadState:NO];
                                                  [[ZWHUDTool showPlainHUDInView:strongSelf.navigationController.view text:@"获取下载地址失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
                                              }
                                          }];
}

- (void)downloadFileWithRequest:(NSURLRequest *)request {
    __weak __typeof(self) weakSelf = self;
    self.downloadTask = [self.downloadManager downloadTaskWithRequest:request
                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                         __strong __typeof(weakSelf) strongSelf = weakSelf;
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             strongSelf.progressLabel.text = [NSString stringWithFormat:@"已完成：%.1f%%", downloadProgress.fractionCompleted * 100];
                                                                             strongSelf.progressView.progress = downloadProgress.fractionCompleted;
                                                                         });
                                                                     }
                                                                  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                      __strong __typeof(weakSelf) strongSelf = weakSelf;
                                                                      return [NSURL fileURLWithPath:[strongSelf properFileName:strongSelf.file.name]];
                                                                  }
                                                            completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                __strong __typeof(weakSelf) strongSelf = weakSelf;
                                                                [strongSelf setDownloadState:NO];
                                                                if (error) {
                                                                    NSLog(@"取消下载或下载失败");
                                                                } else {
                                                                    strongSelf.hasDownloaded = YES;
                                                                    if (strongSelf.downloadCompletion) {
                                                                        strongSelf.downloadCompletion();
                                                                    }
                                                                    
                                                                    
                                                                    [[ZWDataBaseTool sharedInstance] addFileDownloadInfo:strongSelf.file
                                                                                                                storage_name:strongSelf.storage_name
                                                                                                                inSchool:[ZWUserManager sharedInstance].loginUser.currentCollegeName
                                                                                                                inCourse:strongSelf.course];
                                                                }
                                                            }];
    [self.downloadTask resume];
}



/**
 获得文件的最佳存储路径

 @param originFileName

 @return
 */
- (NSString *)properFileName:(NSString *)originFileName {
    NSString *properFileName = originFileName;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *downloadDir = [ZWPathTool downloadDirectory];
    NSRange range = [properFileName rangeOfString:@"." options:NSBackwardsSearch];
    int suffix = 1;
    while ([fileManager fileExistsAtPath:[downloadDir stringByAppendingPathComponent:properFileName]]) {
        properFileName = [originFileName stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"(%d).", suffix ++]];
    }
    self.storage_name = properFileName;
    return [downloadDir stringByAppendingPathComponent:properFileName];
}

#pragma mark - 分享至QQ QQ空间
- (void)shareToComputer{
    
//    [MobClick event:kShareFileEventID];
    //[self.file.name URLEncodedString]
//    NSString *shareUrl = [NSString stringWithFormat:@"%@：%@", self.file.name, [NSString stringWithFormat:[ZWAPITool shareFileAPI], self.file.md5, [self.file.name URLEncodedString]]];
    NSString *shareUrl=[NSString stringWithFormat:@"http://120.77.32.233/qmkl1.0.0/dir/download/file/ios/%@/%@",self.file.md5,[self.file.name URLEncodedString]];
    NSString *forehead=@"文件下载链接:";
    NSLog(@"shareURL%@",shareUrl);
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = [forehead stringByAppendingString:shareUrl];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                NSString *message = nil;
                if (!error) {
                    
                    message = [NSString stringWithFormat:@"分享成功"];
                } else {
                    message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
        
                }
                NSLog(@"%@", message);
    }];
    
}

#pragma mark 打开已下载文件
-(void)openDocumentInThirdPartyApp {
    
//    [MobClick event:kOpenFileEventID];
    
    NSString *filePath = [[ZWPathTool downloadDirectory] stringByAppendingPathComponent:self.storage_name];
    self.documentController.URL = [NSURL fileURLWithPath:filePath];
    NSLog(@"第三方获取的url%@",self.documentController.URL);
    [self.documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

- (void)sendButtonClicked:(UIButton *)sender {
    [self shareToComputer];
}

- (void)setDownloadState:(BOOL)isDownload {
    [self setMainButtonHidden:isDownload];
    [self setDownloadComponmentHidden:!isDownload];
}

- (void)setMainButtonHidden:(BOOL)hidden {
    self.downloadOrOpenButton.hidden = hidden;
    self.shareButton.hidden = hidden;
}

- (void)setDownloadComponmentHidden:(BOOL)hidden {
    self.progressLabel.hidden = hidden;
    self.progressView.hidden = hidden;
    self.cancelButton.hidden = hidden;
    
    self.progressView.progress = 0.f;
    self.progressLabel.text = @"正在准备下载...";
}

#pragma mark - UIDocumentInteractionControllerDelegate代理方法

- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller {
    if (self.navigationController) {
        return self.navigationController;
    }
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}
//点击预览窗口的“Done”(完成)按钮时调用

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)controller {
    NSLog(@"documentInteractionControllerDidEndPreview");
}

// 预览文件或者拷贝至第三方App时都会触发以下两个方法

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller {
    [[ZWDataBaseTool sharedInstance] updateLastAccessTimeWithIdentifier:_file.md5];
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    [[ZWDataBaseTool sharedInstance] updateLastAccessTimeWithIdentifier:_file.md5];
}

//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet {
    return YES;
}

@end
