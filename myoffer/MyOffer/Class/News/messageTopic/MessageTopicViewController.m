//
//  MessageTopicViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageTopicViewController.h"
#import "MyOfferArticle.h"
#import "XWGJMessageFrame.h"
#import "MessageCell.h"
#import "MessageDetaillViewController.h"
#import "UniversityNavView.h"
#import "MessgeTopicModel.h"
#import "XWGJMessageFrame.h"


@interface MessageTopicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MessgeTopicModel *topicModel;
@property(nonatomic,strong)NSMutableArray *messageFrames;
@property(nonatomic,strong)UniversityNavView *topNavigationView;
@property(nonatomic,strong)UIImageView *flexibleView;
@property(nonatomic,assign)CGRect flexFrame_old;
@property(nonatomic,assign)CGPoint flexCenter_old;
@end

@implementation MessageTopicViewController

- (NSMutableArray *)messageFrames{

    if (!_messageFrames) {
     
        _messageFrames = [NSMutableArray  array];
    }
    
    return _messageFrames;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [MobClick beginLogPageView:@"page资讯专题"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯专题"];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeData];
    
    [self makeUI];
}

- (void)makeData{

    NSString *path = [NSString stringWithFormat:@"GET api/topic/%@",self.topic_id];
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
 
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [MBProgressHUD showError:@"网络请求失败" toView:self.view];
        
        [weakSelf dismiss];
        
    }];
    
}


- (void)updateUIWithResponse:(id)response{

    self.topicModel = [MessgeTopicModel mj_objectWithKeyValues:response];
    
    for(MyOfferArticle *article in self.topicModel.articles){
        
        XWGJMessageFrame *messageFrame =  [XWGJMessageFrame messageFrameWithMessage:article];
        
        [self.messageFrames addObject:messageFrame];
        
        [self.tableView reloadData];
        
    }
    
    self.topNavigationView.titleName = self.topicModel.title;
    
    NSString *path = @"http://zx.youdao.com/zx/wp-content/uploads/2013/11/1120oral-pic.jpg";
    //        NSString *path = weakSelf.topicModel.cover_url;
    [self.flexibleView sd_setImageWithURL:[NSURL URLWithString:path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
}

- (void)makeUI{

    [self makeTableView];
    [self makeTopNavigaitonView];
    [self makeFlexiableView];
    
}

//添加自定义顶部导航
-(void)makeTopNavigaitonView{
    
    XWeakSelf
    UniversityNavView *nav = [UniversityNavView ViewWithBlock:^(UIButton *sender) {
        
        [weakSelf navigationItemWithSender:sender];
    }];
    
    self.topNavigationView = nav;
    nav.titleName = self.topicModel.title;
    [nav navigationWithRightViewHiden:YES];
    [nav navigationWithQQHiden:YES];
    [self.view insertSubview:nav aboveSubview:self.tableView];
    
}

#pragma mark :   navigationView 点击事件
- (void)navigationItemWithSender:(UIButton *)sender{
    
    if (sender.tag ==  NavItemStyleQQ) {
        
        
    }else{
        
        [self dismiss];
    }
    
}


//头部下拉图片
- (void)makeFlexiableView{
    
    
    UIImageView *flexibleView = [[UIImageView alloc] init];
        flexibleView.contentMode = UIViewContentModeScaleAspectFill;
    //    flexibleView.contentMode = UIViewContentModeScaleAspectFit;
//    CGFloat iconHeight =  XSCREEN_WIDTH * FlexibleImg.size.height / FlexibleImg.size.width;
    flexibleView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, AdjustF(200.f));
    [self.view insertSubview:flexibleView belowSubview:self.tableView];
    self.flexibleView = flexibleView;
    self.flexFrame_old = self.flexibleView.frame;
    self.flexCenter_old = flexibleView.center;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:flexibleView.frame];

}


-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  Uni_Cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageFrames.count;
}

static NSString *identify = @"cell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell =[MessageCell cellWithTableView:tableView];
    
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    [cell separatorLineShow:(self.messageFrames.count - 1 == indexPath.row)];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWGJMessageFrame  *messageFrame  = self.messageFrames[indexPath.row];
    [self.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:messageFrame.News.message_id] animated:YES];
}


#pragma mark :  UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offersetY =  scrollView.contentOffset.y;
    
    //导航栏显示隐藏
    [self.topNavigationView scrollViewContentoffset:offersetY  andContenHeight:self.flexibleView.bounds.size.height - XNAV_HEIGHT];
    
    self.topNavigationView.nav_Alpha =  offersetY / (self.flexibleView.bounds.size.height - XNAV_HEIGHT);
    
    //下拉图片处理
    if (offersetY > 0) {
        
        
        self.flexibleView.frame = self.flexFrame_old;
        
        self.flexibleView.mj_y = -offersetY;
        
        return;
    }
    
    CGRect newRect = self.flexFrame_old;
    
    newRect.size.height = self.flexFrame_old.size.height - offersetY * 2;
    
    newRect.size.width  = self.flexFrame_old.size.width * newRect.size.height / self.flexFrame_old.size.height;
    
    self.flexibleView.frame = newRect;
    
    self.flexibleView.center = self.flexCenter_old;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
