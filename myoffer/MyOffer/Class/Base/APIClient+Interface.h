//
//  APIClient+Interface.h
//  MyOffer
//
//  Created by Blankwonder on 6/8/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "APIClient.h"

#define kAPISelectorHomepage @"GET api/app/mobile"
//学校详情
#define kAPISelectorUniversityInfo @"GET api/university/:id"
//请求推荐数据
#define kAPISelectorSearchRecommand @"GET api/app/hotSearch"
//请求历史数据
#define kAPISelectorhistorySearch @"GET api/account/searchhistory"
//判断是否有智能匹配数据或收藏学校
#define kAPISelectorRequestCenter @"GET api/account/mycount"
//搜索接口
#define kAPISelectorSearch @"POST api/v2/app/search"
//收藏院校
#define kAPISelectorFavorites @"GET api/account/favorites"
//热门院校
#define kAPISelectorHotUniversity @"GET api/university/hot"
//专业数据
#define kAPISelectorSubjects @"GET docs/:lang/subjects.json"
//专业数据
#define kAPISelectorSubjects_new @"GET api/subject/areas"
//年级数据
#define kAPISelectorGrades @"GET docs/:lang/grades.json"
//国家数据
#define kAPISelectorCountries @"GET docs/:lang/countries.json"
//发送验证码
#define kAPISelectorSendVerifyCode @"POST api/vcode"
//用户注册
#define kAPISelectorRegister @"POST api/account/register"
//用户登录
#define kAPISelectorLogin @"POST api/account/login"
//用户退出登录
#define kAPISelectorLogout @"GET api/account/logout"
//手机绑定
#define kAPISelectorBind @"POST api/account/bind"
// 直接创建新用户登录
#define kAPISelectorNewAndLogin @"POST api/account/oauth/newandlogin"
//请求用户信息
#define kAPISelectorAccountInfo @"GET api/account/accountinfo"
//修改用户密码
#define kAPISelectorUpdateAccountInfo @"POST api/account/accountinfo"
//申请意向
#define kAPISelectorUpdateApplyResult @"POST api/account/unapply"
//重置密码
#define kAPISelectorResetPassword @"POST api/account/resetpassword"
#define kAPISelectorEvaluate @"GET api/account/evaluate/:id"
//查看是否有新消息、通知等
#define kAPISelectorCheckNews @"GET api/account/message/hasnew?client=app"

#define kAPISelectorUserLanguage @"POST api/account/prefer/language"
//审核状态
#define kAPISelectorApplicationStatus @"GET api/account/applicationliststateraw"
//申请意向列表
#define kAPISelectorApplicationList @"GET api/account/applies"
//我要留学
#define kAPISelectorWoYaoLiuXue @"POST api/fastpass"
//热门留学城市
#define kAPISelectorCatigoryHotCities @"GET api/hotcities"
//留学资讯
#define kAPISelectorMessageDetail @"GET api/article/"
//留学资讯推荐
#define kAPISelectorArticleRecommendation @"GET api/article/recommendations"
//留学资讯
#define kAPISelectorArticleCategory @"GET api/article/search?"
//资讯详情
#define kAPISelectorArticleDetail @"GET api/v2/article/"
//留学攻略
#define kAPISelectorGonglueList @"GET http://public.myoffer.cn/docs/zh-cn/tips.json"
//学校详情
#define kAPISelectorUniversityDetail @"GET api/v2/university/"
//取消收藏
#define kAPISelectorUniversityUnfavorited @"GET api/account/unFavorite/:id"
//收藏
#define kAPISelectorUniversityfavorited @"GET api/account/favorite/:id"



