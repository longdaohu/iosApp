//
//  XXiaobaiViewController.m
//  XUObject
//
//  Created by xuewuguojie on 16/4/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//




#import "XBTopToolView.h"
#import "GongLueItemCell.h"
#import "XiaobaiViewController.h"
#import "CatigorySubjectCell.h"
#import "GongLueViewController.h"
#import "CatigorySubject.h"
#import "TopNavView.h"
#import "NomalCollectionController.h"
#import "GonglueItem.h"
#import "GongLueTip.h"
#import "EmptyDataView.h"

@interface XiaobaiViewController ()<XTopToolViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TopNavView *topView;
@property(nonatomic,strong)XBTopToolView *topToolView;
//UIScrollView 背景View
@property(nonatomic,strong)UIScrollView *bgView;
//UITableView 申请攻略
@property(nonatomic,strong)MyOfferTableView *tableView;
//疑难解答 数组
@property(nonatomic,strong)NSArray *helpItems;
//申请攻略 数组
@property(nonatomic,strong)NSArray *gonglueItems;
//无数据提示
//@property(nonatomic,strong)EmptyDataView *noDataView;

@end

@implementation XiaobaiViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page留学小白"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page留学小白"];
    
}


-(NSArray *)helpItems
{
    if (!_helpItems) {
        
        CatigorySubject *one   = [CatigorySubject subjectItemInitWithIcon:@"ICON1"  title:@"平台网站"];
        CatigorySubject *two   = [CatigorySubject subjectItemInitWithIcon:@"ICON2"  title:@"如何申请"];
        CatigorySubject *three = [CatigorySubject subjectItemInitWithIcon:@"ICON3"  title:@"申请条件"];
        CatigorySubject *four  = [CatigorySubject subjectItemInitWithIcon:@"ICON4"  title:@"递交申请"];
        CatigorySubject *five  = [CatigorySubject subjectItemInitWithIcon:@"ICON5"  title:@"Offer管理"];
        CatigorySubject *six   = [CatigorySubject subjectItemInitWithIcon:@"ICON6"  title:@"操作疑问"];
        
        _helpItems = @[one,two,three,four,five,six];
        
    }
    return _helpItems;
}


#pragma mark : 加载申请攻略数据

-(void)makeDataSource:(BOOL)fresh
{
    XWeakSelf
    
    [self startAPIRequestWithSelector:kAPISelectorGonglueList parameters:nil expectedStatusCodes:nil showHUD:fresh showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf configrationUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf.tableView emptyViewWithError:@"网络请求失败，点击重新加载！"];
        
    }];
   
}

//根据网络请求结果配置UI
- (void)configrationUIWithResponse:(id)response{
    
    
    self.gonglueItems =  [GonglueItem mj_objectArrayWithKeyValuesArray:(NSArray *)response];
 
    [self.tableView emptyViewWithHiden:YES];
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeDataSource:NO];
    
    [self makeUI];
    
}


-(void)makeUI
{
    
    self.title = @"留学指南";
    
    [self makeTopView];
    
    [self makebgView];
    
    [self makeWebView];
    
    [self makeCollectView];
    
    [self makeTableView];
    
}

//顶部导航
- (void)makeTopView{
    
    CGRect topRect =  CGRectMake(0, -XNAV_HEIGHT, XSCREEN_WIDTH, XNAV_HEIGHT + 60);
    self.topView= [[TopNavView alloc] initWithFrame:topRect];
    [self.view addSubview:self.topView];
    [self makeTopToolView];
 
}


//滚动工具条
- (void)makeTopToolView{
    
    CGFloat topX = 0;
    CGFloat topY = CGRectGetMaxY(self.topView.frame) - TOP_HIGHT - ITEM_MARGIN;
    CGFloat topW = XSCREEN_WIDTH;
    CGFloat topH = TOP_HIGHT;
    self.topToolView = [[XBTopToolView alloc] initWithFrame:CGRectMake(topX, topY,topW, topH)];
    self.topToolView.itemNames =  @[@"留学流程",@"申请攻略",@"疑难解答"];
    self.topToolView.delegate  = self;
    [self.view  addSubview:self.topToolView];
}


-(void)makebgView
{
    CGFloat bgY  =  CGRectGetMaxY(self.topView.frame);
    CGFloat bgH  = XSCREEN_HEIGHT - bgY;
    CGFloat bgW  = XSCREEN_WIDTH;
    CGFloat bgX  = 0;
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(bgX,bgY, bgW,bgH)];
    bgView.delegate = self;
    bgView.bounces = NO;
    [self.view addSubview:bgView];
    bgView.contentSize = CGSizeMake(3 * XSCREEN_WIDTH, XSCREEN_HEIGHT);
    bgView.pagingEnabled = YES;
    bgView.showsHorizontalScrollIndicator = NO;
    self.bgView = bgView;

}

//添加留学流程
- (void)makeWebView{
 
    WebViewController *webVC = [[WebViewController alloc] initWithPath:[NSString stringWithFormat:@"%@study_white",DOMAINURL]];
    [self addChildViewController:webVC];
    [self.bgView addSubview:webVC.view];
    webVC.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, CGRectGetHeight(self.bgView.frame) - XNAV_HEIGHT);
    webVC.webRect = webVC.view.bounds;

}

//添加申请攻略
-(void)makeTableView{
    
    MyOfferTableView *tableView =[[MyOfferTableView alloc] initWithFrame:CGRectMake(XSCREEN_WIDTH,0, XSCREEN_WIDTH, XSCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(ITEM_MARGIN, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.bgView addSubview:tableView];
    self.tableView = tableView;
    
    XWeakSelf
    
    self.tableView.actionBlock = ^{
    
        [weakSelf makeDataSource:YES];
    };

}

//添加疑难解答
-(void)makeCollectView{
    
    NomalCollectionController *nomalCollectionVC  = [[NomalCollectionController alloc] init];
    [self addChildViewController:nomalCollectionVC];
    [self.bgView addSubview:nomalCollectionVC.view];
    nomalCollectionVC.view.frame = CGRectMake(2 * XSCREEN_WIDTH,0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
    nomalCollectionVC.items = self.helpItems;
}


#pragma mark : UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.bgView.isDragging) {
             //监听滚动，实现顶部工具条按钮切换
            CGPoint offset = scrollView.contentOffset;
            CGFloat offsetX = offset.x;
            CGFloat width = scrollView.frame.size.width;
            NSInteger pageNum =  (offsetX + .5f *  width) / width;
            [self.topToolView setSelectedIndex:pageNum];
         // 限制y轴不动
        self.bgView.contentSize =  CGSizeMake(3 * XSCREEN_WIDTH, 0);
    }
    
}
#pragma mark : UITableViewDelegate  UITableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.gonglueItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    GongLueItemCell *cell =[GongLueItemCell cellWithTableView:tableView];
    
    cell.item = self.gonglueItems[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return FLOWLAYOUT_SubW + 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     GongLueViewController  *list = [[GongLueViewController alloc] init];
    
     list.gonglue =  self.gonglueItems[indexPath.row];
    
     [self.navigationController pushViewController:list  animated:YES];
}

#pragma mark : XTopToolViewDelegate

-(void)XTopToolView:(XBTopToolView *)topToolView andButtonItem:(UIButton *)sender
{
    [self.bgView setContentOffset:CGPointMake(XSCREEN_WIDTH * sender.tag, 0) animated:YES];
}

-(void)dealloc{
    
    KDClassLog(@"留学小白  dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
