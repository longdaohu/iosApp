//
//  ApplyViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "ApplyViewController.h"
#import "SearchResultCell.h"
#import "AgreementViewController.h"
#import "SubmitViewController.h"
#import "ApplySectionView.h"
#import "UniversityCourseViewController.h"
#import "CommitInfoViewController.h"

@interface ApplyViewController () {
    NSArray *_waitingCells;
    NSArray *_info;
    NSMutableSet *_selectedIDs;
    NSArray *_courseInfos;
}
@property(nonatomic,strong)NSArray *responds; //请求得到数据数组
@property(nonatomic,strong)NSMutableArray *idGroups;//所有学校的专业ID数组
@property(nonatomic,assign)int totalCount;//所有学校的专业ID数组
@property(nonatomic,strong)NSMutableArray  *courseSelecteds; //已选中课程ID数组
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation ApplyViewController

//分区的ID，分别放在不同的数组下

-(void)getcourseidGroups
{
    _idGroups = [NSMutableArray array];
    self.totalCount = 0;
    
    for (NSDictionary *universityInfo in self.responds) {
        
        NSArray  *applies   = [universityInfo valueForKey:@"applies"];
        
        NSMutableArray *group = [NSMutableArray array];
        
        for (NSDictionary *courseInfo in applies) {
            
            [group addObject:courseInfo[@"_id"]];
            
            self.totalCount += 1;
        }
        
        [_idGroups addObject:group];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.submitBtn setTitle:GDLocalizedString(@"ApplicationList-005") forState:UIControlStateNormal];
    self.noDataLabel.text = GDLocalizedString(@"ApplicationList-noData");//Duang!请添加您的意向学校吧！
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    if ([_waitingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_waitingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _waitingTableView.tableFooterView = [[UIView alloc] init];
     self.title = GDLocalizedString(@"Me-001");// @"申请意向";
    self.courseSelecteds = [NSMutableArray array];
    
    [self startAPIRequestWithSelector:@"GET api/account/applicationliststate" parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
        
        NSInteger state = [response[@"state"] integerValue];
         if (state == 0) {
             UILabel *notiLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, APPSIZE.height - 50, APPSIZE.width, 50)];
            notiLabel.numberOfLines = 0;
            notiLabel.backgroundColor =[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
            notiLabel.textColor =[UIColor whiteColor];
            notiLabel.text = GDLocalizedString(@"ApplicationList-noti"); //@"您已提交申请，如需要重新提交，请与客服人员联系！";
            notiLabel.adjustsFontSizeToFitWidth = YES;
            self.submitBtn.enabled = NO;
            [self.view addSubview:notiLabel];
        }
     }];
 }


- (void)reloadData {
    
         [self startAPIRequestWithSelector:@"GET api/account/applies" parameters:nil success:^(NSInteger statusCode, NSArray *response) {
         self.responds = response ;

         if(self.responds.count == 0)
         {
             self.noDataView.hidden = NO;
         }
             
         [self getcourseidGroups];
         [self configureSelectedCoursedID:[self.courseSelecteds copy]];
             
         [_waitingTableView reloadData];
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
       [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.responds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *infor = self.responds[section];
    NSArray *applies = [infor valueForKey:@"applies"];
    return applies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"test"];
    
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"test"];
        
        cell.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        [(UIImageView *)cell.accessoryView setContentMode:UIViewContentModeCenter];
        
        //[(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons"]];
    }
    
    NSDictionary *universityInfo = self.responds[indexPath.section];
    NSArray *items = [universityInfo valueForKey:@"applies"];
    NSDictionary *courseInfo = items[indexPath.row];
    NSString *id = courseInfo[@"_id"];
    
    if ([self.courseSelecteds  containsObject:id]) {
        
        [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
    }
    else
    {
        [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons"]];
        
    }
    
     cell.textLabel.text = courseInfo[@"name"] ?: courseInfo[@"official_name"];
    
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 

    __weak typeof(self)weakSelf = self;
    ApplySectionView *sectionView =[[NSBundle mainBundle] loadNibNamed:@"ApplySectionView" owner:nil options:nil].lastObject;
    sectionView.sectionInfo = self.responds[section];
    NSString *universityID = sectionView.sectionInfo[@"_id"];
    sectionView.actionBlock = ^{
       
         UniversityCourseViewController *vc = [[UniversityCourseViewController alloc] initWithUniversityID:universityID];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return sectionView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *universityInfo = self.responds[indexPath.section];
    NSArray *items = [universityInfo valueForKey:@"applies"];
    NSDictionary *courseInfo = items[indexPath.row];
    NSString *courseID = courseInfo[@"_id"];
    
    
    if (self.courseSelecteds.count  == 0) {
        [self.self.courseSelecteds  addObject:courseID];
        
    }
    else if ([self.courseSelecteds containsObject:courseID]) {
        
        [self.courseSelecteds removeObject:courseID];
        
    }
    else
    {
        NSArray  *idArray =  self.idGroups[indexPath.section];
        
        
        for (NSString  *selectedID in self.courseSelecteds){
            
            if([idArray containsObject:selectedID])
            {
                
                [self.courseSelecteds removeObject:selectedID];
                [self.courseSelecteds addObject:courseID];
                
                [_waitingTableView reloadData];
                
                return;
            }
            
        }
        
        [self.courseSelecteds addObject:courseID];
        
    }
    [_waitingTableView reloadData];
    
    
      [self configureSelectedCoursedID:[self.courseSelecteds copy]];
 }


- (IBAction)applyButtonPressed {
   
    if (self.courseSelecteds.count == 0) {
        // GDLocalizedString(@"ApplicationList-001");   @"请至少选择一门课程"    @"好的"
        [KDAlertView showMessage:GDLocalizedString(@"ApplicationList-001")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
        return;
    }
    
    if (![UserDefaults sharedDefault].agreementAccepted.boolValue) {
        AgreementViewController *vc = [[AgreementViewController alloc] init];
        [vc setDismissCompletion:^(BaseViewController *vc) {
            [UserDefaults sharedDefault].agreementAccepted = @YES;
            [self applyButtonPressed];
        }];
        
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:^{}];
        
        return;
    }
    
    if (self.courseSelecteds.count >6) {
         //Your application can not exceed 6   @"您提交审核的申请不能超过6个！"
        [KDAlertView showMessage:GDLocalizedString(@"ApplicationList-002") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"
         return;
    }
    
    
//    NSSet *selectedIDSet = [NSSet setWithArray:];
    CommitInfoViewController *vc = [[CommitInfoViewController alloc] initWithApplyInfo:self.responds selectedIDs:[self.courseSelecteds copy]];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)configureSelectedCoursedID:(NSArray *)selectedIDs {
    
    _selectCountLabel.text = [NSString stringWithFormat:@"%@：%ld %@：%d",GDLocalizedString(@"ApplicationList-003"), (unsigned long)self.courseSelecteds.count,GDLocalizedString(@"ApplicationList-004"),self.totalCount];
}



@end
