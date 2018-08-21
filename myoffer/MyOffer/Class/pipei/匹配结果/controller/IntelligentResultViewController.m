//
//  IntelligentResultViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#define TABLEHEADVIEWHEIGHT 305
#import "XYPieChart.h"
#import "IntelligentResultViewController.h"
#import "ResultTableViewCell.h"
#import "ApplyViewController.h"
#import "UniversityFrame.h"
#import "MyOfferUniversityModel.h"
#import "PipeiEditViewController.h"
#import "PipeiNoResultVeiw.h"
#import "PeiperGroup.h"

@interface IntelligentResultViewController ()<XYPieChartDelegate, XYPieChartDataSource,UITableViewDataSource,UITableViewDelegate,ResultTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet MyOfferTableView *ResultTableView;
@property (weak, nonatomic) IBOutlet UILabel *selectedLab;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *pieTitleLab;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *pieSubtitleLab;
@property (weak, nonatomic) IBOutlet UIView *upHeaderView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)NSArray *current_items;
@property(nonatomic,strong)NSMutableArray *NewSelectUniversityIDs;
@property (strong, nonatomic) XYPieChart *PieHeadView;//pieChart图表
@property(nonatomic,strong)UIButton   *centerButton;//pieChart图表中间按钮
@property(nonatomic,assign)NSUInteger selectIndex;//pieChart已选择项
@property(nonatomic,strong)PipeiNoResultVeiw *pipeiNoDataView;//数据为空时，显示提示信息

@end

@implementation IntelligentResultViewController

-(NSMutableArray *)groups
{
    if (!_groups) {
        
        _groups =[NSMutableArray array];
    }
    return _groups;
}

-(NSMutableArray *)NewSelectUniversityIDs
{
    if (!_NewSelectUniversityIDs) {
        _NewSelectUniversityIDs =[NSMutableArray array];
    }
    return _NewSelectUniversityIDs;
}

- (PipeiNoResultVeiw *)pipeiNoDataView{

    if (!_pipeiNoDataView) {
        
        WeakSelf
        _pipeiNoDataView = [PipeiNoResultVeiw viewWithActionBlock:^{
            [weakSelf casePipeiEditPage];
        }];
        [self.view insertSubview:_pipeiNoDataView atIndex:0];

    }
    
    return _pipeiNoDataView;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page智能匹配结果"];
 
    NavigationBarHidden(NO);

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page智能匹配结果"];
    
}


- (void)viewDidUnload
{
    self.PieHeadView = nil;
   
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self DataSourseRequst];

    [self makeUI];
}

-(void)makeHeaderView
{
    
    self.headerView.frame =  CGRectMake(0, 0, self.ResultTableView.frame.size.width, TABLEHEADVIEWHEIGHT);
    self.ResultTableView.tableHeaderView = self.headerView;
    self.ResultTableView.backgroundColor = XCOLOR_BG;
    self.ResultTableView.tableFooterView = [UIView new];
    
    CGFloat centerW = 110;
    CGFloat centerH = centerW;
    CGFloat centerX = 0.5 * (XSCREEN_WIDTH - centerW);
    CGFloat centerY = 0.5 *(208 - 110);
    self.centerButton =  [[UIButton alloc] initWithFrame:CGRectMake(centerX, centerY, centerW, centerH)];
    self.centerButton.backgroundColor = XCOLOR_BG;
    self.centerButton.layer.cornerRadius = self.centerButton.frame.size.width *0.5;
    self.centerButton.layer.masksToBounds = YES;
    self.centerButton.titleLabel.numberOfLines = 0;
    self.centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.upHeaderView addSubview:self.centerButton];
    
}

-(void)makePieChar{

    
    if (self.PieHeadView) {
        
        [self.PieHeadView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.PieHeadView removeFromSuperview];
        self.PieHeadView = nil;
    }
    
    self.PieHeadView = [[XYPieChart alloc] initWithFrame:CGRectMake(0.5 *(XSCREEN_WIDTH - 208), 0, 208, 208)];
    [self.upHeaderView insertSubview:self.PieHeadView belowSubview:self.centerButton];
    
    [self.PieHeadView setDataSource:self];
    [self.PieHeadView setDelegate:self];
    [self.PieHeadView setStartPieAngle:M_PI/6];
    [self.PieHeadView setAnimationSpeed:1.0];
    [self.PieHeadView setLabelFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16]];
    [self.PieHeadView setLabelRadius:75];
    [self.PieHeadView setShowPercentage:NO];
    self.PieHeadView.showLabel = YES;
    [self.PieHeadView setPieBackgroundColor:[UIColor clearColor]];
    [self.PieHeadView setUserInteractionEnabled:YES];
    //    [self.PieHeadView setLabelShadowColor:[UIColor blackColor]];
//    self.PieHeadView.backgroundColor = [UIColor greenColor];
  
}




-(void)makeNavigatinView
{
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Edit39"] style:UIBarButtonItemStylePlain target:self action:@selector(casePipeiEditPage)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow_white"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
}

-(void)makeUI
{
    [self makeNavigatinView];
    [self makeHeaderView];
    self.title = @"智能匹配";

}


-(void)DataSourseRequst
{
 
        WeakSelf;
        
        [self startAPIRequestWithSelector:kAPISelectorZiZengRecommendation  parameters:@{} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        } additionalSuccessAction:^(NSInteger statusCode, id response) {
            [weakSelf updateUIWithResponse:response];
        } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
            [weakSelf showError];
            
        }];
  
}

- (void)makeGroupsDataWithReconmentes:(NSArray *)reconmentes{
    
    if (self.groups.count > 0) {
     
        [self.groups removeAllObjects];
    }
    
    NSMutableArray *group_temp = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        
        NSArray *recommendation = (i >(reconmentes.count - 1)) ? @[] : reconmentes[i];
        NSArray *universities = [MyOfferUniversityModel mj_objectArrayWithKeyValuesArray:recommendation];
        
        NSMutableArray *temps = [NSMutableArray array];
        for (MyOfferUniversityModel *uni  in universities) {
            
            UniversityFrame *uniFrame = [[UniversityFrame alloc] init];
            uniFrame.university = uni;
            [temps addObject:uniFrame];
        }
        NSString *title = @"";
        NSString *subtitle = @"";
        UIColor *slice_color = nil;
        switch (i) {
            case 0:{
                title = @"冲刺";
                subtitle = @"申请成功就赚了，选2所试试。";
                slice_color = XCOLOR_RED;
            }
                break;
            case 1:{
                title = @"核心";
                subtitle = @"最适合你的学校，请至少重点考虑2-3所学校。";
                slice_color = XCOLOR(44, 175, 222 , 1);
            }
                break;
            default:{
                title = @"保底";
                subtitle = @"申请成功率较高的学校，建议至少选择1-2所。";
                slice_color = XCOLOR(18, 35, 60 , 1);
            }
                break;
        }
        PeiperGroup *group = [PeiperGroup groupWithTitle:title  subtitle:subtitle items:temps];
        group.sliceColor = slice_color;
        [group_temp addObject:group];
    }
    
    self.groups = [group_temp mutableCopy];
    
    
}

//根据返回数据设置UI
- (void)updateUIWithResponse:(id)response{
 
    [self.NewSelectUniversityIDs removeAllObjects];
    [self makePieChar];
    [self makeGroupsDataWithReconmentes:response[@"recommendations"]];
    
    //------------------------------------------------------------------------
    NSInteger selectedIndex = -1;//当前选择项
    NSInteger slices_count = 0;//几个色块
    NSInteger uni_count = 0;

    for(int i = 0; i < self.groups.count; i ++){
        
        PeiperGroup *group =  self.groups[i];
        NSUInteger group_items_count = group.items.count;
        uni_count += group_items_count;

        //count 数字大小可以增加显示范围
        if (group_items_count != 0)
        {
            slices_count++;
            group_items_count = group_items_count + 4;
        }
        group.slice_count = [NSNumber numberWithInt:(int)group_items_count];
        
        //设置当前项数据
        if (group_items_count > 0 && -1 == selectedIndex) {
            
            selectedIndex = i;//设置选择项
            PeiperGroup *group = self.groups[selectedIndex];
            group.selected = YES;
            self.selectIndex  = selectedIndex;
            [self makCurrentDataWithGroup:group];
        }
        
     }

    self.PieHeadView.userInteractionEnabled = (slices_count > 1);
    if (slices_count > 1) { //当选项只有一个时，self.PieHeadView不可点击
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.PieHeadView setSliceSelectedAtIndex:selectedIndex];
        });
    }
    //------------------------------------------------------------------------
    
    int total = 0; //用于显示学校总数
    NSNumber *startNum;
    for (PeiperGroup *group in self.groups) {
       total +=  group.slice_count.intValue;
        if (group.slice_count.intValue > 0 && !startNum) {
            startNum = group.slice_count;
         }
    }
    CGFloat angle = 2 * M_PI * startNum.integerValue / total;
    [self.PieHeadView setStartPieAngle:M_PI_2 - angle/2]; //piechar设置开始角度
 
    //这里应该是正常的
    //NSLog(@"piechar设置开始角度  %lf %lf",angle,M_PI_2 - angle/2);
    //添加pieCharr的角度
    for (PeiperGroup *group in self.groups) {
        CGFloat angle = 2 * M_PI * group.slice_count.intValue /total;
         group.slice_angle = [NSString stringWithFormat:@"%lf",angle];
    }

    //延迟显示
     WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (total>0) [weakSelf.PieHeadView reloadData];
    });
    //延迟显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
    });
    
    self.pipeiNoDataView.hidden = !(slices_count == 0);
    self.ResultTableView.hidden =  (slices_count == 0);
    self.commitButton.superview.hidden = self.ResultTableView.hidden;
    [self.ResultTableView reloadData];
 
    // 富文本文字
    NSString *total_str = [NSString stringWithFormat:@"%ld",uni_count];
    NSString *centerText = [NSString stringWithFormat:@"%@\n%@", total_str,GDLocalizedString(@"Evaluate-match")];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:centerText];
    [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[centerText rangeOfString:centerText]];
    [AttributedString addAttribute:NSForegroundColorAttributeName   value:XCOLOR_RED  range:[centerText rangeOfString:total_str]];
    [AttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:[centerText rangeOfString:total_str]];
    [self.centerButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
    
    self.selectedLab.text =[NSString stringWithFormat:@"%@ ：%d",GDLocalizedString(@"ApplicationList-003"),(int)self.NewSelectUniversityIDs.count];
    
}

#pragma mark :UITableViewDelegate  UITableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return  self.current_items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ResultTableViewCell  *cell = [ResultTableViewCell cellInitWithTableView:tableView];
    cell.delegate = self;
    UniversityFrame *uniFrame = self.current_items[indexPath.row];
    [cell configureWithUniversityFrame:uniFrame];
 
    if (uniFrame.university.in_cart) {
        [cell configrationCellLefButtonWithTitle:@"已添加"  imageName:nil]   ;
    } else if ([self.NewSelectUniversityIDs containsObject:uniFrame.university.NO_id]) {
        [cell configrationCellLefButtonWithTitle:nil  imageName:@"check-icons-yes"]   ;
    } else {
        [cell configrationCellLefButtonWithTitle:nil  imageName:@"check-icons"]   ;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityFrame *uniFrame = self.current_items[indexPath.row];

    return uniFrame.cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UniversityFrame *uniFrame = self.current_items[indexPath.row];
    [self.navigationController pushUniversityViewControllerWithID:uniFrame.university.NO_id animated:YES];
    
}

//提交申请意向
- (IBAction)CommitButtonPressed:(KDEasyTouchButton *)sender {
    
    if (self.NewSelectUniversityIDs.count == 0) {
        AlerMessage(GDLocalizedString(@"Evaluate-commitNoti"));
        return;
    }
    
    
    [self
     startAPIRequestWithSelector:kAPISelectorZiZengApplyPost
     parameters:@{@"uid": self.NewSelectUniversityIDs}
     success:^(NSInteger statusCode, id response) {
     
         MBProgressHUD *hud = [MBProgressHUD showSuccessWithMessage:@"加入成功" ToView:self.view];
         hud.completionBlock = ^{
             
             ApplyViewController *apply = [[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil];
 
             NSInteger current = self.navigationController.childViewControllers.count - 1;
             NSInteger pop_index = current - 1;
             
             if (self.from_Edit_Pipei) {
                 
                 pop_index = pop_index - 1;
             }
             
             
             apply.pop_back_index = pop_index;
             
             [self.navigationController pushViewController:apply animated:YES];
         };
         
     }];
}


#pragma mark : ResultTableViewCellDelegate
-(void)selectResultTableViewCellItem:(UIButton *)sender withUniversityInfo:(NSString *)universityID
{
    NSString *icon =  @"";
    if( [self.NewSelectUniversityIDs containsObject:universityID]){
        
        [self.NewSelectUniversityIDs removeObject:universityID];
        icon = @"check-icons";
    }
    else{
        [self.NewSelectUniversityIDs addObject:universityID];
        icon = @"check-icons-yes";
    }
    [sender setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    self.selectedLab.text =[NSString stringWithFormat:@"%@ ：%d",GDLocalizedString(@"ApplicationList-003"),(int)self.NewSelectUniversityIDs.count];
}



#pragma mark : XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    
    return self.groups.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    
    PeiperGroup *group = self.groups[index];
    return group.slice_count.intValue;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    
    PeiperGroup *group = self.groups[index];
    return group.sliceColor;
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
    
     PeiperGroup *group = self.groups[index];
     return group.title;
}

#pragma mark : XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    
    if (self.selectIndex == index) return;
    
        PeiperGroup *group = self.groups[index];
        PeiperGroup *group_selected = self.groups[self.selectIndex];
        NSString *slice_selected_angle = group_selected.slice_angle;
        NSString *slices_angle =  group.slice_angle;
        
        NSInteger pie_count = 0;
        for (PeiperGroup *group in self.groups) {
            if (group.items.count > 0) {
                pie_count += 1;
            }
        }
        __block  CGFloat turnAngle = 0;
      //只有一个数组中有数据 这里不可能点击到
      //if (pie_count<=1){return; }
        if(pie_count == 2) {
            //有两组数据
            //turnAngle = (index == 1) ? - turn : turn;
            CGFloat turn = 0.5 * (slices_angle.floatValue + slice_selected_angle.floatValue);
            turnAngle = -turn;

        }else{
            //三个数组都有数据
            CGFloat turn = 0.5 * (slices_angle.floatValue + slice_selected_angle.floatValue);
            if (self.selectIndex ==0 &&slices_angle.floatValue != 0) {
                turnAngle = index == 1 ? -turn: turn;
            }
            else if(self.selectIndex == 1 &&slices_angle.floatValue != 0){
                turnAngle = index == 2 ? - turn : turn;
            }
            else if(self.selectIndex == 2 &&slices_angle.floatValue != 0){
                turnAngle = index == 0 ? - turn : turn;
            }
            
        }
        //pieChart转动
        [UIView animateWithDuration:0.6 animations:^{
            pieChart.transform = CGAffineTransformRotate(self.PieHeadView.transform, turnAngle);
        }];

        UIView *pie = self.PieHeadView.subviews[0];
        CALayer *parentLayer = [pie layer];
        NSArray *slicelayers = [parentLayer sublayers];
        [slicelayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            CAShapeLayer *layer = (CAShapeLayer *)obj;
             for (CATextLayer *textLayer in layer.sublayers) {
                 [UIView animateWithDuration:3 animations:^{
                     textLayer.transform = CATransform3DRotate(textLayer.transform, - turnAngle, 0, 0,1);
                 }];
            }
            
        }];
 
        self.selectIndex = index;
        [self makCurrentDataWithGroup:group];
        [self.ResultTableView reloadData];

}



//返回上级页面
-(void)popBack
{
     //判断是否从编辑页面跳转过来
    if (self.from_Edit_Pipei) {

        
        NSInteger current = self.navigationController.childViewControllers.count - 1;
        NSInteger pop_index = current - 1;
        NSInteger index = pop_index - 1;
        
        if (index < 0 ) {
            
            index  = 0;
        }
        
        UIViewController *pop_vc = self.navigationController.childViewControllers[index];
        
        [self.navigationController popToViewController:pop_vc animated:YES];
     
        return ;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
 
}

//设置当前数据
- (void)makCurrentDataWithGroup:(PeiperGroup *)group{
    
    self.current_items = group.items;
    self.lineView.backgroundColor = group.sliceColor;
    self.pieTitleLab.text = group.title;
    self.pieSubtitleLab.text = group.subtitle;
    
}

//进入智能匹配
-(void)casePipeiEditPage
{
    WeakSelf;
    PipeiEditViewController *pipeiEdit = [[PipeiEditViewController alloc] init];
    pipeiEdit.actionBlock = ^(NSString *pipei) {
 
        weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
        [weakSelf DataSourseRequst];
    };
    [self.navigationController pushViewController:pipeiEdit animated:YES];

}

//显示错误提示
- (void)showError{
    
    if (self.groups.count == 0) {
        
        self.ResultTableView.tableHeaderView = [UIView new];
        [self.ResultTableView emptyViewWithError:NetRequest_ConnectError];
        self.footerView.alpha = 0;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }
}

- (void)dealloc{
    
    KDClassLog(@"智能匹配结果 dealloc");
}

@end
