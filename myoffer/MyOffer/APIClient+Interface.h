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
#define kAPISelectorRequestCenter @"GET api/account/mycount"
#define kAPISelectorSearch @"POST api/app/search"
#define kAPISelectorHotUniversity @"GET api/university/hot"
#define kAPISelectorSubjects @"GET docs/:lang/subjects.json"
#define kAPISelectorGrades @"GET docs/:lang/grades.json"
#define kAPISelectorCountries @"GET docs/:lang/countries.json"
#define kAPISelectorSendVerifyCode @"POST api/vcode"
#define kAPISelectorRegister @"POST api/account/register"
#define kAPISelectorLogin @"POST api/account/login"
#define kAPISelectorAccountInfo @"GET api/account/accountinfo"
#define kAPISelectorUpdateAccountInfo @"POST api/account/accountinfo"
#define kAPISelectorUpdateApplyResult @"POST api/account/unapply"
#define kAPISelectorResetPassword @"POST api/account/resetpassword"
#define kAPISelectorEvaluate @"GET api/account/evaluate/:id"
 