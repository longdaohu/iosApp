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
#import "IDMPhotoBrowser.h"
#import "ShareViewController.h"
#import "UniversityFooterView.h"
#import "UniversityCourseViewController.h"
#import "InteProfileViewController.h"
#import "UniDetailGroup.h"


typedef enum {
    UniversityItemTyDeFault,
    UniversityItemTypeFavor,
    UniversityItemTypeShare,
    UniversityItemTypeMore,
    UniversityItemTypeWeb,
    UniversityItemTypePop
}UniversityItemType;//表头按钮选项


@interface UniversityViewController ()<UITableViewDelegate,UITableViewDataSource,IDMPhotoBrowserDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UniGroupOneView  *oneGroup;
@property(nonatomic,strong)UniversityNewFrame    *UniFrame;
@property(nonatomic,strong)UIImageView           *iconView;
@property(nonatomic,assign)CGRect                iconViewOldFrame;
@property(nonatomic,assign)CGPoint               iconViewOldCenter;
@property(nonatomic,strong)NSMutableArray        *groups;
@property(nonatomic,strong)UniverstyHeaderView   *header;
@property(nonatomic,strong)UniversityNavView     *topNavigationView;
@property(nonatomic,assign)BOOL favorited;
@property(nonatomic,assign)UniversityItemType    *clickType;
@property(nonatomic,strong)ShareViewController   *shareVC;

@end

@implementation UniversityViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [MobClick beginLogPageView:@"page学校详情"];
    
    if (LOGIN) {
        
        [self refesh];
        
    }
  
}

-(void)refesh{

    NSString *path =[NSString stringWithFormat:@"GET api/v2/university/%@",self.uni_id];
    
    XJHUtilDefineWeakSelfRef
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        UniversitydetailNew  *item  =   [UniversitydetailNew mj_objectWithKeyValues:response];
        
        weakSelf.favorited = item.favorited;
        
        [weakSelf configureLikeButton:item.favorited];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
    }];
    
}


//判断用户在未登录前在申请中心页面选择服务，当用户登录时直接跳转已选择服务
-(void)userDidClickItem
{
//    if (LOGIN) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self detailPageClickWithItemType:self.detailType];
//        });
//        
//    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page学校详情"];
    
}

-(NSMutableArray *)groups{

    if (!_groups) {
        
        _groups =[NSMutableArray array];
    }
    
    return _groups;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadNewDataSourse];
    
    [self makeUI];
 
}
//加载数据
-(void)loadNewDataSourse
{
  
    XJHUtilDefineWeakSelfRef
    NSString *path =[NSString stringWithFormat:@"GET api/v2/university/%@",self.uni_id];
    
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        [weakSelf pop];

    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        UniversitydetailNew  *item  =   [UniversitydetailNew mj_objectWithKeyValues:response];
        
        [weakSelf makeUIWithUni:item];
        
        [UIView animateWithDuration:0.2 animations:^{
           
            weakSelf.tableView.alpha = 1;

        }];
        
        [weakSelf.tableView reloadData];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf pop];
        
    }];
    
}

#pragma mark ——— 设置控件数据
-(void)makeUIWithUni:(UniversitydetailNew *)university{
    
    
    self.favorited = university.favorited;
    
    [self configureLikeButton: university.favorited];
    
    UniversityNewFrame *UniFrame = [UniversityNewFrame frameWithUniversity:university];
    self.UniFrame = UniFrame;
    
    
    XJHUtilDefineWeakSelfRef
   //表头
    UniverstyHeaderView  * header   = [UniverstyHeaderView headerTableViewWithUniFrame:UniFrame];
    header.frame                   = UniFrame.headerFrame;
    header.actionBlock = ^(UIButton *sender){
    
        [weakSelf onClick:sender];
        
    };
    self.header = header;
    self.tableView.tableHeaderView  = header;
    
    
    //拉伸图片
    NSString *countryImageName = [university.country isEqualToString:@"英国"] ? @"Uni-uk.jpg" : @"Uni-au.jpg";
    [UIView transitionWithView:self.iconView duration:0.5 options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.iconView setImage:[UIImage imageNamed:countryImageName]];
    } completion:^(BOOL finished) {
        
    }];
    
    
    //设置第一分组cell数据
    [self oneGroupViewWithUniFrame:UniFrame];
    NSArray *sectionOne = @[UniFrame];
    UniDetailGroup *groupOne = [UniDetailGroup groupWithTitle:@"" contentes:sectionOne andFooter:NO];
    [self.groups addObject:groupOne];
    
    
    //相关资讯 第二分组
    NSArray *newses  = [NewsItem mj_objectArrayWithKeyValuesArray:university.relate_articles];
    NSMutableArray *news_temps = [NSMutableArray array];
    for (NewsItem *news in newses) {
        XWGJMessageFrame *newsFrame =  [XWGJMessageFrame messageFrameWithMessage:news];
        [news_temps addObject:newsFrame];
    }
 
    UniDetailGroup *groupTwo = [UniDetailGroup groupWithTitle:@"相关文章" contentes:[news_temps copy] andFooter:NO];
    [self.groups addObject:groupTwo];
    
    //相关院校  大于第二分组
    NSMutableArray *neightbour_temps = [NSMutableArray array];
    [university.rankNeighbour enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UniversityItemNew *uni = [UniversityItemNew mj_objectWithKeyValues:obj];
        UniItemFrame *uniFrame = [UniItemFrame frameWithUniversity:uni];
        [neightbour_temps addObject:uniFrame];
        
        NSString *title = idx == 0 ? @"相关院校" : @"";
        NSArray *items = @[uniFrame];
        UniDetailGroup *group = [UniDetailGroup groupWithTitle:title contentes:items andFooter:YES];
        [self.groups addObject:group];
        
        
    }];
    
}

-(void)makeUI{

    [self makeTableView];
    
    [self makeHeaderIconView];
    
    [self makeFooterView];
    
}


-(void)makeFooterView{
    
    XJHUtilDefineWeakSelfRef
    UniversityFooterView *footer = [[UniversityFooterView alloc] initWithFrame:CGRectMake(0, XScreenHeight - 70, XScreenWidth, 70)];
    footer.actionBlock = ^(UIButton *sender){
        [weakSelf footerWithButton:sender];
    };
    [self.view addSubview:footer];
    
}

-(void)makeTopNavigaitonView{

    
    XJHUtilDefineWeakSelfRef
    self.topNavigationView = [[NSBundle mainBundle] loadNibNamed:@"UniversityNavView" owner:self options:nil].lastObject;
    self.topNavigationView.frame = CGRectMake(0, 0, XScreenWidth, NAV_HEIGHT);
    self.topNavigationView.actionBlock = ^(UIButton *sender){
        
        [weakSelf onClick:sender];
        
    };
    
    [self.view addSubview:self.topNavigationView];
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.alpha = 0.1;
 
    [self makeTopNavigaitonView];
    
    
}

//表头显示图片
-(void)makeHeaderIconView{
    
    self.view.clipsToBounds = YES;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -NAV_HEIGHT, XScreenWidth, XPERCENT * 400)];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = BACKGROUDCOLOR;
//    iconView.image = [UIImage imageNamed:@"PlaceHolderImage"];
    self.iconView = iconView;
    self.iconViewOldFrame = iconView.frame;
    self.iconViewOldCenter = iconView.center;
    [self.view insertSubview:iconView  belowSubview:self.tableView];
    
}

//设置第一分区
- (void)oneGroupViewWithUniFrame:(UniversityNewFrame *)UniFrame
{
    UniGroupOneView  *oneGroup =[[UniGroupOneView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, UniFrame.contentHeight)];
    oneGroup.contentFrame = UniFrame;
    self.oneGroup = oneGroup;
    XJHUtilDefineWeakSelfRef
    oneGroup.actionBlock = ^(NSString *name,NSInteger index){
             [weakSelf showPhotoAtIndex:index];
      };
    
}

#pragma mark —————— UITableViewDelegate,UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    HomeSectionHeaderView *sectionView = [[HomeSectionHeaderView alloc] init];
    
    UniDetailGroup *group = self.groups[section];

    sectionView.TitleLab.text = group.HeaderTitle;
    
    return sectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    UniDetailGroup *group = self.groups[section];
    
    return group.HaveFooter ? PADDING_TABLEGROUP : 0.0000000001;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    UniDetailGroup *group = self.groups[section];

    return  group.HaveHeader ? 40 : 0.0000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    CGFloat height = indexPath.section == 0 ? self.oneGroup.contentFrame.contentHeight : University_HEIGHT;
 
    return height;
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
    
        XWGJMessageTableViewCell *news_cell =[XWGJMessageTableViewCell cellWithTableView:tableView];
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
        MessageDetailViewController *detail  =[[MessageDetailViewController alloc] init];
        detail.NO_ID = newsFrame.News.messageID;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        
        UniItemFrame *uniFrame   = group.items[indexPath.row];
        UniversityViewController *Uni  =[[UniversityViewController alloc] init];
        Uni.uni_id =  uniFrame.item.NO_id;
        [self.navigationController pushViewController:Uni animated:YES];
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
      //顶部导航条透明度
    [self.topNavigationView scrollViewContentoffset:scrollView.contentOffset.y];
 
    //顶部图片拉伸
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
        
        self.iconView.hidden = scrollView.contentOffset.y > XScreenHeight * 0.5;

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
//集成分享功能
- (ShareViewController *)shareVC{

    if (!_shareVC) {
        
        XJHUtilDefineWeakSelfRef
        _shareVC = [[ShareViewController alloc] initWithUniversity:self.UniFrame.item];
        _shareVC.actionBlock = ^{
             [weakSelf.shareVC.view removeFromSuperview];
         };
        
        [self.view addSubview:_shareVC.view];
        
        [self addChildViewController:_shareVC];

    }
    return _shareVC;
}

//分享
- (void)share{
    
    if (_shareVC.view.superview != self.view) {
        
        [self.view addSubview:_shareVC.view];
        
        [self.shareVC  show];
    }
}

//收藏
- (void)favorite{
    
    XJHUtilDefineWeakSelfRef
    NSString *path = self.favorited ?  @"GET api/account/unFavorite/:id"  : @"GET api/account/favorite/:id";
    [self startAPIRequestWithSelector:path parameters:@{@":id": self.UniFrame.item.NO_id} success:^(NSInteger statusCode, id response) {
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        NSString *title =  weakSelf.favorited ?  @"取消收藏"  : @"收藏成功";
        [hud setLabelText:title];//@"关注成功"];
        weakSelf.favorited =  !weakSelf.favorited;
        [hud hideAnimated:YES afterDelay:1];
        [weakSelf configureLikeButton:weakSelf.favorited];

    }];
}
//回退
- (void)pop{

     [self.navigationController popViewControllerAnimated:YES];
}

//点击查看更多
- (void)more{
  
    self.tableView.tableHeaderView  = self.header;
    
    self.UniFrame.showMore = !self.UniFrame.showMore;
 
    if (CGRectGetHeight(self.header.frame) > 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.header.itemFrame = self.UniFrame;
            
            self.header.frame   =  self.UniFrame.headerFrame;
            
            
//            _tableView.tableHeaderView = self.header;
//            [self.tableView reloadData];

            [_tableView beginUpdates];
            [_tableView setTableHeaderView:self.header];
            [_tableView endUpdates];

        }];
    
    }
    
    
}

//web
- (void)web{
    
    NSLog(@" %@",self.UniFrame.item.website);

}
//设置是否收藏
- (void)configureLikeButton:(BOOL)favorite{
    
     NSString *nomalFavor = favorite ? @"Uni_Favor" : @"Uni_Unfavor";
     [ self.topNavigationView.rightView.favoriteBtn setImage:[UIImage imageNamed:nomalFavor] forState:UIControlStateNormal];
     self.header.rightView.favorited = favorite;
    
}


//点击footer按钮
- (void)footerWithButton:(UIButton *)sender
{
    if ([sender.currentTitle containsString:@"查看"]) {
        
        [self allSubjects];
        
    }else{
        
        [self CasePipei];
    }
    
}

//查看所有专业
- (void)allSubjects{
    
    UniversityCourseViewController   *subjects = [[UniversityCourseViewController alloc] initWithUniversityID:self.uni_id];
    [self.navigationController pushViewController:subjects animated:YES];
}

//智能匹配
-(void)CasePipei{
    
    RequireLogin
    InteProfileViewController  *vc = [[InteProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

 

#pragma mark - IDMPhotoBrowser Delegate
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
    NSMutableArray *photos = [NSMutableArray new];
    NSMutableArray *temps = [NSMutableArray new];
    
    for (NSString *path in self.UniFrame.item.images) {
        [temps addObject:[NSURL URLWithString:path]];
    }
    
    NSArray *photosWithURL = [IDMPhoto photosWithURLs:temps];
    photos = [NSMutableArray arrayWithArray:photosWithURL];
    // Create and setup browser
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    browser.delegate = self;
    //图片数组开始index
    [browser setInitialPageIndex:index];
    browser.displayCounterLabel = YES;
    browser.displayActionButton = NO;
    [self presentViewController:browser animated:YES completion:nil];
    
}



-(void)dealloc{
    
    NSLog(@" 学校详情 dealloc");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end