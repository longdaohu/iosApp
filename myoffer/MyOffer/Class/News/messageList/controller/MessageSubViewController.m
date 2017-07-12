//
//  MessageSubViewController.m
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import "MessageSubViewController.h"
#import "messageCatigroyModel.h"
#import "MessageTopicView.h"
#import "MessageTopicModel.h"
#import "MessageTopiccGroup.h"
#import "MyOfferArticle.h"
#import "MessageCell.h"
#import "XWGJMessageFrame.h"
#import "MyofferSectionView.h"
#import "MessageTopicFooterView.h"
#import "MessageDetaillViewController.h"
#import "MessageCountryViewController.h"


@interface MessageSubViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)MessageTopicView *topicView;
@property(nonatomic,strong)UIScrollView  *bgView;
@property(nonatomic,strong)NSArray *group;
@property(nonatomic,strong)MessageTopiccGroup *topic_group_current;
@property(nonatomic,strong)UITableView *superView;

@end

@implementation MessageSubViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
 
}


- (void)makeUI{

    
    self.topicView = [[MessageTopicView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 60)];
    
    [self.view addSubview:self.topicView];
    
    __weak typeof(self) weakSelf = self;
    
    self.topicView.actionBlock = ^(NSString *code,NSInteger index){
    
        [weakSelf makeDataWithCatigoryIndex:index];
        
        [weakSelf superViewHeaderViewHiden];

    };
    
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topicView.mj_h, XSCREEN_WIDTH, XSCREEN_HEIGHT - self.topicView.mj_h)];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    bgView.delegate = self;
    bgView.backgroundColor = XCOLOR_BG;
    bgView.pagingEnabled = YES;
    
}

- (void)setCell_Height:(CGFloat)cell_Height{
    
    _cell_Height = cell_Height;
    
    self.view.mj_h = cell_Height;
    
    self.view.clipsToBounds= YES;
    
    self.bgView.mj_h = self.view.mj_h - self.bgView.mj_y;
    
}


- (void)setCatigories:(NSArray *)catigories{

    _catigories = catigories;
    
    self.topicView.catigories = catigories;
    
    messageCatigroyModel *catigory = catigories.firstObject;
    
    [self makeDataWithCatigoryCode:catigory.code];
    
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *tempes = [NSMutableArray array];
    for (NSInteger index = 0; index < catigories.count; index++) {
    
    
        UITableView *tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.mj_x = index * self.bgView.mj_w;
        tableView.mj_h = self.bgView.mj_h;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView =[[UIView alloc] init];
        [self.bgView addSubview:tableView];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.tag = 0;
        tableView.scrollEnabled = NO;
        [tempes addObject:[MessageTopiccGroup  groupWithIndex:index]];
        
    }
 
    self.group = [tempes copy];
    
    
    self.bgView.contentSize = CGSizeMake(self.bgView.subviews.count * self.bgView.mj_w, 0);
}


//让背景滚动条移到对应页面
- (void)bgViewScrollToPage:(NSInteger)page{
     //1  动画效果不会太突然  滚动 uiscrollView
    CGFloat distance =  fabs((page * self.bgView.mj_w -  self.bgView.contentOffset.x));
    BOOL animate = distance > self.bgView.mj_w ? NO : YES;
    [self.bgView setContentOffset:CGPointMake(page * self.bgView.mj_w, 0) animated:animate];
}

//导航栏点击选项网络请求
- (void)makeDataWithCatigoryIndex:(NSInteger)index{
    
    messageCatigroyModel *catigory = self.catigories[index];
    
    //3 背景滚动到对应页面
    [self bgViewScrollToPage:index];
    
    //2  如果对应选项已布在数据，不再网络请求
    MessageTopiccGroup *topic_group = self.group[index];
    
    if (topic_group.topic.count > 0) {
        
        self.topic_group_current  = topic_group;
        UITableView *table = self.bgView.subviews[index];
        //每次点击，回到表格顶部
        [table setContentOffset:CGPointZero animated:NO];
        [table reloadData];
        
        return;
    }
    
    // 3  发起网络请求
    [self makeDataWithCatigoryCode:catigory.code];
    
}


//根据对应专题选项网络请求
- (void)makeDataWithCatigoryCode:(NSString *)code{

    NSDictionary *pass = @{@"category" : code};
    
    XWeakSelf
    
    [self startAPIRequestWithSelector:@"GET api/articles/index"  parameters:pass success:^(NSInteger statusCode, id response) {
        
        NSArray *topic = [MessageTopicModel mj_objectArrayWithKeyValuesArray:response];
        
        NSArray *codes =[self.catigories valueForKeyPath:@"code"];
        
        NSInteger index = [codes indexOfObject:code];
        
        weakSelf.topic_group_current = self.group[index];
        
        weakSelf.topic_group_current.topic = topic;

        UITableView *table =  weakSelf.bgView.subviews[index];
        
        [table reloadData];
        

    }];
  
}



#pragma mark :  UITableViewDelegate,UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTopicModel *topic = self.topic_group_current.topic[indexPath.section];
    
    XWGJMessageFrame *frame  = topic.messageFrames[indexPath.row];
    
    return frame.cell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.topic_group_current.topic.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    MessageTopicModel *topic = self.topic_group_current.topic[section];
    
    return topic.articles.count;
}

static NSString *identify = @"topic";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    
    MessageTopicModel *topic = self.topic_group_current.topic[indexPath.section];
    
    cell.messageFrame  = topic.messageFrames[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
     MessageTopicModel *topic = self.topic_group_current.topic[section];
  
     MessageTopicFooterView *fooer = [MessageTopicFooterView fooerWithTitle:topic.category  action:^{
         
         MessageCountryViewController *topicVC = [[MessageCountryViewController  alloc] init];
         
         topicVC.countryName = topic.category;
         
        [self.navigationController pushViewController:topicVC animated:YES];
         
     }];
    
    
    return fooer;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    MyofferSectionView *sectionView = [[MyofferSectionView alloc] init];
    
//    NSLog(@">>>>>>viewForHeaderInSection>>>>>  %ld",self.topic_group_current.index);
    
    MessageTopicModel *topic = self.topic_group_current.topic[section];

    sectionView.title = topic.category;
    
    
    return sectionView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageTopicModel *topic = self.topic_group_current.topic[indexPath.section];
    
     XWGJMessageFrame *messageFrame  = topic.messageFrames[indexPath.row];
    
    MessageDetaillViewController *detail = [[MessageDetaillViewController alloc] initWithMessageId:messageFrame.News.message_id];
    
    [self.navigationController pushViewController:detail  animated:YES];
    
}




#pragma mark : UIScrollViewDelege

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    if (scrollView == self.bgView) {
          //1 滚动到对应页面
//        [self.topicView superViewScrollViewDidScrollContentOffset:scrollView.contentOffset];
     }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgView) {
        
        //1 监听滚动，实现顶部工具条按钮切换
        CGFloat offsetX = scrollView.contentOffset.x;
        
        CGFloat width = scrollView.frame.size.width;
        
        NSInteger index =  (offsetX + .5f *  width) / width;
        
        //2 滚动到对应页面
        [self.topicView secrollToCatigoryIndex:index];
  
        //3 背景滚动到对应页面
        [self bgViewScrollToPage:index];
        
        //5 请求数据
        [self makeDataWithCatigoryIndex:index];
     
    }
    
}


- (void)superViewScroll:(UITableView * )superView contentOffsetY:(CGFloat)Y{
    
    self.superView = superView;
    
    //监听 父视图滚动
    if (Y > superView.tableHeaderView.mj_h) {
        
        [superView setContentOffset:CGPointMake(0, superView.tableHeaderView.mj_h) animated:NO];
        
        superView.scrollEnabled = NO;
        
        for (UITableView *table in self.bgView.subviews) {
            
            table.scrollEnabled = YES;
  
        }
        
    }
    
}



- (void)superViewHeaderViewHiden{
    
    if (!self.superView.scrollEnabled) {
        
        return;
    }
    
    self.superView.scrollEnabled = NO;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.superView.contentOffset = CGPointMake(0, self.superView.tableHeaderView.mj_h);
        
    }];
    
    for (UITableView *table in self.bgView.subviews) {
        
        table.scrollEnabled = YES;
        
    }
}

- (void)superViewScrollEnable:(BOOL)enable{

    
    if (enable) {
        
        self.superView.scrollEnabled = YES;
    
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
    
            self.superView.contentOffset = CGPointZero;
        }];
        
        
        for (UITableView *table in self.bgView.subviews) {
            
            table.scrollEnabled = NO;
            
            [table setContentOffset:CGPointZero animated:YES];
            
        }
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end



