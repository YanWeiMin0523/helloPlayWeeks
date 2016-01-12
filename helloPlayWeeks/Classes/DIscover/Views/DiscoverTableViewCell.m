//
//  DiscoverTableViewCell.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DiscoverTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDiscoverModel:(DiscoverModel *)discoverModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:discoverModel.image] placeholderImage:nil];
    self.headImage.layer.cornerRadius = 20;
    self.headImage.clipsToBounds = YES;
    self.titleLabel.text = discoverModel.title;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
