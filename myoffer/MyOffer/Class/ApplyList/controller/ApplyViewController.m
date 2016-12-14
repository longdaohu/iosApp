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
#import "UniversityNew.h"

#define SECTIONFOOTERHEIGHT  10

@interface ApplyViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//模型数组
@property(nonatomic,strong)NSMutableArray *groups;
//已选中课程ID数组
@property(nonatomic,strong)NSMutableArray *courseSelecteds;
//提交删除的课程ID数组
@property(nonatomic,strong)NSMutableArray *cancelCourseList;
//提交删除的学校ID数组
@property(nonatomic,strong)NSMutableArray *cancelUniversityList;
//删除分区数组
@property(nonatomic,strong)NSMutableArray *cancelSetions;
//删除cell对就的indexpath数组
@property(nonatomic,strong)NSMutableArray *cancelindexPathes;
@property(nonatomic,strong)XWGJnodataView *NDataView;
//删除按钮
@property(nonatomic,strong)UIButton *cancelBottomButton;
//提交按钮
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *submitBtn;
//底部按钮SuperView
@property (strong, nonatomic) IBOutlet UIView *bottomView;
//用户已提交审核，防止用户重复提交
@property (weak, nonatomic) IBOutlet UILabel *AlertLab;
//已选择数量
@property (weak, nonatomic) IBOutlet UILabel *selectCountLabel;
//判断cell是否需要做动画效果
@property(nonatomic,assign)BOOL cell_Animation;

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
        
         [self checkApplyStatus];
        
    }else{
        
        [self.groups removeAllObjects];
        [self.tableView reloadData];
        self.NDataView.hidden = NO;
    }
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请意向"];
    
}


-(NSMutableArray *)groups
{
    if (!_groups) {
        
        _groups = [NSMutableArray array];
    }
    return _groups;
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



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
}


//网络数据请求
- (void)RequestDataSourse {
    
    
    XWeakSelf;
    
    [self startAPIRequestWithSelector:kAPISelectorApplicationList parameters:nil success:^(NSInteger statusCode, NSArray *response) {
        
        [weakSelf UIWithArray:(NSArray *)response];
        
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
    
 
    
    NSMutableArray *temp_group = [NSMutableArray array];
    
    for (NSDictionary *sectionInfo in response) {
        
        ApplySection *sectionModal = [ApplySection applySectionWithDictionary:sectionInfo];
        
        [temp_group addObject:sectionModal];
  
    }
    
    self.groups = [temp_group mutableCopy];
    
    
    [self.tableView reloadData];
    
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
        
        if (![response[@"state"] containsString:@"1"] && ![response[@"state"] containsString:@"ack"])
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
    [self.view insertSubview:self.NDataView  aboveSubview:self.tableView];
    
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
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    self.tableView.tableFooterView     = [[UIView alloc] init];
    
    self.tableView.sectionFooterHeight =  SECTIONFOOTERHEIGHT;
}


-(void)makeButtonItem
{
    UIBarButtonItem  *leftItem             = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popBackRootViewController)];
    self.navigationItem.leftBarButtonItem  = leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:GDLocalizedString(@"ApplicationList-Edit") style:UIBarButtonItemStylePlain target:self action:@selector(EditClick:)];
}


-(void)makeCancelBottonButtonView
{
    UIButton *cancelBottomButton =[[UIButton alloc] initWithFrame:CGRectMake(0,XSCREEN_HEIGHT - XNAV_HEIGHT,XSCREEN_WIDTH, 50)];
    [cancelBottomButton setTitle:GDLocalizedString(@"ApplicationList-Delete")  forState:UIControlStateNormal];
    [cancelBottomButton addTarget:self action:@selector(commitCancelList:) forControlEvents:UIControlEventTouchUpInside];
    cancelBottomButton.backgroundColor = XCOLOR_RED;
    self.cancelBottomButton = cancelBottomButton;
    [self.view addSubview:self.cancelBottomButton];
}




#pragma mark —— UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)  return;
    
    
    if (self.cancelCourseList.count > 0) {
        
        [self commitCancelselectCell];
        
        return ;
    }
        
     if (self.cancelSetions.count > 0) {
         
         [self commitCancelSectionView:YES];
    }
    
    
    

}
//用于删除cell,先删除cell再删除sectionHeader
-(void)commitCancelselectCell
{
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"ids":self.cancelCourseList}
                              success:^(NSInteger statusCode, id response) {
                                  

                                  //排序，从大小到删除
                                  NSArray *sortIndexPathes =[weakSelf sortArray:weakSelf.cancelindexPathes];
                                  
                                  for (NSIndexPath *indexpath in sortIndexPathes) {
                                      ApplySection *group = weakSelf.groups[indexpath.section];
                                      //1、 删除已被选中 indexpath.row 对应的 group.subjects数组的子项
                                       [group.subjects removeObjectAtIndex:indexpath.row];
                                  }
                                  
                                  [weakSelf.tableView deleteRowsAtIndexPaths:weakSelf.cancelindexPathes withRowAnimation:UITableViewRowAnimationFade];
                                  //2、 当group.subjects数组的子项被删除后，可以清空 cancelindexPathes 数组
                                  //3、 当group.subjects数组的子项被删除后，可以清空 cancelCourseList 数组
                                  [weakSelf.cancelindexPathes removeAllObjects];
                                  [weakSelf.cancelCourseList  removeAllObjects];
                                  //4、 如里存在要删除的分组数据，再进入删除分区功能
                                  if (weakSelf.cancelSetions.count > 0) [weakSelf commitCancelSectionView:NO];
                                  
                              }];
    
}

//删除sectionHeader
-(void)commitCancelSectionView:(BOOL)fresh
{     XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"uIds":self.cancelUniversityList}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  //1、排序，从大小到删除
                                  NSArray *newArray = [weakSelf  sortArray:weakSelf.cancelSetions];
                                  
                                  //2、清空删除学校ID数组 、 删除分组信息数组
                                  [weakSelf.cancelUniversityList removeAllObjects];
                                  [weakSelf.cancelSetions removeAllObjects];
                                  
                                  
                                  NSMutableIndexSet *deleteSet = [NSMutableIndexSet indexSet];
                                  for (NSString *section in newArray) {
                                      
                                      [weakSelf.groups removeObjectAtIndex:section.integerValue];
                                    //3、添加需要删除的分组
                                      [deleteSet addIndex:section.integerValue];
                                  }
                                    //4、动画删除选中分组
                                      [weakSelf.tableView deleteSections:deleteSet withRowAnimation:UITableViewRowAnimationFade];
                                  
                                     //5、动画刷新未选中分组
                                      NSMutableIndexSet *reloadSet = [NSMutableIndexSet indexSet];
                                      for (NSInteger index = 0; index < self.groups.count; index++) {
                                          [reloadSet addIndex:index];
                                      }
                                    [weakSelf.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationFade];
                                  
                                  
                                  weakSelf.NDataView.hidden  = weakSelf.groups.count  > 0;
                                  weakSelf.submitBtn.enabled = weakSelf.groups.count  > 0;
                                  
                                  if (weakSelf.groups.count == 0) {
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
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    ApplySection *group = self.groups[section];
    
    return group.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplySection *group = self.groups[indexPath.section];
    Applycourse *subject = group.subjects[indexPath.row];
    ApplyTableViewCell *cell =[ApplyTableViewCell cellWithTableView:tableView];
    cell.Edit = [self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")];
    cell.title =  subject.official_name;
    cell.isSelected = cell.Edit ? [self.cancelCourseList containsObject:subject.courseID] : [self.courseSelecteds  containsObject:subject.courseID];
    
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
    ApplySection *group = self.groups[section];
    UniversityNew *university = group.uniFrame.universtiy;
    
    ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
    sectionView.cell_Animation = self.cell_Animation;
    sectionView.edit = [self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")];
    sectionView.isSelected = [self.cancelUniversityList containsObject:university.NO_id];
    sectionView.uniFrame = group.uniFrame;
    sectionView.actionBlock = ^(UIButton *sender){
        
        if (sender.tag == 10) {//点击进入 UniversityCourseViewController 课程详情
            
            if (![weakSelf checkNetworkState])  return;
            
            weakSelf.cell_Animation = NO;
            [weakSelf.navigationController pushViewController:[[UniversityCourseViewController alloc] initWithUniversityID:university.NO_id] animated:YES];
            
            return;
        }
        
            
        
        NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)section];
        //添加或删除   需要被删除组的信息
        [weakSelf.cancelSetions containsObject:sectionStr] ? [weakSelf.cancelSetions removeObject:sectionStr] :  [weakSelf.cancelSetions addObject:sectionStr];
         
        
        NSArray *sujectItems = group.subjects;
        //添加或删除   需要被删除学校ID的信息 及学校ID对应学科ID数组
        if (![weakSelf.cancelUniversityList containsObject:university.NO_id]) {
            
                [weakSelf.cancelUniversityList addObject:university.NO_id];
            
                for (NSInteger index = sujectItems.count - 1; index >= 0; index--) {
                    
                    Applycourse *subject  = sujectItems[index];
                    if (![weakSelf.cancelCourseList containsObject:subject.courseID]) {
                        [weakSelf.cancelCourseList addObject:subject.courseID];
                        [weakSelf.cancelindexPathes addObject:[NSIndexPath  indexPathForRow:index inSection:section]];
                    }
                    
                }
            
            
        }else{
            
            //学校取消
            [weakSelf.cancelUniversityList removeObject:university.NO_id];
            
            for (NSInteger row = 0; row < sujectItems.count; row++) {
                Applycourse *subject  = sujectItems[row];
                [weakSelf.cancelCourseList removeObject:subject.courseID];
                [weakSelf.cancelindexPathes removeObject:[NSIndexPath  indexPathForRow:row inSection:section]];
            }
        }
        

        //取消cell刷新时默认动画效果
        [UIView performWithoutAnimation:^{
             [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        }];
   
        
    };
    
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ApplySection *group = self.groups[indexPath.section];
    Applycourse *subject = group.subjects[indexPath.row];
    UniversityNew *university = group.uniFrame.universtiy;
    
     //编辑状态
     if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"取消"]){
        
        //删除的 indexPath 数组
        [self.cancelindexPathes containsObject:indexPath] ?  [self.cancelindexPathes removeObject:indexPath] :  [self.cancelindexPathes addObject:indexPath];
        
        ApplyTableViewCell *cell =(ApplyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.cancelCourseList containsObject:subject.courseID]) {
            
            [self.cancelCourseList removeObject:subject.courseID];
            
            [cell cellIsSelected:NO];
            
        }else{
            
            [self.cancelCourseList addObject:subject.courseID];
            
            [cell cellIsSelected:YES];

         }
        
        //如果学校被选择状态，在先中cell时，要删除学校的选中状态
        if ([self.cancelUniversityList containsObject:university.NO_id]) {
            
            [self.cancelUniversityList removeObject:university.NO_id];
            [self.cancelSetions removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        // [self.tableView reloadData];
            
        }
        
        
        
    }else{  //非编辑状态
 
        
        if (self.courseSelecteds.count  == 0) {
            
            [self.self.courseSelecteds  addObject:subject.courseID];
            
 
        }else if ([self.courseSelecteds containsObject:subject.courseID]) {
            
            [self.courseSelecteds removeObject:subject.courseID];
            
 
        }else{
            
            NSArray *idGroup = [group.subjects valueForKey:@"courseID"];
            
            for (NSString  *selectedID in self.courseSelecteds){
                
                if([idGroup containsObject:selectedID]){
                    
                    [self.courseSelecteds removeObject:selectedID];
                    
                    [self.courseSelecteds addObject:subject.courseID];
                    
                    //取消cell刷新时默认动画效果
                    [UIView performWithoutAnimation:^{
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                    
                    return;
                }
                
             }
            
                [self.courseSelecteds addObject:subject.courseID];

           }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [self configureSelectedCoursedID:[self.courseSelecteds copy]];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



/*
 *  ApplicationList-001 = @"请至少选择一门课程"
 *  Evaluate-0016   = @"好的"
 *  ApplicationList-002 =  @"您提交审核的申请不能超过6个！"
 *  NSSet *selectedIDSet = [NSSet setWithArray:];
 */
- (IBAction)applyButtonPressed {
    
    RequireLogin
    
    if (![self checkNetworkState])  return;
    
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
        
        return;
    }
    
        
    UIAlertView *aler =[[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"ApplicationList-comfig") delegate:self cancelButtonTitle:GDLocalizedString(@"NetRequest-OK") otherButtonTitles:GDLocalizedString(@"Potocol-Cancel"), nil];
    [aler show];
    
}


//编辑按钮方法
-(void)EditClick:(UIBarButtonItem *)sender
{
    NSString *cancelTitle =  @"取消";
    NSString *editTitle = @"编辑";
    
    self.cell_Animation = YES;
    if ([sender.title isEqualToString:editTitle] ) {
        
        sender.title = cancelTitle;
        [self bottomUp:NO];
        
    }else{
        
        sender.title = editTitle;
        [self.cancelCourseList removeAllObjects];
        [self.cancelUniversityList removeAllObjects];
        [self.cancelSetions removeAllObjects];
        [self.cancelindexPathes removeAllObjects];
        [self bottomUp:YES];
        
    }
    
    [self.tableView reloadData];
    [self.courseSelecteds removeAllObjects];
    [self configureSelectedCoursedID:self.courseSelecteds];
    
}


-(void)dealloc{
    
    KDClassLog(@"申请意向  dealloc");
}

@end
