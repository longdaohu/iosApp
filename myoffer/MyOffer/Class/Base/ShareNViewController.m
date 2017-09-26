//
//  ShareNViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/2/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ShareNViewController.h"
#import "ShareNView.h"

//@interface ShareNViewController ()<UMSocialUIDelegate>
@interface ShareNViewController ()
@property(nonatomic,strong)ShareNView *shareView;
@property(nonatomic,strong)UniversitydetailNew *university;

@end

@implementation ShareNViewController

+ (instancetype)shareView{

    ShareNViewController *shareVC =  [[ShareNViewController alloc] init];
    
    return shareVC;
}


- (instancetype)initWithUniversity:(UniversitydetailNew *)Uni{
    
    self = [self init];
    
    if (self) {
        
        self.university = Uni;
    }
    
    return self;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
  
    XWeakSelf;
    self.shareView = [ShareNView shareViewWithAction:^(UIButton *sender, BOOL isHiden) {
        
        if (sender) [weakSelf shareItemClick:sender];
        
        if (isHiden) weakSelf.view.hidden = isHiden;
        
     }];
    
}


//分享功能面版
-(void)shareItemClick:(UIButton *)sender{
  
    
    NSString *shareURL;
    NSString *path;
    UIImage *shareImage;
    NSString *shareTitle;
    NSString *shareContent;
    NSString *shareFromPlat = nil;
    
    if (self.university) {
        
        shareURL = [NSString stringWithFormat:@"%@university/%@.html",DOMAINURL,self.university.short_id];
        path = [self.university.logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *ImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        shareImage = [UIImage imageWithData:ImageData];
        shareTitle = [NSString stringWithFormat:@"%@%@",self.university.name,shareURL];
        shareContent = self.university.introduction;
        
    }else if(self.shareInfor){
        
        shareURL = self.shareInfor[@"shareURL"];
        path = [self.shareInfor[@"icon"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *ImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        shareImage = [UIImage imageWithData:ImageData];
        shareTitle = [NSString stringWithFormat:@"%@%@",self.shareInfor[@"shareTitle"],shareURL];
        shareContent = self.shareInfor[@"shareContent"];
        shareFromPlat = self.shareInfor[@"plat"];
        
    }else{
        
        shareImage = [UIImage imageNamed:@"shareMyOffer"];
        shareURL   = [NSString stringWithFormat:@"http://www.myoffer.cn/ad/landing/app_promotion"];
        shareTitle = [NSString stringWithFormat:@"跨境的全球留学生服务生态圈——myOffer%@",shareURL];
        shareContent =  GDLocalizedString(@"About_shareSummary");
        
    }
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle  descr:shareContent thumImage:shareImage];
    shareObject.webpageUrl = shareURL;
    
    switch (sender.tag) {
        case myOfferShareTypeWeiXin:{
//                BOOL wx = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
//                if (!wx) {
//                    [MBProgressHUD showError:@"请先安装微信app"];
//                    return;
//                }
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession message:shareObject video:(shareFromPlat.length > 0)];

        }
            break;
        case myOfferShareTypeFriend:  //朋友圈
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine message:shareObject video:(shareFromPlat.length > 0)];
            break;
        case myOfferShareTypeQQ:
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ message:shareObject video:(shareFromPlat.length > 0)];
            break;
        case myOfferShareTypeZone:
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone message:shareObject video:(shareFromPlat.length > 0)];
            break;
        case myOfferShareTypeWB:
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina message:shareObject video:(shareFromPlat.length > 0)];
        }
            break;
        case myOfferShareTypeEmail:
        {
   
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            //设置文本
            messageObject.text = [NSString stringWithFormat:@"%@%@",shareURL,shareTitle];
             //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Email messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            
/*
            NSString *shareTEXT = [NSString stringWithFormat:@"%@%@",shareURL,shareTitle];
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"5668ea43e0f55af981002131"
                                              shareText:shareTEXT
                                             shareImage:nil
                                        shareToSnsNames:@[UMShareToEmail]
                                            delegate:self];
  */
        }
            break;
            
            
            
        case myOfferShareTypeCopy:
        {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:shareURL];
            [KDAlertView showMessage:@"复制成功" cancelButtonTitle:@"好的"];
            
        }
            break;
            
        case myOfferShareTypeMore:
        {//更多
            NSString *textToShare =  shareTitle;
            UIImage *imageToShare = shareImage;
            NSURL *urlToShare = [NSURL URLWithString:shareURL];
            NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            NSArray *excludedActivities = @[UIActivityTypePostToTwitter,
                                            UIActivityTypePostToFacebook,
                                            UIActivityTypePostToWeibo,
                                            UIActivityTypePostToTencentWeibo];
            controller.excludedActivityTypes = excludedActivities;
            [self presentViewController:controller animated:YES completion:nil];
        }
            
            break;
            
        default:
            break;
    }
    
    
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType message:(UMShareWebpageObject *)message video:(BOOL)video
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //分享消息对象设置分享内容对象
    messageObject.shareObject = message;
 
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            
            if(video){
                
                [MobClick event:@"ALL_transpond"];
                NSDictionary *dict = @{@"title" : message.title};
                [MobClick event:@"Assign_ALL_transpond" attributes:dict];
            }
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                 //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{/*

  U-Share返回错误类型
    typedef NS_ENUM(NSInteger, UMSocialPlatformErrorType) {
        UMSocialPlatformErrorType_Unknow            = 2000,            // 未知错误
        UMSocialPlatformErrorType_NotSupport        = 2001,            // 不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持）
        UMSocialPlatformErrorType_AuthorizeFailed   = 2002,            // 授权失败
        UMSocialPlatformErrorType_ShareFailed       = 2003,            // 分享失败
        UMSocialPlatformErrorType_RequestForUserProfileFailed = 2004,  // 请求用户信息失败
        UMSocialPlatformErrorType_ShareDataNil      = 2005,             // 分享内容为空
        UMSocialPlatformErrorType_ShareDataTypeIllegal = 2006,          // 分享内容不支持
        UMSocialPlatformErrorType_CheckUrlSchemaFail = 2007,            // schemaurl fail
        UMSocialPlatformErrorType_NotInstall        = 2008,             // 应用未安装
        UMSocialPlatformErrorType_Cancel            = 2009,             // 取消操作
        UMSocialPlatformErrorType_NotNetWork        = 2010,             // 网络异常
        UMSocialPlatformErrorType_SourceError       = 2011,             // 第三方错误
        
        UMSocialPlatformErrorType_ProtocolNotOverride = 2013,   // 对应的    UMSocialPlatformProvider的方法没有实现
        UMSocialPlatformErrorType_NotUsingHttps      = 2014,   // 没有用https的请求,@see UMSocialGlobal isUsingHttpsWhenShareContent
        
    };
  
    */
    
    
    if (!error) {
        [MBProgressHUD showSuccess:@"分享成功"];
        return;
    }
    
     if (![error.userInfo[@"message"] containsString:@"cancel"]) {
         
        [MBProgressHUD showError: @"分享失败"];
    }
    
      
    
 
}



- (void)show{
    
    [self.shareView show];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{

//    NSLog(@"新分享功能新分享功能新分享功能新分享功能新分享功能新分享功能新分享功能  dealloc");
}

@end
