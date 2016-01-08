//
//  ActivityDetailViewController.m
//  helloPlayWeeks
//  活动详情
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "ActivityView.h"
@interface ActivityDetailViewController ()
{
    NSString *_phoneNum;
}

@property (strong, nonatomic) IBOutlet ActivityView *activityDetialView;


@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动详情";    
    //添加类目之后引入的方法
    [self showBackButton];
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    //去地图页面
    self.activityDetialView.bankBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.activityDetialView.bankBtn addTarget:self action:@selector(gotoMakeMap:) forControlEvents:UIControlEventTouchUpInside];
    //打电话
    self.activityDetialView.makeCallBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.activityDetialView.makeCallBtn addTarget:self action:@selector(gotoMakeCall:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self getModel];
    
}
//网络请求
- (void)getModel{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpManger GET:[NSString stringWithFormat:@"%@&id=%@", kActivityDetail, self.activityID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        YWMLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityDetialView.dateDic = successDic;
            //获取电话号码
            _phoneNum = successDic[@"tel"];
            //获取特色描述
            
            
        }else{
        
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        YWMLog(@"error = %@", error);
    }];
    
    
    
}

//点击事件
- (void)gotoMakeCall:(UIButton *)btn{
    //程序外打电话，之后返回应用程序
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNum]]];
    
    //程序内打电话，之后不反悔当前应用程序
    UIWebView *cellPhone = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNum]]];
    [cellPhone loadRequest:request];
    [self.view addSubview:cellPhone];
}
- (void)gotoMakeMap:(UIButton *)btn{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
