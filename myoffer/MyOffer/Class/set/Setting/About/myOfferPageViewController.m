//
//  myOfferPageViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "myOfferPageViewController.h"
#import "myOfferMenuItem.h"
#import "myOfferMenuGroup.h"
#import "myofferMenuCell.h"
#import "ShareNViewController.h"
#import "myOfferSectionHeaderView.h"
#import "XWGJAaboutHeader.h"
#import "Masonry.h"

@interface myOfferPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ShareNViewController *shareVC;

@end

@implementation myOfferPageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    NSString *page = [self currentPage];
    
    [MobClick beginLogPageView:page];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString *page = [self currentPage];

    [MobClick endLogPageView:page];
    
}

- (NSString *)currentPage{
    
    NSString *page = @"page关于";
    switch (self.pageType) {
        case myOfferPageTypeHelp:
            page = @"page帮助中心";
            break;
        default:
            break;
    }
    
    return page;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
    [self makeData];
}

- (void)makeData{

    switch (self.pageType) {
            
        case myOfferPageTypeAbout:
            [self aboutPage];
            break;
        case myOfferPageTypeHelp:
            [self helpPage];
            break;
        default:
            break;
    }
    
}

- (void)aboutPage{
    
    myOfferMenuItem *like_item = [myOfferMenuItem itemWithIcon:@"about_love" title:@"喜欢我们" arrow:true accessoryTitle:nil accessoryImage:nil active:NSStringFromSelector(@selector(caseLike))];
    
    myOfferMenuItem *share_item = [myOfferMenuItem itemWithIcon:@"about_share" title:@"分享我们" arrow:true accessoryTitle:nil accessoryImage:nil active:NSStringFromSelector(@selector(caseShare))];
    
    myOfferMenuItem *web_item = [myOfferMenuItem itemWithIcon:@"about_home" title:@"官方网站" arrow:false accessoryTitle:@"www.myoffer.cn" accessoryImage:nil active:NSStringFromSelector(@selector(caseWeb))];
    
    myOfferMenuItem *weibo_item = [myOfferMenuItem itemWithIcon:nil title:@"官方微博" arrow:false accessoryTitle:nil accessoryImage:@"about_weibo" active:NSStringFromSelector(@selector(caseWeibo))];
    
    myOfferMenuItem *weixin_item = [myOfferMenuItem itemWithIcon:nil title:@"官方微信" arrow:false accessoryTitle:nil accessoryImage:@"about_liu" active:NSStringFromSelector(@selector(caseWeixin))];
    
    myOfferMenuItem *china_item = [myOfferMenuItem itemWithIcon:nil title:@"中国支持中心" arrow:false accessoryTitle:@"4000 666 522" accessoryImage:nil active:NSStringFromSelector(@selector(caseCallIn))];
    
    myOfferMenuItem *eng_item = [myOfferMenuItem itemWithIcon:nil title:@"伦敦支持中心" arrow:false accessoryTitle:@"8000 699 799" accessoryImage:nil active:NSStringFromSelector(@selector(caseCallOut))];
    
    NSArray *first_items = @[like_item,share_item,web_item,weibo_item,weixin_item];
    NSArray *sec_items = @[china_item,eng_item];
    
    myOfferMenuGroup *first_group = [myOfferMenuGroup itemWithTitle:@"" items:first_items moreTitle:nil headerHeigh:HEIGHT_ZERO footerHeigh:HEIGHT_ZERO arrow:false active: nil];
    
    myOfferMenuGroup *sec_group = [myOfferMenuGroup itemWithTitle:@"联系我们" items:sec_items moreTitle:nil headerHeigh:Section_header_Height_nomal footerHeigh:HEIGHT_ZERO  arrow:NO active:NSStringFromSelector(@selector(caseMore:))];
    
    self.groups = @[first_group,sec_group];
 
    self.title = @"关于";
    UILabel *copyRightLab  =[[UILabel alloc] init];
    copyRightLab.font = [UIFont systemFontOfSize:14];
    copyRightLab.textColor = XCOLOR_TITLE;
    copyRightLab.textAlignment = NSTextAlignmentCenter;
    copyRightLab.text = @"CopyRight 2016 myOffer.All rights reserved.";
    [self.view insertSubview:copyRightLab atIndex:0];
    
    [copyRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    self.tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    //添加表头
    self.tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"XWGJAaboutHeader" owner:self options:nil].lastObject;
    
}

- (void)helpPage{
    
    self.title  = @"帮助中心";
    
    myOfferMenuItem *one = [myOfferMenuItem itemWithIcon:nil title:@"平台网站" arrow:true accessoryTitle:nil accessoryImage:nil active:nil];
    myOfferMenuItem *two = [myOfferMenuItem itemWithIcon:nil title:@"如何申请" arrow:true accessoryTitle:nil accessoryImage:nil active:nil];
    myOfferMenuItem *three = [myOfferMenuItem itemWithIcon:nil title:@"申请条件" arrow:true accessoryTitle:nil accessoryImage:nil active:nil];
    myOfferMenuItem *four = [myOfferMenuItem itemWithIcon:nil title:@"递交申请" arrow:true accessoryTitle:nil accessoryImage:nil active:nil];
    myOfferMenuItem *five = [myOfferMenuItem itemWithIcon:nil title:@"Offer管理" arrow:true accessoryTitle:nil accessoryImage:nil active:nil];
    myOfferMenuItem *six = [myOfferMenuItem itemWithIcon:nil title:@"操作疑问" arrow:true accessoryTitle:nil accessoryImage:nil active:nil];
    NSArray *first_items = @[one,two,three,four,five,six];
    myOfferMenuGroup *first_group = [myOfferMenuGroup itemWithTitle:@"" items:first_items moreTitle:nil headerHeigh:HEIGHT_ZERO footerHeigh:HEIGHT_ZERO arrow:false active: nil];
    self.groups = @[first_group];
 
}

- (void)makeUI{
    
    [self makeTableView];
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (ShareNViewController *)shareVC{
    
    if (!_shareVC) {
        
        _shareVC = [ShareNViewController shareView];
        [self addChildViewController:_shareVC];
        [self.view addSubview:self.shareVC.view];
        
    }
    
    return _shareVC;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    myOfferMenuGroup *group  = self.groups[section];
    
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    myofferMenuCell *cell =[myofferMenuCell cellWithTalbeView:tableView];
    myOfferMenuGroup *group  = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    [cell bottomLineWithHiden: (indexPath.row == group.items.count - 1)];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.pageType == myOfferPageTypeHelp) {
        
        WebViewController *help = [[WebViewController alloc] init];
        help.path    = [NSString stringWithFormat:@"%@faq#index=%ld",DOMAINURL,(long)indexPath.row];
        [self.navigationController pushViewController:help animated:YES];
        
        return;
    }
    
    myOfferMenuGroup *group  = self.groups[indexPath.section];
    
    myOfferMenuItem *item = group.items[indexPath.row];
    
    if (!item.active) return;
    
    [self performSelector:NSSelectorFromString(item.active) withObject:nil afterDelay:0];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    myOfferSectionHeaderView *header = [myOfferSectionHeaderView headerWithTableView:tableView];

    myOfferMenuGroup *group = self.groups[section];
    header.group = group;
    
    if(group.active.length>0){
        
        WeakSelf
        header.myOfferSectionHeaderViewBlock = ^{
            
            [weakSelf caseMore:group];
            
        };
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView  viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [UIView  new];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myOfferMenuGroup *group  = self.groups[indexPath.section];
    
    myOfferMenuItem *item  = group.items[indexPath.row];

    return  item.cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section{
    
    myOfferMenuGroup *group  = self.groups[section];
    
    return  group.header_heigh;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForFooterInSection:(NSInteger)section{

    myOfferMenuGroup *group  = self.groups[section];

    return  group.footer_heigh;
}

#pragma mark : 事件处理

- (void)caseLike{
    
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

- (void)caseMore:(myOfferMenuGroup *)group{
    
    [self performSelector:NSSelectorFromString(group.active) withObject:nil afterDelay:0];
}



- (void)dealloc
{
    KDClassLog(@"关于 dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
