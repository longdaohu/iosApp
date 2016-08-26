//
//  UniversityViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityViewController.h"
#import "UniversitydetailNew.h"
#import "UniversityNewFrame.h"
#import "UniverstyHeaderView.h"
#import "OneGroupView.h"
#import "HomeSectionHeaderView.h"
#import "NewsItem.h"
#import "XWGJMessageTableViewCell.h"
#import "XWGJMessageFrame.h"
#import "UniversityItemNew.h"
#import "UniversityCell.h"
#import "UniItemFrame.h"
#import "UniversityRightView.h"
#import "UniversityNavView.h"
#import "UniversityRightView.h"
#import "MessageDetailViewController.h"

typedef enum {
    UniversityItemTyDeFault,
    UniversityItemTypeFavor,
    UniversityItemTypeShare,
    UniversityItemTypeMore,
    UniversityItemTypeWeb,
    UniversityItemTypePop
}UniversityItemType;//表头按钮选项


@interface UniversityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)OneGroupView  *oneGroup;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UniversityNewFrame *UniFrame;
@property(nonatomic,assign)CGRect iconViewOldFrame;
@property(nonatomic,assign)CGPoint iconViewOldCenter;
@property(nonatomic,strong)NSArray *newsFrames;
@property(nonatomic,strong)NSArray *Result;
@property(nonatomic,strong)UniverstyHeaderView  *header;
@property(nonatomic,strong)UniversityNavView *topNavigationView;
@property(nonatomic,assign)BOOL favorited;
@property(nonatomic,assign)UniversityItemType *clickType;

@end

@implementation UniversityViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadNewDataSourse];
    
    [self makeUI];
 
}

-(void)loadNewDataSourse
{
  
    
    XJHUtilDefineWeakSelfRef
    NSString *path =[NSString stringWithFormat:@"GET api/university/v2/%@",self.uni_id];
    
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        [weakSelf pop];

    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        
        UniversitydetailNew  *item  =   [UniversitydetailNew mj_objectWithKeyValues:response];
        
        [weakSelf makeUIWithUni:item];
        
        [weakSelf.tableView reloadData];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
        
    }];
    
    
   
}


//设置控件数据
-(void)makeUIWithUni:(UniversitydetailNew *)university{
    
    BOOL favorited = (university.favorited == 1);
    self.favorited = favorited;
    [self configureLikeButton: favorited];

    //相关院校
    NSMutableArray *neightbour_temps = [NSMutableArray array];
    [university.rankNeighbour enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
       UniversityItemNew *uni = [UniversityItemNew mj_objectWithKeyValues:obj];
        
       UniItemFrame *uniFrame = [UniItemFrame frameWithUniversity:uni];
        
       [neightbour_temps addObject:uniFrame];
  
    }];
    
    self.Result = [neightbour_temps copy];
    

    
   //相关资讯
    NSArray *newses  = [NewsItem mj_objectArrayWithKeyValuesArray:university.relate_articles];
    NSMutableArray *news_temps = [NSMutableArray array];
    for (NewsItem *news in newses) {
        XWGJMessageFrame *newsFrame =  [XWGJMessageFrame messageFrameWithMessage:news];
        [news_temps addObject:newsFrame];
    }
    self.newsFrames = [news_temps copy];
    
    
    UniversityNewFrame *UniFrame = [[UniversityNewFrame alloc] init];
    UniFrame.item = university;
    self.UniFrame = UniFrame;
    
    XJHUtilDefineWeakSelfRef
   //表头
    UniverstyHeaderView  * header   = [[UniverstyHeaderView alloc] init];
    header.actionBlock = ^(UIButton *sender){
    
        [weakSelf onClick:sender];
    };
    
    self.header = header;
    header.clipsToBounds = YES;
    header.itemFrame  = UniFrame;
    header.frame = UniFrame.headerFrame;
    self.tableView.tableHeaderView  = header;
    
    //设置第一组cell数据
    [self oneGroupViewWithUniFrame:UniFrame];
    
}


-(void)makeUI{

    [self makeTableView];
    
    [self makeHeaderIconView];
    
}


-(void)makeHeaderIconView{
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -NAV_HEIGHT, XScreenWidth, XPERCENT * 400)];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = XCOLOR_RED;
    iconView.image = [UIImage imageNamed:@"testPick.jpg"];
    iconView.clipsToBounds = YES;
    self.iconView = iconView;
    self.iconViewOldFrame = iconView.frame;
    self.iconViewOldCenter = iconView.center;
    [self.view insertSubview:iconView  belowSubview:self.tableView];
    
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
 
    
    XJHUtilDefineWeakSelfRef
    self.topNavigationView = [[NSBundle mainBundle] loadNibNamed:@"UniversityNavView" owner:self options:nil].lastObject;
    self.topNavigationView.frame = CGRectMake(0, 0, XScreenWidth, 64);
    self.topNavigationView.actionBlock = ^(UIButton *sender){
    
         [weakSelf onClick:sender];

    };
    
    
    [self.view addSubview:self.topNavigationView];

    
}


- (void)oneGroupViewWithUniFrame:(UniversityNewFrame *)UniFrame
{
    OneGroupView  *oneGroup =[[OneGroupView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, UniFrame.contentHeight)];
    oneGroup.contentFrame = UniFrame;
    self.oneGroup = oneGroup;
}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomeSectionHeaderView *sectionView = [[HomeSectionHeaderView alloc] init];
    
    switch (section) {
        case 1:
            sectionView.TitleLab.text = @"相关文章";
            break;
        default:
            sectionView.TitleLab.text = @"相关院校";
            break;
    }
    
    return sectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.0000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0 == section ? 0.0000000001 : 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 0 == indexPath.section ? self.oneGroup.contentFrame.contentHeight : University_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger sectionRow = 0;
    
    switch (section) {
        case 1:
            sectionRow = self.newsFrames.count;
            break;
        case 2:
            sectionRow = self.Result.count;
            break;
        default:
            sectionRow = 1;
            break;
    }
    
    return  sectionRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"one"];
        
        if (!cell) {
            
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell.contentView addSubview:self.oneGroup];
        
        return cell;

        
    }else if(indexPath.section == 1){
    
        XWGJMessageTableViewCell *cell =[XWGJMessageTableViewCell cellWithTableView:tableView];
        
        cell.messageFrame = self.newsFrames[indexPath.row];
        
        return cell;
        
    }else{

        UniversityCell *cell =[UniversityCell cellWithTableView:tableView];
        cell.itemFrame = self.Result[indexPath.row];
        
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        XWGJMessageFrame *newsFrame  =  self.newsFrames[indexPath.row];
        MessageDetailViewController *detail  =[[MessageDetailViewController alloc] init];
        detail.NO_ID = newsFrame.News.messageID;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    
    if (indexPath.section == 2) {
        
        UniItemFrame *uniFrame   =  self.Result[indexPath.row];
         UniversityViewController *Uni  =[[UniversityViewController alloc] init];
        Uni.uni_id =  uniFrame.item.NO_id;
        [self.navigationController pushViewController:Uni animated:YES];
     }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    [self.topNavigationView scrollViewContentoffset:scrollView.contentOffset.y];
    
    if (scrollView.contentOffset.y < 0) {
        
        
        CGRect frame = self.iconViewOldFrame;
        frame.size.height = self.iconViewOldFrame.size.height - scrollView.contentOffset.y;
        frame.size.width  =self.iconViewOldFrame.size.width * (frame.size.height)/self.iconViewOldFrame.size.height;
        self.iconView.frame = frame;
        self.iconView.center = self.iconViewOldCenter;
 
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.iconView.frame = self.iconViewOldFrame;
            
        }];
    }
     
}


- (void)onClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 110:
            [self UnivertityClickType:UniversityItemTypeFavor];
            break;
        case 111:
            [self UnivertityClickType:UniversityItemTypeShare];
            break;
        case 112:
            [self UnivertityClickType:UniversityItemTypePop];
            break;
        case 113:
            [self UnivertityClickType:UniversityItemTypeMore];
            break;
        case 114:
            [self UnivertityClickType:UniversityItemTypeWeb];
            break;
         default:
            break;
    }
}

-(void)UnivertityClickType:(UniversityItemType)type{

    switch (type) {
        case UniversityItemTypeFavor:
            [self favorite];
            break;
        case UniversityItemTypeShare:
            [self share];
            break;
        case UniversityItemTypePop:
            [self pop];
            break;
        case UniversityItemTypeMore:
            [self more];
            break;
        case UniversityItemTypeWeb:
            [self web];
            break;
        default:
            break;
    }

}

//分享
- (void)share{
    
    NSLog(@" 分享");

}

//收藏
- (void)favorite{
  
    
    XJHUtilDefineWeakSelfRef
    NSString *path = self.favorited ?  @"GET api/account/favorite/:id"  : @"GET api/account/unFavorite/:id";
    
    [self startAPIRequestWithSelector:path parameters:@{@":id": self.UniFrame.item.NO_id} success:^(NSInteger statusCode, id response) {
     
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        NSString *title =  self.favorited ?  @"取消收藏"  : @"收藏成功";
        [hud setLabelText:title];//@"关注成功"];
        weakSelf.favorited =  !self.favorited;
        [hud hideAnimated:YES afterDelay:1];
        
        [weakSelf configureLikeButton:self.favorited];

    }];
  
    
}
//回退
- (void)pop{

     [self.navigationController popViewControllerAnimated:YES];
}

//更多
- (void)more{
    
    NSLog(@" 更多");
}

//更多
- (void)web{
    
    NSLog(@" %@",self.UniFrame.item.website);

}
//设置是否收藏
- (void)configureLikeButton:(BOOL)favorite{
    
    self.topNavigationView.favorited = favorite;
    self.header.rightView.favorited =  favorite;
    
}


-(void)dealloc{
  
    NSLog(@" 学校详情 dealloc");


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
