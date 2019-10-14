//
//  WYSendPostViewController.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/22.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYSendPostViewController.h"
#import "Masonry/Masonry.h"
#import "ZWAPIRequestTool.h"
#import "ZWUserManager.h"
#import "ZWHUDTool.h"
@interface WYSendPostViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView *textView;
@end

@implementation WYSendPostViewController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setHidesBottomBarWhenPushed:YES];
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendPost)];
    self.view.backgroundColor=[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1];

    [self addviews];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -method
- (void)addviews{
    self.textView=({
        UITextView *textView=[[UITextView alloc]init];
        textView.backgroundColor=[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
        //字体
        textView.font = [UIFont boldSystemFontOfSize:18.0];
        //对齐
        textView.textAlignment = NSTextAlignmentLeft;
        //字体颜色
        textView.textColor = [UIColor blackColor];
        //允许编辑
        textView.editable = YES;
        //用户交互     ///////若想有滚动条 不能交互 上为No，下为Yes
        textView.userInteractionEnabled = YES; ///
        //自定义键盘
        
        //textView.inputView = view;//自定义输入区域
        //textView.inputAccessoryView = view;//键盘上加view
        textView.delegate = self;
        [self.view addSubview:textView];
        textView.scrollEnabled = YES;//滑动
        //textView.returnKeyType = UIReturnKeyNext;//返回键类型
        textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
//        textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;//左对齐
        //editable为yes下无效
//        textView.dataDetectorTypes = UIDataDetectorTypeAll;//自动检测url等数据类型
        textView.inputAccessoryView=nil;
        textView.autocorrectionType = UITextAutocorrectionTypeNo;//自动纠错方式
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;//自动大写方式 在某些keyboardType下无效
        
        //禁止文字居中或下移64，因为avigationController下scrollView自动适应屏幕，而UITextView继承自UIScrollView
//        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(200);
        make.top.mas_equalTo(self.view).offset(self.navigationController.navigationBar.frame.size.height+40);
        }];
        textView;
    });
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"开始编辑");
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"结束编辑");
}

- (void)sendPost{
    __weak __typeof(self) weakSelf = self;
    if (self.textView.text.length!=0) {
        [ZWAPIRequestTool requestAddPostWithToken:[ZWUserManager sharedInstance].loginUser.token content:self.textView.text result:^(id response, BOOL success) {
            if(success){
                int code=[response[kHTTPResponseCodeKey] intValue];
                
                if (code==200) {
                     [[ZWHUDTool showPlainHUDInView:weakSelf.navigationController.view text:@"发布成功"] hideAnimated:YES afterDelay:kTimeIntervalShort];
                    if (weakSelf.completion) {
                        weakSelf.completion();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
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
        }];
    }
   
}
@end
