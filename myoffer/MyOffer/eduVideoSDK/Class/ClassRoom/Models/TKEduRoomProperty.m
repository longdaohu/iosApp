//
//  TKEduClassRoomProperty.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduRoomProperty.h"

@implementation TKEduRoomProperty

-(void)parseMeetingInfo:(NSDictionary*) params
{
  
    _sWebIp       = [params objectForKey:@"host"]?[params objectForKey:@"host"]:sHost;
    _sWebPort     = [params objectForKey:@"port"]?[params objectForKey:@"port"]:sPort;
    _sNickName    = [params objectForKey:@"nickname"]?[params objectForKey:@"nickname"]:@"";
    _sDomain      = [params objectForKey:@"domain"]?[params objectForKey:@"domain"]:@"www";
    _sCmdPassWord = [params objectForKey:@"password"]?[params objectForKey:@"password"]:@"";
    _sCmdUserRole = [params objectForKey:@"userrole"]?[[params objectForKey:@"userrole"]intValue]:0;
     _iUserId     = [params objectForKey:@"userid"]?[params objectForKey:@"userid"]:@"0";
    _iRoomName    = [params objectForKey:@"roomname"]?[params objectForKey:@"roomname"]:@"";
    _iRoomId      = [params objectForKey:@"serial"]?[params objectForKey:@"serial"]:@"";
    _iCompanyID   = [params objectForKey:@"companyId"]?[params objectForKey:@"companyId"]:@"";
    _defaultServerArea = [params objectForKey:@"server"]?[params objectForKey:@"server"]:@"";
}

@end
