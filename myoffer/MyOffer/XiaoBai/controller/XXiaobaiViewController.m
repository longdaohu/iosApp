//
//  XXiaobaiViewController.m
//  XUObject
//
//  Created by xuewuguojie on 16/4/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//




#import "XTopToolView.h"
#import "XGongLueTableViewCell.h"
#import "XXiaobaiViewController.h"
#import "XWGJSubjectCollectionViewCell.h"
#import "DetailWebViewController.h"
#import "GonglueListViewController.h"
#import "XWGJNODATASHOWView.h"


@interface XXiaobaiViewController ()<XTopToolViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIWebViewDelegate>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)XTopToolView *topToolView;
//UIScrollView 背景View
@property(nonatomic,strong)UIScrollView *bgScrollView;
//UIWebView 留学流程
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)KDProgressHUD *hud;
//UICollectionView 疑难解答
@property(nonatomic,strong)UICollectionView *quetionCollectionView;
//UITableView 申请攻略
@property(nonatomic,strong)UITableView *TableView;
//渐变色图片
@property(nonatomic,strong)UIImage *navigationBgImage;
//疑难解答 数组
@property(nonatomic,strong)NSArray *helpItems;
//申请攻略 数组
@property(nonatomic,strong)NSArray *gonglueItems;
//无数据提示
@property(nonatomic,strong)XWGJNODATASHOWView *noDataView;

@end

@implementation XXiaobaiViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page留学小白"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page留学小白"];
    
}

//加载导航栏背影图片
-(UIImage *)navigationBgImage
{
    if (!_navigationBgImage) {
        
        NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
        
        _navigationBgImage =[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        
    }
    return _navigationBgImage;
}



-(NSArray *)helpItems
{
    if (!_helpItems) {
        
        NSDictionary *one = [self makeHelpItemWithLogoName:@"ICON1" titleName:@"平台网站"];
        NSDictionary *two = [self makeHelpItemWithLogoName:@"ICON2" titleName:@"如何申请"];
        NSDictionary *three = [self makeHelpItemWithLogoName:@"ICON3" titleName:@"申请条件"];
        NSDictionary *four = [self makeHelpItemWithLogoName:@"ICON4" titleName:@"递交申请"];
        NSDictionary *five = [self makeHelpItemWithLogoName:@"ICON5" titleName:@"Offer管理"];
        NSDictionary *six = [self makeHelpItemWithLogoName:@"ICON6" titleName:@"操作疑问"];
        
        _helpItems = @[one,two,three,four,five,six];
        
    }
    return _helpItems;
}

//数据为空时出现
-(XWGJNODATASHOWView *)noDataView
{
    if (!_noDataView) {
        
        XJHUtilDefineWeakSelfRef
        
        _noDataView =[[XWGJNODATASHOWView alloc] initWithFrame:CGRectMake(0, -200, XScreenWidth, XScreenHeight)];
        
        _noDataView.bgViewY = 100;
        
        _noDataView.ActionBlock = ^{
            
             [weakSelf makeDataSource:YES];
        };
     }
    return _noDataView;
}



-(NSDictionary *)makeHelpItemWithLogoName:(NSString *)logoName titleName:(NSString *)title
{
    NSMutableDictionary *item =[NSMutableDictionary dictionary];
    [item setValue:title forKey:@"title"];
    [item setValue:logoName forKey:@"logo"];
    
    return [item copy];
}


-(void)makeUI
{
   
    self.title = @"留学小白";
    
    [self makeTopView];
    
    [self makebgScrollView];
    
}


//加载申请攻略数据
-(void)makeDataSource:(BOOL)fresh
{
    
    [self startAPIRequestWithSelector:@"GET http://public.myoffer.cn/docs/zh-cn/tips.json" parameters:nil expectedStatusCodes:nil showHUD:fresh showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        
        self.gonglueItems =  (NSArray *)response;
        
        self.TableView.tableFooterView = nil;
        
        [self.TableView reloadData];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.TableView.tableFooterView = self.noDataView;
        
    }];
   
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeDataSource:NO];
    
    [self makeUI];
    
}




-(void)makeTopView
{
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, XScreenWidth, 124)];
    self.topView.backgroundColor = XCOLOR_RED;
    [self.view addSubview:self.topView];
 
    UIImageView *topImageView =[[UIImageView alloc] initWithFrame:self.topView.bounds];
    topImageView.image = self.navigationBgImage;
    topImageView.contentMode =UIViewContentModeScaleToFill;
    [self.topView addSubview:topImageView];
    
    [self makeTopToolView];
    
}


-(void)makeTopToolView
{
    self.topToolView = [[XTopToolView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) - TOP_HIGHT -10,XScreenWidth, TOP_HIGHT)];
    self.topToolView.delegate  = self;
    [self.view  addSubview:self.topToolView];
}

-(void)makebgScrollView
{
    CGFloat bgsY  =  CGRectGetMaxY(self.topView.frame);
    CGFloat height  = XScreenHeight - bgsY;
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,bgsY, XScreenWidth,height)];
    self.bgScrollView.delegate = self;
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.contentSize = CGSizeMake(3 * XScreenWidth, XScreenHeight);
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;

    
    [self makeWebViewWithHeight:height];
    
    [self makeCollectView];

    [self makeTableView];
}

-(void)makeWebViewWithHeight:(CGFloat)height
{
    self.webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, height -64)];
    [self.bgScrollView addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.myoffer.cn/study_white"]]];
    self.webView.backgroundColor = BACKGROUDCOLOR;
    self.webView.delegate=self;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scalesPageToFit = YES;
    
}

-(void)makeTableView
{
    self.TableView =[[UITableView alloc] initWithFrame:CGRectMake(XScreenWidth,0, XScreenWidth, XScreenHeight) style:UITableViewStylePlain];
    self.TableView.backgroundColor = BACKGROUDCOLOR;
    self.TableView.contentInset = UIEdgeInsetsMake(ITEM_MARGIN, 0, 0, 0);
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.bgScrollView addSubview:self.TableView];
    self.TableView.tableFooterView =[[UIView alloc] init];
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

static NSString *subjectIdentify = @"subjectCell";
-(void)makeCollectView
{
    CGRect subRect = CGRectMake(2 * XScreenWidth, 0, XScreenWidth, XScreenHeight);
    self.quetionCollectionView = [self makeCollectionViewWithFlowayoutWidth:FLOWLAYOUT_SubW andFrame:subRect andcontentInset:UIEdgeInsetsMake(ITEM_MARGIN + 2, 0, 0, 0)];
    UINib *sub_xib = [UINib nibWithNibName:@"XWGJSubjectCollectionViewCell" bundle:nil];
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
    flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowlayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = BACKGROUDCOLOR;
    collectionView.contentInset = Inset;
    
    [self.bgScrollView addSubview:collectionView];
    
    return collectionView;
}


#pragma mark ———————— UIScrollViewDelegate
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
        self.bgScrollView.contentSize =  CGSizeMake(3 * XScreenWidth, 0);
    }
    
    
}

#pragma mark ———————— UITableViewData UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.gonglueItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    XGongLueTableViewCell *cell =[XGongLueTableViewCell cellWithTableView:tableView];
    
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
     GonglueListViewController  *list = [[GonglueListViewController alloc] init];
     list.navigationBgImage           =  self.navigationBgImage;
     list.gonglue                     =  self.gonglueItems[indexPath.row];
     [self.navigationController pushViewController:list  animated:YES];
}


#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.helpItems.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        XWGJSubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:subjectIdentify forIndexPath:indexPath];
        cell.helpItem =self.helpItems[indexPath.row];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
 
        return CGSizeMake(0, 0);
 }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
    DetailWebViewController *helpDetail = [[DetailWebViewController alloc] init];
    helpDetail.navigationBgImage = self.navigationBgImage;
    helpDetail.index = indexPath.row;
    [self.navigationController pushViewController:helpDetail animated:YES];
    
}

#pragma mark —————— XTopToolViewDelegate
-(void)XTopToolView:(XTopToolView *)topToolView andButtonItem:(UIButton *)sender
{
    [self.bgScrollView setContentOffset:CGPointMake(XScreenWidth*sender.tag, 0) animated:YES];
    
}

#pragma mark ——————UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    self.hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hud removeFromSuperViewOnHide];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //加载完成后重新设置 tableview的cell的高度,和webview的frame
     [self.hud hideAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [self.hud hideAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

