//
//  hotModel.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "hotModel.h"

@implementation hotModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.img = dict[@"img"];
        self.themeID = dict[@"id"];
    }
    return self; 
}


@end
