//
//  XWGJAboutViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "UMSocial.h"
#import "XWGJAboutViewController.h"
#import "XWGJAbout.h"
#import "XWGJShareView.h"
#import "XWGJAaboutHeader.h"
#import "XWGJMessageSectionView.h"

@interface XWGJAboutViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *abountArray;         //关于数据源
@property(nonatomic,strong)XWGJShareView *ShareView;       //分享View
@property(nonatomic,strong)UIView *CoverView;            //遮盖
@property(nonatomic,strong)UIWebView *webView;           //用于打电话
@property(nonatomic,strong)UILabel *CompanyLab;          //公司信息Label

@end


@implementation XWGJAboutViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page关于"];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.CoverView.hidden = YES;
    
    [MobClick endLogPageView:@"page关于"];
    
}



//关于数组
-(NSArray *)abountArray
{
    if (!_abountArray) {
        
        XWGJAbout *love = [XWGJAbout aboutWithLogo:@"about_love" andContent:GDLocalizedString(@"About_download") andsubTitle:nil  andRightAccessoryImage:nil];
        XWGJAbout *share = [XWGJAbout aboutWithLogo:@"about_share" andContent:GDLocalizedString(@"About_share") andsubTitle:nil  andRightAccessoryImage:nil];
        XWGJAbout *weibo = [XWGJAbout aboutWithLogo:nil andContent:GDLocalizedString(@"About_weibo") andsubTitle:nil  andRightAccessoryImage:@"about_weibo"];
        XWGJAbout *weixin = [XWGJAbout aboutWithLogo:nil andContent:GDLocalizedString(@"About_weixin") andsubTitle:nil  andRightAccessoryImage:@"about_liu"];
        XWGJAbout *web = [XWGJAbout aboutWithLogo:@"about_home" andContent:GDLocalizedString(@"About_home")  andsubTitle:@"www.myoffer.cn"  andRightAccessoryImage:nil];
        XWGJAbout *chinaContect = [XWGJAbout aboutWithLogo:nil andContent:GDLocalizedString(@"About_phoneCN")  andsubTitle:@"4000 666 522"  andRightAccessoryImage:nil];
        XWGJAbout *englandContect = [XWGJAbout aboutWithLogo:nil andContent:GDLocalizedString(@"About_phoneEN")  andsubTitle:@"8000 699 799"  andRightAccessoryImage:nil];
        
        NSArray *one = @[love,share,web,weibo,weixin];
        NSArray *two = @[chinaContect,englandContect];
        
        _abountArray = @[one,two];
        
    }
    return _abountArray;
}

//分享出现时的遮盖
-(UIView *)CoverView
{
    if (!_CoverView) {
        
        _CoverView =[[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        [[UIApplication sharedApplication].windows.lastObject addSubview:_CoverView];
        
        _CoverView.backgroundColor = [UIColor clearColor];
        UIButton *cover =[[UIButton alloc] initWithFrame:_CoverView.frame];
        [cover addTarget:self action:@selector(RemoveCover) forControlEvents:UIControlEventTouchDown];
        cover.alpha = 0.3;
        cover.backgroundColor =[UIColor blackColor];
        [_CoverView addSubview:cover];
    }
    return _CoverView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
  
}

-(void)makeUI
{
    self.title = GDLocalizedString(@"About_title");
    self.CompanyLab  =[[UILabel alloc] initWithFrame:CGRectMake(0, APPSIZE.height - 114, APPSIZE.width, 50)];
    self.CompanyLab.font = [UIFont systemFontOfSize:14];
    self.CompanyLab.textColor = XCOLOR_DARKGRAY;
    self.CompanyLab.textAlignment = NSTextAlignmentCenter;
    self.CompanyLab.text = @"CopyRight 2016 myOffer.All rights reserved.";
    [self.view addSubview:self.CompanyLab];
    
    
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.sectionFooterHeight = 0;
    
    //添加表头
    self.tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"XWGJAaboutHeader" owner:self options:nil].lastObject;
 
}



#pragma mark —————— UITableViewDataDeleage UITableViewDeleage
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeigt = section == 0 ? 0 : 40;
    
    return   sectionHeigt;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return nil;
    }else{
        
        XWGJMessageSectionView *MSView =[[XWGJMessageSectionView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 50)];
       
        MSView.SecitonName = GDLocalizedString(@"About_contect");
        
        return MSView;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.abountArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = self.abountArray[section];
    return  items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"About"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"About"];
    }
    
    NSArray *items = self.abountArray[indexPath.section];
    XWGJAbout *item = items[indexPath.row];
    cell.imageView.image =[UIImage imageNamed:item.Logo];
    cell.textLabel.text = item.contentName;
    cell.detailTextLabel.text = item.SubName;
    
    if(0 == indexPath.section){
        
        if (indexPath.row == 0 || indexPath.row ==1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (item.RightImageName) {
        
        UIImageView *mv =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        mv.image = [UIImage imageNamed:item.RightImageName];
        cell.accessoryView = mv;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( 0  == indexPath.section) {
        switch (indexPath.row) {
            case 0: //喜欢
            {
                NSString *appid = @"1016290891";
                
                NSString *str = [NSString stringWithFormat:
                                 
                                 @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
               
            }
                break;
            case 1:   //分享
            {
                 [self share];
            }
                break;
            case 2:    //打开官网
            {
                NSURL *url = [NSURL URLWithString:@"http://www.myoffer.cn"];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            case 3:    //打开weibo
            {
                NSURL *url = [NSURL URLWithString:@"http://weibo.com/u/5479612029?topnav=1&wvr=6&topsug=1"];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            default:{  //复制微信账号
                
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                
                NSString *string = @"ukyingwen";
                
                [pab setString:string];
                
                AlerMessage(GDLocalizedString(@"About_AlerCopy"));

            }
                break;
        }
    }else{ //打电话
       
        NSString *phoneNumber = indexPath.row == 0 ? @"tel://4000666522" : @"tel://8000699799";
        
        if (_webView == nil) {
            
            _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            
        }
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNumber]]];
    
    }
    
}

//移除遮盖
-(void)RemoveCover{
    
    [self shareViewUp:NO];
}


//分享按钮
-(void)share
{
    [self shareViewUp:YES];
}

//分享面板出现隐藏
-(void)shareViewUp:(BOOL)up
{
    XJHUtilDefineWeakSelfRef
    CGFloat Fy = up ? APPSIZE.height - APPSIZE.width + 20 : APPSIZE.height;
    
    __block CGRect  NewRect = self.ShareView.frame;
    
    NewRect.origin.y = Fy;
    
    if (up) {
        
        self.CoverView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            weakSelf.ShareView.frame = NewRect;
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            weakSelf.ShareView.frame = NewRect;
            
        } completion:^(BOOL finished) {
            
            weakSelf.CoverView.hidden = YES;
            
        }];
    }
}

//分享功能面版
-(XWGJShareView *)ShareView
{
    if (!_ShareView) {
        
        XJHUtilDefineWeakSelfRef
        
        _ShareView = [[XWGJShareView alloc] initWithFrame:CGRectMake(0, APPSIZE.height, APPSIZE.width, APPSIZE.width)];
        
        _ShareView.ShareBlock = ^(UIButton *sender){
            UIImage *shareImage = [UIImage imageNamed:@"shareMyOffer"];
            NSString *shareURL = [NSString stringWithFormat:@"http://www.myoffer.cn/ad/landing/app_promotion"];
            NSString *shareTitle = GDLocalizedString(@"About_shareContent");
            NSString *shareContent =  GDLocalizedString(@"About_shareSummary");
            
            switch (sender.tag) {
                case 0: //微信
                {
                    [UMSocialData defaultData].extConfig.wechatSessionData.title =  shareTitle;
                    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
                    
                    [[UMSocialControllerService defaultControllerService] setShareText:shareContent shareImage:shareImage socialUIDelegate:nil];
                    //设置分享内容和回调对象
                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(weakSelf,[UMSocialControllerService defaultControllerService],YES);
                    
                }
                    break;
                    
                    
                case 1:  //朋友圈
                {

                    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
                    
                    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
                    
                    [[UMSocialControllerService defaultControllerService] setShareText:shareContent  shareImage:shareImage socialUIDelegate:weakSelf];        //设置分享内容和回调对象
                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(weakSelf,[UMSocialControllerService defaultControllerService],YES);
                    
                }
                    break;
                    
                case 2: //QQ
                {
                    
                    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
                    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
                    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareContent image:shareImage location:nil urlResource:nil presentedController:weakSelf completion:^(UMSocialResponseEntity *response){
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            //                                                        NSLog(@"QQ分享成功！");
                        }
                    }];
                    
                    
                }
                    break;
                    
                case 3://QQ空间
                {
                    
                    [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
                    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
                    
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareContent image:shareImage location:nil urlResource:nil presentedController:weakSelf completion:^(UMSocialResponseEntity *response){
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            
                        }
                    }];
                }
                    break;
                    
                case 4: //微博
                {
                    NSString *title =   [NSString stringWithFormat:@"%@（来自@myOffer学无国界）",shareTitle];
                  
                    UIImage *shareImage = [UIImage imageNamed:@"share_market.jpg"];

                    NSString *shareTEXT = [NSString stringWithFormat:@"%@%@",title,shareURL];
                    
                    [[UMSocialControllerService defaultControllerService] setShareText:shareTEXT shareImage:shareImage  socialUIDelegate:weakSelf];        //设置分享内容和回调对象
                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(weakSelf,[UMSocialControllerService defaultControllerService],YES);
                    
                    
                }
                    break;
                case 5: //Email
                {
                    
                    NSString *shareTEXT = [NSString stringWithFormat:@"%@%@",shareURL,shareTitle];
                    
                    [UMSocialSnsService presentSnsIconSheetView:weakSelf
                                                         appKey:@"5668ea43e0f55af981002131"
                                                      shareText:shareTEXT
                                                     shareImage:nil
                                                shareToSnsNames:@[UMShareToEmail]
                                                       delegate:weakSelf];
                }
                    break;
                    
                    
                    
                case 6: //复制
                {
                    UIPasteboard *pab = [UIPasteboard generalPasteboard];
                    
                    NSString *string = shareURL;
                    
                    [pab setString:string];
                    
                    AlerMessage(GDLocalizedString(@"About_CopySusess"));
                }
                    break;
                    
                case 7: //更多
                {
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
                    
                    
                    
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                }
                    
                    break;
                    
                default:
                    break;
            }
            
            [weakSelf shareViewUp:NO];
            
        };
        
        [self.CoverView addSubview:_ShareView];
        
    }
    return _ShareView;
}
//友盟分享回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    KDClassLog(@"XWGJAboutViewController dealloc");
}
@end
