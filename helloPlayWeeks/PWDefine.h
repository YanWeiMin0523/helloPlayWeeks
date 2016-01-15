//
//  PWDefine.h
//  helloPlayWeeks
//  以后把所有的接口都统一放在HWDefine里
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#ifndef PWDefine_h
#define PWDefine_h

typedef NS_ENUM(NSInteger, ClassfityListType){
    ClassfityListTypeShowRepertoire = 1,   //演出剧目
    ClassfityListTypeToursePlace,          //景点场馆
    ClassfityListTypeStudyPUZ,             //学习益智
    ClassfityListTypeFamilyTravel          //亲子旅游
    
};

//首页数据接口
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"

//活动详情接口
#define kActivityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&lat=34.61356779156581&lng=112.4141403843618"
//活动专题接口
#define kActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"
//精选活动
#define kGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&type=1"
//热门专题
#define kHotActivity @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942"
//分类列表接口 //演出剧目 //学习益智 //亲子旅游 //景点场馆
#define kClassfityActivity @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=78284130ab87a8396ec03073eac9c50a&_t_=1452495156&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"
//发现的接口
#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"

//新浪微博分享
#define kAppKey @"1853483581"
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define kAppSecret @"fb5db329af39e183e4e14d11a7c82e03"

//微信分享
#define kWeixinKey @"wx63bad32379646e98"
#define kWeixinAppSecret @"432df58689cb5c87d64426f061645ca5"
#define kBmobKey @"0943f77b82ebeef017937871ceb7060e"

#endif /* PWDefine_h */
