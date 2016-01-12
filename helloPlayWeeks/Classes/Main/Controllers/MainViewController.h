//
//  MainViewController.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFURLSessionManager.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface MainViewController : UIViewController<NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate, NSURLSessionDelegate>

@end
