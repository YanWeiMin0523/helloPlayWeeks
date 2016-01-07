//
//  ActivityView.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityView ()
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
    self.mainScrollerView.contentSize =CGSizeMake(kWidth, 1000);
}


//在set方法中赋值
- (void)setDateDic:(NSDictionary *)dateDic{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dateDic[@"image"]] placeholderImage:nil];
    self.activityLabel.text = dateDic[@"title"];
    self.activityPhoneLAbel.text = dateDic[@"tel"];
    self.activityAddressLabel.text = dateDic[@"address"];
    self.priceLabel.text = dateDic[@"pricedesc"];
    self.priceLabel.numberOfLines = 0;
    self.favourLabel.text = [NSString stringWithFormat:@"%@人已喜欢", dateDic[@"fav"]];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
