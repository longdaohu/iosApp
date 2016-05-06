//
//  ApplyViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
// 我的申请意向

#import "ApplyViewController.h"
#import "SearchResultCell.h"
#import "ApplySectionView.h"
#import "UniversityCourseViewController.h"
#import "CommitInfoViewController.h"
#import "ApplySection.h"
#import "Applycourse.h"


@interface ApplyViewController ()<UIAlertViewDelegate>
{
    NSArray *_waitingCells;
    NSArray *_info;
    NSMutableSet *_selectedIDs;
    NSArray *_courseInfos;
}
@property(nonatomic,strong)NSMutableArray *responds; //请求得到数据数组
@property(nonatomic,strong)NSMutableArray *idGroups;//所有学校的专业ID数组
@property(nonatomic,assign)int totalCount;//所有学校的专业ID数组
@property(nonatomic,strong)NSMutableArray  *courseSelecteds; //已选中课程ID数组
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property(nonatomic,strong)NSMutableArray *cancelCourseList;//提交删除的课程ID数组
@property(nonatomic,strong)NSMutableArray *cancelUniversityList;//提交删除的学校ID数组
@property(nonatomic,strong)NSMutableArray *sectionGroups;
@property(nonatomic,strong)NSMutableArray *cancelSetions;//删除分区数组
@property(nonatomic,strong)NSMutableArray *cancelindexPathes;//删除cell对就的indexpath数组
@property(nonatomic,copy)NSString *rightButtonTitle;
@property(nonatomic,strong)UIButton *cancelBottomButton;
@property(nonatomic,strong)UILabel *notiCoverLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic,assign)BOOL haveUp;

@end

@implementation ApplyViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(UILabel *)notiCoverLabel
{
    if (!_notiCoverLabel) {
        _notiCoverLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0, APPSIZE.width, 50)];
        _notiCoverLabel.numberOfLines = 0;
        _notiCoverLabel.textAlignment = NSTextAlignmentCenter;
        _notiCoverLabel.backgroundColor =[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        _notiCoverLabel.textColor =[UIColor whiteColor];
        _notiCoverLabel.text = GDLocalizedString(@"ApplicationList-noti"); //用于提示用户已提交留学审核，不能重复提交;
        _notiCoverLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _notiCoverLabel;
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


-(void)makeUI
{
    
    [self.submitBtn setTitle:GDLocalizedString(@"ApplicationList-005") forState:UIControlStateNormal];
    self.noDataLabel.text = GDLocalizedString(@"ApplicationList-noData");//Duang!请添加您的意向学校吧！
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([_waitingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_waitingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
     _waitingTableView.tableFooterView = [[UIView alloc] init];
    _waitingTableView.sectionFooterHeight = 10;
    self.title = GDLocalizedString(@"Me-001");
    
    if (self.isLeftMenu) {
        //左侧菜单按钮
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BurgerMenu_39"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu:)];
        
    }else{
    
        UIBarButtonItem  *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-50"] style:UIBarButtonItemStylePlain target:self action:@selector(popBackRootViewController)];
        self.navigationItem.leftBarButtonItem =leftItem;
    }
 
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:GDLocalizedString(@"ApplicationList-Edit") style:UIBarButtonItemStylePlain target:self action:@selector(EditClick:)];
    
    self.bottomView.frame = CGRectMake(0, APPSIZE.height - 50,APPSIZE.width, 50);
    [self.view addSubview:self.bottomView];
    
    self.cancelBottomButton =[[UIButton alloc] initWithFrame:CGRectMake(0,APPSIZE.height,APPSIZE.width, 50)];
    [self.cancelBottomButton setTitle:GDLocalizedString(@"ApplicationList-Delete")  forState:UIControlStateNormal];
    [self.cancelBottomButton addTarget:self action:@selector(commitCancelList:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBottomButton.backgroundColor = MAINCOLOR;
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
    if (self.cancelCourseList.count == 0 && self.cancelUniversityList.count == 0) { //
          [KDAlertView showMessage:GDLocalizedString(@"ApplicationList-please") cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];
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
     [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"ids":self.cancelCourseList}
                              success:^(NSInteger statusCode, id response) {
                                
//                                  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
//                                  NSArray *sortArray = [self.cancelindexPathes  sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
                                  
                                  NSArray *sortArray =[self sortArray:self.cancelindexPathes];
//                                   NSLog(@"xxxxxxxxxxxxxxx sort = %@, paths = %@",sortArray,self.cancelindexPathes);
                                  for (NSIndexPath *indexpath in sortArray) {
                                      
                                         ApplySection *sectionModal = self.sectionGroups[indexpath.section];
                                         [sectionModal.subjects removeObjectAtIndex:indexpath.row];
                                         [_waitingTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationFade];
                                  }
                           
                                  [self.cancelindexPathes removeAllObjects];
                                  [self.cancelCourseList removeAllObjects];
                                  
                                  if (self.cancelSetions > 0) {
                                      
                                      [self commitCancelSectionView];
                                      
                                  }
                               }];
    
}

//删除sectionHeader
-(void)commitCancelSectionView
{
     [self startAPIRequestWithSelector:kAPISelectorUpdateApplyResult
                           parameters:@{@"uIds":self.cancelUniversityList}
                              success:^(NSInteger statusCode, id response) {
                                 
//                                  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
//                                  NSArray *newArray = [self.cancelSetions  sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
                                   NSArray *newArray = [self  sortArray:self.cancelSetions];
                                  for (NSString *section in newArray) {
                                        [self.sectionGroups removeObjectAtIndex:section.integerValue];
                                       [_waitingTableView deleteSections:[NSIndexSet indexSetWithIndex:section.integerValue] withRowAnimation:UITableViewRowAnimationFade];
                                     }
                                  [self.cancelUniversityList removeAllObjects];
                                  [self.cancelSetions removeAllObjects];
                                  [_waitingTableView reloadData];
                                   self.noDataView.hidden = self.sectionGroups.count == 0 ?NO:YES;
                               }];
}
//对数组进行排序
-(NSArray *)sortArray:(NSArray *)contents
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    NSArray *sortArray = [contents  sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
     return sortArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
   
 }


//网络数据请求
- (void)RequestDataSourse {
    
    XJHUtilDefineWeakSelfRef;
    [self startAPIRequestWithSelector:@"GET api/account/applies" parameters:nil success:^(NSInteger statusCode, NSArray *response) {
     
         weakSelf.responds = [response mutableCopy];
         weakSelf.noDataView.hidden = YES;
         if(response.count == 0)
         {
             weakSelf.noDataLabel.text = GDLocalizedString(@"ApplicationList-noData");
             weakSelf.noDataView.hidden = NO;
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
-(void)checkApplyStatus
{
     if (self.isApplied) {
        
        self.submitBtn.enabled = NO;
        
        [self.bottomView addSubview:self.notiCoverLabel];
         
         
         return ;
         
     }
    
    
    if (!self.haveUp) {
        
            self.haveUp = YES;
        
        [self startAPIRequestWithSelector:@"GET api/account/applicationliststateraw" parameters:nil success:^(NSInteger statusCode, id response) {
            
            NSString *state = response[@"state"];
            
            if (![state containsString:@"1"])
            {
                
                self.submitBtn.enabled = NO;
                [self.bottomView addSubview:self.notiCoverLabel];
               
            }
            
        }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
        if ([[AppDelegate sharedDelegate] isLogin]) {
                 [self RequestDataSourse];
        }else{
        
            [self.sectionGroups removeAllObjects];
             [_waitingTableView reloadData];
             self.noDataView.hidden = NO;
         }
    
     [self checkApplyStatus];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ApplySection *sectionM = self.sectionGroups[section];
    
    return sectionM.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"applyCell"];
    
    if (!cell) {
         cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"applyCell"];
         cell.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
         [(UIImageView *)cell.accessoryView setContentMode:UIViewContentModeCenter];
     }
    
    ApplySection *sectionM = self.sectionGroups[indexPath.section];
    Applycourse *subject = sectionM.subjects[indexPath.row];
      if ([self.courseSelecteds  containsObject:subject.courseID]) {
        [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
    }
    else
    {
        [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons"]];
     }
    
     cell.textLabel.text = subject.courseName ?subject.courseName:subject.official_name;
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")]) {
       
        [(UIImageView *)cell.accessoryView setImage:nil];
        
          if ([self.cancelCourseList containsObject:subject.courseID]){
            cell.imageView.image = [UIImage imageNamed:@"check-icons-yes"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"check-icons"];
        }
        
        }else{
        
        cell.imageView.image = nil;

     }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
      __weak typeof(self)weakSelf = self;
      __weak ApplySectionView *sectionView =[[NSBundle mainBundle] loadNibNamed:@"ApplySectionView" owner:nil options:nil].lastObject;
    
     ApplySection *sectionModal = self.sectionGroups[section];
     NSString *universityID = sectionModal.universityInfo[@"_id"];
     sectionView.sectionInfo = sectionModal.universityInfo;
     sectionView.isEdit = [self.navigationItem.rightBarButtonItem.title isEqualToString:GDLocalizedString(@"Potocol-Cancel")];
     sectionView.isSelected = [self.cancelUniversityList containsObject:universityID];
    
     sectionView.actionBlock = ^(UIButton *sender){
       
         if (sender.tag == 10) {
            UniversityCourseViewController *vc = [[UniversityCourseViewController alloc] initWithUniversityID:universityID];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else{

             NSString *sectionStr = [NSString stringWithFormat:@"%ld",section];
             if (![self.cancelSetions containsObject:sectionStr]) {
                
                [self.cancelSetions addObject:sectionStr];
  
            }else{
                
                 [self.cancelSetions removeObject:sectionStr];
            }
            
             NSArray *sujectItems = sectionModal.subjects;
            
             if (![self.cancelUniversityList containsObject:universityID]) {
                
                 [self.cancelUniversityList addObject:universityID];
  
                  for (NSInteger row = sujectItems.count - 1; row >= 0; row--) {
                      
                     Applycourse *subject  = sujectItems[row];
                      
                      if (![self.cancelCourseList containsObject:subject.courseID]) {
                        
                          [self.cancelCourseList addObject:subject.courseID];
                          
                           NSIndexPath *indexpath = [NSIndexPath  indexPathForRow:row inSection:section];
 
                            [self.cancelindexPathes addObject:indexpath];
                       }
                    }
                 
    
            }else{
                
                [self.cancelUniversityList removeObject:universityID];
                
//                [_waitingTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                
                for (NSInteger row = 0; row < sujectItems.count; row++) {
                    
                    Applycourse *subject  = sujectItems[row];
                    
                    [self.cancelCourseList removeObject:subject.courseID];
                    
                    NSIndexPath *indexpath = [NSIndexPath  indexPathForRow:row inSection:section];
                    
//                    [_waitingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
                    [self.cancelindexPathes removeObject:indexpath];
                    
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
        
        
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.cancelCourseList containsObject:subject.courseID]) {
            
             [self.cancelCourseList removeObject:subject.courseID];
            
              cell.imageView.image = [UIImage imageNamed:@"check-icons"];
        }else{
            
             [self.cancelCourseList addObject:subject.courseID];
              cell.imageView.image = [UIImage imageNamed:@"check-icons-yes"];
             }
        
        
         if ([self.cancelUniversityList containsObject:universityInfo[@"_id"]]) {
          
             [self.cancelUniversityList removeObject:universityInfo[@"_id"]];
             
             [self.cancelSetions removeObject:[NSString stringWithFormat:@"%ld",indexPath.section]];
             
             
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




- (IBAction)applyButtonPressed {
   
     RequireLogin
    
    if (self.courseSelecteds.count == 0) {
        /*
         *  ApplicationList-001 = @"请至少选择一门课程"  
         *  Evaluate-0016   = @"好的"
         *  ApplicationList-002 =  @"您提交审核的申请不能超过6个！"
         *  NSSet *selectedIDSet = [NSSet setWithArray:];
         */
        [KDAlertView showMessage:GDLocalizedString(@"ApplicationList-001")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
        return;
    }
    
         if (self.courseSelecteds.count > 6) {
         [KDAlertView showMessage:GDLocalizedString(@"ApplicationList-002") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"
       
     }
    
     CommitInfoViewController *vc = [[CommitInfoViewController alloc] initWithApplyInfo:self.responds selectedIDs:[self.courseSelecteds copy]];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)configureSelectedCoursedID:(NSArray *)selectedIDs {
    
    _selectCountLabel.text = [NSString stringWithFormat:@"%@ : %ld ",GDLocalizedString(@"ApplicationList-003"), (unsigned long)self.courseSelecteds.count];
}

//打开左侧菜单
-(void)showLeftMenu:(UIBarButtonItem *)barButton
{
    [self.sideMenuViewController presentLeftMenuViewController];

}

-(void)popBackRootViewController
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    
//    NSLog(@"xxxxxxxxxx popToRootViewControllerAnimatedpopToRootViewControllerAnimated");
}

@end
