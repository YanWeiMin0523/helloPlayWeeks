//
//  HeaderCollectionView.h
//  helloPlayWeeks
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HeaderCollectionView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloactionBtn;

@property(nonatomic, copy) NSString *checkCityName;

@end
