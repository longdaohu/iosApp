//
//  IntelligentResultViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#define TABLEROWHEIGHT 100
#define TABLEHEADVIEWHEIGHT 305

#import "XYPieChart.h"
#import "IntelligentResultViewController.h"
#import "ResultTableViewCell.h"
#import "ApplyViewController.h"
#import "UniversityFrame.h"
#import "UniversityNew.h"
#import "PipeiEditViewController.h"
#import "PipeiNoResultVeiw.h"

@interface IntelligentResultViewController ()<XYPieChartDelegate, XYPieChartDataSource,UITableViewDataSource,UITableViewDelegate,ResultTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ResultTableView;
@property (weak, nonatomic) IBOutlet UILabel *NewSelectLabel;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *currentCountLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *pieSelectLabel;
@property (weak, nonatomic) IBOutlet UIView *upHeaderView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
//推荐数据源
@property(nonatomic,strong)NSMutableArray *recommendations;
//临时数据源
@property(nonatomic,strong)NSMutableArray *resultList;
@property(nonatomic,strong)NSMutableArray *NewSelectUniversityIDs;
@property(nonatomic,strong)NSMutableArray *SelectedUniversityIDs;
//pieChart图表
@property (strong, nonatomic) XYPieChart *PieHeadView;
//pieChart图表每一格的数量数组
@property(nonatomic, strong) NSMutableArray  *slices;
//pieChart图表每一格对应的图标说明
@property(nonatomic, strong)NSArray            *subtitleArr;
//pieChart图表每一格对应的颜色数组
@property(nonatomic, strong) NSMutableArray    *sliceColors;
//pieChart图表每一格对应名称数组
@property(nonatomic, strong) NSMutableArray    *sliceTitles;
//pieChart图表每一格对应弧度数组
@property(nonatomic, strong) NSMutableArray    *sliceAngles;
//pieChart图表中间的文字说明
@property(nonatomic,strong)UILabel    *centerLabel;
//pieChart图表中间按钮
@property(nonatomic,strong)UIButton   *centerButton;
//pieChart已选择项
@property(nonatomic,assign)NSUInteger selectIndex;
//数据为空时，显示提示信息
@property(nonatomic,strong)PipeiNoResultVeiw *pipeiNoDataView;


@end

@implementation IntelligentResultViewController

-(NSMutableArray *)NewSelectUniversityIDs
{
    if (!_NewSelectUniversityIDs) {
        
        _NewSelectUniversityIDs =[NSMutableArray array];
    }
    return _NewSelectUniversityIDs;
}

-(NSMutableArray *)SelectedUniversityIDs
{
    if (!_SelectedUniversityIDs) {
        
        _SelectedUniversityIDs =[NSMutableArray array];
    }
    return _SelectedUniversityIDs;
}

-(NSMutableArray *)resultList
{
    if (!_resultList) {
        
        _resultList =[NSMutableArray array];
    }
    return _resultList;
}

-(NSMutableArray *)sliceAngles
{
    if (!_sliceAngles) {
        
        _sliceAngles =[NSMutableArray array];
    }
    return _sliceAngles;
}

-(NSMutableArray *)sliceColors{

    if (!_sliceColors) {
        
        _sliceColors = [NSMutableArray arrayWithObjects:XCOLOR_RED,XCOLOR(44, 175, 222),XCOLOR(18, 35, 60),nil];
    }
    
    return _sliceColors;
}

-(NSMutableArray *)sliceTitles{

    if (!_sliceTitles) {
        /*
         "Evaluate-Dream" = "冲刺";
         "Evaluate-Middle" = "核心";
         "Evaluate-Secure" = "保底";
         */
        _sliceTitles = [NSMutableArray arrayWithObjects:GDLocalizedString(@"Evaluate-Dream"),GDLocalizedString(@"Evaluate-Middle"),GDLocalizedString(@"Evaluate-Secure"),nil];
    }
    return _sliceTitles;

}

-(NSArray *)subtitleArr
{
    if (!_subtitleArr) {
        /*
         "Evaluate-PieDream_chongChi" = "申请成功就赚了，选2所试试。";
         "Evaluate-PieCore_heXin" = "最适合你的学校，请至少重点考虑2-3所学校。";
         "Evaluate-PieSecure_baoDi" = "申请成功率较高的学校，建议至少选择1-2所。";
         */
        _subtitleArr = @[GDLocalizedString(@"Evaluate-PieDream_chongChi"),GDLocalizedString(@"Evaluate-PieCore_heXin"),GDLocalizedString(@"Evaluate-PieSecure_baoDi")];
    }
    return _subtitleArr;
}

- (PipeiNoResultVeiw *)pipeiNoDataView{

    if (!_pipeiNoDataView) {
        
        XWeakSelf
        _pipeiNoDataView = [PipeiNoResultVeiw viewWithActionBlock:^{
            
            [weakSelf casePipeiEditPage];
            
        }];
        
        [self.view addSubview:_pipeiNoDataView];
    }
    
    return _pipeiNoDataView;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page智能匹配结果"];
    
    [self DataSourseRequst];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page智能匹配结果"];
    
}


- (void)viewDidUnload
{
    self.PieHeadView = nil;
    self.slices = nil;
    self.sliceColors = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self changeLanguageEnvironment];
  
}

-(void)changeLanguageEnvironment{
    
     [self.commitButton setTitle:GDLocalizedString(@"UniCourseDe-009") forState:UIControlStateNormal];
     self.NewSelectLabel.text =[NSString stringWithFormat:@"%@ ：0",GDLocalizedString(@"ApplicationList-003")];
     self.pieSelectLabel.text = self.subtitleArr[0];
     self.title = GDLocalizedString(@"Evaluate-inteligent");
     self.NoDataLabel.text = GDLocalizedString(@"Evaluate-noData");
}


-(void)makeHeaderView
{
    
    self.ResultTableView.rowHeight = TABLEROWHEIGHT;
    self.headerView.frame =  CGRectMake(0, 0, self.ResultTableView.frame.size.width, TABLEHEADVIEWHEIGHT);
    self.ResultTableView.tableHeaderView = self.headerView;
    
    
    CGFloat centerW = 110;
    CGFloat centerH = centerW;
    CGFloat centerX = 0.5 * (XScreenWidth - centerW);
    CGFloat centerY = 0.5 *(208 - 110);
    self.centerButton =  [[UIButton alloc] initWithFrame:CGRectMake(centerX, centerY, centerW, centerH)];
    self.centerButton.backgroundColor = XCOLOR_BG;
    self.centerButton.layer.cornerRadius = self.centerButton.frame.size.width *0.5;
    self.centerButton.layer.masksToBounds = YES;
    self.centerButton.titleLabel.numberOfLines = 0;
    self.centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.upHeaderView addSubview:self.centerButton];
    self.slices = [NSMutableArray arrayWithCapacity:10];

    
}

-(void)makePieChar{

    
    if (self.PieHeadView) {
        
        [self.PieHeadView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.PieHeadView removeFromSuperview];
        self.PieHeadView = nil;
    }
    
    self.PieHeadView = [[XYPieChart alloc] initWithFrame:CGRectMake(0.5 *(XScreenWidth - 208), 0, 208, 208)];
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


-(void)makeOtherView
{
    self.ResultTableView.backgroundColor = XCOLOR_BG;
    self.bottomView.hidden = YES;
    self.NoDataView.frame = CGRectMake(0, 0, XScreenWidth, XScreenHeight);
    self.NoDataView.hidden = YES;
    [self.view addSubview: self.NoDataView];
}

-(void)makeNavigatinView
{
 
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Edit39"] style:UIBarButtonItemStylePlain target:self action:@selector(casePipeiEditPage)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    
}

-(void)makeUI
{

    [self makeNavigatinView];
    
    [self makeHeaderView];
    
    [self makeOtherView];
    
}

-(void)makeAttributedText:(NSString *)sumCountStr currentcount:(NSString *)currentCountSr  currentItem:(NSString *)currentStr
{
    // 富文本文字
    NSString *centerText = [NSString stringWithFormat:@"%@\n%@", sumCountStr,GDLocalizedString(@"Evaluate-match")];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:centerText];
    [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[centerText rangeOfString:centerText]];
    [AttributedString addAttribute:NSForegroundColorAttributeName   value:XCOLOR_RED  range:[centerText rangeOfString:sumCountStr]];
    [AttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:[centerText rangeOfString:sumCountStr]];
    [self.centerButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
   
    if (currentCountSr.intValue > 0) {
        
         [self makeCurrentLabel:currentCountSr currentItem:currentStr];
     }
}


-(void)makeCurrentLabel:(NSString *)currentCountSr  currentItem:(NSString *)currentStr
{
    NSString *currentText = [NSString stringWithFormat:@"%@",currentStr];
    NSMutableAttributedString *Attribut = [[NSMutableAttributedString alloc] initWithString:currentText];
    [Attribut addAttribute:NSForegroundColorAttributeName   value:XCOLOR_RED  range:[currentText rangeOfString:currentCountSr]];
    self.currentCountLabel.attributedText = Attribut;
}

-(void)DataSourseRequst
{
    
    if (self.refreshCount >  0) return;
    
     self.refreshCount++;
  
        XWeakSelf;
        
        [self startAPIRequestWithSelector:kAPISelectorZiZengRecommendation  parameters:@{} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
            
        } additionalSuccessAction:^(NSInteger statusCode, id response) {
            
            [weakSelf configrationUI:response[@"recommendations"]];
            
        } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
            
            weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
            
        }];
  
}

//根据返回数据设置UI
- (void)configrationUI:(NSArray *)recommendations
{
    
    [_slices removeAllObjects];
    [self.sliceAngles removeAllObjects];
    [self.recommendations removeAllObjects];
    [self makePieChar];
    
    NSMutableArray *temp_recommendations = [NSMutableArray array];
    
    for (NSArray *items in recommendations) {
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSDictionary *obj  in items) {
           
            UniversityFrame *uniFrame = [[UniversityFrame alloc] init];
            uniFrame.university = [UniversityNew mj_objectWithKeyValues:obj];
            [temps addObject:uniFrame];
            
         }
        
        [temp_recommendations addObject:temps];
        
    }
    
    self.recommendations = [temp_recommendations mutableCopy];
    
    
    NSUInteger totalCount = 0;
    
    for (NSArray *uniersitys in  self.recommendations) {
        
        totalCount += uniersitys.count;
    }
    
    //------------------------------------------------------------------------
    NSString *firstItem;
    NSInteger selectedIndex = -1;
    for(int i = 0; i < 3; i ++){
        
        NSUInteger count = [self.recommendations[i] count];
        
        //设置选择项
        if (count > 0  && -1 == selectedIndex ) selectedIndex = i;
        
        //count 数字大小可以增加显示范围
        if (count != 0)  count = count + 4;
        
        NSNumber *one = [NSNumber numberWithInt:(int)count];
        
        [_slices addObject:one];
        
        if (count > 0 && firstItem.length == 0) {
            
            firstItem = @"已存在";
            self.resultList  =  [self.recommendations[i] mutableCopy];
            [self makeAttributedText:[NSString stringWithFormat:@"%ld",(unsigned long)totalCount] currentcount:[NSString stringWithFormat:@"%ld",(long)self.resultList.count]  currentItem:self.sliceTitles[i]];
            self.lineView.backgroundColor =self.sliceColors[i];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.PieHeadView setSliceSelectedAtIndex:selectedIndex];
        
    });
    
    self.selectIndex  = selectedIndex;
    
    //------------------------------------------------------------------------
    
    int total = 0; //用于显示学校总数
    
    for (NSNumber *num in _slices) {
        
        total += num.intValue;
    }
    
    
    NSNumber *startNum;
    
    for (NSNumber *num in _slices) {
        
        if (num.intValue > 0) {
            
            startNum = num;
            
            break;
        }
    }
    
    
    CGFloat angle = 2 * M_PI * startNum.integerValue / total;
    
    [self.PieHeadView setStartPieAngle:M_PI_2 - angle/2]; //piechar设置开始角度
    
    //这里应该是正常的
   //   NSLog(@"piechar设置开始角度  %lf %lf",angle,M_PI_2 - angle/2);
    //添加pieCharr的角度
    for (NSNumber *num in _slices) {
        
        CGFloat angle = 2 * M_PI * num.intValue /total;
        NSString *angleStr = [NSString stringWithFormat:@"%lf",angle];
        [self.sliceAngles addObject:angleStr];
        
    }
    
    //数组0 的字数据为0时，设置 已选择项 为 1
    if([self.sliceAngles[0] floatValue] == 0) self.selectIndex = 1;

    
    for (NSArray *universitys in self.recommendations) {
        
        for(UniversityFrame *uniFrame in universitys)
        {
            if (uniFrame.university.in_cart) [self.SelectedUniversityIDs addObject:uniFrame.university.NO_id];
        }
    }
    
    self.bottomView.hidden = total == 0 ? YES : NO;
    self.NoDataView.hidden = !self.bottomView.hidden;
    self.pipeiNoDataView.hidden = !self.bottomView.hidden;
    
    //延迟显示
     XWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (total>0) [weakSelf.PieHeadView reloadData];
     
    });
    
    //延迟显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        
    });

    
    [self.ResultTableView reloadData];
    
    
}


#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Uni_Cell_Height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultTableViewCell  *cell = [ResultTableViewCell cellInitWithTableView:tableView];
    cell.delegate = self;
    
    UniversityFrame *uniFrame = self.resultList[indexPath.row];
    UniversityNew *university = uniFrame.university;
    [cell configureWithUniversityFrame:uniFrame];
    [self configureCellSelectionView:cell universityId:university.NO_id];
    
    return cell;
}

#pragma mark ——— ResultTableViewCellDelegate

-(void)selectResultTableViewCellItem:(UIButton *)sender withUniversityInfo:(NSString *)universityID
{
   
    if ([self.SelectedUniversityIDs containsObject:universityID]) {return;}
    
    
    if( [self.NewSelectUniversityIDs containsObject:universityID])
    {
        [self.NewSelectUniversityIDs removeObject:universityID];
        [sender setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
    }
    else
    {
        [self.NewSelectUniversityIDs addObject:universityID];
        [sender setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateNormal];

    }
    
    self.NewSelectLabel.text =[NSString stringWithFormat:@"%@ ：%d",GDLocalizedString(@"ApplicationList-003"),(int)self.NewSelectUniversityIDs.count];
}


- (void)configureCellSelectionView:(ResultTableViewCell *)cell universityId:(NSString *)Uni_id {

    if ([self.SelectedUniversityIDs containsObject:Uni_id]) {// @"已添加"
        [cell configrationCellLefButtonWithTitle:GDLocalizedString(@"UniCourseDe-007")  imageName:nil]   ;
    } else if ([self.NewSelectUniversityIDs containsObject:Uni_id]) {
        [cell configrationCellLefButtonWithTitle:nil  imageName:@"check-icons-yes"]   ;
    } else {
        [cell configrationCellLefButtonWithTitle:nil  imageName:@"check-icons"]   ;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     UniversityFrame *uniFrame = self.resultList[indexPath.row];
 
     [self.navigationController pushUniversityViewControllerWithID:uniFrame.university.NO_id animated:YES];
}


- (IBAction)CommitButtonPressed:(KDEasyTouchButton *)sender {
    
    if (self.NewSelectUniversityIDs.count == 0) {
        
        AlerMessage(GDLocalizedString(@"Evaluate-commitNoti"));
        
        return;
    }
/*
    else if(self.NewSelectUniversityIDs.count >6)
    {
        [KDAlertView showMessage:GDLocalizedString(@"Evaluate-commitAlert") cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];//@"好的"];
        return;
    }
*/
    
    [self
     startAPIRequestWithSelector:kAPISelectorZiZengApplyPost
     parameters:@{@"uid": self.NewSelectUniversityIDs}
     success:^(NSInteger statusCode, id response) {
     
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud setLabelText:GDLocalizedString(@"ApplicationProfile-0015")];//@"加入成功"];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             
             
          ApplyViewController *apply = [[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil];
             
          if (self.fromStyle.length > 0) {
                 
                 apply.backStyle = YES;
          }
          [self.navigationController pushViewController:apply animated:YES];
         
         }];
     }];
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    
    return self.sliceTitles[index];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    
    
    self.lineView.backgroundColor =self.sliceColors[index];
    
    if (self.selectIndex != index) {
      
    [self.resultList removeAllObjects];
    
    self.resultList =  [self.recommendations[index] mutableCopy];
        
    [self.ResultTableView reloadData];
    
    [self makeCurrentLabel:[NSString stringWithFormat:@"%lu",(unsigned long)self.resultList.count] currentItem:self.sliceTitles[index]];

    self.pieSelectLabel.text = self.subtitleArr[index];
        
        
        __block  CGFloat turnAngle = 0;
        
        if ([self.sliceAngles[0] floatValue] == 0  && [self.sliceAngles[1] floatValue] == 0){
            
            //只有一个数组中有数据， 0 1 数组为空
            
//             NSLog(@"1   if sliceAngles  %lf  %lf  %lf",[self.sliceAngles[0] floatValue],[self.sliceAngles[1] floatValue],[self.sliceAngles[2] floatValue]);

            return;
            
        }else if([self.sliceAngles[0] floatValue] == 0 && [self.sliceAngles[1] floatValue] != 0) {
            
            //数组0 为空  1  2 有数据

            
            NSString *slicesAngle = self.sliceAngles[2];
            
            NSString *slicesSelectAngle = self.sliceAngles[1];
            
            CGFloat turn = 0.5 * (slicesAngle.floatValue + slicesSelectAngle.floatValue);
            
            if(self.selectIndex == 1)
            {
                turnAngle = index == 2 ? - turn : turn;
            }
            else if(self.selectIndex == 2)
            {
                turnAngle = index == 1 ? - turn :turn;
            }
            
//            NSLog(@"2  else   if sliceAngles  %lf  %lf  %lf",[self.sliceAngles[0] floatValue],[self.sliceAngles[1] floatValue],[self.sliceAngles[2] floatValue]);
            
        }else{
            
            //三个数组都有数据
            
//            NSLog(@"3 else     sliceAngles  %lf  %lf  %lf",[self.sliceAngles[0] floatValue],[self.sliceAngles[1] floatValue],[self.sliceAngles[2] floatValue]);
            
            NSString *slicesAngle = self.sliceAngles[index];
            
            NSString *slicesSelectAngle = self.sliceAngles[self.selectIndex];
            
            CGFloat turn = 0.5 * (slicesAngle.floatValue +slicesSelectAngle.floatValue);
            
            if (self.selectIndex ==0 &&slicesAngle.floatValue != 0) {
                
                turnAngle = index == 1 ? -turn: turn;
            }
            else if(self.selectIndex == 1 &&slicesAngle.floatValue != 0)
            {
                turnAngle = index == 2 ? - turn : turn;
            }
            else if(self.selectIndex == 2 &&slicesAngle.floatValue != 0)
            {
                turnAngle = index == 0 ? - turn : turn;
            }
            
        }
        
        [UIView animateWithDuration:0.6 animations:^{
            
            pieChart.transform = CGAffineTransformRotate(self.PieHeadView.transform, turnAngle);
            
        }];
        
        self.selectIndex = index;
        
        
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
    }

}



//返回上级页面
-(void)popBack
{
     //判断是否从编辑页面跳转过来
    if (self.fromStyle.length > 0) {
        
        //从编辑页跳转过来,返回时不经过编辑页跳回上级页面
        if (self.navigationController.childViewControllers.count > 3) {
            
            [self.navigationController popToViewController: (UIViewController *)self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:YES];
       
            return ;

         }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
     
        return ;
    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
 
}



-(void)casePipeiEditPage
{
    PipeiEditViewController *pipeiEdit = [[PipeiEditViewController alloc] init];
    pipeiEdit.isfromPipeiResultPage = YES;
    [self.navigationController pushViewController:pipeiEdit animated:YES];
        
    
}



- (void)dealloc{
    
    KDClassLog(@"智能匹配结果 dealloc");
}

@end
