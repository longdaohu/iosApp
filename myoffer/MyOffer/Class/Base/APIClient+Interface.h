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

#define kAPISelectorSearchRecommand @"GET api/app/hotSearch"

#define kAPISelectorhistorySearch @"GET api/account/searchhistory"

#define kAPISelectorRequestCenter @"GET api/account/mycount"
//搜索接口
#define kAPISelectorSearch @"POST api/v2/app/search"
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
#define kAPISelectorSendVerifyCode @"POST api/vcode"
//用户注册
#define kAPISelectorRegister @"POST api/account/register"
//用户登录
#define kAPISelectorLogin @"POST api/account/login"
//用户退出登录
#define kAPISelectorLogout @"GET api/account/logout"
//手机绑定
#define kAPISelectorBind @"POST api/account/bind"

#define kAPISelectorNewAndLogin @"POST api/account/oauth/newandlogin"
//请求用户信息
#define kAPISelectorAccountInfo @"GET api/account/accountinfo"
#define kAPISelectorUpdateAccountInfo @"POST api/account/accountinfo"
#define kAPISelectorUpdateApplyResult @"POST api/account/unapply"
#define kAPISelectorResetPassword @"POST api/account/resetpassword"
#define kAPISelectorEvaluate @"GET api/account/evaluate/:id"
#define kAPISelectorCheckNews @"GET api/account/message/hasnew?client=app"
#define kAPISelectorUserLanguage @"POST api/account/prefer/language"
#define kAPISelectorApplicationStatus @"GET api/account/applicationliststateraw"
#define kAPISelectorApplicationList @"GET api/account/applies"
#define kAPISelectorWoYaoLiuXue @"POST api/fastpass"
#define kAPISelectorCatigoryHotCities @"GET api/hotcities"
#define kAPISelectorMessageDetail @"GET api/article/"
//留学资讯推荐
#define kAPISelectorArticleRecommendation @"GET api/article/recommendations"
//留学资讯
#define kAPISelectorArticleCategory @"GET api/article/search?"
