//
//  PipeiEditViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiEditViewController.h"
#import "XWGJSummaryView.h"
#import "PipeiSectionHeaderView.h"
#import "PipeiGroup.h"
#import "PipeiEditCell.h"
#import "PipeiCountryCell.h"
#import "CountryItem.h"
#import "SubjectItem.h"
#import "EvaluateSearchCollegeViewController.h"

@interface PipeiEditViewController ()<UITableViewDelegate,UITableViewDataSource,PipeiEditCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)NSArray *countryItems_CN;
@property(nonatomic,strong)NSArray *subjectItems_CN;

@end

@implementation PipeiEditViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getSelectionResourse];

    [self makeUI];

    [self requestDataSource];

}

//用于网络数据请求
-(void)requestDataSource{
    
    if (!LOGIN) return;
    
     XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet  parameters:nil success:^(NSInteger statusCode, id response) {
        
        [weakSelf configrationUIWithresponse:response];
        
    }];
}

- (void)configrationUIWithresponse:(id)response{

    
//    NSLog(@"peipeieepwrlkdsjflsd  %@",response);
    
    for (PipeiGroup *group in self.groups) {
     
        switch (group.groupType) {
            case PipeiGroupTypeCountry:{
            
                
                if (!response[@"des_country"]) {
                
                     group.content  = @"英国";

                }else{
                
                    BOOL haveCountry = NO;
                    for (NSInteger index = 0; index < self.countryItems_CN.count; index++) {
                        
                        CountryItem *item = self.countryItems_CN[index];

                        if ([item.NOid isEqualToString:response[@"des_country"]]) {
                            
                            haveCountry = YES;
                            group.content = item.CountryName;
                            
                        }
                    }
                    
                    if (!haveCountry) {
                        
                        group.content  = @"英国";

                    }
                    

                }
             
            }
                
                
                break;
            case PipeiGroupTypeUniversity:
                group.content = response[@"university"];
                break;
            case PipeiGroupTypeSubject:
                group.content = [NSString stringWithFormat:@"%@",response[@"subject"]];
                break;
            case PipeiGroupTypeScorce:
                group.content = [NSString stringWithFormat:@"%@",response[@"score"]];
                break;
            default:
                break;
        }
        
    }
    
    [self.tableView reloadData];
}

//请求匹配相关数据
-(void)getSelectionResourse
{
    
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    self.countryItems_CN = [[ud valueForKey:@"Country_CN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                                {
                                    CountryItem *item = [CountryItem CountryWithDictionary:obj];
                                    return item;
                                }];
  
    
    self.subjectItems_CN = [[ud valueForKey:@"Subject_CN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                                {
                                    SubjectItem *item = [SubjectItem subjectWithDictionary:obj];
                                    return item;
                                }];
    
}


- (void)makeUI{

    self.title = @"智能匹配";
    
    [self makeTableView];
    
}


-(NSMutableArray *)groups{

    if (!_groups) {
        
        _groups = [NSMutableArray array];
        
        PipeiGroup *country = [PipeiGroup groupWithHeader: @"意向国家"  groupType:PipeiGroupTypeCountry];
        PipeiGroup *university = [PipeiGroup groupWithHeader: @"在读或毕业院校"  groupType:PipeiGroupTypeUniversity];
        PipeiGroup *subject = [PipeiGroup groupWithHeader: @"在读或毕业专业"  groupType:PipeiGroupTypeSubject];
        PipeiGroup *score = [PipeiGroup groupWithHeader: @"平均成绩（百分制）"  groupType:PipeiGroupTypeScorce];
        
        [_groups addObject:country];
        [_groups addObject:university];
        [_groups addObject:subject];
        [_groups addObject:score];
    }
    
    return _groups;
}


//添加表头
-(void)makeHeaderView
{
    XWGJSummaryView *headerView = [XWGJSummaryView ViewWithContent:@"myOffer通过REBAT大数据分析技术，运用独特TBDT算法，为你一键生成智能匹配方案。"];
    headerView.line.hidden = NO;
    self.tableView.tableHeaderView = headerView;
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    [self makeHeaderView];
    
}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    PipeiSectionHeaderView *header = [[PipeiSectionHeaderView alloc] init];
    
    PipeiGroup *sectionGroup =  self.groups[section];
    
    header.titleLab.text = sectionGroup.header;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return  HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return  50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.groups.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    PipeiGroup *group = self.groups[indexPath.section];

    if (group.groupType == PipeiGroupTypeCountry) {
        
        PipeiCountryCell *countryCell = [PipeiCountryCell cellWithTableView:tableView];
        
        countryCell.countryName = group.content;
        
        return countryCell;
        
    }else{
    
        PipeiEditCell *cell =[PipeiEditCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.group =  self.groups[indexPath.section];
        
        return cell;
    }

}
#pragma mark ——— PipeiEditCellDelegate
-(void)PipeiEditCellPush{

    EvaluateSearchCollegeViewController *search =[[EvaluateSearchCollegeViewController alloc] initWithNibName:@"EvaluateSearchCollegeViewController" bundle:nil];
    search.valueBlock = ^(NSString *value){
        
//        tableViewCell.universityTF.text = value;
        
    };
    
    [self.navigationController pushViewController:search animated:YES];

    
}

-(void)PipeiEditCell:(PipeiEditCell *)cell  textFieldDidEndEditing:(UITextField *)textField{

    
}

-(void)PipeiEditCell:(PipeiEditCell *)cell  textFieldDidBeginEditing:(UITextField *)textField{

}




- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
