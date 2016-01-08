//
//  GoodModel.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.age = dict[@"age"];
        self.price = dict[@"price"];
        self.type = dict[@"type"];
        self.activityID = dict[@"id"];
        self.address = dict[@"address"];
        self.counts = dict[@"counts"];
        
    }
    return self;
}


@end
