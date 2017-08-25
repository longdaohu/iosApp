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
#define kAPISelectorRequestCenter @"GET api/v2/account/mycount"
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
//获取完整类别信息
#define kAPISelectorArticleArticleCategory @"GET api/article-category"
//获取文章列表
#define kAPISelectorArticalesList @"GET api/articles"
//留学资讯
#define kAPISelectorArticleCategory @"GET api/article/search?"
//资讯详情
#define kAPISelectorArticleDetail @"GET api/v2/article/"
//留学攻略
#define kAPISelectorGonglueList @"GET http://public.myoffer.cn/docs/zh-cn/tips.json"
//学校详情
#define kAPISelectorUniversityDetail @"GET api/v2/university/"
//取消收藏
#define kAPISelectorUniversityUnfavorited @"GET api/account/unFavorite/"
//收藏
#define kAPISelectorUniversityfavorited @"GET api/account/favorite/"
//智能匹配
#define kAPISelectorZiZengPipeiGet @"GET api/account/evaluate"
//提交智能匹配
#define kAPISelectorZiZengPipeiPost @"POST api/account/evaluate"
//提交智能匹配结果选择项
#define kAPISelectorZiZengApplyPost @"POST api/account/apply"
//智能匹配结果
#define kAPISelectorZiZengRecommendation @"GET api/v2/university/recommendations"
//根据用户资料测试录取难易程度
#define kAPISelectorUniversityDetailUserLevel @"GET api/v2/account/evaluate/"
//获取通知列表
#define kAPISelectorTongZhiList @"GET api/account/messagelist"
//删除通知列表
#define kAPISelectorDeleteTongZhi @"DELETE api/account/message/%@"
//学校专业列表
#define kAPISelectorUniversityCourses @"GET api/v2/university/:id/courses"
//订单
#define kAPISelectorOrderList @"GET api/account/order"
//关闭订单
#define kAPISelectorOrderClose @"GET api/account/order/close?order_id=%@"
//订单详情
#define kAPISelectorOrderDetail @"GET api/account/order/%@"
//订单支付宝
#define kAPISelectorOrderAlipay @"GET api/account/alipayapp?order_id=%@"
//订单微信
//#define kAPISelectorOrderWeixin @"GET api/account/wechatpayapp?is_ios=1&order_id=%@"
#define kAPISelectorOrderWeixin @"GET api/sz/account/wechatpayapp?is_ios=1&order_id=%@"
//文章点赞
#define kAPISelectorMessageZang @"GET api/article/%@/like"
//文章轮播
#define kAPISelectorMessagePromotions @"GET api/app/promotions"
//申请状态
#define kAPISelectorApplyStutas @"GET api/account/checklist"
//申请审核状态
#define kAPISelectorApplyStutasNew @"GET api/account/applicationliststateraw"
//反馈意见
#define kAPISelectorFeedback @"POST api/app/feedback"
//留学购
#define kAPISelectorMyofferMall @"GET api/emall/app/index"
//留学购详情
#define kAPISelectorMyofferServiceDetail @"GET api/emall/sku/"
//资讯专题
#define kAPISelectorArticleCatigoryIndex @"GET api/article/category/index"
//资讯热门专题
#define kAPISelectorArticleTopic @"GET api/topic/"
//超级导师
#define kAPISelectorSuperMasterHome @"GET api/sm/index"
//超级导师详情
#define kAPISelectorSuperMasterDetail @"GET /api/sm/lecture/"
//超级导师详情
#define kAPISelectorSuperMasterlist @"GET api/sm/lectures"
//文章分类
#define kAPISelectorMessageCenterCatigory @"GET api/articles/index"
//文章分类专题
#define kAPISelectorMessageCenterTopic @"GET api/hot-article-topics"
//服务状态列表
#define kAPISelectorStatusList @"GET api/account/apply-process"
//申请流程状态详情
#define kAPISelectorStatusDetail @"GET api/account/apply-process/"


