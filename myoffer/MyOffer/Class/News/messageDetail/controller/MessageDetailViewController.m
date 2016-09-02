//
//  MessageDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#define ZangFontSize 15
#import "MessageDetailViewController.h"
#import "XWGJMessageDetailFrame.h"
#import "XWGJMessageTableViewCell.h"
#import "XWGJMessageDetailContentCell.h"
#import "ApplyViewController.h"
#import "XWGJMessageSectionView.h"
#import "XWGJMessageFrame.h"
#import "NewsItem.h"
#import <WebKit/WebKit.h>
#import "ShareViewController.h"
#import "UniversityItemNew.h"
#import "UniItemFrame.h"
#import "UniversityCell.h"

@interface MessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UMSocialUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)UITableView *tableView;
//嵌套webView到Cell中
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)WKWebView *web_wk;
//webView的高度
@property(nonatomic,assign)CGFloat WebHeight;
//推荐资讯数据源
@property(nonatomic,strong)NSArray *Messages;
//推荐院校数据源
@property(nonatomic,strong)NSArray *Universities;
//请求返回数据字典
@property(nonatomic,strong)NSDictionary *ArticleInfo;
// 点赞按钮
@property(nonatomic,strong)UIButton *ZangBtn;
//点分享按钮
@property(nonatomic,strong)UIButton *shareBtn;
//导航右边按钮
@property(nonatomic,strong)UIView *RightView;
//资讯详情Frame模型
@property(nonatomic,strong)XWGJMessageDetailFrame *MessageDetailFrame;
@property(nonatomic,strong)KDProgressHUD *hud;
//分享
@property(nonatomic,strong)ShareViewController *shareVC;
//无数据提示框
@property(nonatomic,strong)XWGJnodataView *noDataView;
//导航栏下图片
@property(nonatomic,strong)UIImageView *navImageView;

@end

@implementation MessageDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [MobClick beginLogPageView:@"page资讯详情"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯详情"];
    
}



//自定义导航栏右侧按钮
-(UIView *)RightView
{
    if (!_RightView) {
        _RightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
         _RightView.hidden = YES;
        
        CGFloat Lx = 0;
        CGFloat Ly = 0;
        CGFloat Lw = _RightView.frame.size.width - 35;
        CGFloat Lh = 40;
         self.ZangBtn  = [[UIButton alloc] initWithFrame:CGRectMake(Lx,Ly, Lw, Lh)];
        [self.ZangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.ZangBtn  setImage:[UIImage imageNamed:@"nav_likeHightLight"] forState:UIControlStateNormal];
        [self.ZangBtn  setImage:[UIImage imageNamed:@"nav_likeNomal"] forState:UIControlStateDisabled];
        self.ZangBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.ZangBtn  addTarget:self action:@selector(ZangBtnClick)  forControlEvents:UIControlEventTouchUpInside];
        self.ZangBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 0, 0);
        self.ZangBtn.titleLabel.font =[UIFont systemFontOfSize:ZangFontSize];
        [_RightView addSubview:self.ZangBtn ];
        
        CGFloat Sy = 0;
        CGFloat Sw = 35;
        CGFloat Sh = 40;
        CGFloat Sx = _RightView.frame.size.width - Sw;
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake( Sx, Sy, Sw, Sh)];
        [self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn  setImage:[UIImage imageNamed:@"nav_shareNomal"] forState:UIControlStateNormal];
        [self.shareBtn  setImage:[UIImage imageNamed:@"nav_shareHightLight"] forState:UIControlStateHighlighted];
        [_RightView addSubview:self.shareBtn];
        
    }
    
    return _RightView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeDataSourse];
    
}

-(void)makeOtherView
{
    
    //没有数量是显示提示
     self.noDataView =[XWGJnodataView noDataView];
     self.noDataView.hidden = YES;
     self.noDataView.contentLabel.text = @"网络请求失败，请稍候再试!";
     [self.view insertSubview:self.noDataView  aboveSubview:self.tableView];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.RightView];
    
    if (self.navigationBgImage) {
        self.navImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, -64, XScreenWidth, 64)];
        self.navImageView.clipsToBounds = YES;
        self.navImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.navImageView.image = self.navigationBgImage;
        [self.view addSubview:self.navImageView];
        
    }

}



-(void)makeWebView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 1)];
        NSString *RequestString =[NSString stringWithFormat:@"%@api/article/%@/detail",DOMAINURL,self.NO_ID];
        [self.web_wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
        self.web_wk.scrollView.scrollEnabled = NO;
        self.web_wk.userInteractionEnabled = NO;
        [self.web_wk sizeToFit];
        self.web_wk.navigationDelegate = self;
        
    }else{
    
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, APPSIZE.width, 1)];
        self.webView.delegate = self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.userInteractionEnabled = NO;
        [self.webView sizeToFit];
        NSString *RequestString =[NSString stringWithFormat:@"%@api/article/%@/detail",DOMAINURL,self.NO_ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
     }
    
   
}
-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.hidden = YES;
    self.tableView.sectionFooterHeight = 0;
//    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
}

-(void)makeUI
{
    
    [self makeTableView];
    
    [self makeWebView];
    
    [self makeOtherView];
    
}

-(void)makeDataSourse
{
    
    XJHUtilDefineWeakSelfRef
    
    self.MessageDetailFrame  = [[XWGJMessageDetailFrame alloc] init];

    NSString *testpath =[NSString stringWithFormat:@"GET api/article/v2/%@",self.NO_ID];
    
    [self startAPIRequestWithSelector:testpath parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        [weakSelf dismiss];
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        
        self.tableView.hidden = NO;
        
        weakSelf.ZangBtn.enabled = ![response[@"like"] integerValue];
        
        if ([response[@"like"] integerValue]) {
            
            [weakSelf.ZangBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
            
        }
        
        //根据点赞数量改变导航栏右侧相关控件宽度
        [weakSelf.ZangBtn  setTitle:[NSString  stringWithFormat:@"%@",response[@"like_count"]]  forState:UIControlStateNormal];
        CGSize LikeCountSize =[[NSString  stringWithFormat:@"%@",response[@"like_count"]]  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:ZangFontSize]];
        
        CGRect NewRightFrame = weakSelf.RightView.frame;
        NewRightFrame.size.width += LikeCountSize.width;
        weakSelf.RightView.frame = NewRightFrame;
        
        CGRect NewShareFrame = weakSelf.shareBtn.frame;
        NewShareFrame.origin.x +=  LikeCountSize.width;
        weakSelf.shareBtn.frame = NewShareFrame;
        
        CGRect NewLoveFrame = weakSelf.ZangBtn.frame;
        NewLoveFrame.size.width +=  LikeCountSize.width;
        weakSelf.ZangBtn.frame = NewLoveFrame;
        
        
        //推荐资讯数据
        NSMutableArray *messageFrames = [NSMutableArray array];
        
        for (NSDictionary *MessageDic in  response[@"recommendations"]) {
            
            if (![self.NO_ID isEqualToString:MessageDic[@"_id"]]) {
                
                NewsItem  *News =[NewsItem mj_objectWithKeyValues:MessageDic];
                
                XWGJMessageFrame *messageFrame = [XWGJMessageFrame messageFrameWithMessage:News];
                
                [messageFrames addObject:messageFrame];
            }
            
        }
        
        weakSelf.Messages = [messageFrames copy];
        
        weakSelf.ArticleInfo = (NSDictionary *)response;
        
        weakSelf.MessageDetailFrame.MessageDetail = (NSDictionary *)response;
        
        
        
        NSMutableArray *related_universities = [NSMutableArray array];
        
        [response[@"related_universities"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            UniversityItemNew *uni = [UniversityItemNew mj_objectWithKeyValues:obj];
            UniItemFrame *uniFrame = [UniItemFrame frameWithUniversity:uni];
            [related_universities addObject:uniFrame];
            
        }];

        weakSelf.Universities = [related_universities copy];
        
        [weakSelf.tableView reloadData];
        
        

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        weakSelf.noDataView.hidden = NO;
        
    }];
    
 
 

}

#pragma mark ——————  WKWebViewDeleage
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
  
     self.hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    
     [self.hud removeFromSuperViewOnHide];

}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id obj, NSError * _Nullable error) {
       
        
        NSInteger height = [(NSString *)obj integerValue];
     
        self.web_wk.frame = CGRectMake(0, 0,XScreenWidth,height);
  
        [self.tableView reloadData];
            
        
    }];
    
    //加载完成后重新设置 tableview的cell的高度,和webview的frame
    if (!webView.isLoading) {
        
        self.RightView.hidden = NO;
        
        [self.hud hideAnimated:YES afterDelay:1];
    }

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [self.hud hideAnimated:YES afterDelay:1];

}

#pragma mark ——————  UIWebViewDeleage
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    self.hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.hud removeFromSuperViewOnHide];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:
                         @"document.body.scrollHeight"] integerValue];
    self.webView.frame = CGRectMake(0, 0,XScreenWidth,height);
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    
    //加载完成后重新设置 tableview的cell的高度,和webview的frame
    if (!webView.isLoading) {
        
        self.RightView.hidden = NO;

        [self.hud hideAnimated:YES afterDelay:1];
    }

    
}


//用于设置网页快捷链接跳转
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
     NSURL  *url = request.URL;
    
    NSString *URLstr = [NSString stringWithFormat:@"%@",url];
    
    
    
    if ([URLstr containsString:@"api/article"]) {
        
        return YES;
        
    }else{
          //用于设置网页快捷链接跳转到自带浏览器
//          [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
        
    }
    
 

    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self.hud hideAnimated:YES afterDelay:1];
 
}



#pragma mark —————— UITableViewDataDeleage UITableViewDeleage
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return   50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return nil;
    }else{
        
         XWGJMessageSectionView *MSView =[[XWGJMessageSectionView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 50)];
      
          MSView.SecitonName = @"推荐阅读";
        
        if (self.Universities.count) {
            
            MSView.SecitonName = section == 1 ? @"相关院校": @"推荐阅读";

        }
        
          return MSView;
        
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.Universities.count > 0 ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    switch (section) {
        case 0:
            return 1;
            break;
        default:
        {
            if (self.Universities.count > 0)
            {
                if (section == 1) {
                    
                    return self.Universities.count;
                    
                }else{
                    
                    return self.Messages.count > 2 ? 2 : self.Messages.count;
                }
                
            }else{
                
                return self.Messages.count > 2 ? 2 : self.Messages.count;
                
            }
        
        }
            break;
    }
    
}
/**
 *  设置cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    CGFloat cellHight = 0;
  
    CGFloat webHeight = [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? self.web_wk.frame.size.height : self.webView.frame.size.height ;
    
    if (indexPath.section==0) {
        
        cellHight =  self.MessageDetailFrame.MessageDetailHeight + webHeight;
        
    }else{
        
        cellHight =  University_HEIGHT;
        
    }
    
    return cellHight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.section) {
        case 0:
        {
            XWGJMessageDetailContentCell *cell = [XWGJMessageDetailContentCell CreateCellWithTableView:tableView];
            cell.MessageFrame = self.MessageDetailFrame;
           
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                self.web_wk.frame = CGRectMake(0, self.MessageDetailFrame.MessageDetailHeight, APPSIZE.width,self.web_wk.frame.size.height);
                [cell.contentView addSubview:self.web_wk];
             
            }else{
                self.webView.frame = CGRectMake(0, self.MessageDetailFrame.MessageDetailHeight, APPSIZE.width,self.webView.frame.size.height);
                [cell.contentView addSubview:self.webView];
                
            
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;

        }
            break;
        default:
        {
            if (self.Universities.count > 0)
            {
                
                
                if (indexPath.section == 1) {
                    
                    UniversityCell *universityCell =[UniversityCell cellWithTableView:tableView];
                    universityCell.itemFrame = self.Universities[indexPath.row];
 
                    return universityCell;
                    
                }else{
                    
                    
                XWGJMessageTableViewCell *cell =[XWGJMessageTableViewCell cellWithTableView:tableView];
                cell.messageFrame = self.Messages[indexPath.row];
                    
                return cell;
                }
                
            }else{
                
                
                XWGJMessageTableViewCell *cell =[XWGJMessageTableViewCell cellWithTableView:tableView];
                cell.messageFrame = self.Messages[indexPath.row];

                return cell;
            }
            
        }
            break;
    }
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (self.Universities.count >0) {
        
        switch (indexPath.section) {
            case 1:
            {
                UniItemFrame *itemFrame = self.Universities[indexPath.row];
                [self.navigationController pushUniversityViewControllerWithID:itemFrame.item.NO_id animated:YES];
            
            }
                break;
            case 2:
            {
                [self TableViewDidSelectRowAtIndexPath:indexPath];
            }
                break;
            default:
                break;
        }
        
    }else{
    
    
        if (indexPath.section == 1) {
            
            [self TableViewDidSelectRowAtIndexPath:indexPath];
            
        }

    }
    
}

-(void)TableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailViewController *detail =[[MessageDetailViewController alloc] init];
    XWGJMessageFrame *messageFrame =  self.Messages[indexPath.row];
    detail.NO_ID = messageFrame.News.messageID;
    [self.navigationController pushViewController:detail animated:YES];
}


//点赞
-(void)ZangBtnClick
{
    XJHUtilDefineWeakSelfRef
    NSString *path =[NSString stringWithFormat:@"GET api/article/%@/like",self.NO_ID];
    [self startAPIRequestWithSelector:path  parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSString *LikeCount = self.ZangBtn.currentTitle;
        [weakSelf.ZangBtn setTitle:[NSString stringWithFormat:@"%ld",(long)LikeCount.integerValue + 1]  forState:UIControlStateNormal];
        [weakSelf.ZangBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        
        weakSelf.ZangBtn.enabled = NO;
        
     }];
}


//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

- (ShareViewController *)shareVC{
    
    if (!_shareVC) {
        
        NSString *shareURL = [NSString stringWithFormat:@"http://www.myoffer.cn/article/%@",self.NO_ID];
        NSString *path = [self.ArticleInfo[@"cover_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *shareTitle = self.ArticleInfo[@"title"];
        NSString *shareContent = self.ArticleInfo[@"summary"];
        NSMutableDictionary *shareInfor = [NSMutableDictionary dictionary];
        [shareInfor setValue:shareURL forKey:@"shareURL"];
        [shareInfor setValue:path forKey:@"icon"];
        [shareInfor setValue:shareTitle forKey:@"shareTitle"];
        [shareInfor setValue:shareContent forKey:@"shareContent"];
        
        XJHUtilDefineWeakSelfRef
        _shareVC = [[ShareViewController alloc] init];
        _shareVC.shareInfor = shareInfor;
        _shareVC.actionBlock = ^{
            
            [weakSelf.shareVC.view removeFromSuperview];
            
        };
        [self.view addSubview:_shareVC.view];

        [self addChildViewController:_shareVC];
        
    }
    return _shareVC;
}


//分享
- (void)share{
    
    if (_shareVC.view.superview != self.view) {
        
        [self.view addSubview:_shareVC.view];
        
        [self.shareVC  show];
    }
    
}


-(void)dealloc
{
    KDClassLog(@" MessageDetailViewController    dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
