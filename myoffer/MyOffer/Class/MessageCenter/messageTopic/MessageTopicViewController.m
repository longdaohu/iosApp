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
#import "XWGJMessageFrame.h"
#import "myofferFlexibleView.h"


@interface MessageTopicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UniversityNavView *topNavigationView;
@property(nonatomic,strong)myofferFlexibleView *flexView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)NSMutableArray *messageFrames;

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
    
    [MobClick beginLogPageView:@"page资讯热门专题"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯热门专题"];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeData];
    
    [self makeUI];
}

- (void)makeData{

    NSString *path = [NSString stringWithFormat:@"%@%@",kAPISelectorArticleTopic,self.topic_id];
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
 
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [MBProgressHUD showError:@"网络请求失败" toView:self.view];
        
        [weakSelf dismiss];
        
    }];
    
}


- (void)updateUIWithResponse:(id)response{
    
    NSArray *articles = [MyOfferArticle mj_objectArrayWithKeyValuesArray:response[@"articles"]];
    
    for(MyOfferArticle *article in articles){
        
        XWGJMessageFrame *messageFrame =  [XWGJMessageFrame messageFrameWithMessage:article];
        
        [self.messageFrames addObject:messageFrame];
        
    }
    
    [self.tableView reloadData];
    
    
    
    NSString *title = response[@"title"];
    self.topNavigationView.titleName = title;
    
    
    
    self.flexView.image_url = response[@"cover_url"];
    [UIView animateWithDuration:ANIMATION_DUATION * 2 animations:^{
        
        self.flexView.alpha = 1;
    }];
    
    
    
    NSShadow *shadow=[[NSShadow alloc]init];
    shadow.shadowBlurRadius= 3;//阴影的模糊程度
    shadow.shadowColor= XCOLOR_BLACK;//阴影颜色
    shadow.shadowOffset=CGSizeMake(2, 2);//阴影相对原来的偏移
    NSDictionary* attrs =@{
                           NSShadowAttributeName:shadow,//设置阴影，复制为一个NSShadow 的对象
                           };
    
    self.titleLab.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attrs];
    
}

- (void)makeUI{

    [self makeTableView];
    [self makeFlexiableView];
    [self makeTopNavigaitonView];
    self.view.clipsToBounds = YES;
    
}

//添加自定义顶部导航
-(void)makeTopNavigaitonView{
    
    XWeakSelf
    UniversityNavView *nav = [UniversityNavView ViewWithBlock:^(UIButton *sender) {
        
        [weakSelf navigationItemWithSender:sender];
    }];
    
    self.topNavigationView = nav;
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
    
    myofferFlexibleView *flexView = [myofferFlexibleView flexibleViewWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH,AdjustF(200.f))];
    [self.view insertSubview:flexView belowSubview:self.tableView];
    self.flexView = flexView;
    flexView.alpha = 0.1;
    
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:flexView.frame];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, XSCREEN_WIDTH - 40,self.tableView.tableHeaderView.mj_h)];
    self.titleLab.font = [UIFont systemFontOfSize:KDUtilSize(20)];
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.numberOfLines = 0;
    [self.tableView.tableHeaderView addSubview:self.titleLab];

}


-(void)makeTableView{
    
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    XWGJMessageFrame *messageFrame = self.messageFrames[indexPath.row];
  
    return  messageFrame.cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell =[MessageCell cellWithTableView:tableView];
    
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    [cell tagsShow:NO];
    
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
    
    //1 导航栏显示隐藏
    [self.topNavigationView scrollViewContentoffset:offersetY  andContenHeight:self.flexView.bounds.size.height - XNAV_HEIGHT];
    self.topNavigationView.nav_Alpha =  offersetY / (self.flexView.bounds.size.height - XNAV_HEIGHT);
    
 
    //2 图片下拉
    [self.flexView flexWithContentOffsetY:offersetY];
    
}

- (void)dealloc{

    KDClassLog(@"资讯热门专题 dealloc MessageTopicViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
