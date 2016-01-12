//
//  hotModel.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotModel : NSObject

@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *themeID;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
