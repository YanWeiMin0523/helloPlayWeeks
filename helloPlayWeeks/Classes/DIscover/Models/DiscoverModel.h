//
//  DiscoverModel.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject

@property(nonatomic, copy) NSString *activityID;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *shareImage;

- (instancetype)initWithGetDictionary:(NSDictionary *)dict;
@end
