//
//  MainViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MainViewController.h"
#import "playWeeks.pch"
#import "MainTableViewCell.h"
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClsaafityViewController.h"
#import "GoodThemeViewController.h"
#import "HotViewController.h"
@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
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
//定时器用于图片滚动
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
//    [self requstModel];
    
    [self configTableViewHiderView];
    
    //加入定时器
    [self startTimer];
    
    
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
     MainModel *model = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *activityStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityDetailViewController *activityVC = [activityStory instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
         //活动id
       
        activityVC.activityID = model.activityID;
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        themeVC.themeID = model.activityID;
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
    
    //轮播图片
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 186)];
        [scrollImage sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        self.scrollView.delegate = self;
        //打开用户交互
        scrollImage.userInteractionEnabled = YES;
        [self.scrollView addSubview:scrollImage];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = scrollImage.frame;
        touchBtn.tag = 1+i;
        [touchBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:touchBtn];
        
    }
    
    //小圆点
    self.pageControl.numberOfPages = self.adArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    //将轮播图添加到tableViewHeader上
    [tableViewHeader addSubview:self.scrollView];
    [tableViewHeader addSubview:self.pageControl];
    
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth / 4 * i, 186, kWidth / 4, kWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d", i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 1 + i;
        [btn addTarget:self action:@selector(mainActivityAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeader addSubview:btn];

    }
    //精选活动&热门专题
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth / 2 * i, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_%02d", i];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainGoodActivityAction:) forControlEvents:UIControlEventTouchUpInside];
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
                
                NSDictionary *dic = @{@"url":dict[@"url"], @"type":dict[@"type"], @"id":dict[@"id"]};
                [self.adArray addObject:dic];
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

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        //轮播图
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
        self.scrollView.contentSize = CGSizeMake(kWidth * self.adArray.count, 0);
        //图片整张滑动
        self.scrollView.pagingEnabled = YES;
        //不显示水平滑动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        //************* self.pageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 186-30, kWidth - 200, 30)];
        [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
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

//点击轮播图实现广告
- (void)touchAction:(UIButton *)btn{
    //从数组中的字典去吃type类型
    NSString *type = self.adArray[btn.tag - 1][@"type"];
    if ([type integerValue] == 1) {
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStory instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
        //controller产值
        activityVC.activityID = self.adArray[btn.tag - 1][@"id"];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        themeVC.themeID = self.adArray[btn.tag - 1][@"id"];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}

#pragma mark ------ 轮播图
- (void)startTimer{
    //防止定时器重复创建
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//定时器方法 每一秒执行一次，图片自动轮播
- (void)timerAction:(NSTimer *)timer{
    //把page当前页加1
    //self.adArray.count数组元素个诉可能为0，打不过对0取余的时候无意义
    if (self.adArray.count > 0) {
    NSInteger rollPage = (self.pageControl.currentPage+ 1)% self.adArray.count;
    self.pageControl.currentPage = rollPage;
    //计算scrollView应该滚动x轴坐标
    CGFloat offset = _pageControl.currentPage * kWidth;
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

//当手动去滑动scrollView的时候，定时器依然在计算时间，可能我们刚刚滑动到下一页，定时器有刚好触发，导致当前页停留不到2秒
//解决方案：在scrollView开始移动的时候结束定时器，在scrollView移动完毕在启动定时器


/*
 scrollView将要开始拖拽
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //定时器停止
    [self.timer invalidate];
    _timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //定时器启动
    [self.timer isValid];
}

//四个小按钮方法
- (void)mainActivityAction:(UIButton *)btn{
    ClsaafityViewController *classfityVC = [[ClsaafityViewController alloc] init];
    [self.navigationController pushViewController:classfityVC animated:YES];

    
}
//精选活动&热门专题
- (void)mainGoodActivityAction:(UIButton *)button{
    if (button.tag == 100) {
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


//在堆栈中再次调用以前页面时，调用次方法
- (void)viewWillAppear:(BOOL)animated{
    [self viewDidAppear:YES];
    //取消隐藏tabBar
    self.tabBarController.tabBar.hidden = NO;
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
