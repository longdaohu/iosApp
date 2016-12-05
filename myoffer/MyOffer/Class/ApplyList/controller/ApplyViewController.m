//
//  ApplyViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
// 申请意向
#import "XWGJTiJiaoViewController.h"
#import "ApplyViewController.h"
#import "UniversityCourseViewController.h"
#import "ApplySection.h"
#import "Applycourse.h"
#import "ApplySectionHeaderView.h"
#import "UniversityFrameNew.h"
#import "ApplyTableViewCell.h"
#define SECTIONFOOTERHEIGHT  10

@interface ApplyViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *responds;            //请求得到数据数组
@property(nonatomic,strong)NSMutableArray *idGroups;             //所有学校的专业ID数组
@property(nonatomic,strong)NSMutableArray  *courseSelecteds;     //已选中课程ID数组
@property(nonatomic,strong)NSMutableArray *cancelCourseList;     //提交删除的课程ID数组
@property(nonatomic,strong)NSMutableArray *cancelUniversityList; //提交删除的学校ID数组
@property(nonatomic,strong)NSMutableArray *sectionGroups;
@property(nonatomic,strong)NSMutableArray *cancelSetions;        //删除分区数组
@property(nonatomic,strong)NSMutableArray *cancelindexPathes;    //删除cell对就的indexpath数组
@property(nonatomic,copy)NSString *rightButtonTitle;
//删除按钮
@property(nonatomic,strong)UIButton *cancelBottomButton;
@property(nonatomic,strong)XWGJnodataView *NDataView;
@property (weak, nonatomic) IBOutlet UITableView *waitingTableView;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *submitBtn;  //提交按钮
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *AlertLab;             //用户已提交审核，防止用户重复提交
@property (weak, nonatomic) IBOutlet UILabel *selectCountLabel;


@end

@implementation ApplyViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page申请意向"];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
 
    [self presentViewWillAppear];
    
}

//viewWillAppear状态页面数据调整
-(void)presentViewWillAppear{

    if (![self checkNetworkState]) {
        
        self.NDataView.errorStr = GDLocalizedString(@"NetRequest-noNetWork") ;
        self.NDataView.hidden = NO;
        
        return;
    }
    
    if (LOGIN) {
        
        [self RequestDataSourse];
        
    }else{
        
        [self.sectionGroups removeAllObjects];
        [self.waitingTableView reloadData];
        self.NDataView.hidden = NO;
    }
    
    [self checkApplyStatus];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请意向"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
//     NSLog(@"childViewControllers  %ld",self.navigationController.childViewControllers.count);
    
}


//网络数据请求
- (void)RequestDataSourse {
    
    
    XWeakSelf;
    
    [self startAPIRequestWithSelector:kAPISelectorApplicationList parameters:nil success:^(NSInteger statusCode, NSArray *response) {
        
        weakSelf.responds = [response mutableCopy];
        
        [weakSelf UIWithArray:response];
        
    }];
    
}

//根据网络请求刷新页面
-(void)UIWithArray:(NSArray *)response{

    if(response.count == 0)
    {
        self.NDataView.hidden = NO;
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        self.submitBtn.enabled = NO;
        
        return ;
    }
    
    
    [self getcourseidGroups];
    
    NSMutableArray *sectionM = [NSMutableArray array];
    
    for (NSDictionary *sectionInfo in response) {
        
        ApplySection *sectionModal = [ApplySection applySectionWithDictionary:sectionInfo];
        
        [sectionM addObject:sectionModal];
    }
    self.sectionGroups = [sectionM mutableCopy];
    
    [self configureSelectedCoursedID:[self.courseSelecteds copy]];
    
    [self.waitingTableView reloadData];
    
}


//如果用户已经申请过，在提交按钮上添加一个遮盖
/*     state     状态有4个值
 *  【 pending  ——审核中
 *  【 PushBack ——退回
 *  【 Approved ——审核通过
 *  【 -1       ——没有申请过
 */
-(void)checkApplyStatus
{
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorApplicationStatus parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSString *state = response[@"state"];
        
        if (![state containsString:@"1"] && ![state containsString:@"ack"])
        {
            weakSelf.submitBtn.enabled = NO;
            weakSelf.AlertLab.hidden = NO;
        }
        
    }];
    
}


-(void)makeUI
{
    
    self.NDataView =[XWGJnodataView noDataView];
    self.NDataView.hidden = YES;
    self.NDataView.errorStr = GDLocalizedString(@"ApplicationList-noData");//Duang!请添加您的意向学校吧！
    [self.view insertSubview:self.NDataView  aboveSubview:self.waitingTableView];
    
    [self makeOther];
    [self makeButtonItem];
    [self makeCancelBottonButtonView];
    
}


-(void)makeOther
{
    self.selectCountLabel.text = [NSString stringWithFormat:@"%@ : ",GDLocalizedString(@"ApplicationList-003")];
    self.AlertLab.text     = GDLocalizedString(@"ApplicationList-noti");
    self.title             = GDLocalizedString(@"Me-001");
    [self.submitBtn setTitle:GDLocalizedString(@"ApplicationList-commit") forState:UIControlStateNormal];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self.waitingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.waitingTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    self.waitingTableView.tableFooterView     = [[UIView alloc] init];
    
    self.waitingTableView.sectionFooterHeight =  SECTIONFOOTERHEIGHT;
}


-(void)makeButtonItem
{
    UIBarButtonItem  *leftItem             = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popBackRootViewController)];
    self.navigationItem.leftBarButtonItem  = leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:GDLocalizedString(@"ApplicationList-Edit") style:UIBarButtonItemStylePlain target:self action:@selector(EditClick:)];
}


-(void)makeCancelBottonButtonView
{
    self.cancelBottomButton =[[UIButton alloc] initWithFrame:CGRectMake(0,XScreenHeight - 64,XScreenWidth, 50)];
    [self.cancelBottomButton setTitle:GDLocalizedString(@"ApplicationList-Delete")  forState:UIControlStateNormal];
    [self.cancelBottomButton addTarget:self action:@selector(commitCancelList:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBottomButton.backgroundColor = XCOLOR_RED;
    [self.view addSubview:self.cancelBottomButton];
}




#pragma mark —— UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        return;
    }
    
    if (self.cancelCourseList.count > 0) {
        
        [self commitCancelselectCell];
        
    }else{
        
        if (self.cancelSetions.count > 0) {
            
            [self commitCancelSectionView];
        }
    }
    
    

}
//用于删除cell,先删除cell再删除sectionHeader
-(void)commitCancelselectCell
{
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"ids":self.cancelCourseList}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  NSArray *sortArray =[weakSelf sortArray:weakSelf.cancelindexPathes];
                                  
                                  for (NSIndexPath *indexpath in sortArray) {
                                      
                                      ApplySection *sectionModal = self.sectionGroups[indexpath.section];
                                      [sectionModal.subjects removeObjectAtIndex:indexpath.row];
                                  }
                                  
                                  
                                  
                                  [weakSelf.cancelindexPathes removeAllObjects];
                                  
                                  [weakSelf.cancelCourseList  removeAllObjects];
                                  
                                  if (weakSelf.cancelSetions > 0) {
                                      
                                      [weakSelf commitCancelSectionView];
                                      
                                  }else{
                                      
                                      [weakSelf.waitingTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:sortArray] withRowAnimation:UITableViewRowAnimationFade];
                                      
                                  }
                              }];
    
}

//删除sectionHeader
-(void)commitCancelSectionView
{     XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"uIds":self.cancelUniversityList}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  NSArray *newArray = [weakSelf  sortArray:weakSelf.cancelSetions];
                                  
                                  for (NSString *section in newArray) {
                                      
                                      [weakSelf.sectionGroups removeObjectAtIndex:section.integerValue];
                                  }
                                  
                                  [weakSelf.cancelUniversityList removeAllObjects];
                                  [weakSelf.cancelSetions removeAllObjects];
                                  [weakSelf.waitingTableView reloadData];
                                  
                                  weakSelf.NDataView.hidden  = weakSelf.sectionGroups.count  > 0;
                                  weakSelf.submitBtn.enabled = weakSelf.sectionGroups.count  > 0;
                                  
                                  if (weakSelf.sectionGroups.count == 0) {
                                      
                                      [weakSelf bottomUp:YES];
                                      weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
                                      
                                  }
                                  
                              }];
}

//对数组进行排序
-(NSArray *)sortArray:(NSArray *)contents
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    NSArray *sortArray = [contents  sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    return sortArray;
}


#pragma mark ——————————UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ApplySection *sectionM = self.sectionGroups[section];
    
    return sectionM.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    ApplySection *group = self.sectionGroups[indexPath.section];
    Applycourse *subject = group.subjects[indexPath.row];
    ApplyTableViewCell *cell =[ApplyTableViewCell cellWithTableView:tableView];
   
    cell.title =  subject.official_name;
    cell.containt_select = [self.courseSelecteds  containsObject:subject.courseID];
    BOOL edit =  [self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")];
    cell.Edit = edit;
    
    if (edit) {
        cell.containt = [self.cancelCourseList containsObject:subject.courseID];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return KDUtilSize(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  Uni_Cell_Height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    XWeakSelf
    
    ApplySection *group = self.sectionGroups[section];
    NSString *uni_ID = group.universityInfo[@"_id"];
    
    ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
    sectionView.edit = [self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")];
    sectionView.isSelected = [self.cancelUniversityList containsObject:uni_ID];
    sectionView.uniFrame = group.uniFrame;
    sectionView.actionBlock = ^(UIButton *sender){
        
        if (sender.tag == 10) {
            
            if (![weakSelf checkNetworkState]) {
                
                
                return;
            }
            
            UniversityCourseViewController *vc = [[UniversityCourseViewController alloc] initWithUniversityID:uni_ID];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            
            NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)section];
            
            if (![weakSelf.cancelSetions containsObject:sectionStr]) {
                
                [weakSelf.cancelSetions addObject:sectionStr];
                
            }else{
                
                [weakSelf.cancelSetions removeObject:sectionStr];
            }
            
            NSArray *sujectItems = group.subjects;
            
            if (![weakSelf.cancelUniversityList containsObject:uni_ID]) {
                
                [weakSelf.cancelUniversityList addObject:uni_ID];
                
                for (NSInteger row = sujectItems.count - 1; row >= 0; row--) {
                    
                    Applycourse *subject  = sujectItems[row];
                    
                    if (![weakSelf.cancelCourseList containsObject:subject.courseID]) {
                        
                        [weakSelf.cancelCourseList addObject:subject.courseID];
                        
                        NSIndexPath *indexpath = [NSIndexPath  indexPathForRow:row inSection:section];
                        
                        [weakSelf.cancelindexPathes addObject:indexpath];
                    }
                }
                
                
            }else{
                
                [weakSelf.cancelUniversityList removeObject:uni_ID];
                
                
                for (NSInteger row = 0; row < sujectItems.count; row++) {
                    
                    Applycourse *subject  = sujectItems[row];
                    
                    [weakSelf.cancelCourseList removeObject:subject.courseID];
                    
                    NSIndexPath *indexpath = [NSIndexPath  indexPathForRow:row inSection:section];
                    
                    [weakSelf.cancelindexPathes removeObject:indexpath];
                    
                }
            }
            
            [weakSelf.waitingTableView reloadData];
            
        }
        
    };
    
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ApplySection *group = self.sectionGroups[indexPath.section];
    Applycourse *subject = group.subjects[indexPath.row];
    NSDictionary *uni_Info = group.universityInfo;
    
     if ([self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")])
    {
        
        if([self.cancelindexPathes containsObject:indexPath]){
            
            [self.cancelindexPathes removeObject:indexPath];
        }
        else{
            
            [self.cancelindexPathes addObject:indexPath];
        }
        
        
        ApplyTableViewCell *cell =(ApplyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.cancelCourseList containsObject:subject.courseID]) {
            
            [self.cancelCourseList removeObject:subject.courseID];
            
            [cell cellIsSelected:NO];
            
        }else{
            
            [self.cancelCourseList addObject:subject.courseID];
            
            [cell cellIsSelected:YES];

         }
        
        
        if ([self.cancelUniversityList containsObject:uni_Info[@"_id"]]) {
            
            [self.cancelUniversityList removeObject:uni_Info[@"_id"]];
            
            [self.cancelSetions removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            
            
            [self.waitingTableView reloadData];
            
        }
        
    }else{
        
        if (self.courseSelecteds.count  == 0) {
            
            [self.self.courseSelecteds  addObject:subject.courseID];
            
        }
        else if ([self.courseSelecteds containsObject:subject.courseID]) {
            
            [self.courseSelecteds removeObject:subject.courseID];
            
        }
        else
        {
            NSArray  *idArray =  self.idGroups[indexPath.section];
            
            
            for (NSString  *selectedID in self.courseSelecteds){
                
                if([idArray containsObject:selectedID])
                {
                    
                    [self.courseSelecteds removeObject:selectedID];
                    [self.courseSelecteds addObject:subject.courseID];
                    
                    [self.waitingTableView reloadData];
                    
                    return;
                }
                
            }
            
            [self.courseSelecteds addObject:subject.courseID];
            
        }
        [self.waitingTableView reloadData];
        
        
        [self configureSelectedCoursedID:[self.courseSelecteds copy]];
        
    }
    
    
}



/*
 *  ApplicationList-001 = @"请至少选择一门课程"
 *  Evaluate-0016   = @"好的"
 *  ApplicationList-002 =  @"您提交审核的申请不能超过6个！"
 *  NSSet *selectedIDSet = [NSSet setWithArray:];
 */
- (IBAction)applyButtonPressed {
    
    RequireLogin
    
    if (![self checkNetworkState]) {
        
        return;
    }
    
    if (self.courseSelecteds.count == 0) {
        
        AlerMessage(GDLocalizedString(@"ApplicationList-001"));
        
        return;
    }
    
    if (self.courseSelecteds.count > 6) {
        AlerMessage(GDLocalizedString(@"ApplicationList-002"));
       
        return;
        
    }
    
    
    XWGJTiJiaoViewController *vc = [[XWGJTiJiaoViewController alloc] init];
    vc.selectedCoursesIDs        =  [self.courseSelecteds copy];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)configureSelectedCoursedID:(NSArray *)selectedIDs {
    
    self.selectCountLabel.text = [NSString stringWithFormat:@"%@ : %ld ",GDLocalizedString(@"ApplicationList-003"), (unsigned long)self.courseSelecteds.count];
}


-(NSMutableArray *)sectionGroups
{
    if (!_sectionGroups) {
        _sectionGroups = [NSMutableArray array];
    }
    return _sectionGroups;
}

-(NSMutableArray *)cancelSetions
{
    if (!_cancelSetions) {
        _cancelSetions = [NSMutableArray array];
    }
    return _cancelSetions;
}

-(NSMutableArray *)cancelindexPathes
{
    if (!_cancelindexPathes) {
        _cancelindexPathes = [NSMutableArray array];
    }
    return _cancelindexPathes;
}

-(NSMutableArray *)courseSelecteds
{
    if (!_courseSelecteds) {
        _courseSelecteds = [NSMutableArray array];
    }
    return _courseSelecteds;
}

-(NSMutableArray *)cancelCourseList
{
    if (!_cancelCourseList) {
        
        _cancelCourseList = [NSMutableArray array];
    }
    return _cancelCourseList;
}

-(NSMutableArray *)cancelUniversityList
{
    if (!_cancelUniversityList) {
        
        _cancelUniversityList = [NSMutableArray array];
    }
    return _cancelUniversityList;
}

//分区的ID，分别放在不同的数组下
-(void)getcourseidGroups
{
    _idGroups = [NSMutableArray array];
    
    
    for (NSDictionary *universityInfo in self.responds) {
        
        NSArray  *applies     = [universityInfo valueForKey:@"applies"];
        
        NSMutableArray *group = [NSMutableArray array];
        
        for (NSDictionary *courseInfo in applies) {
            
            [group addObject:courseInfo[@"_id"]];
            
        }
        
        [_idGroups addObject:group];
    }
}


//返回上级页面
-(void)popBackRootViewController
{
    
    NSArray *items = self.navigationController.childViewControllers;
    
    if (self.backStyle) {
        
        if (items.count > 4) {
            
            [self.navigationController popToViewController: (UIViewController *)items[items.count - 4] animated:YES];
            
            return ;
        }
        
    }else{
     
        if (items.count > 3) {
            
            [self.navigationController popToViewController: (UIViewController *)items[items.count - 3] animated:YES];
            
            return ;
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
 }

//用于控制删除按钮出现隐藏
-(void)bottomUp:(BOOL)up
{
    float distance = up ? 50.0 : -50.0;
    
    XWeakSelf
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
    
        CGPoint center = self.cancelBottomButton.center;
        center.y += distance;
        weakSelf.cancelBottomButton.center = center;
        weakSelf.bottomView.hidden = !up;
    }];
}

//提交删除按钮
-(void)commitCancelList:(UIButton *)sender
{
    if (self.cancelCourseList.count == 0 && self.cancelUniversityList.count == 0) {
        
        AlerMessage(GDLocalizedString(@"ApplicationList-please"));
        
    }else{
        
        UIAlertView *aler =[[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"ApplicationList-comfig") delegate:self cancelButtonTitle:GDLocalizedString(@"NetRequest-OK") otherButtonTitles:GDLocalizedString(@"Potocol-Cancel"), nil];
        [aler show];
    }
}


//编辑按钮方法
-(void)EditClick:(UIBarButtonItem *)sender
{
    NSString *cancelTitle =  GDLocalizedString(@"Me-007");
    NSString *editTitle = GDLocalizedString(@"ApplicationList-Edit");
    
    if ([sender.title isEqualToString:editTitle] ) {
        
        sender.title = cancelTitle;
        self.rightButtonTitle = sender.title;
        [self bottomUp:NO];
        
    }else{
        
        sender.title = editTitle;
        self.rightButtonTitle =  sender.title;
        [self.cancelCourseList removeAllObjects];
        [self.cancelUniversityList removeAllObjects];
        [self.cancelSetions removeAllObjects];
        [self.cancelindexPathes removeAllObjects];
        [self bottomUp:YES];
        
    }
    
    [self.waitingTableView reloadData];
    [self.courseSelecteds removeAllObjects];
    [self configureSelectedCoursedID:self.courseSelecteds];
    
}


-(void)dealloc{
    
    KDClassLog(@"申请意向  dealloc");
}

@end
