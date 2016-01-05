//
//  MainModel.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    RecommandTypeActivity = 1,
    RecommandTypeTheme
    
    
}Recommand;

@interface MainModel : NSObject

@property(nonatomic, copy) NSString *address;
//首页大图
@property(nonatomic, copy) NSString *image_big;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *price;
//经纬度
@property(nonatomic, assign) CGFloat lat;
@property(nonatomic, assign) CGFloat lng;
//活动时间
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;

@property(nonatomic, copy) NSString *count;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *activityID;
@property(nonatomic, copy) NSString *activityDescription;

//自定义方法，使用model传值
- (instancetype)initMainWithDictronary:(NSDictionary *)mainDic;

@end
