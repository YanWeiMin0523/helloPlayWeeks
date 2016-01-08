//
//  ClsaafityViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ClsaafityViewController.h"

@interface ClsaafityViewController ()

@end

@implementation ClsaafityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分类列表";
    
    UISegmentedControl *segement = [[UISegmentedControl alloc] initWithItems:@[@"演出剧目", @"景点场馆", @"学习益智", @"亲子旅游"]];
    segement.tintColor = [UIColor orangeColor];
    segement.frame = CGRectMake(10, 70, kWidth - 20, 40);
    [self.view addSubview:segement];
    
    
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
