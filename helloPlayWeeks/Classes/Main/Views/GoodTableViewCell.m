//
//  GoodTableViewCell.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GoodTableViewCell.h"
#import "GoodModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *ageBgImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation GoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kWidth, 90);
    
}

- (void)setGoodModel:(GoodModel *)goodModel{
    NSLog(@"%@",goodModel.title);
    
    self.titleLabel.text = goodModel.title;
    self.priceLabel.text = goodModel.price;
    self.ageLabel.text = goodModel.age;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
