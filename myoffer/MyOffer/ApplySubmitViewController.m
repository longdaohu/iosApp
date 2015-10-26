//
//  ApplySubmitViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplySubmitViewController.h"
#import "SearchResultCell.h"

@interface ApplySubmitViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray  *_submittedCells;
}
@property (weak, nonatomic) IBOutlet UITableView *submittedTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

 @implementation ApplySubmitViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = GDLocalizedString(@"Me-002");//"申请状态";//@"已提交申请";
     self.noDataLabel.text =GDLocalizedString(@"ApplicationStutasVC-noData");
     self.automaticallyAdjustsScrollViewInsets = NO;
     self.submittedTableView.tableFooterView = [[UIView alloc] init];
     [self reloadData];
     if (self.from.length) {
        //左侧菜单按钮
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BurgerMenu_39"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu:)];
    }
}
//打开左侧菜单
-(void)showLeftMenu:(UIBarButtonItem *)barButton
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}
 - (void)reloadData {
   
    
    [self startAPIRequestWithSelector:@"GET api/account/checklist" parameters:nil success:^(NSInteger statusCode, id response) {
        
         NSArray *items = response[@"records"];
        
        if (items.count == 0) {
            self.noDataView.hidden = NO;
        }
        
        _submittedCells = [items KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
            
            SearchResultCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SearchResultCell class]) owner:nil options:nil][0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *universityInfo = obj[@"university"];
            cell.titleLabel.text = universityInfo[@"name"];
            cell.subtitleLabel.text = universityInfo[@"official_name"];
             NSString *locationStr  = GDLocalizedString(@"UniversityDetail-005");
            NSString *RankStr  = GDLocalizedString(@"ApplicationStutasVC-001");
            cell.descriptionLabel.text = [NSString stringWithFormat:@"%@：%@ - %@\n%@：%@",locationStr, universityInfo[@"country"], universityInfo[@"state"], RankStr,[universityInfo[@"ranking_qs"] intValue] == 99999 ? GDLocalizedString(@"UniversityDetail-0010") : universityInfo[@"ranking_qs"]];
            [cell.logoView.logoImageView KD_setImageWithURL:universityInfo[@"logo"]];
            
            NSDictionary *courseInfo = [obj valueForKey:@"course"];
             NSString *coreName =  [courseInfo  valueForKey:@"official_name"];

             UITableViewCell *xcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, APPSIZE.width - 90 , xcell.contentView.frame.size.height)];
            [xcell.contentView addSubview:contentLabel];
             contentLabel.text = coreName;
            xcell.detailTextLabel.text = obj[@"state"];//GDLocalizedString(@"ApplySummit-001");// @"正在审核";
            NSMutableArray *cells = [NSMutableArray arrayWithObject:cell];
            [cells addObject:xcell];
            return cells;
        }];
        
        [self.submittedTableView reloadData];
        
     }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _submittedCells.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_submittedCells[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  _submittedCells[indexPath.section][indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_submittedCells[indexPath.section][indexPath.row] frame].size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
