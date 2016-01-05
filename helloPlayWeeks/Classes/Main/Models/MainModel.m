//
//  MainModel.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

//init方法
- (instancetype)initMainWithDictronary:(NSDictionary *)mainDic{
    self = [super init];
    if (self) {
        self.type = mainDic[@"type"];
        //如果是推荐活动
        if ([self.type intValue] == 1) {
            self.endTime = mainDic[@"endTime"];
            self.startTime = mainDic[@"startTime"];
            self.lat = [mainDic[@"lat"] floatValue];
            self.lng = [mainDic[@"lng"] floatValue];
            self.address = mainDic[@"address"];
            self.count = mainDic[@"counts"];
            self.price = mainDic[@"price"];
        }else{
            //如果是推荐专题
            self.activityDescription = mainDic[@"description"];
            
        }
        self.title = mainDic[@"title"];
        self.image_big = mainDic[@"image_big"];
        self.activityID = mainDic[@"id"];
        
    }
    return self;
}





@end
