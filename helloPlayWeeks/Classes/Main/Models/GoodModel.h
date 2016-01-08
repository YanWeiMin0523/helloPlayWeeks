//
//  GoodModel.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : NSObject

@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *counts;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *activityID;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *type;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
