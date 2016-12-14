//
//  XXiaobaiViewController.m
//  XUObject
//
//  Created by xuewuguojie on 16/4/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//




#import "XBTopToolView.h"
#import "GongLueTableViewCell.h"
#import "XiaobaiViewController.h"
#import "CatigorySubjectCell.h"
#import "GongLueViewController.h"
#import "XWGJNODATASHOWView.h"
#import "CatigorySubject.h"
#import "TopNavView.h"


@interface XiaobaiViewController ()<XTopToolViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)TopNavView *topView;
@property(nonatomic,strong)XBTopToolView *topToolView;
//UIScrollView 背景View
@property(nonatomic,strong)UIScrollView *bgScrollView;
//UIWebView 留学流程
@property(nonatomic,strong)KDProgressHUD *hud;
//UICollectionView 疑难解答
@property(nonatomic,strong)UICollectionView *quetionCollectionView;
//UITableView 申请攻略
@property(nonatomic,strong)UITableView *TableView;
//疑难解答 数组
@property(nonatomic,strong)NSArray *helpItems;
//申请攻略 数组
@property(nonatomic,strong)NSArray *gonglueItems;
//无数据提示
@property(nonatomic,strong)XWGJNODATASHOWView *noDataView;

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
        
        CatigorySubject *one   = [CatigorySubject subjectItemInitWithIconName:@"ICON1"  TitleName:@"平台网站"];
        CatigorySubject *two   = [CatigorySubject subjectItemInitWithIconName:@"ICON2"  TitleName:@"如何申请"];
        CatigorySubject *three = [CatigorySubject subjectItemInitWithIconName:@"ICON3"  TitleName:@"申请条件"];
        CatigorySubject *four  = [CatigorySubject subjectItemInitWithIconName:@"ICON4"  TitleName:@"递交申请"];
        CatigorySubject *five  = [CatigorySubject subjectItemInitWithIconName:@"ICON5"  TitleName:@"Offer管理"];
        CatigorySubject *six   = [CatigorySubject subjectItemInitWithIconName:@"ICON6"  TitleName:@"操作疑问"];
        
        _helpItems = @[one,two,three,four,five,six];
        
    }
    return _helpItems;
}


//数据为空时出现
-(XWGJNODATASHOWView *)noDataView
{
    if (!_noDataView) {
        
        XWeakSelf
        
        _noDataView =[[XWGJNODATASHOWView alloc] initWithFrame:CGRectMake(0, -200, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
        
        _noDataView.bgViewY = 100;
        
        _noDataView.ActionBlock = ^{
            
             [weakSelf makeDataSource:YES];
        };
     }
    return _noDataView;
}



//加载申请攻略数据
-(void)makeDataSource:(BOOL)fresh
{
    XWeakSelf
    
    [self startAPIRequestWithSelector:kAPISelectorGonglueList parameters:nil expectedStatusCodes:nil showHUD:fresh showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf configrationUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        weakSelf.TableView.tableFooterView = self.noDataView;
        
    }];
   
}

//根据网络请求结果配置UI
-(void)configrationUIWithResponse:(id)response
{
    self.gonglueItems =  (NSArray *)response;
    
    self.TableView.tableFooterView = [UIView new];
    
    [self.TableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeDataSource:NO];
    
    [self makeUI];
    
}

-(void)makeUI
{
    
    self.title = @"留学小白";
    
    [self makeTopView];
    
    [self makebgScrollView];
    
}


-(void)makeTopView
{
    
    self.topView= [[TopNavView alloc] initWithFrame:CGRectMake(0, -XNAV_HEIGHT, XSCREEN_WIDTH, XNAV_HEIGHT + 60)];
    [self.view addSubview:self.topView];
    
    [self makeTopToolView];
    
}


//滚动工具条
-(void)makeTopToolView
{
    self.topToolView = [[XBTopToolView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) - TOP_HIGHT - ITEM_MARGIN,XSCREEN_WIDTH, TOP_HIGHT)];
    self.topToolView.itemNames =  @[@"留学流程",@"申请攻略",@"疑难解答"];
    self.topToolView.delegate  = self;
    [self.view  addSubview:self.topToolView];
}


-(void)makebgScrollView
{
    CGFloat bgsY  =  CGRectGetMaxY(self.topView.frame);
    CGFloat bgsH  = XSCREEN_HEIGHT - bgsY;
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,bgsY, XSCREEN_WIDTH,bgsH)];
    self.bgScrollView.delegate = self;
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.contentSize = CGSizeMake(3 * XSCREEN_WIDTH, XSCREEN_HEIGHT);
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;

    
    [self makeWebViewWithHeight:bgsH];
    
    [self makeCollectView];

    [self makeTableView];
}

//添加留学流程
- (void)makeWebViewWithHeight:(CGFloat)height
{
 
    WebViewController *webVC = [[WebViewController alloc] init];
    [self addChildViewController:webVC];
    webVC.path = [NSString stringWithFormat:@"%@study_white",DOMAINURL];
    [self.bgScrollView addSubview:webVC.view];
    webVC.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, height - XNAV_HEIGHT);
    webVC.web_wk.frame = webVC.view.bounds;
    
}

//添加申请攻略
-(void)makeTableView
{
    self.TableView =[[UITableView alloc] initWithFrame:CGRectMake(XSCREEN_WIDTH,0, XSCREEN_WIDTH, XSCREEN_HEIGHT) style:UITableViewStylePlain];
    self.TableView.backgroundColor = XCOLOR_BG;
    self.TableView.contentInset = UIEdgeInsetsMake(ITEM_MARGIN, 0, 0, 0);
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.bgScrollView addSubview:self.TableView];
    self.TableView.tableFooterView =[[UIView alloc] init];
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

//添加疑难解答
static NSString *subjectIdentify = @"subjectCell";
-(void)makeCollectView
{
    CGRect subRect = CGRectMake(2 * XSCREEN_WIDTH, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
    self.quetionCollectionView = [self makeCollectionViewWithFlowayoutWidth:FLOWLAYOUT_SubW andFrame:subRect andcontentInset:UIEdgeInsetsMake(ITEM_MARGIN + 2, ITEM_MARGIN, 0, ITEM_MARGIN)];
    UINib *sub_xib = [UINib nibWithNibName:@"CatigorySubjectCell" bundle:nil];
    [self.quetionCollectionView registerNib:sub_xib forCellWithReuseIdentifier:subjectIdentify];
}

//创建CollectionView公共方法
-(UICollectionView *)makeCollectionViewWithFlowayoutWidth:(CGFloat)width andFrame:(CGRect)frame andcontentInset:(UIEdgeInsets)Inset
{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每一个cell的宽高 (cell在CollectionView中称之为item)
    flowlayout.itemSize = CGSizeMake(width, width);
    // 设置item行与行之间的间隙
    flowlayout.minimumLineSpacing = ITEM_MARGIN;
    // 设置item列与列之间的间隙
    //    flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
//    flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowlayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = XCOLOR_BG;
    collectionView.contentInset = Inset;
    
    [self.bgScrollView addSubview:collectionView];
    
    return collectionView;
}


#pragma mark ——— UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.bgScrollView.isDragging) {
        
             //监听滚动，实现顶部工具条按钮切换
            CGPoint offset = scrollView.contentOffset;
            
            CGFloat offsetX = offset.x;
            
            CGFloat width = scrollView.frame.size.width;
            
            NSInteger pageNum =  (offsetX + .5f *  width) / width;
            
            [self.topToolView SelectButtonIndex:pageNum];
        
         // 限制y轴不动
        self.bgScrollView.contentSize =  CGSizeMake(3 * XSCREEN_WIDTH, 0);
    }
    
    
}

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.gonglueItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    GongLueTableViewCell *cell =[GongLueTableViewCell cellWithTableView:tableView];
    
    cell.item = self.gonglueItems[indexPath.row];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return FLOWLAYOUT_SubW + 10;;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     GongLueViewController  *list = [[GongLueViewController alloc] init];
    
     list.gonglue                 =  self.gonglueItems[indexPath.row];
    
     [self.navigationController pushViewController:list  animated:YES];
}


#pragma mark ——— UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.helpItems.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CatigorySubjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:subjectIdentify forIndexPath:indexPath];

    cell.subject = self.helpItems[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 
        return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
    WebViewController *help = [[WebViewController alloc] init];
    
    help.path    = [NSString stringWithFormat:@"%@faq#index=%ld",DOMAINURL,(long)indexPath.row];
    
    [self.navigationController pushViewController:help animated:YES];
    
}


#pragma mark ——— XTopToolViewDelegate

-(void)XTopToolView:(XBTopToolView *)topToolView andButtonItem:(UIButton *)sender
{
    [self.bgScrollView setContentOffset:CGPointMake(XSCREEN_WIDTH * sender.tag, 0) animated:YES];
}

-(void)dealloc{
    
    KDClassLog(@"留学小白  dealloc");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

