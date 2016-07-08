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
#import "UniversityFrameApplyObj.h"
#import "ApplyTableViewCell.h"

@interface ApplyViewController ()<UIAlertViewDelegate>
{
    NSArray *_waitingCells;
    NSArray *_info;
    NSMutableSet *_selectedIDs;
    NSArray *_courseInfos;
}
@property(nonatomic,strong)NSMutableArray *responds; //请求得到数据数组
@property(nonatomic,strong)NSMutableArray *idGroups; //所有学校的专业ID数组
@property(nonatomic,strong)NSMutableArray  *courseSelecteds;     //已选中课程ID数组
@property(nonatomic,strong)NSMutableArray *cancelCourseList;     //提交删除的课程ID数组
@property(nonatomic,strong)NSMutableArray *cancelUniversityList; //提交删除的学校ID数组
@property(nonatomic,strong)NSMutableArray *sectionGroups;
@property(nonatomic,strong)NSMutableArray *cancelSetions;        //删除分区数组
@property(nonatomic,strong)NSMutableArray *cancelindexPathes;    //删除cell对就的indexpath数组
@property(nonatomic,copy)NSString *rightButtonTitle;
@property(nonatomic,strong)UIButton *cancelBottomButton;         //删除按钮
@property(nonatomic,assign)BOOL haveUp;
@property(nonatomic,strong)XWGJnodataView *NDataView;
@end

@implementation ApplyViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page申请意向"];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (![self checkNetworkState]) {
        
        self.NDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork") ;
        self.NDataView.hidden = NO;
        
        return;
    }
    
    if ([[AppDelegate sharedDelegate] isLogin]) {
        
        [self RequestDataSourse];
        
    }else{
        
        [self.sectionGroups removeAllObjects];
        [_waitingTableView reloadData];
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
    
}


//网络数据请求
- (void)RequestDataSourse {
    
    
    XJHUtilDefineWeakSelfRef;
    
    [self startAPIRequestWithSelector:kAPISelectorApplicationList parameters:nil success:^(NSInteger statusCode, NSArray *response) {
        
        weakSelf.responds = [response mutableCopy];
        
        
        if(response.count == 0)
        {
            weakSelf.NDataView.hidden = NO;
            
            weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
            
            return ;
        }
        
        [weakSelf getcourseidGroups];
        
        NSMutableArray *sectionM = [NSMutableArray array];
        
        for (NSDictionary *sectionInfo in response) {
            
            ApplySection *sectionModal = [ApplySection applySectionWithDictionary:sectionInfo];
            
            [sectionM addObject:sectionModal];
        }
        weakSelf.sectionGroups = [sectionM mutableCopy];
        
        [weakSelf configureSelectedCoursedID:[self.courseSelecteds copy]];
        
        [_waitingTableView reloadData];
    }];
    
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
    [self startAPIRequestWithSelector:@"GET api/account/applicationliststateraw" parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSString *state = response[@"state"];
        
        if (![state containsString:@"1"] && ![state containsString:@"ack"])
        {
            self.submitBtn.enabled = NO;
            self.AlertLab.hidden = NO;
        }
        
    }];
    
}


-(void)makeUI
{
    
    
    self.NDataView =[XWGJnodataView noDataView];
    self.NDataView.hidden = YES;
    self.NDataView.contentLabel.text = GDLocalizedString(@"ApplicationList-noData");//Duang!请添加您的意向学校吧！
    [self.view insertSubview:self.NDataView  aboveSubview:_waitingTableView];
    
    [self makeOther];
    [self makeButtonItem];
    [self makeCancelBottonButtonView];
    
}


-(void)makeOther
{
    _selectCountLabel.text = [NSString stringWithFormat:@"%@ : ",GDLocalizedString(@"ApplicationList-003")];
    self.AlertLab.text = GDLocalizedString(@"ApplicationList-noti");
    self.title = GDLocalizedString(@"Me-001");
    [self.submitBtn setTitle:GDLocalizedString(@"ApplicationList-commit") forState:UIControlStateNormal];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([_waitingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_waitingTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    _waitingTableView.tableFooterView = [[UIView alloc] init];
    _waitingTableView.sectionFooterHeight = 10;
}


-(void)makeButtonItem
{
    UIBarButtonItem  *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popBackRootViewController)];
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:GDLocalizedString(@"ApplicationList-Edit") style:UIBarButtonItemStylePlain target:self action:@selector(EditClick:)];
}
-(void)makeCancelBottonButtonView
{
    self.cancelBottomButton =[[UIButton alloc] initWithFrame:CGRectMake(0,APPSIZE.height - 64,APPSIZE.width, 50)];
    [self.cancelBottomButton setTitle:GDLocalizedString(@"ApplicationList-Delete")  forState:UIControlStateNormal];
    [self.cancelBottomButton addTarget:self action:@selector(commitCancelList:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBottomButton.backgroundColor = XCOLOR_RED;
    [self.view addSubview:self.cancelBottomButton];
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
    [_waitingTableView reloadData];
    [self.courseSelecteds removeAllObjects];
    [self configureSelectedCoursedID:self.courseSelecteds];
    
}
//用于控制删除按钮出现隐藏
-(void)bottomUp:(BOOL)up
{
    float distance = up ? 50.0:-50.0;
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.cancelBottomButton.center;
        center.y += distance;
        self.cancelBottomButton.center = center;
        self.bottomView.hidden = !up;
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

#pragma mark —— UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        return;
    }
    if (self.cancelCourseList.count > 0) {
        
        [self commitCancelselectCell];
        
        
    }else{
        
        if (self.cancelSetions > 0) {
            
            [self commitCancelSectionView];
        }
    }
    
}
//用于删除cell,先删除cell再删除sectionHeader
-(void)commitCancelselectCell
{
    XJHUtilDefineWeakSelfRef
    [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"ids":self.cancelCourseList}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  NSArray *sortArray =[weakSelf sortArray:weakSelf.cancelindexPathes];
                                  
                                  for (NSIndexPath *indexpath in sortArray) {
                                      
                                      ApplySection *sectionModal = self.sectionGroups[indexpath.section];
                                      [sectionModal.subjects removeObjectAtIndex:indexpath.row];
                                  }
                                  
                                  
                                  
                                  [weakSelf.cancelindexPathes removeAllObjects];
                                  [weakSelf.cancelCourseList removeAllObjects];
                                  
                                  if (weakSelf.cancelSetions > 0) {
                                      
                                      [weakSelf commitCancelSectionView];
                                  }else{
                                      
                                      [_waitingTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:sortArray] withRowAnimation:UITableViewRowAnimationFade];
                                      
                                  }
                              }];
    
}

//删除sectionHeader
-(void)commitCancelSectionView
{     XJHUtilDefineWeakSelfRef
    [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"uIds":self.cancelUniversityList}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  NSArray *newArray = [weakSelf  sortArray:weakSelf.cancelSetions];
                                  
                                  for (NSString *section in newArray) {
                                      [weakSelf.sectionGroups removeObjectAtIndex:section.integerValue];
                                  }
                                  
                                  [weakSelf.cancelUniversityList removeAllObjects];
                                  [weakSelf.cancelSetions removeAllObjects];
                                  
                                  [_waitingTableView reloadData];
                                  
                                  weakSelf.NDataView.hidden = weakSelf.sectionGroups.count == 0 ?NO:YES;
                                  
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
    
 
    
    ApplySection *sectionM = self.sectionGroups[indexPath.section];
    Applycourse *subject = sectionM.subjects[indexPath.row];
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
    return  University_HEIGHT;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    XJHUtilDefineWeakSelfRef
    
    ApplySection *sectionModal = self.sectionGroups[section];
    NSString *universityID = sectionModal.universityInfo[@"_id"];
    
    ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
    sectionView.isEdit = [self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")];
    sectionView.isSelected = [self.cancelUniversityList containsObject:universityID];
    sectionView.UniversityInfo = sectionModal.universityInfo;
    sectionView.uniFrame = sectionModal.uniFrame;
    sectionView.actionBlock = ^(UIButton *sender){
        
        if (sender.tag == 10) {
            
            if (![weakSelf checkNetworkState]) {
                
                
                return;
            }

            
            UniversityCourseViewController *vc = [[UniversityCourseViewController alloc] initWithUniversityID:universityID];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            
            NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)section];
            
            if (![weakSelf.cancelSetions containsObject:sectionStr]) {
                
                [weakSelf.cancelSetions addObject:sectionStr];
                
            }else{
                
                [weakSelf.cancelSetions removeObject:sectionStr];
            }
            
            NSArray *sujectItems = sectionModal.subjects;
            
            if (![weakSelf.cancelUniversityList containsObject:universityID]) {
                
                [weakSelf.cancelUniversityList addObject:universityID];
                
                for (NSInteger row = sujectItems.count - 1; row >= 0; row--) {
                    
                    Applycourse *subject  = sujectItems[row];
                    
                    if (![weakSelf.cancelCourseList containsObject:subject.courseID]) {
                        
                        [weakSelf.cancelCourseList addObject:subject.courseID];
                        
                        NSIndexPath *indexpath = [NSIndexPath  indexPathForRow:row inSection:section];
                        
                        [weakSelf.cancelindexPathes addObject:indexpath];
                    }
                }
                
                
            }else{
                
                [weakSelf.cancelUniversityList removeObject:universityID];
                
                
                for (NSInteger row = 0; row < sujectItems.count; row++) {
                    
                    Applycourse *subject  = sujectItems[row];
                    
                    [weakSelf.cancelCourseList removeObject:subject.courseID];
                    
                    NSIndexPath *indexpath = [NSIndexPath  indexPathForRow:row inSection:section];
                    
                    [weakSelf.cancelindexPathes removeObject:indexpath];
                    
                }
            }
            
            [_waitingTableView reloadData];
            
        }
        
    };
    
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApplySection *sectionModal = self.sectionGroups[indexPath.section];
    Applycourse *subject = sectionModal.subjects[indexPath.row];
    
    NSDictionary *universityInfo = sectionModal.universityInfo;
    
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
            
            cell.iconView.image = [UIImage imageNamed:@"check-icons"];
        }else{
            
            [self.cancelCourseList addObject:subject.courseID];
            cell.iconView.image = [UIImage imageNamed:@"check-icons-yes"];
        }
        
        
        if ([self.cancelUniversityList containsObject:universityInfo[@"_id"]]) {
            
            [self.cancelUniversityList removeObject:universityInfo[@"_id"]];
            
            [self.cancelSetions removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            
            
            [_waitingTableView reloadData];
            
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
                    
                    [_waitingTableView reloadData];
                    
                    return;
                }
                
            }
            
            [self.courseSelecteds addObject:subject.courseID];
            
        }
        [_waitingTableView reloadData];
        
        
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
    
    
    XWGJTiJiaoViewController *vc =[[XWGJTiJiaoViewController alloc] init];
    vc.selectedCoursesIDs = [self.courseSelecteds copy];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}




- (void)configureSelectedCoursedID:(NSArray *)selectedIDs {
    
    _selectCountLabel.text = [NSString stringWithFormat:@"%@ : %ld ",GDLocalizedString(@"ApplicationList-003"), (unsigned long)self.courseSelecteds.count];
}


-(void)popBackRootViewController
{
    
    if (self.isFromMessage) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

-(NSMutableArray *)sectionGroups
{
    if (!_sectionGroups) {
        _sectionGroups =[NSMutableArray array];
    }
    return _sectionGroups;
}

-(NSMutableArray *)cancelSetions
{
    if (!_cancelSetions) {
        _cancelSetions =[NSMutableArray array];
    }
    return _cancelSetions;
}

-(NSMutableArray *)cancelindexPathes
{
    if (!_cancelindexPathes) {
        _cancelindexPathes =[NSMutableArray array];
    }
    return _cancelindexPathes;
}

-(NSMutableArray *)courseSelecteds
{
    if (!_courseSelecteds) {
        _courseSelecteds =[NSMutableArray array];
    }
    return _courseSelecteds;
}

-(NSMutableArray *)cancelCourseList
{
    if (!_cancelCourseList) {
        _cancelCourseList =[NSMutableArray array];
    }
    return _cancelCourseList;
}

-(NSMutableArray *)cancelUniversityList
{
    if (!_cancelUniversityList) {
        _cancelUniversityList =[NSMutableArray array];
    }
    return _cancelUniversityList;
}

//分区的ID，分别放在不同的数组下
-(void)getcourseidGroups
{
    _idGroups = [NSMutableArray array];
    
    
    for (NSDictionary *universityInfo in self.responds) {
        
        NSArray  *applies   = [universityInfo valueForKey:@"applies"];
        
        NSMutableArray *group = [NSMutableArray array];
        
        for (NSDictionary *courseInfo in applies) {
            
            [group addObject:courseInfo[@"_id"]];
            
        }
        
        [_idGroups addObject:group];
    }
}


-(void)dealloc{
    
    KDClassLog(@"ApplyViewController  dealloc");
}

@end
