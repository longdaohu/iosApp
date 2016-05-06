//
//  ApplySubmitViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
// 申请状态

#import "ApplyStatusViewController.h"
#import "SearchResultCell.h"
#import "ApplySectionView.h"
#import "ApplySection.h"
#import "Applycourse.h"

@interface ApplyStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray  *_submittedCells;
}
@property (weak, nonatomic) IBOutlet UITableView *submittedTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property(nonatomic,assign)BOOL ischange;
@property(nonatomic,strong)NSMutableArray *resultInfors;

@end

 @implementation ApplyStatusViewController
-(NSMutableArray *)resultCells
{
    if (!_resultInfors) {
        _resultInfors =[NSMutableArray array];
    }
    return _resultInfors;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 
}
-(void)makeUI
{
    self.title = GDLocalizedString(@"Me-002");//"申请状态";
    self.noDataLabel.text =GDLocalizedString(@"ApplicationStutasVC-noData");
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.submittedTableView.tableFooterView = [[UIView alloc] init];
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.submittedTableView.mj_header = header;
    self.submittedTableView.sectionFooterHeight = 0;
 
}
-(void)loadNewData
{
     [self RequestDataSourse:YES];
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [self makeUI];
    
    [self RequestDataSourse:NO];
 }

- (void)RequestDataSourse:(BOOL)refresh
{
     
    [self startAPIRequestWithSelector:@"GET api/account/checklist" parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *items = response[@"records"];
        self.noDataView.hidden = items.count ? YES : NO;
         if (self.resultInfors.count > 0) {
             [self.resultInfors removeAllObjects];
         }
        
         self.resultInfors = [items mutableCopy];
        [self.submittedTableView reloadData];
        
        if (refresh) {
             [self.submittedTableView.mj_header endRefreshing];
         }
       
        
     }];
  
}

 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  100;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *info = self.resultInfors[section];
    NSDictionary *universityInfo = info[@"university"];
    SearchResultCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SearchResultCell class]) owner:nil options:nil][0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = universityInfo[@"name"];
    cell.subtitleLabel.text = universityInfo[@"official_name"];
     NSString *locationStr  = GDLocalizedString(@"UniversityDetail-005");
     NSString *RankStr  = GDLocalizedString(@"ApplicationStutasVC-001");
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@：%@ - %@\n%@：%@",locationStr, universityInfo[@"country"], universityInfo[@"state"], RankStr,[universityInfo[@"ranking_qs"] intValue] == 99999 ? GDLocalizedString(@"UniversityDetail-0010") : universityInfo[@"ranking_qs"]];
     [cell.logoView.logoImageView KD_setImageWithURL:universityInfo[@"logo"]];
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resultInfors.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *obj = self.resultInfors[indexPath.section];
    NSDictionary *subjectInfo = obj[@"course"];
    NSString *statusStr = obj[@"state"];
    CGSize statusSize =[statusStr  sizeWithFont:[UIFont systemFontOfSize:13]];
    UILabel *statusLabel =[[UILabel alloc] initWithFrame:CGRectMake(APPSIZE.width - statusSize.width - 5, 0, statusSize.width, 44)];
    statusLabel.font = [UIFont systemFontOfSize:13];
    statusLabel.textColor = [UIColor darkGrayColor];
    statusLabel.text =statusStr;
    [cell.contentView addSubview:statusLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, APPSIZE.width - statusSize.width - 20, 44)];
    [cell.contentView addSubview:contentLabel];
     contentLabel.text = subjectInfo[@"official_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
