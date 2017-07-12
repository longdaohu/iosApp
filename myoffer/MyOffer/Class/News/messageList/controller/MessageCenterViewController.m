//
//  MessageCenterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCell.h"
#import "messageCatigroyModel.h"
#import "XWGJMessageFrame.h"
#import "MessageTopicHeaderViewController.h"
#import "MessageSubViewController.h"
#import "MessageHotTopicMedel.h"

@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *messageCatigroies;
@property(nonatomic,strong)NSMutableArray *messageFrames;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *tableViewHeader;
@property(nonatomic,strong)MessageTopicHeaderViewController *messageHeaderView;
@property(nonatomic,strong)MessageSubViewController *subVC;
@property(nonatomic,strong)UIButton *leftBtn;

@end

@implementation MessageCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page资讯中心"];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯中心"];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.messageFrames = [NSMutableArray array];
    
    [self makeUI];
    
    [self makeData];
  
}

- (void)makeUI{
    
    [self makeTableView];
    
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.leftBtn setImage:XImage(@"search_icon_gray") forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn.tag = 0;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
 
    
}

- (void)makeData{
    
    [self startAPIRequestWithSelector:@"GET api/hot-article-topics" parameters:nil success:^(NSInteger statusCode, id response) {
        
        self.messageHeaderView.topices  = [MessageHotTopicMedel mj_objectArrayWithKeyValuesArray:response[@"items"]];
        
    }];
    
 
    [self startAPIRequestWithSelector:kAPISelectorArticleCatigoryIndex  parameters:nil success:^(NSInteger statusCode, id response) {
        
        self.messageCatigroies  = [messageCatigroyModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
        
        self.subVC.catigories = self.messageCatigroies;
        
    }];
    
 
    
    
    
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.mj_h = XSCREEN_HEIGHT - XNAV_HEIGHT - 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    self.messageHeaderView = [[MessageTopicHeaderViewController alloc] init];
    [self addChildViewController:self.messageHeaderView];
    self.messageHeaderView.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_WIDTH * 0.3 + 50);
    self.messageHeaderView.header_Height = XSCREEN_WIDTH * 0.3 + 50;
    
    self.tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_WIDTH * 0.3 + 50)];
    self.tableView.tableHeaderView = self.tableViewHeader ;
    [self.tableViewHeader addSubview:self.messageHeaderView.view];

    
    
    self.subVC = [[MessageSubViewController alloc] init];
    [self addChildViewController:self.subVC];
    self.subVC.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, self.tableView.mj_h);
    self.subVC.cell_Height =  self.tableView.mj_h;
    [self.subVC superViewScroll:self.tableView contentOffsetY:0];
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.contentView.backgroundColor = [UIColor redColor];
    
    [cell.contentView addSubview:self.subVC.view];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  self.subVC.cell_Height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
//    NSLog(@">>>>>> %lf",scrollView.contentOffset.y);
    
    [self.subVC superViewScroll:self.tableView contentOffsetY:scrollView.contentOffset.y];
    
    if (scrollView.contentOffset.y >= self.tableView.tableHeaderView.mj_h) {
        
        if (self.leftBtn.tag == 0) {
            
            self.leftBtn.tag = DEFAULT_NUMBER;
            [self.leftBtn setImage:XImage(@"close_button") forState:UIControlStateNormal];
        }
        
    }else{
    
        self.leftBtn.tag = 0;
 
    }
    
}


-(void)leftOnClick:(UIBarButtonItem *)item{

    
    if (item.tag == 0) {
        
    }else{
    
        [self.subVC superViewScrollEnable:YES];
     
        [self.leftBtn setImage:XImage(@"search_icon_gray") forState:UIControlStateNormal];
        
        self.leftBtn.tag = 0;

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

