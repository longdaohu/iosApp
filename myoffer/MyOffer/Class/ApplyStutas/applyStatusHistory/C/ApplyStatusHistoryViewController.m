//
//  ApplyStatusHistoryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStatusHistoryViewController.h"
#import "ApplyStatusHistoryCell.h"
#import "ApplyStutasModel.h"
#import "ApplyStatusHistoryFrameModel.h"
#import "ApplyStatusHistoryItemFrame.h"
#import "ApplyStatusHistoryHeaderView.h"

@interface ApplyStatusHistoryViewController ()
@property(nonatomic,strong)ApplyStatusHistoryFrameModel *historyFrameModel;
@property(nonatomic,strong)ApplyStatusHistoryHeaderView *headerView;
@property(nonatomic,strong)NSArray *group;
@end

@implementation ApplyStatusHistoryViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    [self makeUI];
}


- (void)makeUI{

    self.title = @"服务状态";
 
    self.tableView.tableFooterView = [UIView new];
    
    self.view.backgroundColor = XCOLOR_BG;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)setStatus_frame:(ApplyStatusModelFrame *)status_frame{

    _status_frame = status_frame;
    
    [self updateUIWithStatus:status_frame.statusModel];

}

- (void)setStatus_history:(NSDictionary *)status_history{

    _status_history = status_history;
 
    ApplyStutasModel *statusModel = [ApplyStutasModel mj_objectWithKeyValues:status_history];
    
    [self updateUIWithStatus:statusModel];
    
}

- (void)updateUIWithStatus:(ApplyStutasModel *)status{

    ApplyStatusHistoryFrameModel *historyFrameModel = [[ApplyStatusHistoryFrameModel alloc] init];
    historyFrameModel.statusModel = status;
    self.historyFrameModel = historyFrameModel;
    
    
    NSMutableArray *items_tmp = [NSMutableArray array];
    for (NSInteger index = 0; index < status.history.count; index++) {
        
        ApplyStutasHistoryModel *historyItem = status.history[index];
        historyItem.status_color  =  XCOLOR_SUBTITLE;
        historyItem.image_Name  =   @"dot";
        
        if (index == 0) {
            historyItem.status_color  =   XCOLOR_LIGHTBLUE;
            historyItem.image_Name  = @"dot_40x40.gif" ;
        }
        
        
        ApplyStatusHistoryItemFrame *frame_historyItem = [ApplyStatusHistoryItemFrame  frameWithHistoryItem:historyItem];
        [items_tmp addObject:frame_historyItem];
    }
    
    
    
    self.group = [items_tmp copy];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ApplyStatusHistoryCell *cell = [ApplyStatusHistoryCell cellWithTableView:tableView];
    
    cell.histroyFrame =self.group[indexPath.row];
    
    return cell;
}

//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    BOOL clips = (self.group.count - 1 == indexPath.row);
  
    cell.clipsToBounds = YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ApplyStatusHistoryItemFrame  *histroyFrame = self.group[indexPath.row];
    
    return  histroyFrame.cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return  self.historyFrameModel.header_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ApplyStatusHistoryHeaderView class]) owner:self options:nil].firstObject;
    
    _headerView.histoyFrame = self.historyFrameModel;
    
    return  _headerView;
}


#pragma mark - Table view delegate

- (void)dealloc{

    KDClassLog(@"服务状态 dealloc");
}

@end
