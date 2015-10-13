//
//  PersonInfoViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/9.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UniversitySearchViewController.h"
#import "UserInfViewController.h"
#import "GPAscoreViewController.h"
#import "YasiViewController.h"
#import "PersonSectionView.h"
#import "CountrySelectionViewController.h"
#import "PlanTimeeViewController.h"
#import "planSubViewController.h"
#import "peronInfoItem.h"
#import "ApplySubmitViewController.h"


@interface PersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *personInfoTableView;
@property(nonatomic,strong)NSArray *orderInfo;
@property(nonatomic,strong)NSSet *selectedCourseIDs;
@property(nonatomic,strong)NSArray *selectedCoursesIDs;
@property(nonatomic,strong)NSArray *PersonInfoGroups;
@property(nonatomic,strong)UIView *NotiTableHeaderView;
@property(nonatomic,strong)UIView *FirstSectionView;
@property(nonatomic,strong)UIView *SecondSectionView;
@property(nonatomic,strong)KDEasyTouchButton *commitButton;
@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,assign)int progressValueA;
@property(nonatomic,assign)int progressValueB;
@end

@implementation PersonInfoViewController
- (instancetype)initWithApplyInfo:(NSArray *)info selectedIDs:(NSArray *)courseIds {
    self = [self init];
    if (self) {
        self.orderInfo = info;
        self.selectedCoursesIDs = courseIds;
     }
    return self;
}


//- (instancetype)initWithApplyInfo:(NSArray *)info selectedIDs:(NSSet *)ids {
//    self = [self init];
//    if (self) {
//        self.orderInfo = info;
//        self.selectedCourseIDs = ids;
//    }
//    return self;
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self startAPIRequestWithSelector:@"GET api/account/applicationdata" parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
        
        self.userInfo   = response;
        
         
        NSString *des_country = [response valueForKey:@"des_country"];
        
        NSString *target_date = [response valueForKey:@"target_date"];
        
        NSString *apply = [response valueForKey:@"apply"];
        
        NSString *last_name = [response valueForKey:@"last_name"];
        
        NSString *university = [response valueForKey:@"university"];
        
        NSString *score = [response valueForKey:@"score"];
        NSString *scoreStr =[NSString stringWithFormat:@"%@",score];
        
        NSString *ielts_avg = [response valueForKey:@"ielts_avg"];
        NSString *ielts_avgStr =[NSString stringWithFormat:@"%@",ielts_avg];
        
        peronInfoItem *item001 =[[peronInfoItem alloc] init];
                
        item001.itemTitle = GDLocalizedString(@"ApplicationProfile-003");//@"想去的国家或地区";
        if (des_country.length) {
            item001.isFinsh = YES;
            self.progressValueA += 1;
        }
        
        peronInfoItem *item002 =[[peronInfoItem alloc] init];
        item002.itemTitle = GDLocalizedString(@"ApplicationProfile-004");//@"计划出国时间";
        if (target_date.length) {
            item002.isFinsh = YES;
            self.progressValueA += 1;
            
        }
        
        peronInfoItem *item003 =[[peronInfoItem alloc] init];
        item003.itemTitle = GDLocalizedString(@"ApplicationProfile-005");//@"希望就读专业";
        if (apply.length) {
            item003.isFinsh = YES;
            self.progressValueA += 1;
        }
        
        NSArray *group001 = @[item001,item002,item003];
        
        
        peronInfoItem *item004 =[[peronInfoItem alloc] init];
        item004.itemTitle = GDLocalizedString(@"ApplicationProfile-006");//@"姓名";
        if (last_name.length) {
            item004.isFinsh = YES;
            self.progressValueB += 1;
            
        }
        peronInfoItem *item005 =[[peronInfoItem alloc] init];
        item005.itemTitle = GDLocalizedString(@"ApplicationProfile-007");//@"就读院校";
        if (university.length) {
            item005.isFinsh = YES;
            self.progressValueB += 1;
        }
        
        peronInfoItem *item007 =[[peronInfoItem alloc] init];
        item007.itemTitle = GDLocalizedString(@"ApplicationProfile-009");//@"雅思成绩";
        if (ielts_avgStr.length) {
            item007.isFinsh = YES;
            self.progressValueB += 1;
            
        }
        
        peronInfoItem *item006 =[[peronInfoItem alloc] init];
        item006.itemTitle = GDLocalizedString(@"ApplicationProfile-008");//@"GPA(平均成绩)";
        if (scoreStr.length) {
            item006.isFinsh = YES;
            self.progressValueB += 1;
        }
        NSArray *group002 = @[item004,item005,item006,item007];
        self.PersonInfoGroups = @[group001,group002];
        
        [self.personInfoTableView reloadData];
        
    }];
    
}
- (void)viewDidLoad {
    
     [super viewDidLoad];
    self.title = GDLocalizedString(@"ApplicationProfile-001");//@"个人资料";  @"提交审核"
    [self makeHeaderView];
    [self makeFootView];
    
}
//设置底部提交按钮
-(void)makeFootView
{
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, APPSIZE.height - 50, APPSIZE.width, 50)];
    footView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:footView];
    KDEasyTouchButton *commitButton =[[KDEasyTouchButton alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 50)];
    [commitButton setTitle:GDLocalizedString(@"ApplicationProfile-0012") forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    commitButton.backgroundColor =[UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    self.commitButton = commitButton;
    [footView addSubview:commitButton];
    
}

//设置表头
-(void)makeHeaderView
{
    self.NotiTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 100)];
    UILabel *notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.NotiTableHeaderView.bounds.size.width - 20, 100)];
    notiLabel.text = GDLocalizedString(@"ApplicationProfile-0016");// @"亲，你离成功申请只差填写基本资料哦。
    notiLabel.numberOfLines = 0;
    [self.NotiTableHeaderView addSubview:notiLabel];
    self.personInfoTableView.tableHeaderView = self.NotiTableHeaderView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.PersonInfoGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *testArray = self.PersonInfoGroups[section];
    return testArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"test"];
    
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"test"];
        
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    NSArray *group = self.PersonInfoGroups[indexPath.section];
    peronInfoItem *item = group[indexPath.row];
    
    cell.textLabel.text = item.itemTitle;
    if (item.isFinsh == YES) {
 
        cell.detailTextLabel.text = GDLocalizedString(@"ApplicationProfile-0010");//@"已完成";
        
    }else
    {   cell.detailTextLabel.textColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
        
        cell.detailTextLabel.text = GDLocalizedString(@"ApplicationProfile-0011");//@"未完成";
        
    }
 
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PersonSectionView *personSV =[[NSBundle mainBundle] loadNibNamed:@"PersonSectionView" owner:nil options:nil].lastObject;
    
    NSArray *group = self.PersonInfoGroups[section];
    
    if (section ==0 ) {
        

        personSV.sectionTitleLabel.text =  GDLocalizedString(@"ApplicationProfile-002");//@"请您选择你的留学意向";
        
        personSV.ProgressValue = self.progressValueA*1.0/ group.count;
        
    }else
    {
        personSV.sectionTitleLabel.text =   GDLocalizedString(@"ApplicationProfile-0013");// @"请填写您的背景资料";
        
        personSV.ProgressValue  = self.progressValueB*1.0/ group.count;
        
    }
    return personSV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
      
        if (indexPath.row == 0) {
            
            CountrySelectionViewController *vc =[[CountrySelectionViewController alloc] initWithNibName:@"CountrySelectionViewController" bundle:nil];
            vc.userInfo = self.userInfo;
            [self.navigationController pushViewController:vc animated:YES];
           
            
        }else if(indexPath.row == 1)
        {
            PlanTimeeViewController *vc =[[PlanTimeeViewController alloc] initWithNibName:@"PlanTimeeViewController" bundle:nil];
             vc.userInfo = self.userInfo;
             [self.navigationController pushViewController:vc animated:YES];
        }else
        {   //希望申请专业
            planSubViewController *vc =[[planSubViewController alloc] initWithNibName:@"planSubViewController" bundle:nil];
            vc.userInfo = self.userInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
     }else{
        
        if (indexPath.row == 0) {//姓名
             UserInfViewController *vc =[[UserInfViewController alloc] initWithNibName:@"UserInfViewController" bundle:nil];
            vc.userInfo = self.userInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1) //学校
        {
            UniversitySearchViewController *vc =[[UniversitySearchViewController alloc] initWithNibName:@"UniversitySearchViewController" bundle:nil];
            vc.userInfo = self.userInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2) //平均成绩
        {
            GPAscoreViewController *vc =[[GPAscoreViewController alloc] initWithNibName:@"GPAscoreViewController" bundle:nil];
            vc.userInfo = self.userInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }else   //雅思成绩
        {
            YasiViewController *vc =[[YasiViewController alloc] initWithNibName:@"YasiViewController" bundle:nil];
            vc.userInfo = self.userInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)commitButtonPressed:(KDEasyTouchButton *)sender {
    
 
    for (NSArray *group in self.PersonInfoGroups) {
        
        for (int i = 0; i<group.count; i++) {
            peronInfoItem *item = group[i];
            if (item.isFinsh == NO) {
 
                NSString *EmptyNoti = GDLocalizedString(@"ApplicationProfile-0014");//不能为空
                NSString *itemName = [NSString stringWithFormat:@"%@%@",item.itemTitle,EmptyNoti];
                [KDAlertView showMessage:itemName cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"]; "Evaluate-0016"
                return;
                
            }
        }
    }
   
     [self
     startAPIRequestWithSelector:@"POST /api/account/checkin"
     parameters:@{@"courseIds": self.selectedCoursesIDs}
     success:^(NSInteger statusCode, id response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud setLabelText: GDLocalizedString(@"ApplicationProfile-0015")];//@"加入成功"];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self.navigationController popToRootViewControllerAnimated:YES];
            // [self dismiss];
         }];
     }];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
