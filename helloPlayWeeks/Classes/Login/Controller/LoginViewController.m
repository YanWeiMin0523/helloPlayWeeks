//
//  LoginViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
@interface LoginViewController ()
- (IBAction)AddData:(id)sender;
- (IBAction)ModeData:(id)sender;
- (IBAction)DeledeData:(id)sender;
- (IBAction)SelectData:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton];

    
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

//添加数据
- (IBAction)AddData:(id)sender {
    //往User表添加一条数据
    BmobObject *user = [BmobObject objectWithClassName:@"MemberUser"];
    [user setObject:@"闫卫敏" forKey:@"user_Name"];
    [user setObject:@19 forKey:@"user_Age"];
    [user setObject:@"女" forKey:@"user_Gender"];
    [user setObject:@"18860233196" forKey:@"user_PhoneNumber"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        YWMLog(@"注册成功！");
    }];
}
//更改数据
- (IBAction)ModeData:(id)sender {
    //查找user表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找user表里面id为55d588a3c8的数据
    [bquery getObjectInBackgroundWithId:@"55d588a3c8" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置电话为YES
                [obj1 setObject:@"18860233255" forKey:@"user_PhoneNumber"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];
    
}
//删除数据
- (IBAction)DeledeData:(id)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    [bquery getObjectInBackgroundWithId:@"f7448a9991" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
        }
    }];
}
//查找数据
- (IBAction)SelectData:(id)sender {
    //查找MemberUser表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"cdd1759956" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到userName和cheatMode
                NSString *userName = [object objectForKey:@"user_Name"];
                NSString *userPhone = [object objectForKey:@"user_PhoneNumber"];
                NSLog(@"%@----%@",userName,userPhone);
            }
        }
    }];
}
@end
