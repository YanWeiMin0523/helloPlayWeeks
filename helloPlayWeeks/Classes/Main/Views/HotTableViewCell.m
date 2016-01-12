//
//  HotTableViewCell.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@end

@implementation HotTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(hotModel *)model{
    [self.hotImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    self.hotImageView.layer.cornerRadius = 50;
    self.hotImageView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
