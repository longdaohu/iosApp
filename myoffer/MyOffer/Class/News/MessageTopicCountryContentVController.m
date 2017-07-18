//
//  MessageTopicCountryContentVController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageTopicCountryContentVController.h"
#import "XWGJMessageFrame.h"
#import "MessageCell.h"
#import "MessageDetaillViewController.h"
#import "MyOfferArticle.h"
#import "SearchPromptView.h"

@interface MessageTopicCountryContentVController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong) SearchPromptView *promptView;

@end

@implementation MessageTopicCountryContentVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeSubViews];
}


- (void)setGroup:(MessageCountryTopicModel *)group{
    
    _group = group;
    
//    NSLog(@" ageTopicCountryContentVCont ++++++++++ %@",group.parameters);
    
    [self.tableView reloadData];

    //1 如果为空是显示提示
    [self showEmpty];
    
    //2 提示加载信息
    [self promptShowWithCount:group.messageFrames.count];
    
}


- (SearchPromptView *)promptView{
    
    if (!_promptView) {
        
        _promptView = [[SearchPromptView alloc] initWithFrame:CGRectMake(0, -50, XSCREEN_WIDTH, 50)];
        
        _promptView.alpha = 0;
        
    }
    
    return _promptView;
}


//每次清空数据时，表格回到顶部
- (void)tableViewScrollToTop{

    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    [self.tableView.mj_footer resetNoMoreData];
}


- (void)makeSubViews
{
    _tableView = [[MyOfferTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    
    _tableView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 120 + 64, 0);
    
    
    [self.view insertSubview:self.promptView aboveSubview:self.tableView];
}


#pragma mark : 网络请求
- (void)makeDataWithPage:(NSInteger)page{
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorArticalesList  parameters:self.group.parameters expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, NSDictionary *response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf showError];
        
    }];
    
}

//更新的页面
- (void)updateUIWithResponse:(id)response{

    // 1 添加数据
    NSArray *items = [MyOfferArticle mj_objectArrayWithKeyValuesArray: response[@"items"]];
    
    NSMutableArray *temps = [NSMutableArray array];
    for (MyOfferArticle *article in items) {
        
        [temps addObject:[XWGJMessageFrame messageFrameWithMessage:article]];
    }
    [self.group.messageFrames addObjectsFromArray:temps];
    
    
    //2 判断数据是否加载完毕
    if (self.group.messageFrames.count >= [response[@"counts"] integerValue]) {
        
        self.group.endPage = YES;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }else{
        
        self.group.page++;
        [self.group.parameters setValue:@(self.group.page) forKey:@"page"];
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.tableView reloadData];
    
    //3 判断数据是否为空
    [self showEmpty];
    //4 展示加载数据
    [self promptShowWithCount:temps.count];
}


#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.group.messageFrames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XWGJMessageFrame *messageFrame =  self.group.messageFrames[indexPath.row];
    
    return messageFrame.cell_Height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //2 正常展示数据
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    
    cell.messageFrame =   self.group.messageFrames[indexPath.row];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWGJMessageFrame *messageFrame =  self.group.messageFrames[indexPath.row];
    
    MessageDetaillViewController *vc = [[MessageDetaillViewController alloc] initWithMessageId:messageFrame.News.message_id];
    
    [self.navigationController pushViewController:vc  animated:YES];
    
}

#pragma mark : 事件处理

- (void)loadMoreData{
    
    [self makeDataWithPage:self.group.page];
}


- (void)showEmpty{
    
    if (self.group.messageFrames.count) {
        
        [self.tableView emptyViewWithHiden:YES];
        
    }else{
        
        [self.tableView emptyViewWithError:@"数据为空"];
        
    }
}


- (void)showError{

    if (self.group.messageFrames.count == 0) {
        
        [self.tableView emptyViewWithError:@"网络请求错误，请确认网络是否正常连接！"];
     }
}

//显示提示新加载数据
- (void)promptShowWithCount:(NSInteger )count{
    
    //数据为0时不显示提示信息
    if (count == 0) return;
    
    XWeakSelf
    [self.promptView promptShowWithMessage:[NSString stringWithFormat:@"加载%ld条资讯",count]];
    
    //每次点击时 清空动画
    [self.promptView.layer removeAllAnimations];
    self.promptView.alpha = 0;
    self.promptView.mj_y = - self.promptView.mj_h;
    
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        weakSelf.promptView.alpha = 1;
        weakSelf.promptView.mj_y = 0;
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:ANIMATION_DUATION delay:2 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            
            weakSelf.promptView.mj_y = - self.promptView.mj_h;
            weakSelf.promptView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
    
}

- (void)dealloc{

    NSLog(@" MessageTopicCountryContentVController  资讯内容展示区 dealloc");

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end