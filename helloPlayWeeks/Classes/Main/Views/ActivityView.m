//
//  ActivityView.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ActivityView.h"
#import "playWeeks.pch"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityView ()
{
    CGFloat _previonsImageBottom;  //保存上一次图片底部的高度
    CGFloat _lastLabelBottom;  //最后一个label底部的高度
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favourLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollerView;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPhoneLAbel;



@end

@implementation ActivityView

- (void)awakeFromNib{
    self.mainScrollerView.contentSize =CGSizeMake(kWidth, kHeight * 8);
}


//在set方法中赋值
- (void)setDateDic:(NSDictionary *)dateDic{
    //活动图片
    NSArray *urls = dateDic[@"urls"];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    //活动标题
    self.activityLabel.text = dateDic[@"title"];
    //活动电话和地址
    self.activityPhoneLAbel.text = dateDic[@"tel"];
    self.activityAddressLabel.text = dateDic[@"address"];
    //活动简介
    self.priceLabel.text = dateDic[@"pricedesc"];
    self.priceLabel.numberOfLines = 0;
    //活动有多少人喜欢
    self.favourLabel.text = [NSString stringWithFormat:@"%@人已喜欢", dateDic[@"fav"]];
    //活动起止时间
    NSString *new_end_time = [HWTools getDateFromString:dateDic[@"new_end_time"]] ;
    NSString *new_start_time = [HWTools getDateFromString:dateDic[@"new_start_time"]];
    self.timeLabel.text = [NSString stringWithFormat:@"正在进行：%@-%@", new_start_time, new_end_time];
    
    //活动详情
    [self drawContentWithArray:dateDic[@"content"]];
}

- (void)drawContentWithArray:(NSArray *)array{
      for (NSDictionary *dic in array) {
        //获取文本
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kWidth, 1000) Font:15.0];
          CGFloat y;
          if (_previonsImageBottom > 500) {
              //当第一个活动详情显示，label先从保留的图片底部的坐标开始
              y = 520 + _previonsImageBottom - 520;
          }else{
              //当第二个开始时，要加上上面控件的高度
              y = 520 + _previonsImageBottom;
          }
          //如果标题存在,标题高度应该是上次图片的高度的底部高度
          NSString *title = dic[@"title"];
          if (title !=nil) {
              UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
              titleLabel.text = title;
              [self.mainScrollerView addSubview:titleLabel];
              y += 30;   //下边显示详细信息的时候，高度坐标再加30即标题的高度
          }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, kWidth- 10, height)];
        label.text = dic[@"description"];
        label.font = [UIFont systemFontOfSize:15.0];
        label.numberOfLines = 0;
        [self.mainScrollerView addSubview:label];
        //保留最后一个label的高度
          _lastLabelBottom = label.bottom + 10 + 64;
          
        NSArray *urlArray = dic[@"urls"];
          //当某一段落没有图片的时候，上次图片的高度用上次label的高度+10
          if (urlArray == nil) {
              _previonsImageBottom = label.bottom + 10;
          }else{
        CGFloat lastImageBootm = 0.0;
        for (NSDictionary *urlDic in urlArray) {
            CGFloat imageY;
            if (urlArray.count > 1) {
                //图片不止一张
                if (lastImageBootm == 0.0) {
                if (title != nil) {
                    //有title的加上title的label高度
                    imageY = _previonsImageBottom + label.height + 30 + 5;
                }else{
                    imageY = _previonsImageBottom + label.height + 5;
                }
            }else{
                imageY = lastImageBootm + 10;
            }
            }else{
            //图片单张的情况
            imageY = label.bottom;
            }
            CGFloat width = [urlDic[@"width"] integerValue];
            CGFloat imageHeight = [urlDic[@"height"] integerValue];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, imageY, kWidth - 10, (kWidth - 10) / width * imageHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
            //每一次都保留图片底部的高度
            _previonsImageBottom = imageView.bottom + 5;
            [self.mainScrollerView addSubview:imageView];
            if (urlArray.count > 1) {
                lastImageBootm = imageView.bottom;
            }
           
        }
          }
      }
    if (_lastLabelBottom > _previonsImageBottom) {
         self.mainScrollerView.contentSize = CGSizeMake(kWidth, _lastLabelBottom + 30);
    }
    //重新设置scrollView的可滚动高度
    self.mainScrollerView.contentSize = CGSizeMake(kWidth, _previonsImageBottom + 30);

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
