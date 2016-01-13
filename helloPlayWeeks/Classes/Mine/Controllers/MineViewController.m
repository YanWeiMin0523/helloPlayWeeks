//
//  MineViewController.m
//  helloPlayWeeks
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *headButton;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) UILabel *nameLabel;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
   
    //cell
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"用户反馈", @"给我评分", @"分享好友", @"当前版本1.0", nil];
    self.imageArray = @[@"btn_order_wait", @"btn_recommend", @"ac_details_recommed_img", @"btn_share_selected", @"home"];
    [self setupHeadImage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //每当页面将要出现的时候计算图片缓存
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.02fM)", (float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark ----------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
//            YWMLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]);
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            //清除缓存
            [imageCache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark ------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndex = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndex];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    

 
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

#pragma mark --------- Custom Method
- (void)setupHeadImage{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    headView.backgroundColor = MainColor;
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.headButton];
    [headView addSubview:self.nameLabel];
    
}

- (void)headAction:(UIButton *)btn{
    
    
    
    
}

#pragma mark -------- lazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 120) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
        
    }
    return _tableView;
}

- (UIButton *)headButton{
    if (!_headButton) {
        self.headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headButton.frame = CGRectMake(20, 20, 120, 120);
        self.headButton.layer.cornerRadius = 60;
        self.headButton.clipsToBounds = YES;
        [self.headButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [self.headButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.headButton.backgroundColor = [UIColor whiteColor];
        [self.headButton addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headButton;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, kWidth - 200, 40)];
        self.nameLabel.text = @"欢迎畅享周末 开始你的周末之旅吧!";
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
