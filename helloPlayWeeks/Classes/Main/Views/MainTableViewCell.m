//
//  MainTableViewCell.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
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
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
