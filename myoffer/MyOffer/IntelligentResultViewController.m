//
//  IntelligentResultViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//
typedef enum {
    descendeType = 0,
    AscendeType,
    NoType
} SortType;
#define TABLEROWHEIGHT 100
#define TABLEHEADVIEWHEIGHT 300

#import "XYPieChart.h"
#import "IntelligentResultViewController.h"
#import "SearchResultCell.h"
#import "ApplySectionView.h"
#import "ResultTableViewCell.h"
#import "IntelligentViewController.h"
#import "ApplyViewController.h"


@interface IntelligentResultViewController ()<XYPieChartDelegate, XYPieChartDataSource,UITableViewDataSource,UITableViewDelegate,ResultTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ResultTableView;
@property(nonatomic,strong)NSMutableArray *recommendations;
@property(nonatomic,strong)NSMutableArray *resultList;
@property(nonatomic,strong)NSMutableArray *NewSelectUniversityIDs;
@property(nonatomic,strong)NSMutableArray *SelectedUniversityIDs;
@property (weak, nonatomic) IBOutlet UILabel *NewSelectLabel;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;
@property (strong, nonatomic) IBOutlet XYPieChart *PieHeadView;
@property (weak, nonatomic) IBOutlet UILabel *currentCountLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *pieSelectLabel;
@property(nonatomic,assign)SortType universitySortType;
@property(nonatomic, strong) NSMutableArray  *slices;
@property(nonatomic, strong) NSMutableArray   *sliceColors;
@property(nonatomic, strong) NSMutableArray    *sliceTitleS;
@property(nonatomic,strong)UILabel *centerLabel;
@property(nonatomic,strong)UIButton *centerButton;
@property(nonatomic,assign)NSUInteger selectIndex;
@property(nonatomic,assign)BOOL isFresh;
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




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 
}

- (void)viewDidUnload
{
    self.PieHeadView = nil;
    self.slices = nil;
    self.sliceColors = nil;
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    
    [self DataSourseRequst];
    [self.PieHeadView reloadData];

}
-(void)changeLanguageEnvironment{
    
    [self.commitButton setTitle:GDLocalizedString(@"UniCourseDe-009") forState:UIControlStateNormal];
     self.NewSelectLabel.text =[NSString stringWithFormat:@"%@ ：0",GDLocalizedString(@"ApplicationList-003")];
     self.pieSelectLabel.text =GDLocalizedString(@"Evaluate-PieLabel");
     self.title = GDLocalizedString(@"Evaluate-inteligent");
     self.NoDataLabel.text = GDLocalizedString(@"Evaluate-noData");
}
-(void)makeUI;
{
    
    UIBarButtonItem  *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Edit39"] style:UIBarButtonItemStylePlain target:self action:@selector(fillInfomation)];
    self.navigationItem.rightBarButtonItem =rightItem;
    
    UIBarButtonItem  *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-50"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    self.pieSelectLabel.adjustsFontSizeToFitWidth = YES;
    self.ResultTableView.rowHeight = TABLEROWHEIGHT;
    self.headerView.frame =  CGRectMake(0, 0, self.ResultTableView.frame.size.width, TABLEHEADVIEWHEIGHT);
    self.ResultTableView.tableHeaderView = self.headerView;
    self.centerButton =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
    self.centerButton.center = CGPointMake(APPSIZE.width*0.5,110);
    self.centerButton.backgroundColor =[UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1];
    self.centerButton.layer.cornerRadius = self.centerButton.frame.size.width *0.5;
    self.centerButton.layer.masksToBounds = YES;
    self.centerButton.titleLabel.numberOfLines = 0;
    self.centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.centerButton];
 
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
//    self.PieHeadView.backgroundColor =[UIColor lightGrayColor];
    [self.PieHeadView setDataSource:self];
    [self.PieHeadView setDelegate:self];
    [self.PieHeadView setStartPieAngle:M_PI/6];
    [self.PieHeadView setAnimationSpeed:1.0];
    [self.PieHeadView setLabelFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16]];
    [self.PieHeadView setLabelRadius:80];
    [self.PieHeadView setShowPercentage:NO];
     self.PieHeadView.showLabel = YES;
    [self.PieHeadView setPieBackgroundColor:[UIColor clearColor]];
    [self.PieHeadView setUserInteractionEnabled:YES];
//    [self.PieHeadView setLabelShadowColor:[UIColor blackColor]];
 
}

-(void)makeAttributedText:(NSString *)sumCountStr currentcount:(NSString *)currentCountSr  currentItem:(NSString *)currentStr
{
    // 富文本文字
    NSString *centerText = [NSString stringWithFormat:@"%@\n%@", sumCountStr,GDLocalizedString(@"Evaluate-match")];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:centerText];
    [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[centerText rangeOfString:centerText]];
    [AttributedString addAttribute:NSForegroundColorAttributeName   value:MAINCOLOR  range:[centerText rangeOfString:sumCountStr]];
    [AttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:[centerText rangeOfString:sumCountStr]];
    [self.centerButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
   
    [self makeCurrentLabel:currentCountSr currentItem:currentStr];
}

-(void)makeCurrentLabel:(NSString *)currentCountSr  currentItem:(NSString *)currentStr
{
    NSString *currentText = [NSString stringWithFormat:@"%@ %@ %@",currentStr,currentCountSr,GDLocalizedString(@"Evaluate-dangwei")];
    NSMutableAttributedString *Attribut = [[NSMutableAttributedString alloc] initWithString:currentText];
    [Attribut addAttribute:NSForegroundColorAttributeName   value:MAINCOLOR  range:[currentText rangeOfString:currentCountSr]];
    self.currentCountLabel.attributedText = Attribut;
}

-(void)DataSourseRequst
{
 
    [_slices removeAllObjects];
//      __weak typeof(self) weakSelf = self;
    XJHUtilDefineWeakSelfRef;
      [self
     startAPIRequestWithSelector:@"GET api/university/recommendations"
     parameters:@{}
     success:^(NSInteger statusCode, id response) {
        
        weakSelf.recommendations = [response[@"recommendations"] mutableCopy];
         NSArray *recommendations  = [weakSelf.recommendations copy];
         
        weakSelf.sliceColors = [NSMutableArray arrayWithObjects:
                                   MAINCOLOR,
                                   [UIColor colorWithRed:47/255.0 green:175/255.0 blue:222/255.0 alpha:1],
                                  [UIColor colorWithRed:18/255.0 green:35/255.0 blue:60/255.0 alpha:1],nil];
         
        weakSelf.sliceTitleS =  [NSMutableArray arrayWithObjects:GDLocalizedString(@"Evaluate-Dream"),GDLocalizedString(@"Evaluate-Middle"),GDLocalizedString(@"Evaluate-Secure"),nil];
 
         
         NSUInteger totalCount = 0;
         
         for (NSArray *uniersitys in  weakSelf.recommendations) {
             
             totalCount += uniersitys.count;
         }
 
         
         NSString *firstItem;
         for(int i = 0; i < 3; i ++)
         {
             
             NSUInteger count = [recommendations[i] count];
             if (count != 0) {
                 
                  count = count + 3;
             }
             
             NSNumber *one = [NSNumber numberWithInt:(int)count];
             
             [_slices addObject:one];


             if (count > 0 && firstItem.length == 0) {
                 
                firstItem = @"已存在";
                weakSelf.resultList  =  [self.recommendations[i] mutableCopy];
                 
                [weakSelf makeAttributedText:[NSString stringWithFormat:@"%ld",(unsigned long)totalCount] currentcount:[NSString stringWithFormat:@"%ld",(long)weakSelf.resultList.count]  currentItem:weakSelf.sliceTitleS[i]];
             }
           }
         
         for (NSArray *universitys in weakSelf.recommendations) {
             
             for(NSDictionary *UniversityInfo in universitys)
             {
                 if (UniversityInfo[@"in_cart"]) {
                     
                     [weakSelf.SelectedUniversityIDs addObject:UniversityInfo[@"_id"]];
                 }
             }
         }
         
         [weakSelf.PieHeadView reloadData];
         [weakSelf.ResultTableView reloadData];
     }];
}

-(void)fillInfomation
{
    IntelligentViewController *vc = [[IntelligentViewController alloc] initWithNibName:@"IntelligentViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultTableViewCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell"];
  
    if (!cell) {
        
        cell =[[NSBundle mainBundle] loadNibNamed:@"ResultTableViewCell" owner:nil options:nil].lastObject;
        
    }
    cell.delegate = self;
    NSDictionary *infomation = self.resultList[indexPath.row];
    [cell configureWithInfo:infomation];
    [self configureCellSelectionView:cell universityId:infomation[@"_id"]];
    
    return cell;
}

-(void)selectResultTableViewCellItem:(UIButton *)sender withUniversityInfo:(NSString *)universityID
{
   
    if ([self.SelectedUniversityIDs containsObject:universityID]) {
        
         return;
    }
    
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
        [cell.selectButton setTitle:GDLocalizedString(@"UniCourseDe-007")  forState:UIControlStateNormal];
        [cell.selectButton setImage:nil forState:UIControlStateNormal];
    } else if ([self.NewSelectUniversityIDs containsObject:Uni_id]) {
        [cell.selectButton setTitle:nil forState:UIControlStateNormal];
        [cell.selectButton setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateNormal];
    } else {
        [cell.selectButton setTitle:nil forState:UIControlStateNormal];
        [cell.selectButton setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      NSDictionary *info = self.resultList[indexPath.row];
    
     [self.navigationController pushUniversityViewControllerWithID:info[@"_id"] animated:YES];
}


- (IBAction)CommitButtonPressed:(KDEasyTouchButton *)sender {
    
    if (self.NewSelectUniversityIDs.count == 0) {
        
        [KDAlertView showMessage:GDLocalizedString(@"Evaluate-commitNoti") cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];//@"好的"];
        
        return;
    }
    else if(self.NewSelectUniversityIDs.count >6)
    {
        [KDAlertView showMessage:GDLocalizedString(@"Evaluate-commitAlert") cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];//@"好的"];
        return;
    }
    
    [self
     startAPIRequestWithSelector:@"POST api/account/apply"
     parameters:@{@"uid": self.NewSelectUniversityIDs}
     success:^(NSInteger statusCode, id response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud setLabelText:GDLocalizedString(@"ApplicationProfile-0015")];//@"加入成功"];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {

             ApplyViewController *vc = [[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil];
             [self.navigationController pushViewController:vc animated:YES];
         
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
    
    return self.sliceTitleS[index];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    if (self.selectIndex != index) {
        
    self.universitySortType = NoType;
    
    [self.resultList removeAllObjects];
    
    self.resultList =  [self.recommendations[index] mutableCopy];
    [self.ResultTableView reloadData];
    
   [self makeCurrentLabel:[NSString stringWithFormat:@"%lu",(unsigned long)self.resultList.count] currentItem:self.sliceTitleS[index]];

    NSString *lang =[InternationalControl userLanguage];
    if ([lang containsString:@"en"]) {
        
        switch (index) {
            case 1:
                self.pieSelectLabel.text = @"we suggest you pick less than 2 as your target";
                break;
            case 0:
                self.pieSelectLabel.text = @"we suggest you choose 2-3 as your focus";
                break;
            default:
                self.pieSelectLabel.text = @"we strongly recommend you choose at least 2 for safe admission";
                break;
        }
    }
    
//        __block  CGFloat turnAngle = 0;
//        if (self.selectIndex ==0) {
//            turnAngle = index == 1 ? - 2*M_PI/3 : 2*M_PI/3;
//        }else if(self.selectIndex == 1)
//        {
//            turnAngle = index == 2 ? - 2*M_PI/3 : 2*M_PI/3;
//        }else
//        {
//            turnAngle = index == 0 ? - 2*M_PI/3 : 2*M_PI/3;
//        }
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            self.PieHeadView.transform = CGAffineTransformRotate(self.PieHeadView.transform, turnAngle);
//        }];
        
        self.selectIndex = index;
    }
    
   
}

-(void)popBack
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//被放弃的方法（暂时不用）
/*

- (void)tableHeaderViewRankingButton:(UIButton *)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, M_PI);
    }];
    
    self.universitySortType = self.universitySortType == AscendeType?descendeType:AscendeType;
    
    NSArray *resultArray = [self.resultList mutableCopy];
    [self.resultList removeAllObjects];
    
    if (self.universitySortType == AscendeType) {
        
        self.resultList  = [[resultArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1[@"ranking_ti"] integerValue] > [obj2[@"ranking_ti"] integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1[@"ranking_ti"] integerValue] <  [obj2[@"ranking_ti"] integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }] mutableCopy];
        
    }else
    {
        self.resultList  = [[resultArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1[@"ranking_ti"] integerValue] < [obj2[@"ranking_ti"] integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1[@"ranking_ti"] integerValue] >  [obj2[@"ranking_ti"] integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }] mutableCopy];
        
    }
    [self.ResultTableView reloadData];
    
}
 */


@end
