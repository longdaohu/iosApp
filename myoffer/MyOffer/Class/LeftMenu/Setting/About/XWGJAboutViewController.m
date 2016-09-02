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
#import "ShareViewController.h"

@interface XWGJAboutViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *abountArray;         //关于数据源
@property(nonatomic,strong)XWGJShareView *ShareView;       //分享View
@property(nonatomic,strong)UIWebView *webView;           //用于打电话
@property(nonatomic,strong)UILabel *CompanyLab;          //公司信息Label
@property(nonatomic,strong)ShareViewController *shareVC;
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
       
        NSString *phoneNumber = indexPath.row == 0 ? @"tel://4000666522" : @"tel://8000699799";
        
        if (_webView == nil) {
            
            _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            
        }
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNumber]]];
    
    }
    
}


- (ShareViewController *)shareVC{
    
    if (!_shareVC) {
        
        
        XJHUtilDefineWeakSelfRef
        _shareVC = [[ShareViewController alloc] init];
        
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    KDClassLog(@"XWGJAboutViewController dealloc");
}
@end
