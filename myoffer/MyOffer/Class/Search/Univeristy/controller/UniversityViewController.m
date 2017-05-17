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
#import "UniGroupOneView.h"
#import "HomeSectionHeaderView.h"
#import "MyOfferArticle.h"
#import "MessageCell.h"
#import "XWGJMessageFrame.h"
#import "MyOfferUniversityModel.h"
#import "UniversityCell.h"
#import "UniItemFrame.h"
#import "UniversityRightView.h"
#import "UniversityNavView.h"
#import "UniversityRightView.h"
#import "MessageDetaillViewController.h"
#import "IDMPhotoBrowser.h"
#import "ShareNViewController.h"
#import "UniversityFooterView.h"
#import "UniversitySubjectListViewController.h"
#import "PipeiEditViewController.h"
#import "UniDetailGroup.h"
#import "UniversityheaderCenterView.h"
#import "IntelligentResultViewController.h"
#import "WYLXViewController.h"

typedef enum {
    UniversityItemTyDeFault,
    UniversityItemTypeFavor,
    UniversityItemTypeShare,
    UniversityItemTypeMore,
    UniversityItemTypeWeb,
    UniversityItemTypePipei,
    UniversityItemTypePop
}UniversityItemType;//表头按钮选项
#define HEIGHT_BOTTOM 70

@interface UniversityViewController ()<UITableViewDelegate,UITableViewDataSource,IDMPhotoBrowserDelegate>
@property(nonatomic,strong)DefaultTableView *tableView;
//第一分组
@property(nonatomic,strong)UniGroupOneView  *oneGroup;
//学校Frame数据
@property(nonatomic,strong)UniversityNewFrame    *UniFrame;
//头部图片
@property(nonatomic,strong)UIImageView           *iconView;
//头部图片数据
@property(nonatomic,assign)CGRect                iconViewOldFrame;
@property(nonatomic,assign)CGPoint               iconViewOldCenter;
//分组数据
@property(nonatomic,strong)NSMutableArray        *groups;
//表头
@property(nonatomic,strong)UniverstyHeaderView   *headerView;
//自定义导航栏
@property(nonatomic,strong)UniversityNavView     *topNavigationView;
//是否收藏
@property(nonatomic,assign)BOOL favorited;
//当前选择类型
@property(nonatomic,assign)UniversityItemType    clickType;
//分享功能
@property(nonatomic,strong)ShareNViewController   *shareVC;
//底部按钮
@property(nonatomic,strong)UniversityFooterView *footer;
//用于记录用户入学难易程度
@property(nonatomic,strong)NSNumber *user_level;
//是否来自匹配页面
@property(nonatomic,assign)BOOL FromPipei;

@end

@implementation UniversityViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.user_level = @DEFAULT_NUMBER;

    }
    return self;
}

-(instancetype)initWithUniversityId:(NSString *)Uni_id{

    self = [super init];
    
    if (self) {
        
        self.uni_id = Uni_id;
        
        self.user_level = @DEFAULT_NUMBER;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page学校详情"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [MobClick beginLogPageView:@"page学校详情"];
    
    if (LOGIN) {
        
        [self refesh];
       
        [self userDidClickItem];
        
    }
}

- (void)refesh{
    
    XWeakSelf
    [self startAPIRequestWithSelector:[NSString stringWithFormat:@"%@%@",kAPISelectorUniversityDetail,self.uni_id] parameters:nil success:^(NSInteger statusCode, id response) {
        
        UniversitydetailNew  *item  =   [UniversitydetailNew mj_objectWithKeyValues:response];
        
        weakSelf.favorited = item.favorited;
        
        [weakSelf configureLikeButton:item.favorited];
        
    }];
    
    //加载报考难易程度
    [self loadUserLevel];
    
}


//判断用户在未登录前在申请中心页面选择服务，当用户登录时直接跳转已选择服务
-(void)userDidClickItem
{
         XWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [weakSelf  UnivertityClickType:self.clickType];
            
        });
    
}


-(NSMutableArray *)groups{

    if (!_groups) {
        
        _groups =[NSMutableArray array];
    }
    
    return _groups;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addDataSourse];
    
    [self makeUI];
    
}

//根据用户资料测试录取难易程度
- (void)loadUserLevel{
   
    if (self.FromPipei) return;
    
        XWeakSelf
    
        NSString *path = [NSString stringWithFormat:@"%@%@",kAPISelectorUniversityDetailUserLevel,self.uni_id];
    
         [self startAPIRequestWithSelector:path  parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
             
             [weakSelf caseLevelWithResponse:response];

         }];
    
    
}

//加载数据
-(void)addDataSourse
{
 
    XWeakSelf
    NSString *path =[NSString stringWithFormat:@"%@%@",kAPISelectorUniversityDetail,self.uni_id];
    
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        [weakSelf casePop];

    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf makeUIWithUni:[UniversitydetailNew mj_objectWithKeyValues:response]];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf casePop];
        
    }];
    
}

#pragma mark ——— 设置控件数据
-(void)makeUIWithUni:(UniversitydetailNew *)university{
    
    
    self.favorited = university.favorited;
    
    [self configureLikeButton: university.favorited];
    
    UniversityNewFrame *UniFrame = [UniversityNewFrame frameWithUniversity:university];
    self.UniFrame = UniFrame;
    
    
    XWeakSelf
   //表头
    UniverstyHeaderView  * header  = [UniverstyHeaderView headerTableViewWithUniFrame:UniFrame];
    header.frame       = UniFrame.header_Frame;
    header.actionBlock = ^(UIButton *sender){
    
        [weakSelf onClick:sender];
        
    };
    self.headerView = header;
    self.tableView.tableHeaderView  = header;
    
    
     //拉伸图片
    NSString *countryImageName =  @"Uni-au";
    if ([university.country isEqualToString:@"英国"]) {
        countryImageName =  @"Uni-uk";
    }else if ([university.country isEqualToString:@"美国"]) {
        countryImageName =  @"Uni-USA";
     }
 
    [UIView transitionWithView:self.iconView duration:ANIMATION_DUATION options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
         [self.iconView setImage:[UIImage imageNamed:countryImageName]];
        
     } completion:^(BOOL finished) {
         
    }];
    
    
    //设置第一分组cell数据
    [self oneGroupViewWithUniFrame:UniFrame];
    NSArray *sectionOne = @[UniFrame];
    UniDetailGroup *groupOne = [UniDetailGroup groupWithTitle:@"" contentes:sectionOne andFooter:NO];
    [self.groups addObject:groupOne];
    
    
    //相关资讯 第二分组
    NSArray *newses  = [MyOfferArticle mj_objectArrayWithKeyValuesArray:university.relate_articles];
    NSMutableArray *news_temps = [NSMutableArray array];
    [newses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        XWGJMessageFrame *newsFrame =  [XWGJMessageFrame messageFrameWithMessage:obj];
        [news_temps addObject:newsFrame];
    }];
    
    UniDetailGroup *groupTwo = [UniDetailGroup groupWithTitle:@"相关文章" contentes:[news_temps copy] andFooter:NO];
    [self.groups addObject:groupTwo];
 
    
    //相关院校  大于第二分组
    NSMutableArray *neightbour_temps = [NSMutableArray array];
    
   NSArray *rankNeighbour = [MyOfferUniversityModel  mj_objectArrayWithKeyValuesArray: university.rankNeighbour];
    
    
    [rankNeighbour enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
         UniItemFrame *uniFrame = [UniItemFrame frameWithUniversity:(MyOfferUniversityModel*)obj];
        [neightbour_temps addObject:uniFrame];
        
        NSString *title = idx == 0 ? @"相关院校" : @"";
        NSArray *items = @[uniFrame];
        UniDetailGroup *group = [UniDetailGroup groupWithTitle:title contentes:items andFooter:YES];
        [self.groups addObject:group];
        
    }];
    
    self.footer.uni_country = university.country;
    
    [self.tableView reloadData];
    

    
}

-(void)makeUI{

    [self makeTableView];
    
    [self makeHeaderIconView];
    
    [self makeFooterView];
    
}

//添加底部按钮
-(void)makeFooterView{
    
    XWeakSelf

    UniversityFooterView *footer = [[UniversityFooterView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT - HEIGHT_BOTTOM, XSCREEN_WIDTH, HEIGHT_BOTTOM)];
    self.footer = footer;
    footer.actionBlock = ^(UIButton *sender){
        
        [weakSelf footerWithButton:sender];
    };
    [self.view addSubview:footer];
    
}

//添加自定义顶部导航
-(void)makeTopNavigaitonView{

    
    XWeakSelf
    self.topNavigationView = [UniversityNavView ViewWithBlock:^(UIButton *sender) {

        [weakSelf onClick:sender];
        
    }];
    
    [self.view addSubview:self.topNavigationView];
    
}


-(void)makeTableView
{
    self.tableView =[[DefaultTableView alloc] initWithFrame:CGRectMake(0,0, XSCREEN_WIDTH, XSCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, HEIGHT_BOTTOM, 0);
    self.tableView.backgroundColor = XCOLOR(1, 1, 1, 0);
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    [self.view addSubview:self.tableView];
    
    [self makeTopNavigaitonView];
    
}

//表头显示图片
-(void)makeHeaderIconView{
    
    self.view.clipsToBounds = YES;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XPERCENT * 200 + 50)];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = XCOLOR_BG;
    self.iconView = iconView;
    self.iconViewOldFrame = iconView.frame;
    self.iconViewOldCenter = iconView.center;
    [self.view insertSubview:iconView  belowSubview:self.tableView];
    
}

//设置第一分区
- (void)oneGroupViewWithUniFrame:(UniversityNewFrame *)UniFrame
{
    UniGroupOneView  *oneGroup =[[UniGroupOneView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, UniFrame.group_One_Height)];
    oneGroup.contentFrame = UniFrame;
    self.oneGroup = oneGroup;
    XWeakSelf
    oneGroup.actionBlock = ^(NSString *name,NSInteger index){
        
              [weakSelf showPhotoAtIndex:index];
      };
    
}

#pragma mark : UITableViewDelegate,UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    UniDetailGroup *group = self.groups[section];
    
    return  group.HaveHeader ? 40 : HEIGHT_ZERO;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
     UniDetailGroup *group = self.groups[section];
    
    return [HomeSectionHeaderView sectionHeaderViewWithTitle:group.HeaderTitle];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    UniDetailGroup *group = self.groups[section];
    
    return group.HaveFooter ? PADDING_TABLEGROUP : HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return indexPath.section == 0 ? self.oneGroup.contentFrame.group_One_Height : Uni_Cell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    UniDetailGroup *group = self.groups[section];
    
    return  group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UniDetailGroup *group = self.groups[indexPath.section];

    if (indexPath.section == 0) {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"one"];
        
         if (!cell) {
             cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView addSubview:self.oneGroup];
        
        return cell;

        
    }else if(indexPath.section == 1){
    
        MessageCell *news_cell =[MessageCell cellWithTableView:tableView];
        news_cell.messageFrame =  group.items[indexPath.row];
         return news_cell;
        
    }else{

        UniversityCell *uni_cell =[UniversityCell cellWithTableView:tableView];
        uni_cell.itemFrame = group.items[indexPath.row];

        return uni_cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) return;
    
    UniDetailGroup *group = self.groups[indexPath.section];
    
    if ([group.HeaderTitle containsString:@"文章"]) {
        
        XWGJMessageFrame *newsFrame  = group.items[indexPath.row];
   
        [self.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:newsFrame.News.message_id] animated:YES];
        
    }else{
        
        UniItemFrame *uniFrame   = group.items[indexPath.row];
        
        [self.navigationController pushViewController:[[UniversityViewController alloc] initWithUniversityId:uniFrame.item.NO_id]  animated:YES];
    }
    
}

#pragma mark : UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    
    //监听顶部导航条透明度
    [self.topNavigationView scrollViewContentoffset:scrollView.contentOffset.y andContenHeight:self.UniFrame.centerView_Frame.origin.y - XNAV_HEIGHT];
  
    //顶部图片拉伸
    if (scrollView.contentOffset.y < 0) {
         
        CGRect frame = self.iconViewOldFrame;
        frame.size.height = self.iconViewOldFrame.size.height - scrollView.contentOffset.y * 2;
        frame.size.width  =self.iconViewOldFrame.size.width * (frame.size.height)/self.iconViewOldFrame.size.height;
        self.iconView.frame = frame;
        self.iconView.center = self.iconViewOldCenter;
  
    }else{
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            self.iconView.frame = self.iconViewOldFrame;
            
        }];
        
        //向上拉伸的时候，防止头部图片显示出来
        self.iconView.hidden = scrollView.contentOffset.y > XSCREEN_HEIGHT * 0.5;

    }
    
}


 
#pragma mark : IDMPhotoBrowser Delegate

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)pageIndex
{
//    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    
//    NSLog(@"Did show photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)pageIndex
{
//    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    
//    NSLog(@"Will dismiss photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
{
//    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    
//    NSLog(@"Did dismiss photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
  
//    id <IDMPhoto> photo = [photoBrowser photoAtIndex:photoIndex];
    
//    NSLog(@"Did dismiss actionSheet with photo index: %zu, photo caption: %@", photoIndex, photo.caption);

    
//    NSString *title = [NSString stringWithFormat:@"Option %zu", buttonIndex+1];
//    
//    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"test" message:title delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
//    
//    [aler show];
 
}

//点击图片浏览器
-(void)showPhotoAtIndex:(NSUInteger)index
{
    
    NSMutableArray *temps = [NSMutableArray new];
    
    for (NSString *path in self.UniFrame.item.images) {
        
        [temps addObject:[NSURL URLWithString:path]];
    }
    
    NSArray *photosWithURL = [IDMPhoto photosWithURLs:temps];
     NSMutableArray *photos = [NSMutableArray arrayWithArray:photosWithURL];
    // Create and setup browser
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    browser.delegate = self;
    //图片数组开始index
    [browser setInitialPageIndex:index];
    browser.displayCounterLabel = YES;
    browser.displayActionButton = NO;
    [self presentViewController:browser animated:YES completion:nil];
    
}


#pragma mark : 事件处理

//根据网络请求显示用用户入学申请等级
- (void)caseLevelWithResponse:(id)response{

    NSArray *values = [(NSDictionary *)response allValues];
    
    self.user_level = values[0];
    
    if (!([values[0] integerValue] == -1)) {
        
        self.footer.level = [values[0] integerValue];
    }
}

//根据智能匹配结果拼接相关参数网络请求
- (void)pipeiLevelWithParameter:(NSString *)pString{
   
    NSMutableString *path = [NSMutableString string];
    
    [path  appendFormat:@"%@%@",kAPISelectorUniversityDetailUserLevel,self.uni_id];
    
    [path  appendFormat:@"%@",pString];
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *values = [(NSDictionary *)response allValues];
        
        weakSelf.footer.level = [values[0] integerValue];
        
        weakSelf.FromPipei = NO;
 
    }];
    
}


- (void)onClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case RightViewItemStyleFavorited:
            [self UnivertityClickType:UniversityItemTypeFavor];
            break;
        case RightViewItemStyleShare:
            [self UnivertityClickType:UniversityItemTypeShare];
            break;
        case NavItemStyleBack:
            [self UnivertityClickType:UniversityItemTypePop];
            break;
        case Uni_Header_CenterItemStyleMore:
            [self UnivertityClickType:UniversityItemTypeMore];
            break;
            
        default:
            break;
    }
}

-(void)UnivertityClickType:(UniversityItemType)type{
    
    switch (type) {
        case UniversityItemTypeFavor:
        {
            self.clickType = UniversityItemTypeFavor;
            [self caseFavorite];
        }
            break;
        case UniversityItemTypeShare:
            [self caseShare];
            break;
        case UniversityItemTypePop:
            [self casePop];
            break;
        case UniversityItemTypeMore:
            [self caseMore];
            break;
        case UniversityItemTypePipei:
            //            [self CasePipei];
            break;
        default:
            break;
    }
    
}
//集成分享功能
- (ShareNViewController *)shareVC
{
    if (!_shareVC) {
        
        _shareVC = [[ShareNViewController alloc] initWithUniversity:self.UniFrame.item];
        [self addChildViewController:_shareVC];
        [self.view addSubview:self.shareVC.view];
        
    }
    return _shareVC;
}

//分享
- (void)caseShare{
    
    [self.shareVC  show];
}

//收藏
- (void)caseFavorite
{
    
    
    RequireLogin
    XWeakSelf
    NSString *path = self.favorited ?  kAPISelectorUniversityUnfavorited : kAPISelectorUniversityfavorited;
    [self startAPIRequestWithSelector:[NSString stringWithFormat:@"%@%@",path,self.UniFrame.item.NO_id] parameters:nil success:^(NSInteger statusCode, id response) {
        
         NSString *title =  weakSelf.favorited ?  @"取消收藏"  : @"收藏成功";
 
       [MBProgressHUD showSuccessWithMessage:title ToView:self.view];
        
        weakSelf.favorited =  !weakSelf.favorited;
        [weakSelf configureLikeButton:weakSelf.favorited];
        weakSelf.clickType = UniversityItemTyDeFault;
        
    }];
}



//点击查看更多
- (void)caseMore
{
    
    XWeakSelf
    self.UniFrame.showMore = !self.UniFrame.showMore;
    
    if (CGRectGetHeight(self.headerView.frame) > 0) {
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            weakSelf.headerView.itemFrame = weakSelf.UniFrame;
            weakSelf.headerView.frame     = weakSelf.UniFrame.header_Frame;
            
            [weakSelf.tableView beginUpdates]; //  beginUpdates  endUpdates 之间_tableView有刷新处理
            [weakSelf.tableView setTableHeaderView:weakSelf.headerView];
            [weakSelf.tableView endUpdates];
            
        }];
        
    }
}

//回退
- (void)casePop
{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置是否收藏
- (void)configureLikeButton:(BOOL)favorite
{
    [self.topNavigationView navigationWithFavorite:favorite];
    [self.headerView headerViewRightViewWithShadowFavorited:favorite];
}

//点击footer按钮
- (void)footerWithButton:(UIButton *)sender
{
    if ([sender.currentTitle containsString:@"查看"]) {
        
        [self caseAllSubjects];
        
    }else if ([sender.currentTitle containsString:@"免费"]) {
        
        [self caseWoyaoluexue];
        
    }else{
        
        [self CasePipei];
    }
    
}
//我要留学
- (void)caseWoyaoluexue{
    
    [self.navigationController pushViewController:[[WYLXViewController alloc] init] animated:YES];
    
}
//查看所有专业
- (void)caseAllSubjects{
    
    [self.navigationController pushViewController:[[UniversitySubjectListViewController alloc] initWithUniversityID:self.uni_id] animated:YES];
}

//智能匹配
-(void)CasePipei{
    
    
    if ( !LOGIN  ||  self.user_level.integerValue == DEFAULT_NUMBER || self.user_level.integerValue == -1) {
        
        XWeakSelf
        self.FromPipei = YES;
        PipeiEditViewController *pipei = [[PipeiEditViewController alloc] init];
        pipei.Uni_Country = self.oneGroup.contentFrame.item.country;
        pipei.actionBlock = ^(NSString *pipei){
            
            [weakSelf pipeiLevelWithParameter:pipei];
            
        };
        
        [self.navigationController pushViewController:pipei  animated:YES];
        
        return;
    }
    
    
    [self.navigationController pushViewController:[[IntelligentResultViewController alloc] init] animated:YES];
    
}







- (void)dealloc{
    
    KDClassLog(@" 学校详情 dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
