//
//  ShareView.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <MessageUI/MessageUI.h>
@interface ShareView ()<WXApiDelegate, WBHttpRequestDelegate>
@property(nonatomic, strong) UIView *shareView;
@property(nonatomic, strong) UIView *blackView;

@end

@implementation ShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configShareView];
    }
    return self;
}

- (void)configShareView{
    UIWindow *widndow = [[UIApplication sharedApplication].delegate window];
    
    //底部
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 200)];
    self.blackView.alpha = 0.0;
    self.blackView.backgroundColor = [UIColor blackColor];
    [widndow addSubview:self.blackView];
    
    //底部弹出
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 250, kWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [widndow addSubview:self.shareView];
    //微博button
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(20, 20, 80, 80);
    [weiboBtn setImage:[UIImage imageNamed:@"ic_button_focused"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    weiboBtn.tag = 1;
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    weiboLabel.text = @"微博好友";
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weiboBtn];
    [self.shareView addSubview:weiboLabel];
    
    //朋友圈button
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(140, 20, 80, 80);
    [friendBtn setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    friendBtn.tag = 2;
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 100, 80, 30)];
    friendLabel.text = @"朋友圈";
    friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:friendLabel];
    [self.shareView addSubview:friendBtn];
    //微信
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(260, 20, 80, 80);
    [weixinBtn setImage:[UIImage imageNamed:@"icon_pay_weixin"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    weixinBtn.tag = 3;
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 100, 80, 30)];
    weixinLabel.text = @"微信好友";
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weixinLabel];
    [self.shareView addSubview:weixinBtn];
    
    //清除
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    removeBtn.frame = CGRectMake(20, 150, kWidth - 40, 30);
    removeBtn.backgroundColor = [UIColor redColor];
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.frame = CGRectMake(0, kHeight - 200, kWidth, 200);
    }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0 animations:^{
                             self.blackView.alpha = 0.8;
                         }];
                     }];
    
}


//取消按钮，取消当前小视图
- (void)removeAction{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.shareView.alpha = 0.0;
        self.shareView.frame = CGRectMake(0, kHeight - 250, kWidth, 200);
    }completion:^(BOOL finished) {
        [self.shareView removeAllSubviews];
        [self.blackView removeAllSubviews];
    }];
}

//分享到微博 朋友圈，微信
- (void)shareAction:(UIButton *)button{
    switch (button.tag) {
        case 1:
        {
            AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            WBAuthorizeRequest *authRequest =[WBAuthorizeRequest request];
            authRequest.redirectURI = kRedirectURI;
            authRequest.scope = @"all";
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
            
            [WeiboSDK sendRequest:request];
            [self removeAction];
        }
            break;
            case 2:
        {
            //分享微信朋友圈
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.text = @"好的应用平台，好的开始；好的心情，好的追求";
            req.bText = YES;
            req.scene = WXSceneTimeline;
            [WXApi sendReq:req];
        }
            break;
       
        case 3:
        {
            //分享微信朋友
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.text = @"好的应用平台，好的开始；好的心情，好的追求";
            req.bText = YES;
            //默认分享会话
            req.scene = WXSceneSession;
            [WXApi sendReq:req];
        }
            break;

    }
    
    
    
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    //文字
    message.text = NSLocalizedString(@"测试开始!", nil);
    //图片
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"7" ofType:@"png"]];
    message.imageObject = image;
   
    return message;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
