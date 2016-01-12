//
//  DiscoverModel.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

- (instancetype)initWithGetDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.type = dict[@"type"];
        self.activityID = dict[@"id"];
        self.shareImage = dict[@"shareimage"];
        
    }
    return self;
}

@end
