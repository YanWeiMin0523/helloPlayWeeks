//
//  MainViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "playWeeks.pch"
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClsaafityViewController.h"
#import "GoodThemeViewController.h"
#import "HotViewController.h"
@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    int timerCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property(nonatomic, strong) NSMutableArray *listArray;
//推荐专题数据
@property(nonatomic, strong) NSMutableArray *recommandArray;
//推荐活动数据
@property(nonatomic, strong) NSMutableArray *activityArray;
//广告数据
@property(nonatomic, strong) NSMutableArray *adArray;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //导航栏小按钮
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //right
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    
    //请求网络
    [self requstModel];
    
    [self configTableViewHiderView];
    
}


#pragma mark ------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.recommandArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.mainMOdel = array[indexPath.row];
    
    //点击单元格颜色不变
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mainCell;
}


#pragma mark ---------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

//返回分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 25;
}

//自定义分区头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2 - 160, 5, 320, 16)];
    if (section == 0) {
        headerView.image = [UIImage imageNamed:@"home_recommed_ac"];
    }else{
        headerView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    [view addSubview:headerView];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityDetailViewController *activityVC = [[ActivityDetailViewController alloc] init];
        
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        
        [self.navigationController pushViewController:themeVC animated:YES];
        
    }
}

#pragma mark --------  Coustom Method
//选择城市
- (void)selectCityAction:(UIBarButtonItem *)barBtn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    
    
    [self.navigationController presentViewController:selectCityVC animated:YES completion:nil];
}

//搜索按钮
- (void)searchAction:(UIBarButtonItem *)Barbtn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//自定义方法显示tableView自带的区头
- (void)configTableViewHiderView{
  
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 343)];
    self.tableView.tableHeaderView = tableViewHeader;
    
    //轮播图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
    self.scrollView.contentSize = CGSizeMake(kWidth * self.adArray.count, 0);
    //图片整张滑动
    self.scrollView.pagingEnabled = YES;
    //不显示水平滑动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 186)];
        [scrollImage sd_setImageWithURL:[NSURL URLWithString:self.adArray[i]] placeholderImage:nil];
        
        [self.scrollView addSubview:scrollImage];
    }
    [tableViewHeader addSubview:self.scrollView];
    
    //************* self.pageControl
   self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 186-30, kWidth - 200, 30)];
    [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = self.adArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    //加入定时器
    timerCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    
    [tableViewHeader addSubview:self.pageControl];
    
    
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth / 4 * i, 186, kWidth / 4, kWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d", i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 1 + i;
        [btn addTarget:self action:@selector(mainGoodActivityAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeader addSubview:btn];
        
    }
    
    //精选活动&热门专题
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth / 2 * i, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_%02d", i];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 1 + i;
        [btn addTarget:self action:@selector(mainActivityAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeader addSubview:btn];
        
    }
    
    
}

//网络请求数据
- (void)requstModel{
    NSString *urlStr = kMainDataList;
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [manger GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] intValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            
            for (NSDictionary *dict in acDataArray) {
                MainModel *mainModel = [[MainModel alloc] initMainWithDictronary:dict];
                [self.activityArray addObject:mainModel];
                
            }
            [self.listArray addObject:self.activityArray];
            
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc] initMainWithDictronary:dict];
                [self.recommandArray addObject:model];
                
            }
            [self.listArray addObject:self.recommandArray];
            //刷新tableView数据
            [self.tableView reloadData];
            
            //推荐广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dict in adDataArray) {
                [self.adArray addObject:dict[@"url"]];
            }
            //拿到数据之后重新刷新tableView头部数据
            [self configTableViewHiderView];
            
            NSString *cityName = dic[@"cityname"];
            //以请求回来的城市数据修改导航栏左侧的标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            
            
        }else{
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"failure = %@", error);
    }];
    
   
    
}

//轮播图方法
#pragma mark --------- self.scrollView与self.pageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //第一步：获取scrollView的宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //第二部：获取scrollView停止时的偏移量
    CGPoint offset = self.scrollView.contentOffset;
    //第三部：通过偏移量和页面宽度计算当前页面
    NSInteger pageNum = offset.x / pageWidth;
    self.pageControl.currentPage = pageNum;
}


- (void)pageControlAction:(UIPageControl *)page{
    //第一步：获取当前页
    NSInteger pageNum = page.currentPage;
    //第二步：获取scrollView的宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //让scrollView滚动到第几页
    self.scrollView.contentOffset = CGPointMake(pageNum * pageWidth, 0);
    
    
}

- (void)timerAction:(NSTimer *)timer{
    
}

//四个小按钮方法
- (void)mainActivityAction:(UIButton *)btn{
    ClsaafityViewController *classfityVC = [[ClsaafityViewController alloc] init];
    [self.navigationController pushViewController:classfityVC animated:YES];

    
}
//精选活动&热门专题
- (void)mainGoodActivityAction:(UIButton *)btn{
    if (btn.tag == 1) {
        GoodThemeViewController *goodVC = [[GoodThemeViewController alloc] init];
        [self.navigationController pushViewController:goodVC animated:YES];
    }else{
        HotViewController *hotVC = [[HotViewController alloc] init];
        [self.navigationController pushViewController:hotVC animated:YES];
    }
    
}

#pragma martk -----------  懒加载

//懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
        
    }
    return _listArray;
}

- (NSMutableArray *)recommandArray{
    if (!_recommandArray) {
        self.recommandArray = [NSMutableArray new];
    }
    return _recommandArray;
}
- (NSMutableArray *)activityArray{
    if (!_activityArray) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

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
