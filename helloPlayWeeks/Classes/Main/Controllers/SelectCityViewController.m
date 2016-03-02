//
//  SelectCityViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "SelectCityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HeaderCollectionView.h"
#import <CoreLocation/CoreLocation.h>
static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headerIdentifier = @"headerIndentifier";

@interface SelectCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>
{
    CLLocationManager *_manager;
    CLGeocoder *_geocoder;
}

@property(nonatomic, strong) NSMutableArray *allCityArray;
@property(nonatomic, strong) UICollectionView *collectView;
@property(nonatomic, strong) NSMutableArray *cityIDArray;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择城市";
    [self showBackButtonWithImage:@"camera_cancel_up"];
    self.navigationController.navigationBar.barTintColor = MainColor;
    //设置导航栏字体颜色和字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectView];
    //城市网络请求
    [self selectCityRequest];
   
    
    
}

#pragma mark --------- UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allCityArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.alpha = 0.3;
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:cell.frame];
    cellLabel.text = self.allCityArray[indexPath.row];
    cellLabel.textAlignment = NSTextAlignmentCenter;
    [self.collectView addSubview:cellLabel];
    
    return cell;
}

//cell的点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCityName:cityID:)]) {
        [self.delegate getCityName:self.allCityArray[indexPath.row] cityID:self.cityIDArray[indexPath.row]];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//返回头部视图,如果也有尾部，需要判断(kind)
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    //重新定位
    [headerView.reloactionBtn addTarget:self action:@selector(reloactionAction:) forControlEvents:UIControlEventTouchUpInside];
    //当前定位城市
    NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:@"city"];
    //字符窜截取
    headerView.cityLabel.text = [city substringToIndex:city.length - 1];
    
    return headerView;
}


//网络请求
- (void)selectCityRequest{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [httpManager GET:kSelectCity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *successDic = responseObject;
        NSInteger code = [successDic[@"code"] integerValue];
        NSString *status = successDic[@"status"];
        if ([status isEqualToString:@"success"] && code == 0 ) {
            NSDictionary *dic = successDic[@"success"];
            NSArray *listArray = dic[@"list"];
            for (NSDictionary *dict in listArray) {
                [self.cityIDArray addObject:dict[@"cat_id"]];
                [self.allCityArray addObject:dict[@"cat_name"]];
                
            }
            [self.collectView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
    }];
    
    
}

#pragma mark ------------- 重新定位
//重新定位btn点击事件
- (void)reloactionAction:(UIButton *)btn{
    _manager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    _manager.distanceFilter = distance;
    [_manager startUpdatingLocation];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *firstLoaction = [locations firstObject];
    CLLocationCoordinate2D coordinate = firstLoaction.coordinate;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    [defaults setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    
    //获取经纬度，经过饭地理编码得到具体地址
    [_geocoder reverseGeocodeLocation:firstLoaction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        [[NSUserDefaults standardUserDefaults] setValue:placeMark.addressDictionary[@"city"] forKey:@"city"];
        //保存
        [defaults synchronize];
    }];
    [_manager stopUpdatingLocation];
}

#pragma mark ---------- lazyLoading
- (UICollectionView *)collectView{
    if (!_collectView) {
//创建一个UICollectionViewFlowLayout（一个cells的线性布局方案）的类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向(默认垂直方向)
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每一个item的大小
        flowLayout.itemSize = CGSizeMake(100, kWidth / 9);
        //设置collection区头的大小
        flowLayout.headerReferenceSize = CGSizeMake(kWidth, 145);
        //设置item的间距
        flowLayout.minimumInteritemSpacing = 1;
        //设置每一行的间距
        flowLayout.minimumLineSpacing = 10;
        //设置边距
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //通过一个layout布局来创建一个collectionView
        self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 5) collectionViewLayout:flowLayout];
        //设置代理
        self.collectView.delegate = self;
        self.collectView.dataSource = self;
        //注册item类型
        [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        self.collectView.backgroundColor = [UIColor whiteColor];
        //取消滑动条
        self.collectView.showsVerticalScrollIndicator = NO;
        //注册头部
        
        [self.collectView registerNib:[UINib nibWithNibName:@"HeaderCollectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectView;
}

- (NSMutableArray *)allCityArray{
    if (!_allCityArray) {
        self.allCityArray = [NSMutableArray new];
    }
    return _allCityArray;
}

- (NSMutableArray *)cityIDArray{
    if (!_cityIDArray) {
        self.cityIDArray = [NSMutableArray new];
    }
    return _cityIDArray;
}


- (void)leftBarBtnAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
