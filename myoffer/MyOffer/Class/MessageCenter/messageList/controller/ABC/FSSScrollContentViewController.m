//
//  FSSScrollContentViewController.m
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/14.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import "FSSScrollContentViewController.h"
#import "MyofferSectionView.h"
#import "MessageTopicFooterView.h"
#import "MessageTopicModel.h"
#import "MyOfferArticle.h"
#import "MessageCell.h"
#import "MyofferMessageFrame.h"
#import "MessageDetaillViewController.h"
#import "MessageCountryTopicVController.h"

@interface FSSScrollContentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL fingerIsTouch;


@end

@implementation FSSScrollContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[MyOfferTableView alloc]initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, XTabBarHeight + XNAV_HEIGHT + 50, 0);
    _tableView.emptyY = 60;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
}


- (void)setGroup:(MessageTopiccGroup *)group{
 
    _group = group;
    
    [self.tableView emptyViewWithHiden:!(group.contents.count == 0)];
    
    if (group.contents.count == 0) {
        
        [self.tableView emptyViewWithError:NetRequest_NoDATA];
        
    }else{
    
        [self.tableView emptyViewWithHiden:YES];

    }
    
    [self.tableView reloadData];
  
}

- (void)showError:(NSString *)error{

    
    if (error.length > 0) {
        
        [self.tableView emptyViewWithError:error];

    }else{
    
         [self.tableView emptyViewWithError:NetRequest_ConnectError];

    }

}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.group.contents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MessageTopicModel *topic =   self.group.contents[section];
    
    return topic.articles.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Section_header_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    MessageTopicModel *topic =   self.group.contents[section];

    return  (topic.articles.count >= 4) ? 60 : Section_footer_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTopicModel *topic =   self.group.contents[indexPath.section];
    
    MyofferMessageFrame *messageFrame =  topic.messageFrames[indexPath.row];
    
    return messageFrame.cell_Height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //分区View;
    MessageTopicModel *topic =   self.group.contents[section];
    
    MessageTopicFooterView *footer = [MessageTopicFooterView fooerWithTitle:topic.category action:^{
        
        MessageCountryTopicVController *country = [[MessageCountryTopicVController alloc] init];
        
        country.countryName = topic.category;
        
        [self.navigationController pushViewController:country animated:YES];
        
    }];
    
    footer.alpha = (topic.articles.count >= 4);
    
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //分区View;
    MyofferSectionView *sectionView = [[MyofferSectionView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH,Section_header_Height_nomal)];
    MessageTopicModel *topic =   self.group.contents[section];
    sectionView.title = topic.category;
    [self.view addSubview: sectionView];
    
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //2 正常展示数据
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    
    MessageTopicModel *topic =   self.group.contents[indexPath.section];
    
    cell.messageFrame =  topic.messageFrames[indexPath.row];
    
    BOOL padding = !((topic.messageFrames.count - 1) == indexPath.row);
    
    [cell separatorLinePaddingShow: padding];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    MessageTopicModel *topic =   self.group.contents[indexPath.section];
    
     MyofferMessageFrame *messageFrame =  topic.messageFrames[indexPath.row];
    
    MessageDetaillViewController *vc = [[MessageDetaillViewController alloc] initWithMessageId:messageFrame.News.message_id];
    
    [self.navigationController pushViewController:vc  animated:YES];
    
}




#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    KDClassLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    KDClassLog(@"离开屏幕");
    self.fingerIsTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (!self.vcCanScroll) {
        
        scrollView.contentOffset = CGPointZero;
        
    }
    
    if (scrollView.contentOffset.y <= 0) {
        
        //        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
        //            return;
        //        }
        
        self.vcCanScroll = NO;
        
        scrollView.contentOffset = CGPointZero;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll ? YES : NO;
}



@end

