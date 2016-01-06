//
//  ActivityDetailViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动详情";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //添加类目之后引入的方法
    [self showBackButton];
    
    
    
    
    
    
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
        YWMLog(@"responseObject = %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        YWMLog(@"error = %@", error);
    }];
    
    
    
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
