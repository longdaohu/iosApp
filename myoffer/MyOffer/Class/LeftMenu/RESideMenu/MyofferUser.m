//
//  MyofferUser.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyofferUser.h"

@implementation MyofferUser

- (NSString *)user_id{
    
    return self.accountInfo[@"_id"];
}

- (NSString *)displayname{

    return self.accountInfo[@"displayname"];
}


- (NSString *)phonenumber{
    
    return self.accountInfo[@"phonenumber"];
}

- (NSString *)access_agent{
    
    return self.accountInfo[@"access_agent"];
}

- (BOOL)applied{

    return self.accountInfo[@"applied"];
}

- (BOOL)hasPassword{
    
    return self.accountInfo[@"hasPassword"];
}

- (BOOL)is_phonenumber_verified{
    
    return self.accountInfo[@"is_phonenumber_verified"];
}

- (BOOL)is_email_verified{
    
    return self.accountInfo[@"is_email_verified"];
}


- (void)userLogout{
    
    self.portraitUrl = nil;
    self.accountInfo = nil;
    
}




static id UserSingle = nil;

+ (MyofferUser*)defaultUser{
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        if(UserSingle == nil) {
            
            UserSingle = [[self alloc] init];
            
        }
        
    });
    
    
    return UserSingle;
}


/**覆盖该方法主要确保当用户通过[[Singleton alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]
 */
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        if(UserSingle == nil)   {
            
            UserSingle = [super allocWithZone:zone];
        }
    });
    
    return UserSingle;
}
//自定义初始化方法，本例中只有name这一属性
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (id)copy
{
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (id)mutableCopy{
    
    return self;
}







@end
