//
//  APIClient+Interface.h
//  MyOffer
//
//  Created by Blankwonder on 6/8/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "APIClient.h"

#define kAPISelectorHomepage @"GET api/app/mobile"
#define kAPISelectorUniversityInfo @"GET api/university/:id"
#define kAPISelectorSearchRecommand @"GET api/app/hotSearch"
#define kAPISelectorhistorySearch @"GET api/account/searchhistory"
#define kAPISelectorRequestCenter @"GET api/account/mycount"
#define kAPISelectorSearch @"POST api/app/search"
#define kAPISelectorHotUniversity @"GET api/university/hot"
#define kAPISelectorSubjects @"GET docs/:lang/subjects.json"
#define kAPISelectorGrades @"GET docs/:lang/grades.json"
#define kAPISelectorCountries @"GET docs/:lang/countries.json"
#define kAPISelectorSendVerifyCode @"POST api/vcode"
#define kAPISelectorRegister @"POST api/account/register"
#define kAPISelectorLogin @"POST api/account/login"
#define kAPISelectorLogout @"GET api/account/logout"
#define kAPISelectorBind @"POST api/account/bind"
#define kAPISelectorNewAndLogin @"POST api/account/oauth/newandlogin"
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