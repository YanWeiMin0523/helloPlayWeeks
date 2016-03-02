//
//  SelectCityViewController.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cityNameDelegate <NSObject>

- (void)getCityName:(NSString *)name cityID:(NSString *)cityid;

@end

@interface SelectCityViewController : UIViewController
@property(nonatomic, assign) id<cityNameDelegate>delegate;

@end
