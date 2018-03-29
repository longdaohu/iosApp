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
#import "UniverstityTCell.h"
#import "UniversityRightView.h"
#import "UniversityNavView.h"
#import "MessageDetaillViewController.h"
#import "IDMPhotoBrowser.h"
#import "ShareNViewController.h"
#import "UniversityFooterView.h"
#import "UniversitySubjectListViewController.h"
#import "PipeiEditViewController.h"
#import "UniversityheaderCenterView.h"
#import "IntelligentResultViewController.h"
#import "WYLXViewController.h"
#import "myofferFlexibleView.h"


typedef enum {
    UniversityItemTyDeFault,
    UniversityItemTypeFavor,
    UniversityItemTypeShare,
    UniversityItemTypeMore,
    UniversityItemTypeWeb,
    UniversityItemTypePipei,
    UniversityItemTypePop
}UniversityItemType;//表头按钮选项

@interface UniversityViewController ()<UITableViewDelegate,UITableViewDataSource,IDMPhotoBrowserDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
//第一分组
@property(nonatomic,strong)UniGroupOneView  *oneGroup;
//学校Frame数据
@property(nonatomic,strong)UniversityNewFrame    *UniFrame;
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
//头部图片
@property(nonatomic,strong)myofferFlexibleView *flexView;
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
    
    //加载报考难易程度
    [self loadUserLevel];
    
    if (self.UniFrame.item.login != LOGIN) {
        
        [self addDataSourse];

    }
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
    
    BOOL  show = (self.groups.count > 0) ? NO  : YES;
    
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:show showErrorAlert:YES errorAlertDismissAction:^{
  
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithReponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf showError];
        
    }];
    
}

#pragma mark : 设置控件数据

- (void)updateUIWithReponse:(id)response{
    
    UniversitydetailNew *university = [UniversitydetailNew mj_objectWithKeyValues:response];
    university.login = LOGIN;
    
    //用于刷新数据时 判断登录状态下是否收藏学校
    if (self.groups.count > 0) {
        
        self.favorited = university.favorited;

        [self configureLikeButton:university.favorited];
        
        self.UniFrame.item.favorited = university.favorited;
        
        return ;
    }
    
    
    self.uni_id = university.NO_id;
    
    self.favorited = university.favorited;
    
    [self configureLikeButton: university.favorited];
    
    
    [_footer footeTouchEnable:YES];
    
    UniversityNewFrame *UniFrame = [UniversityNewFrame frameWithUniversity:university];
    self.UniFrame = UniFrame;
    
    
    XWeakSelf
   //1  表头
    UniverstyHeaderView  * header  = [UniverstyHeaderView headerTableViewWithUniFrame:UniFrame];
    header.frame       = UniFrame.header_Frame;
    header.actionBlock = ^(UIButton *sender){
    
        [weakSelf onClick:sender];
        
    };
    self.headerView = header;
    self.tableView.tableHeaderView  = header;
    
    
     //2 拉伸图片
    NSString *countryImageName =  @"Uni-au";
    if ([university.country isEqualToString:@"英国"]) {
        countryImageName =  @"Uni-uk";
    }else if ([university.country isEqualToString:@"美国"]) {
        countryImageName =  @"Uni-USA";
     }
 
    [UIView transitionWithView:self.flexView duration:ANIMATION_DUATION options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.flexView.image_name = countryImageName;
        
     } completion:^(BOOL finished) {
         
    }];
    
    
    //3 添加数据
    
    //3-1 设置第一分组cell数据
    [self oneGroupViewWithUniFrame:UniFrame];
    myofferGroupModel *groupOne = [myofferGroupModel groupWithItems:@[UniFrame]  header:nil footer:nil];
    groupOne.type = SectionGroupTypeA;
    [self.groups addObject:groupOne];
    
    
   //3-2 相关资讯 第二分组
    NSArray *newses  = [MyOfferArticle mj_objectArrayWithKeyValuesArray:university.relate_articles];
    NSMutableArray *news_temps = [NSMutableArray array];
    [newses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        XWGJMessageFrame *newsFrame =  [XWGJMessageFrame messageFrameWithMessage:obj];
        [news_temps addObject:newsFrame];
    }];
    
 
    if (news_temps.count > 0) {
        
        myofferGroupModel *article_group = [myofferGroupModel groupWithItems:[news_temps copy]  header:@"相关文章" footer:nil];
        article_group.type = SectionGroupTypeB;
        [self.groups addObject:article_group];
    }
    
  
    
    //3-3 相关院校  大于第二分组
    
   NSArray *rankNeighbour = [MyOfferUniversityModel  mj_objectArrayWithKeyValuesArray: university.rankNeighbour];
    
    [rankNeighbour enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UniversityFrameNew *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy: (MyOfferUniversityModel*)obj];
        
        NSString *title = (idx == 0) ? @"相关院校" : @"";
        
        myofferGroupModel *uni_group = [myofferGroupModel groupWithItems:@[uniFrame] header:title footer:nil];
        uni_group.section_footer_height = Section_footer_Height_nomal;
        uni_group.type = SectionGroupTypeC;
        
        [self.groups addObject:uni_group];
        
    }];
    
    [self.tableView reloadData];
    
    
    self.footer.uni_country = university.country;
    
}

-(void)makeUI{

    [self makeTableView];
    
    [self makeTopView];
    
    [self makeBottomView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.footer.mj_h, 0);
    
    self.view.clipsToBounds = YES;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }


}

//添加底部按钮
-(void)makeBottomView{
    
    XWeakSelf
    CGFloat footer_h = 70;
    CGFloat footer_w = self.tableView.mj_w;
    CGFloat footer_y = self.tableView.mj_h - footer_h;
    UniversityFooterView *footer = [[UniversityFooterView alloc] initWithFrame:CGRectMake(0, footer_y, footer_w, footer_h)];
    self.footer = footer;
    [footer footeTouchEnable:NO];
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
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedSectionFooterHeight = 0;

    [self makeTopNavigaitonView];
    
}

//表头显示图片
-(void)makeTopView{
    
    self.view.clipsToBounds = YES;
   
    UIImage *FlexibleImg = XImage(@"Uni-au");
    CGFloat iconHeight =  XSCREEN_WIDTH * FlexibleImg.size.height / FlexibleImg.size.width;
    myofferFlexibleView *flexView = [myofferFlexibleView flexibleViewWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH,iconHeight)];
    [self.view insertSubview:flexView belowSubview:self.tableView];
    self.flexView = flexView;
    
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
    
    myofferGroupModel *group = self.groups[section];
    
    return group.section_header_height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
     myofferGroupModel *group = self.groups[section];
    
    return [HomeSectionHeaderView sectionHeaderViewWithTitle:group.header_title];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    
    return group.section_footer_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    myofferGroupModel *group = self.groups[indexPath.section];

    CGFloat cellHeight = Uni_Cell_Height;
    
    
    switch (group.type) {
        case SectionGroupTypeA:{
            
            cellHeight = self.oneGroup.contentFrame.group_One_Height;
         }
            break;
            
        case SectionGroupTypeB:{
            XWGJMessageFrame *messageFrame =  group.items[indexPath.row];
            cellHeight  = messageFrame.cell_Height;
        }
            break;
            
        case SectionGroupTypeC:{
            UniversityFrameNew  *uniFrame = group.items[indexPath.row];
            cellHeight = uniFrame.cell_Height;
        }
            
            break;
            
        default:
            break;
    }
    
    
    
    
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    
    return  group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    myofferGroupModel *group = self.groups[indexPath.section];
    
    
    switch (group.type) {
        case SectionGroupTypeA:{
            
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"one"];
            
            if (!cell) {
                cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.contentView addSubview:self.oneGroup];
            
            return cell;
        }
            break;
            
            
        case SectionGroupTypeB:{
            
            MessageCell *news_cell =[MessageCell cellWithTableView:tableView];
            
            news_cell.messageFrame =  group.items[indexPath.row];
            
            [news_cell separatorLineShow: !(group.items.count - 1 == indexPath.row)];
            
            return news_cell;
        }
            break;
            
            
            
        default:{
            
            UniverstityTCell *uni_cell =[UniverstityTCell cellViewWithTableView:tableView];
            
            uni_cell.uniFrame = group.items[indexPath.row];
            
            [uni_cell separatorLineShow:NO];
            
            return uni_cell;
        }
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) return;
    
    myofferGroupModel *group = self.groups[indexPath.section];
    
    UIViewController *VC = [UIViewController new];
    
    switch (group.type) {
        case SectionGroupTypeB:
        {
            XWGJMessageFrame *newsFrame  = group.items[indexPath.row];
            
            VC = [[MessageDetaillViewController alloc] initWithMessageId:newsFrame.News.message_id];
            
            
        }
            break;
            
        case SectionGroupTypeC:
        {
            UniversityFrameNew *uniFrame   = group.items[indexPath.row];
            VC = [[UniversityViewController alloc] initWithUniversityId:uniFrame.universtiy.NO_id] ;
            
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}

#pragma mark : UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    //监听顶部导航条透明度
    [self.topNavigationView scrollViewContentoffset:scrollView.contentOffset.y andContenHeight:self.UniFrame.centerView_Frame.origin.y - XNAV_HEIGHT];
 
    //下拉图片处理
    [self.flexView flexWithContentOffsetY:scrollView.contentOffset.y ];
    
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
 
}

//点击图片浏览器
-(void)showPhotoAtIndex:(NSUInteger)index
{
    
    NSMutableArray *temps = [NSMutableArray new];
    
    for (NSString *path in self.UniFrame.item.m_images) {
        
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
            
            weakSelf.headerView.uniFrame = weakSelf.UniFrame;
            
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
    [self dismiss];
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
    
    [self presentViewController:[[WYLXViewController alloc] init]  animated:YES completion:nil];
    
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

//显示错误提示
- (void)showError{

    if (self.groups.count == 0) {
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.tableView emptyViewWithError:NetRequest_ConnectError];
        
    }
}

- (void)dealloc{
    
    KDClassLog(@" 学校详情 dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
