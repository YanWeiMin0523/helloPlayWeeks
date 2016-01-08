//
//  HWTools.h
//  helloPlayWeeks
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "playWeeks.pch"
@interface HWTools : NSObject

#pragma mark ----- 时间转换相关方法
//时间戳
+ (NSString *)getDateFromString:(NSString *)timestamp;
//获取当前系统时间
+ (NSDate *)getSystemNowDate;

#pragma mark ---- 根据文本内容计算返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize Font:(CGFloat)font;



@end
