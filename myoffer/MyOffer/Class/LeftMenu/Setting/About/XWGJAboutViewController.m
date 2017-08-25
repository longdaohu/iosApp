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

@interface XWGJAboutViewController ()
@property(nonatomic,strong)ShareNViewController *shareVC;//分享
@property(nonatomic,strong)NSArray *groups;

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


- (NSArray *)groups{
    
    if (!_groups) {
        
        XWGJAbout *love = [XWGJAbout cellWithLogo:@"about_love"  title:GDLocalizedString(@"About_download") sub_title:nil accessory_title:nil accessory_icon:nil];
        love.action = NSStringFromSelector(@selector(caseLove));
        love.accessoryType = YES;
        
        XWGJAbout *share = [XWGJAbout cellWithLogo:@"about_share"  title:GDLocalizedString(@"About_share") sub_title:nil accessory_title:nil accessory_icon:nil];
        share.accessoryType = YES;
        share.action = NSStringFromSelector(@selector(caseShare));
        
        XWGJAbout *weibo = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_weibo") sub_title:nil accessory_title:nil accessory_icon:@"about_weibo"];
        weibo.action = NSStringFromSelector(@selector(caseWeibo));
        
        XWGJAbout *weixin = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_weixin") sub_title:nil accessory_title:nil accessory_icon:@"about_liu"];
        weixin.action = NSStringFromSelector(@selector(caseWeixin));
        
        XWGJAbout *web = [XWGJAbout cellWithLogo:@"about_home"  title:GDLocalizedString(@"About_home") sub_title:nil accessory_title:@"www.myoffer.cn" accessory_icon:nil];
        web.action = NSStringFromSelector(@selector(caseWeb));
        
        XWGJAbout *chinaContect = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_phoneCN") sub_title:nil accessory_title:@"4000 666 522"   accessory_icon:nil];
        chinaContect.action = NSStringFromSelector(@selector(caseCallIn));
        
        XWGJAbout *englandContect = [XWGJAbout cellWithLogo:nil  title:GDLocalizedString(@"About_phoneEN") sub_title:nil accessory_title:@"8000 699 799"    accessory_icon:nil];
        englandContect.action = NSStringFromSelector(@selector(caseCallOut));
        
        NSArray *one_arr = @[love,share,web,weibo,weixin];
        NSArray *two_arr = @[chinaContect,englandContect];
        
        myofferGroupModel *one_group = [myofferGroupModel groupWithItems:one_arr header:nil];
        myofferGroupModel *two_group = [myofferGroupModel groupWithItems:two_arr header:@"联系我们"];
        
       _groups = @[one_group,two_group];
        
    }
    
    
    return _groups;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    self.datas = [self.groups copy];
  
}

-(void)makeUI
{
    self.title = GDLocalizedString(@"About_title");
    CGFloat comHeight = 50;
    UILabel *companyLab  =[[UILabel alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT - XNAV_HEIGHT - comHeight, XSCREEN_WIDTH, comHeight)];
     companyLab.font = [UIFont systemFontOfSize:14];
     companyLab.textColor = XCOLOR_TITLE;
     companyLab.textAlignment = NSTextAlignmentCenter;
     companyLab.text = @"CopyRight 2016 myOffer.All rights reserved.";
    [self.view insertSubview:companyLab atIndex:0];
    
    
    
     self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
     self.tableView.backgroundColor = [UIColor clearColor];
     self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //添加表头
    self.tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"XWGJAaboutHeader" owner:self options:nil].lastObject;
 
}



#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.datas[indexPath.section];
    XWGJAbout *item       = group.items[indexPath.row];
    if (item.action.length > 0) {
        
        [self performSelector:NSSelectorFromString(item.action) withObject:item afterDelay:0];
    }

    
     
}
#pragma mark : 事件处理

- (void)caseLove{

    NSString *appid = @"1016290891";
    
    NSString *path = [NSString stringWithFormat:
                     
                     @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid];
    
    
    [self caseURLWithPath:path];
    
}

- (void)caseShare{
    
    [self.shareVC  show];

}

- (void)caseWeb{
    
     NSString *path = @"http://www.myoffer.cn";
    
    [self caseURLWithPath:path];
}

- (void)caseWeibo{
    
    NSString *path = @"http://weibo.com/u/5479612029?topnav=1&wvr=6&topsug=1";
    
    [self caseURLWithPath:path];
    
}

- (void)caseWeixin{
    
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    NSString *string = @"myoffer4u";
    
    [pab setString:string];
    
    AlerMessage(GDLocalizedString(@"About_AlerCopy"));
}


- (void)caseCallIn{
    
    [self caseURLWithPath:@"telprompt://4000666522"];
}

- (void)caseCallOut{
    
    [self caseURLWithPath:@"telprompt://8000699799"];
}


- (void)caseURLWithPath:(NSString *)path{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
    
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
