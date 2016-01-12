//
//  GoodThemeViewController.m
//  helloPlayWeeks
//  精选活动
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GoodThemeViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityDetailViewController.h"
#import "GoodModel.h"
@interface GoodThemeViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;  //请求的页码
}
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *adArray;

@end

@implementation GoodThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"精选活动";
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    
}



#pragma mark -------  UITableViewDataSource 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.adArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GoodModel *model = self.adArray[indexPath.row];
    goodCell.goodModel = model;
    goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return goodCell;
}

#pragma mark --------- UITableViewDelegate 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *activityStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [activityStory instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    //活动id
    GoodModel *model = self.adArray[indexPath.row];
    activityVC.actiID = model.activityID;
    [self.navigationController pushViewController:activityVC animated:YES];
    
}


#pragma mark ------- LazyLoading 
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 130;
        
    }
    return _tableView;
}

#pragma mark ----- PullingTableViewDelegate
//tableView开始刷新的时候调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    //下拉时延
    [self performSelector:@selector(loadingData) withObject:nil afterDelay:1.0];
    
}

//下拉时停顿一秒收回刷新栏
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadingData) withObject:nil afterDelay:1.0];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

//下拉刷新加载数据
- (void)loadingData{
    //数据获取
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [httpManager GET:[NSString stringWithFormat:@"%@&page=%ld", kGoodActivity, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *array = successDic[@"acData"];
            if (self.refreshing) {
                //下拉刷新的时候需要移除数组中的元素
                if (self.adArray.count > 0) {
                    [self.adArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in array) {
                GoodModel *model = [[GoodModel alloc] initWithDictionary:dict];
                  [self.adArray addObject:model];
                }
            
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            //刷新tableView数据,会执行所有tableView的代理方法
            [self.tableView reloadData];
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
    }];
    
    
}

//手指开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}

//手指结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}

#pragma mark ------ 懒加载
- (NSMutableArray *)adArray{
    if (!_adArray) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
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
