//
//  UIViewController+Common.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

- (void)showBackButton{
    //导航栏左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
}


- (void)leftBarBtnAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
