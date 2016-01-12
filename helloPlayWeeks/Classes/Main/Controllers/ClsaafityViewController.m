//
//  ClsaafityViewController.m
//  helloPlayWeeks
//  分类列表
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ClsaafityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodTableViewCell.h"
#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "GoodModel.h"
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"
@interface ClsaafityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL canRefreshing;
//用来负责展示数据的数据
@property(nonatomic, strong) NSMutableArray *showDataArray;
@property(nonatomic, strong) NSMutableArray *showArray;
@property(nonatomic, strong) NSMutableArray *touristArray;
@property(nonatomic, strong) NSMutableArray *studyArray;
@property(nonatomic, strong) NSMutableArray *familyArray;
@property(nonatomic, strong) VOSegmentedControl *VOsegment;

@end

@implementation ClsaafityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分类列表";
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _pageCount = 1;
   //选择点击进入哪一个网络请求
    [self chooseRequest];
    [self showSelectButton];
    [self getFamilyData];
    [self getShowData];
    [self getStudyData];
    [self getTourseData];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.VOsegment];
    
    //导航栏右侧按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_list"] style:UIBarButtonItemStylePlain target:self action:@selector(rightListAction:)];
    rightBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    searchBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[rightBar, searchBar];
    
    
    
    
}

//在页面将要消失的时候去掉所有的加载的圈圈

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

#pragma mark ----- PullingTableViewDelegate
//tableView开始刷新的时候调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.canRefreshing = YES;
    //下拉时延
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
    
}

//下拉时停顿一秒收回刷新栏
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

#pragma mark -------- Custom Method
- (void)chooseRequest{
    //第一次进入分类列表中，判断请求的数据
    switch (self.classfityType) {
        case ClassfityListTypeShowRepertoire:
            [self getShowData];
            break;
        case ClassfityListTypeToursePlace:
            [self getTourseData];
            break;
        case ClassfityListTypeStudyPUZ:
            [self getStudyData];
            break;
        case ClassfityListTypeFamilyTravel:
            [self getFamilyData];
            break;
    }
}

//获取数据
- (void)getShowData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //演出剧目 typeid = 6
    [ProgressHUD show:@"拼命加载中……"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassfityActivity, _pageCount, @(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.canRefreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodModel *model = [[GoodModel alloc] initWithDictionary:dict];
                [self.showArray addObject:model];
                
            }
            
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView数据,会执行所有tableView的代理方法
        [self.tableView reloadData];
        //根据页面选择的按钮，确定请求的数据
        [self showSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
        //加载失败
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
  
}
- (void)getTourseData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //景点场馆 typeid = 23
    [ProgressHUD show:@"拼命加载中……"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassfityActivity, _pageCount, @(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.canRefreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodModel *model = [[GoodModel alloc] initWithDictionary:dict];
                [self.touristArray addObject:model];
                
            }
            
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView数据,会执行所有tableView的代理方法
        [self.tableView reloadData];
        //根据页面选择的按钮，确定请求的数据
        [self showSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
        //加载失败
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
  
}
- (void)getStudyData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //学习益智 typeid = 22
    [ProgressHUD show:@"拼命加载中……"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassfityActivity, _pageCount, @(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.canRefreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodModel *model = [[GoodModel alloc] initWithDictionary:dict];
                [self.studyArray addObject:model];
                
               
            }
            
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView数据,会执行所有tableView的代理方法
        [self.tableView reloadData];
        //根据页面选择的按钮，确定请求的数据
        [self showSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
        //加载失败
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
   
}
- (void)getFamilyData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //亲子旅游   typeid = 21
    [ProgressHUD show:@"拼命加载中……"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassfityActivity, _pageCount, @(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.canRefreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodModel *model = [[GoodModel alloc] initWithDictionary:dict];
                [self.familyArray addObject:model];
                
            }
            
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView数据,会执行所有tableView的代理方法
        [self.tableView reloadData];
        //根据页面选择的按钮，确定请求的数据
        [self showSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
        //加载失败
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
   
}

//点击上一页按钮，请求响应的数据
- (void)showSelectButton{
    if (self.canRefreshing) {  //下拉删除原来数据
    if (self.showDataArray > 0) {
        [self.showDataArray removeAllObjects];
    }
    }
        switch (self.classfityType) {
            case ClassfityListTypeShowRepertoire:
            {
                self.showDataArray = self.showArray;
            }
                break;
            case ClassfityListTypeToursePlace:
            {
                self.showDataArray = self.touristArray;
            }
                break;
            case ClassfityListTypeStudyPUZ:
            {
                self.showDataArray = self.studyArray;
                
            }
                break;
            case ClassfityListTypeFamilyTravel:
            {
                self.showDataArray = self.familyArray;
                
            }
                break;
    }
    [self.tableView reloadData];
    
}

//手指开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}

//手指结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}

#pragma mark ----- tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GoodModel *model = self.showDataArray[indexPath.row];
    cell.goodModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}
//单元格选中方法，下一页
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [storyBoard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    GoodModel *model = self.showDataArray[indexPath.row];
    activityVC.actiID = model.activityID;
    [self.navigationController pushViewController:activityVC animated:YES];
    
}

#pragma mark ---- LazyingLoad
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(5, 40, kWidth - 10, kHeight - 120) pullingDelegate:self];
        self.tableView.rowHeight = 130;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

//导航栏按钮实现方法
- (void)searchAction:(UIBarButtonItem *)bar{
    
}
- (void)rightListAction:(UIBarButtonItem *)batBtton{
    
    
}

#pragma mark ---------- LazyingLoad
- (NSMutableArray *)showArray{
    if (!_showArray) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}
- (NSMutableArray *)showDataArray{
    if (!_showDataArray) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}
- (NSMutableArray *)familyArray{
    if (!_familyArray) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}
- (NSMutableArray *)touristArray{
    if (!_touristArray) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}
- (NSMutableArray *)studyArray{
    if (!_studyArray) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}
- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"}, @{VOSegmentText:@"景点场馆"}, @{VOSegmentText:@"学习益智"}, @{VOSegmentText:@"亲子旅游"}]];
        self.VOsegment.contentStyle = VOContentStyleTextAlone;
        self.VOsegment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.VOsegment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.VOsegment.selectedBackgroundColor = self.VOsegment.backgroundColor;
        self.VOsegment.allowNoSelection = NO;
        self.VOsegment.frame = CGRectMake(0, 0, kWidth, 40);
        self.VOsegment.indicatorThickness = 4;
        [self.view addSubview:self.VOsegment];
        self.VOsegment.selectedSegmentIndex = self.classfityType - 1;
        //返回点击的是哪个按钮
        [self.VOsegment setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"1: block --> %@", @(index));
        }];
        [self.VOsegment addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _VOsegment;
}

#pragma mark ----- UISegmentedControl点击事件
- (void)segmentCtrlValuechange:(UISegmentedControl *)segment{
    self.classfityType = segment.selectedSegmentIndex + 1;
    //调用请求网络的方法
    [self chooseRequest];
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
