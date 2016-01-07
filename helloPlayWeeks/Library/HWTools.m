//
//  HWTools.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools

//时间戳
+ (NSString *)getDateFromString:(NSString *)timestamp{
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setDateFormat:@"yyyy.MM.dd"];
    NSString *timeStr = [dateFromatter stringFromDate:date];
    return timeStr;
}

#pragma mark ---- 根据文本内容计算返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize Font:(CGFloat)font{    
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return textRect.size.height;
}

@end
