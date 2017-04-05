//
//  ShareNViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/2/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ShareNViewController.h"
#import "ShareNView.h"

@interface ShareNViewController ()<UMSocialUIDelegate>
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
    
    if (self.university) {
        
        shareURL = [NSString stringWithFormat:@"%@university/%@.html",DOMAINURL,self.university.short_id];
        path = [self.university.logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *ImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        shareImage = [UIImage imageWithData:ImageData];
        shareTitle = self.university.name;
        shareContent = self.university.introduction;
        
    }else if(self.shareInfor){
        
        shareURL = self.shareInfor[@"shareURL"];
        path = [self.shareInfor[@"icon"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *ImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        shareImage = [UIImage imageWithData:ImageData];
        shareTitle = self.shareInfor[@"shareTitle"];
        shareContent = self.shareInfor[@"shareContent"];
        
    }else{
        
        shareImage = [UIImage imageNamed:@"shareMyOffer"];
        shareURL   = [NSString stringWithFormat:@"http://www.myoffer.cn/ad/landing/app_promotion"];
        shareTitle = @"跨境的全球留学生服务生态圈——myOffer";
        shareContent =  GDLocalizedString(@"About_shareSummary");
        
    }
    
    
    switch (sender.tag) {
        case 1:
        {
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title =  shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
            [[UMSocialControllerService defaultControllerService] setShareText:shareContent shareImage:shareImage socialUIDelegate:nil];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
            break;
            
            
        case 2:  //朋友圈
        {
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
            [[UMSocialControllerService defaultControllerService] setShareText:shareContent  shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
            break;
            
        case 3:
        {
            
            [UMSocialData defaultData].extConfig.qqData.url = shareURL;
            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    //                                                        NSLog(@"QQ分享成功！");
                }
            }];
            
            
        }
            break;
            
        case 4:
        {
            
            [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
        }
            break;
            
        case 5:
        {
            
            NSString *shareTEXT = [NSString stringWithFormat:@"%@%@",shareTitle,shareURL];
            [[UMSocialControllerService defaultControllerService] setShareText:shareTEXT shareImage:shareImage  socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            
        }
            break;
        case 6:
        {
            
            NSString *shareTEXT = [NSString stringWithFormat:@"%@%@",shareURL,shareTitle];
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"5668ea43e0f55af981002131"
                                              shareText:shareTEXT
                                             shareImage:nil
                                        shareToSnsNames:@[UMShareToEmail]
                                               delegate:self];
        }
            break;
            
            
            
        case 7:
        {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            NSString *string = shareURL;
            [pab setString:string];
            [KDAlertView showMessage:@"复制成功" cancelButtonTitle:@"好的"];
            
        }
            break;
            
        case 8:
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


#pragma mark 友盟分享回调  UMSocialUIDelegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //        KDClassLog(@"得到分享到  share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
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
