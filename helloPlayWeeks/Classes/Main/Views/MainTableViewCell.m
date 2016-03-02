//
//  MainTableViewCell.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CLLocation.h>
@interface MainTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;


@end
@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//setter方法赋值
- (void)setMainMOdel:(MainModel *)mainMOdel{
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:mainMOdel.image_big] placeholderImage:nil];
    self.activityNameLabel.text = mainMOdel.title;
    self.priceLabel.text = mainMOdel.price;
    //计算两个经纬度的距离
    double originLat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lat"] doubleValue];
    double originLng = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lng"] doubleValue];
    CLLocation *newDis = [[CLLocation alloc] initWithLatitude:originLat longitude:originLng];
    CLLocation *dis = [[CLLocation alloc] initWithLatitude:mainMOdel.lat longitude:mainMOdel.lng];
    CLLocationDistance distance = [newDis distanceFromLocation:dis] / 1000;
    [self.activityBtn setTitle:[NSString stringWithFormat:@"%.2f", distance] forState:UIControlStateNormal];
    
    
    //隐藏不需要的控件
    if ([mainMOdel.type intValue] == RecommandTypeActivity) {
        self.activityBtn.hidden = NO;
        self.activityNameLabel.hidden = NO;

    }else{
        self.activityBtn.hidden = YES;
        self.activityNameLabel.hidden = YES;
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
