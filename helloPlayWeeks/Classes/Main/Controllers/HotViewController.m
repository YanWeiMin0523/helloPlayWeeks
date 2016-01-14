//
//  HotViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HotViewController.h"
#import "PullingRefreshTableView.h"
#import "HotTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ThemeViewController.h"
#import "hotModel.h"
@interface HotViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>

@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, strong) NSMutableArray *pictureArray;
@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBackButton];
    self.title = @"热门专题";
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    
}


#pragma mark --------- UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.pictureArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotTableViewCell *hotCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    hotModel *model = self.pictureArray[indexPath.row];
    hotCell.model = model;
    hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return hotCell;
    
}


#pragma mark ---- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    hotModel *model = self.pictureArray[indexPath.row];
    themeVC.themeID = model.themeID;
    [self.navigationController pushViewController:themeVC animated:YES];
    
}


#pragma mark ------ LazyingLoad
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(5, 0, kWidth - 10, kHeight - 64) pullingDelegate:self];
        self.tableView.rowHeight = 200;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        self.pictureArray = [NSMutableArray new];
    }
    return _pictureArray;
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

//加载数据
- (void)loadingData{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [httpManager GET:[NSString stringWithFormat:@"%@&page=%ld", kHotActivity, (long)_pageCount] parameters:nil progress:^(  NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *rcArray = successDic[@"rcData"];
            //判断上拉加载
            if (self.pictureArray.count > 0) {
                [self.pictureArray removeAllObjects];
            }
            for (NSDictionary *dic in rcArray) {
                hotModel *model = [[hotModel alloc] initWithDictionary:dic];
                [self.pictureArray addObject:model];
            }
            
        }else{
            
        }
        //完成刷新
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        
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
