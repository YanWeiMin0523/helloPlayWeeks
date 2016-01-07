//
//  ActivityView.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UIButton *makeCallBtn;

@property(nonatomic, strong) NSDictionary *dateDic;

@end
