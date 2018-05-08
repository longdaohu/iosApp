//
//  QQserviceSingleView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "QQserviceSingleView.h"

@interface QQserviceSingleView ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *web;
@end


@implementation QQserviceSingleView

static id QQserviceSingle = nil;

+ (QQserviceSingleView*)defaultService{

    static dispatch_once_t token;
    
          dispatch_once(&token, ^{
              
               if(QQserviceSingle == nil) {
                      
                   QQserviceSingle = [[self alloc] init];
                   
                }
              
              });
    
    
    return QQserviceSingle;
}


 /**覆盖该方法主要确保当用户通过[[Singleton alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]
 */
+(id)allocWithZone:(struct _NSZone *)zone
{
  static dispatch_once_t token;
    
  dispatch_once(&token, ^{
      
       if(QQserviceSingle == nil)   {
           
                      QQserviceSingle = [super allocWithZone:zone];
                     }
           });
    
    return QQserviceSingle;
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


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
 
        UIWebView *webView    = [[UIWebView alloc] initWithFrame:CGRectZero];
        webView.delegate      = self;
        [self addSubview:webView];
        self.web = webView;
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}

- (void)webViewWithpath:(NSString *)path{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    [self.web loadRequest:request];
}

- (void)call{

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        [MobClick event:@"KeFu"];
        
        [self webViewWithpath:@"mqq://im/chat?chat_type=wpa&uin=3062202216&version=1&src_type=web"];
        
        return;
        
    }
    
    WeakSelf
    UIAlertController *alert = [UIAlertController alertWithTitle:@"联系客服前请先下载QQ，是否需要下载QQ？" message:nil actionWithCancelTitle:@"取消" actionWithCancelBlock:nil actionWithDoneTitle:@"下载" actionWithDoneHandler:^{
        //跳转到QQ下载页面
        [weakSelf webViewWithpath:@"http://appstore.com/qq"];
    }];
    //提示是否下载
    [alert alertShow:[UIApplication sharedApplication ].keyWindow.rootViewController];
 
}

@end
