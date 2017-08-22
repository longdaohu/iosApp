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
#import "XWGJAaboutHeader.h"
#import "ShareNViewController.h"
#import "HomeSectionHeaderView.h"
#import "PersonCell.h"

@interface XWGJAboutViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *abountArray;         //关于数据源
@property(nonatomic,strong)UIWebView *webView;           //用于打电话
@property(nonatomic,strong)ShareNViewController *shareVC;//分享
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
    
     [MobClick endLogPageView:@"page关于"];
    
}



//关于数组
-(NSArray *)abountArray
{
    if (!_abountArray) {
        
        
        
        XWGJAbout *love = [XWGJAbout cellWithLogo:@"about_love"  title:GDLocalizedString(@"About_download") sub_title:nil accessory_title:nil accessory_icon:nil];
        love.accessoryType = YES;
        XWGJAbout *share = [XWGJAbout cellWithLogo:@"about_share"  title:GDLocalizedString(@"About_share") sub_title:nil accessory_title:nil accessory_icon:nil];
        share.accessoryType = YES;
        XWGJAbout *weibo = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_weibo") sub_title:nil accessory_title:nil accessory_icon:@"about_weibo"];
        XWGJAbout *weixin = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_weixin") sub_title:nil accessory_title:nil accessory_icon:@"about_liu"];
         XWGJAbout *web = [XWGJAbout cellWithLogo:@"about_home"  title:GDLocalizedString(@"About_home") sub_title:nil accessory_title:@"www.myoffer.cn" accessory_icon:nil];
        XWGJAbout *chinaContect = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_phoneCN") sub_title:nil accessory_title:@"4000 666 522"   accessory_icon:nil];
        XWGJAbout *englandContect = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_phoneEN") sub_title:nil accessory_title:@"8000 699 799"    accessory_icon:nil];
        
        NSArray *one = @[love,share,web,weibo,weixin];
        NSArray *two = @[chinaContect,englandContect];
        
        _abountArray = @[one,two];
        
    }
    return _abountArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
  
}

-(void)makeUI
{
    self.title = GDLocalizedString(@"About_title");
    CGFloat comHeight = 50;
    UILabel *CompanyLab  =[[UILabel alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT - XNAV_HEIGHT - comHeight, XSCREEN_WIDTH, comHeight)];
     CompanyLab.font = [UIFont systemFontOfSize:14];
     CompanyLab.textColor = XCOLOR_DARKGRAY;
     CompanyLab.textAlignment = NSTextAlignmentCenter;
     CompanyLab.text = @"CopyRight 2016 myOffer.All rights reserved.";
    [self.view addSubview:CompanyLab];
    
    
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //添加表头
    self.tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"XWGJAaboutHeader" owner:self options:nil].lastObject;
 
}



#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeigt = (section == 0 )? HEIGHT_ZERO : Section_header_Height_nomal;
    
    return   sectionHeigt;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomeSectionHeaderView *sectionView = [HomeSectionHeaderView sectionHeaderViewWithTitle:GDLocalizedString(@"About_contect")];
    
    return sectionView;
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
 
    
    PersonCell *cell =[PersonCell cellWithTableView:tableView];
    NSArray  *rows = self.abountArray[indexPath.section];
    [cell bottomLineShow:(indexPath.row != (rows.count - 1))];
    cell.item = rows[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ( 0  == indexPath.section) {
        switch (indexPath.row) {
            case 0: //喜欢
            {
                [MobClick event:@"about_likeItemClick"];
                NSString *appid = @"1016290891";
                
                NSString *str = [NSString stringWithFormat:
                                 
                                 @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
               
            }
                break;
            case 1:   //分享
            {
                [MobClick event:@"about_shareItemClick"];
                 [self share];
            }
                break;
            case 2:    //打开官网
            {
                [MobClick event:@"about_webItemClick"];
                NSURL *url = [NSURL URLWithString:@"http://www.myoffer.cn"];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            case 3:    //打开weibo
            {
                [MobClick event:@"about_weiboItemClick"];
                NSURL *url = [NSURL URLWithString:@"http://weibo.com/u/5479612029?topnav=1&wvr=6&topsug=1"];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            default:{  //复制微信账号
                [MobClick event:@"about_weixinItemClick"];
                
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                
                NSString *string = @"myoffer4u";
                
                [pab setString:string];
                
                AlerMessage(GDLocalizedString(@"About_AlerCopy"));

            }
                break;
        }
    }else{ //打电话
       
        NSString *phoneNumber;
        switch (indexPath.row) {
            case 0:
                phoneNumber = @"tel://4000666522";
                break;
            case 1:
                phoneNumber = @"tel://8000699799";
                break;
            default:
                break;
        }
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNumber]]];
    
    }
    
}

- (UIWebView *)webView{

    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    return _webView;
}


- (ShareNViewController *)shareVC{
    
    if (!_shareVC) {

        _shareVC = [ShareNViewController shareView];
        [self addChildViewController:_shareVC];
        [self.view addSubview:self.shareVC.view];
        
    }
    
    return _shareVC;
}



//分享
- (void)share{
    
        [self.shareVC  show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    KDClassLog(@"关于 dealloc");
}
@end
