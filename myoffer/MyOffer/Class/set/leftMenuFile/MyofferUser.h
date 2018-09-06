//
//  MyofferUser.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyofferUser : NSObject
@property(nonatomic,strong)NSDictionary *accountInfo;
@property(nonatomic,copy)NSString *portraitUrl;

@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *displayname;
@property(nonatomic,copy)NSString *phonenumber;
@property(nonatomic,copy)NSString *access_agent;
@property(nonatomic,copy)NSString *coin;
@property(nonatomic,assign)BOOL applied;
@property(nonatomic,assign)BOOL hasPassword;
@property(nonatomic,assign)BOOL is_phonenumber_verified;
@property(nonatomic,assign)BOOL is_email_verified;

+ (MyofferUser*)defaultUser;

- (void)userLogout;

@end


/*
 
 {
 "accountInfo": {
 "_id": "56554dc86ca423d62ffec436",
 "displayname": "myoffer66266508",
 "__v": 1,
 "access_ip": "112.97.51.54",
 "access_agent": "myOffer/1.6.1 iPhone7,1/10.0.2",
 "push_at": "2017-03-22T11:00:32.509Z",
 "sync_CRM_at": "2016-12-10T18:01:57.232Z",
 "CRM_id": "85124ed0-e015-e611-80d5-c10ecb720705",
 "valid": false,
 "applied": false,
 "phonenumber": "18688958114",
 "mentor_type": "myoffer",
 "background_doc": [
 
 ],
 "publish_state": 0,
 "service_category": [
 
 ],
 "prefer_language": "zh-cn",
 "tags": [
 
 ],
 "source": "local",
 "agreement": false,
 "is_email_verified": false,
 "is_phonenumber_verified": true,
 "access_at": "2017-04-17T09:51:37.135Z",
 "update_at": "2016-12-27T07:13:27.906Z",
 "create_at": "2015-11-25T05:57:28.603Z",
 "nationality": "China PRC",
 "sub_roles": [
 
 ],
 "hasPassword": true
 },
 "portraitUrl": "http://public.myoffer.cn/portraits/f704c85f57fc549ea86e7c7167ba33b1.jpg"
 }
 
 
 
 
 正常登录成功相关处理  = {
 "access_token" = "d6cc72b4-8d83-4008-a1b8-f0d6fe795703";
 displayname = myoffer66266508;
 "jpush_alias" = 56554dc86ca423d62ffec436;
 phonenumber = 18688958114;
 redirectUrl = "/";
 role = user;
 }
 */
