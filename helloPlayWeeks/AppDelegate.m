//
//  AppDelegate.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MineViewController.h"
#import "DiscoverViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
//定位1：引入定位所需的框架
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate, CLLocationManagerDelegate>
{
    //定位2：创建定位对象
    CLLocationManager *_locationManager;
    //地理编码
    CLGeocoder *_geocoder;
}
@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //3.初始化定位对象
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    //4.判断定位服务器是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        YWMLog(@"定位服务可能未打开");
    }
    //5.如果没有授权请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //5.1设置代理
        _locationManager.delegate = self;
        //5.2设置定位精度,定位精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //5.3定位频率，每隔多少米定位依次
        CLLocationDistance distance = 100.0;
        _locationManager.distanceFilter = distance;
        //5.4启动定位
        [_locationManager startUpdatingLocation];
        
    }
    
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    //注册BmobKey
    [Bmob registerWithAppKey:kBmobKey];
    
    
    
    //UITabBarCOntroller
    self.tabBarVC = [[UITabBarController alloc] init];
    //创建被tabBar管理的视图控制器
    //主页
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainStory.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    UIImage *mainImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    //选中的图片,按照原始图片状态显示
    mainNav.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //调整tabBar图片显示位置：按照上，左，下，右设置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //发现
    UIStoryboard *discoverStory= [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverStory.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
    UIImage *discoverImage = [UIImage imageNamed:@"ft_found_selected_ic"];
    //选中的图片
    discoverNav.tabBarItem.selectedImage = [discoverImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //我的
    UIStoryboard *mineStory= [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *mineNav = mineStory.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    UIImage *mineImage = [UIImage imageNamed:@"ft_person_selected_ic"];
    //选中的图片
    mineNav.tabBarItem.selectedImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图片位置
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //添加被管理的视图控制器
    self.tabBarVC.viewControllers = @[mainNav, discoverNav, mineNav];
    //设置tabBar导航栏的颜色
    self.tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    
    
    self.window.rootViewController = self.tabBarVC;
    
    //向微信注册
    [WXApi registerApp:kWeixinKey];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark ----- 微博方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"恭喜您，分享成功!", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    
}


#pragma mark ---------- CLLocationManagerDelegate
/*
 定位协议方法
 1.manager: 当前使用的定位对象
 2.Locations:  返回定位的数据，是一个数组对象，数组里面元素是CLLocation类型
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //从数组中取出一个定位信息
    //取出第一个位置
    CLLocation *firstLocation = [locations firstObject];
    //获取坐标
    //CLLocationCoordinate2D坐标系，里面包含经度和纬度
    CLLocationCoordinate2D coordinate = firstLocation.coordinate;
//    YWMLog(@"经度：%f  维度：%f 海拔：%f 航向：%f行走速度：%f", coordinate.longitude, coordinate.latitude, firstLocation.altitude,firstLocation.course,firstLocation.speed);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    [defaults setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    
    //获取经纬度，经过饭地理编码得到具体地址
    [_geocoder reverseGeocodeLocation:firstLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        [[NSUserDefaults standardUserDefaults] setValue:placeMark.addressDictionary[@"city"] forKey:@"city"];
        //保存
        [defaults synchronize];
        
    }];
    //如果不需要实时定位，使用完即关闭定位服务
    [_locationManager stopUpdatingLocation];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
