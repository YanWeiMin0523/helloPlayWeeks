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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //UITabBarCOntroller
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
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
    tabBarVC.viewControllers = @[mainNav, discoverNav, mineNav];
    //设置tabBar导航栏的颜色
    tabBarVC.tabBar.barTintColor = [UIColor whiteColor];  
    
    
    self.window.rootViewController = tabBarVC;
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
