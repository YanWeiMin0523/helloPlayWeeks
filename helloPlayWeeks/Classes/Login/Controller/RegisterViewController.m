//
//  RegisterViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/3/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *againPassText;
@property (weak, nonatomic) IBOutlet UISwitch *switchPass;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    //密码密文
    self.passwordText.secureTextEntry = YES;
    self.againPassText.secureTextEntry = YES;
    //默认switch关闭,密码不显示
    self.switchPass.on = NO;

}
//密码是否铭文
- (IBAction)checkPass:(id)sender {
    UISwitch *passSwitch = sender;
    if (passSwitch.on) {
        //密码密文
        self.passwordText.secureTextEntry = NO;
        self.againPassText.secureTextEntry = NO;
    }else{
        //密码明文
        self.passwordText.secureTextEntry = YES;
        self.againPassText.secureTextEntry = YES;

    }
}
//注册
- (IBAction)registerBtn:(id)sender {
    if (![self checkUserPassword]) {
        return;
    }
    [ProgressHUD show:@"正在注册...."];
    BmobUser *bmUser = [[BmobUser alloc] init];
    [bmUser setUsername:self.userText.text];
    [bmUser setPassword:self.passwordText.text];
    [bmUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
            YWMLog(@"注册成功");
        }else{
            [ProgressHUD showError:@"注册失败"];
            YWMLog(@"%@", error);
        }
    }];
    
}
//判断
- (BOOL)checkUserPassword{
    //用户名不能为空
    if (self.userText.text.length <= 0 || [self.userText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名为空或格式不正确" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }];
        
        [alert addAction:alertAction];
        [alert addAction:alertSure];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    //两次输入密码一致
    if (![self.passwordText.text isEqualToString:self.againPassText.text]) {
        //提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不一致,请核对" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:alertAction];
        [alert addAction:alertSure];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    //判断密码不能为空
    if (self.passwordText.text <= 0 || [self.passwordText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码为空或格式不正确" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:alertAction];
        [alert addAction:alertSure];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    //判断手机号是有效的（正则表达式）
    
    //判断邮箱是否正确
   
    return YES;
}

//点击return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击空白处回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
