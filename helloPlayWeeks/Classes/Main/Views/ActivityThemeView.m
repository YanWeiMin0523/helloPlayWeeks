//
//  ActivityThemeView.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ActivityThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityThemeView ()
{
    CGFloat _previonsImageBottom;  //保存上一次图片底部的高度
    CGFloat _lastLabelBottom;  //最后一个label底部的高度
}
@property(nonatomic, strong) UIImageView *headerImage;
@property(nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation ActivityThemeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}


- (void)configView{
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headerImage];
    
    
}

#pragma mark ----- 懒加载
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.mainScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _mainScrollView;
}

- (UIImageView *)headerImage{
    if (!_headerImage) {
        self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, kWidth - 10, 186)];
    }
    return _headerImage;
}


//set方法赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    
    [self drawContentWithArray:dataDic[@"content"]];

}

- (void)drawContentWithArray:(NSArray *)array{
    for (NSDictionary *dic in array) {
        //获取文本
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kWidth, 1000) Font:15.0];
        CGFloat y;
        if (_previonsImageBottom > 18) {
            //当第一个活动详情显示，label先从保留的图片底部的坐标开始
            y = 186 + _previonsImageBottom - 186;
        }else{
            //当第二个开始时，要加上上面控件的高度
            y = 186 + _previonsImageBottom;
        }
        //如果标题存在,标题高度应该是上次图片的高度的底部高度
        NSString *title = dic[@"title"];
        if (title !=nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            y += 30;   //下边显示详细信息的时候，高度坐标再加30即标题的高度
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, kWidth- 10, height)];
        label.text = dic[@"description"];
        label.font = [UIFont systemFontOfSize:15.0];
        label.numberOfLines = 0;
        [self.mainScrollView addSubview:label];
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
                            imageY = _previonsImageBottom + label.height + 30 + 10;
                        }else{
                            imageY = _previonsImageBottom + label.height + 10;
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
                _previonsImageBottom = imageView.bottom + 10;
                [self.mainScrollView addSubview:imageView];
                if (urlArray.count > 1) {
                    lastImageBootm = imageView.bottom;
                        
                    }
                }
            }
        }
    if (_lastLabelBottom > _previonsImageBottom) {
        //重新设置scrollView的可滚动高度
        self.mainScrollView.contentSize = CGSizeMake(kWidth, _lastLabelBottom);

    }else{
        //重新设置scrollView的可滚动高度
        self.mainScrollView.contentSize = CGSizeMake(kWidth, _previonsImageBottom);

    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
