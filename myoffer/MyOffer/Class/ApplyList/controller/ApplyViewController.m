//
//  ApplyViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
// 申请意向
#import "XWGJTiJiaoViewController.h"
#import "ApplyViewController.h"
#import "Applycourse.h"
#import "ApplySectionHeaderView.h"
#import "ApplyTableViewCell.h"
#import "MyOfferUniversityModel.h"
#import "UniversitySubjectListViewController.h"


#define Button_Title_Cancel @"取消"
#define Button_Title_Edit @"编辑"

typedef NS_ENUM(NSInteger,ApplyTableStatus){

    ApplyTableStatusNomal = 0,
    
    ApplyTableStatusEdit

};

@interface ApplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  MyOfferTableView *tableView;
//模型数组
@property(nonatomic,strong)NSMutableArray *groups;
//已选中课程ID数组
@property(nonatomic,strong)NSMutableArray *courseSelecteds;
//删除分区数组
@property(nonatomic,strong)NSMutableArray *cancelSetions;
//删除cell对就的indexpath数组
@property(nonatomic,strong)NSMutableArray *cancelindexPathes;

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
//tableView的状态
@property(nonatomic,assign)ApplyTableStatus tableStatus;

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewConstraint;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBottomButton;
@property (weak, nonatomic) IBOutlet UILabel *cancelCountLab;


@end

@implementation ApplyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.pop_back_index = DEFAULT_NUMBER;

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page申请意向"];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
 
    [self presentViewWillAppear];
    
}

//viewWillAppear状态页面数据调整

-(void)presentViewWillAppear{

//    if (![self checkNetworkState]) {
//       
//        [self.tableView emptyViewWithError:NetRequest_ConnectError];
//        
//        self.bottomView.alpha = 0;
//        
//        self.navigationItem.rightBarButtonItem.enabled = NO;
// 
//        return;
//    }
    
    
    if (LOGIN) {
        
         [self makeDataSourse];
        
         [self checkApplyStatus];
        
    }else{
        
        [self.groups removeAllObjects];
        [self.tableView reloadData];
        [self emptyViewShowWithResult:self.groups];
        
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



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
}


//如果用户已经申请过，在提交按钮上添加一个遮盖
/*     state     状态有4个值
 *  【 pending  ——审核中
 *  【 PushBack ——退回
 *  【 Approved ——审核通过
 *  【 -1       ——没有申请过
 */
-(void)checkApplyStatus{
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorApplicationStatus  parameters:nil showHUD:NO errorAlertDismissAction:nil success:^(NSInteger statusCode, id response) {
        
        if (![response[@"state"] containsString:@"1"] && ![response[@"state"] containsString:@"ack"])
        {
            weakSelf.submitBtn.enabled = NO;
            weakSelf.AlertLab.hidden = NO;
        }
        
    }];
 
}


//网络数据请求
- (void)makeDataSourse {
    
    XWeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorApplicationList parameters:nil expectedStatusCodes:nil showHUD:(self.groups.count == 0) showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf upadateUIWithResponse:(NSArray *)response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf showError];
    }];
    
}

#pragma mark : 根据网络请求刷新页面
-(void)upadateUIWithResponse:(NSArray *)response{

    if(response.count == 0){
        
        [self emptyViewShowWithResult:response];
       
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        self.submitBtn.enabled = NO;
        
        return ;
    }
    
    
    NSArray *universities = [MyOfferUniversityModel mj_objectArrayWithKeyValuesArray:response];
    
    NSMutableArray  *temps = [NSMutableArray array];
    
    for (MyOfferUniversityModel *uni in universities) {
        
        UniversityFrameNew *uni_frame = [UniversityFrameNew universityFrameWithUniverstiy:uni];
        
        [temps addObject:uni_frame];
    }
    
    self.groups = [temps mutableCopy];
    
    [self.tableView reloadData];
    
}


-(void)makeUI
{
    [self makeTableView];
    
    [self makeOther];
    
    [self makeNavigationBarButtonItem];
    
    self.editViewConstraint.constant = 70;

    
}

- (void)makeTableView{
    
    self.tableView = [[MyOfferTableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view insertSubview:self.tableView atIndex:0];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
}


-(void)makeOther
{
   
    self.title = @"申请意向";
    self.AlertLab.text = GDLocalizedString(@"ApplicationList-noti");
    self.AlertLab.font = XFONT(XFONT_SIZE(1) * 3 + 13);
    
    [self.submitBtn setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_RED] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_Disable] forState:UIControlStateDisabled];
    [self.cancelBottomButton setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_RED] forState:UIControlStateNormal];
    [self.cancelBottomButton setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_Disable] forState:UIControlStateDisabled];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.sectionFooterHeight =  Section_footer_Height_nomal;
    
    
}


-(void)makeNavigationBarButtonItem{
    
    UIBarButtonItem  *leftItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popBackRootViewController)];
    self.navigationItem.leftBarButtonItem  = leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:Button_Title_Edit style:UIBarButtonItemStylePlain target:self action:@selector(EditButtonOnClick:)];
}


#pragma mark : UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UniversityFrameNew *uni_frame = self.groups[section];
    
    return uni_frame.universtiy.applies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UniversityFrameNew *uni_frame = self.groups[indexPath.section];
    
    Applycourse *apply = uni_frame.universtiy.applies[indexPath.row];
    
    ApplyTableViewCell *cell =[ApplyTableViewCell cellWithTableView:tableView];
    
    cell.Edit = (self.tableStatus == ApplyTableStatusEdit);
    
    cell.title =  apply.official_name;
    
    cell.isSelected = cell.Edit ? [self.cancelindexPathes containsObject:indexPath] : [self.courseSelecteds  containsObject:apply.course_id];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return KDUtilSize(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    UniversityFrameNew *uni_frame = self.groups[section];
    
    return  uni_frame.cell_Height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XWeakSelf
    UniversityFrameNew *uni_frame = self.groups[section];
    
    ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
//    sectionView.cell_Animation = self.cell_Animation;
    sectionView.edit = (self.tableStatus == ApplyTableStatusEdit);
    sectionView.isSelected = [self.cancelSetions containsObject:[NSString stringWithFormat:@"%ld",section]];
    sectionView.uniFrame = uni_frame;
    sectionView.actionBlock = ^(UIButton *sender){
        
        [weakSelf updateSetionViewWithSender:sender universityFrame:uni_frame section:section];
        
    };
    
    [sectionView showBottomLineHiden:(uni_frame.universtiy.applies.count == 0)];

    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UniversityFrameNew *uni_frame = self.groups[indexPath.section];

    Applycourse *subject = uni_frame.universtiy.applies[indexPath.row];
    
     //编辑状态
    if (self.tableStatus == ApplyTableStatusEdit){
        
        ApplyTableViewCell *cell =(ApplyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
      
        //删除的 indexPath 数组
        if ([self.cancelindexPathes containsObject:indexPath] ) {
        
            //1 删除 indexPath
            [self.cancelindexPathes removeObject:indexPath];
            
            //2 是否被选中
            [cell cellIsSelected:NO];
            
            
        }else{
            
             //1 添加 indexPath
            [self.cancelindexPathes addObject:indexPath];
            
           //2 是否被选中
            [cell cellIsSelected:YES];
            
            
        }
        
   
        
        //如果学校被选择状态，在先中cell时，要删除学校的选中状态
        NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        if ([self.cancelSetions containsObject: sectionStr]) {
            
            [self.cancelSetions removeObject:sectionStr];
         
            [UIView performWithoutAnimation:^{
                
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        }
        
        
        [self  updateEditStatusFooterView];
        
        
         return;
        
    }
    
    
    
    //非编辑状态
    if([self.courseSelecteds containsObject:subject.course_id]){
    
        [self.courseSelecteds removeObject:subject.course_id];
        
        
    }else{
    
        
        NSArray *course_id_group = [uni_frame.universtiy.applies valueForKeyPath:@"course_id"];
        
        //判断分组是否包含已选择数据
        for (NSString  *course_id in self.courseSelecteds){
            
            if([course_id_group containsObject:course_id]){
                
                //保证一个分组只能添加一个专业课程
                [self.courseSelecteds removeObject:course_id];
                [self.courseSelecteds addObject:subject.course_id];
                
                //取消cell刷新时默认动画效果
                [UIView performWithoutAnimation:^{
                    
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    
                }];
  
                
                return;
            }
            
        }
        
        //当分组没有这个专业时，添加新专业数据
        [self.courseSelecteds addObject:subject.course_id];
        
    }
    
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self updateFooterViewItems];
   
}


/*
 *  ApplicationList-001 = @"请至少选择一门课程"
 *  Evaluate-0016   = @"好的"
 *  ApplicationList-002 =  @"您提交审核的申请不能超过6个！"
 *  NSSet *selectedIDSet = [NSSet setWithArray:];
 */
#pragma mark : 点击提交申请按钮

- (IBAction)applyButtonPressed {
    
    RequireLogin
    
    if (![self checkNetworkState])  return;
    
    
    if (self.courseSelecteds.count > 6) {
        
        AlerMessage(GDLocalizedString(@"ApplicationList-002"));
       
        return;
    }
    
    XWGJTiJiaoViewController *vc = [[XWGJTiJiaoViewController alloc] init];
    
    vc.selectedCoursesIDs        =  [self.courseSelecteds copy];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//1  root -- 我的申请 -- A     3


//返回上级页面
-(void)popBackRootViewController
{
    
    NSArray *items = self.navigationController.childViewControllers;
    
    
    if (self.pop_back_index == DEFAULT_NUMBER) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
  
        NSInteger index =  self.pop_back_index < 0  ?  0 : self.pop_back_index;
        
//        NSLog(@" ApplyViewController   pop >>>>>>>>>>>> current %ld     heavetToPop %ld   self.pop_back_index  %ld",items.count - 1,pop,self.pop_back_index);
        
        UIViewController *childVC = items[index];
        
        [self.navigationController popToViewController:childVC animated:YES];
        
    }
    
    
 }

//用于控制删除按钮出现隐藏
-(void)bottomViewUp:(BOOL)up
{
    
    float distance = up ? 70 : 0;
    
    self.editViewConstraint.constant = distance;
    
    [self.view setNeedsUpdateConstraints];
    
    XWeakSelf
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        [weakSelf.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [weakSelf updateEditStatusFooterView];
        
    }];
 
    
    
}

#pragma mark : 点击提交删除按钮
- (IBAction)cancelOnClick:(UIButton *)sender {
    
    if (self.cancelindexPathes.count == 0 && self.cancelSetions.count == 0) {
        
        AlerMessage(GDLocalizedString(@"ApplicationList-please"));
        
        return;
    }
    
    
    XWeakSelf
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:GDLocalizedString(@"ApplicationList-comfig")  message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Button_Title_Cancel  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:GDLocalizedString(@"NetRequest-OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //先删除 已选择专业数组列表  > 再删除分区头
        [weakSelf commitCancelselectCell];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark : 点击编辑按钮

-(void)EditButtonOnClick:(UIBarButtonItem *)sender
{
    
//    self.cell_Animation = YES;
    
    //编辑状态
    if ([sender.title isEqualToString:Button_Title_Edit] ) {
        
        sender.title = Button_Title_Cancel;

        self.tableStatus = ApplyTableStatusEdit;

        [self bottomViewUp:NO];
        
        
        
    }else{
        
        //正常非编辑状态
        sender.title = Button_Title_Edit;
        
        self.tableStatus = ApplyTableStatusNomal;
        
        [self.cancelSetions removeAllObjects];
        [self.cancelindexPathes removeAllObjects];
        [self bottomViewUp:YES];

        
    }
    
    [self.tableView reloadData];
    [self.courseSelecteds removeAllObjects];
    [self updateFooterViewItems];
    
}



#pragma mark : 用于删除cell,先删除cell再删除sectionHeader

- (void)commitCancelselectCell{
    
    //提取要删除的 已选择学校专业ID
    NSMutableArray *courseIdes = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.cancelindexPathes) {
        
        UniversityFrameNew *uni_Frame = self.groups[indexPath.section];
        
        Applycourse *course =  uni_Frame.universtiy.applies[indexPath.row];
        
        [courseIdes addObject:course.course_id];

    }
    
    //提取要删除的 已选择学校的ID
    NSMutableArray *universtityIdes = [NSMutableArray array];
    
    for (NSString *sectionStr in self.cancelSetions) {
        
        NSInteger section = sectionStr.integerValue;
        
        UniversityFrameNew *uni_Frame = self.groups[section];
        
        [universtityIdes addObject:uni_Frame.universtiy.NO_id];
    }
    
    
    
    XWeakSelf
  
    [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult parameters:@{@"ids":courseIdes,@"uIds":universtityIdes} showHUD:NO success:^(NSInteger statusCode, id response) {
        
        [weakSelf  updateCancelSelectedCell];
        
    }];
    
}

//提交删除已选项 indexPath.row 成功后，更新UI

- (void)updateCancelSelectedCell{

    //排序，从大小到删除
    NSArray *sortIndexPathes =[self sortArray:self.cancelindexPathes];
    
    for (NSIndexPath *indexpath in sortIndexPathes) {
        
        UniversityFrameNew *group = self.groups[indexpath.section];
        //1、 删除已被选中 indexpath.row 对应的 group.subjects数组的子项
        [group.universtiy.applies removeObjectAtIndex:indexpath.row];
    }
    
    [self.tableView deleteRowsAtIndexPaths:self.cancelindexPathes withRowAnimation:UITableViewRowAnimationFade];
  
    //2、 当group.subjects数组的子项被删除后，可以清空 cancelindexPathes 数组
    [self.cancelindexPathes removeAllObjects];
    
    
    //3、 如里存在要删除的分组数据，再进入删除分区功能
    if (self.cancelSetions.count > 0){
    
        [self updateCancelSelectedSection];
        
        return;
    }
    
     [self updateEditStatusFooterView];
    
}


//提交删除已选项 indexPath.section 成功后，更新UI
- (void)updateCancelSelectedSection{
    
    //1、排序，从大小到删除
    NSArray *newArray = [self  sortArray:self.cancelSetions];
    
    //2、清空删除学校ID数组 、 删除分组信息数组
    [self.cancelSetions removeAllObjects];
    
    
    NSMutableIndexSet *deleteSet = [NSMutableIndexSet indexSet];
    for (NSString *section in newArray) {
        
        [self.groups removeObjectAtIndex:section.integerValue];
        //3、添加需要删除的分组
        [deleteSet addIndex:section.integerValue];
    }
    
    //4、动画删除选中分组
    [self.tableView deleteSections:deleteSet withRowAnimation:UITableViewRowAnimationFade];
    
    //5、动画刷新未选中分组
    NSMutableIndexSet *reloadSet = [NSMutableIndexSet indexSet];
    
    for (NSInteger index = 0; index < self.groups.count; index++) {
        
        [reloadSet addIndex:index];
    }
    
    [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationFade];
    
    [self  emptyViewShowWithResult:self.groups];
    
    self.submitBtn.enabled = self.groups.count  > 0;
    
    if (self.groups.count == 0) {
        
        [self bottomViewUp:YES];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

    
    [self updateEditStatusFooterView];
    
}


- (void)emptyViewShowWithResult:(NSArray *)resultes{
    
    if (resultes.count == 0) {
        
        [self.tableView emptyViewWithError:@"Duang!请添加您的意向学校吧！"];
        
        self.bottomView.alpha = 0;
        
    }else{
        
        [self.tableView emptyViewWithHiden:YES];
    }
    
}




//对数组进行排序
-(NSArray *)sortArray:(NSArray *)contents
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    NSArray *sortArray = [contents  sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    return sortArray;
}



- (void)updateSetionViewWithSender:(UIButton *)sender universityFrame:(UniversityFrameNew *)uni_frame  section:(NSInteger)section{

    if (sender.tag == 10) {//点击进入 UniversityCourseViewController 课程详情
        
        //            if (![weakSelf checkNetworkState])  return;
        //            weakSelf.cell_Animation = NO;
        
        [self.navigationController pushViewController:[[UniversitySubjectListViewController alloc] initWithUniversityID:uni_frame.universtiy.NO_id] animated:YES];
        
        return;
    }
    
    
    
    NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)section];
    //添加或删除   需要被删除组的信息
    
    if ([self.cancelSetions containsObject:sectionStr]) {
        
        // 1
        [self.cancelSetions removeObject:sectionStr];
        
        
        
        //2  学校取消
        
        for (NSInteger row = 0; row < uni_frame.universtiy.applies.count; row++) {
            
            
            [self.cancelindexPathes removeObject:[NSIndexPath  indexPathForRow:row inSection:section]];
        }
        
        
    }else{
        
        // 1
        [self.cancelSetions addObject:sectionStr];
        
        
        
        //2 添加或删除   需要被删除学校ID的信息 及学校ID对应学科ID数组
        
        for (NSInteger index = (uni_frame.universtiy.applies.count - 1); index >= 0; index--) {
            
            NSIndexPath *currentIndexPath = [NSIndexPath  indexPathForRow:index inSection:section];
            
            if (![self.cancelindexPathes containsObject:currentIndexPath]) {
                
                [self.cancelindexPathes addObject:[NSIndexPath  indexPathForRow:index inSection:section]];
                
            }
            
        }
        
        
    }
    
    
    //取消cell刷新时默认动画效果
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    
    [self  updateEditStatusFooterView];
    
    
}

//显示已选择专业数量
- (void)updateFooterViewItems{
    
    self.selectCountLabel.text = [NSString stringWithFormat:@"已选择 : %ld ", (unsigned long)self.courseSelecteds.count];
    
    self.submitBtn.enabled = self.courseSelecteds.count > 0;
    
}

-(void)updateEditStatusFooterView{
    
    NSInteger count = self.cancelSetions.count + self.cancelindexPathes.count;
    
    self.cancelCountLab.text = [NSString stringWithFormat:@"已选择 : %ld ", (long)count];
    
    self.cancelBottomButton.enabled = count;
 

}


//显示错误提示
- (void)showError{
    
    if (self.groups.count == 0) {
        
        [self.tableView emptyViewWithError:NetRequest_ConnectError];
        self.bottomView.alpha = 0;

    }
}




-(void)dealloc{
    
    KDClassLog(@"申请意向  dealloc");
}

@end
