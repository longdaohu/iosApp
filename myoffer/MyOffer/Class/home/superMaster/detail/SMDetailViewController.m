//
//  SMDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMDetailViewController.h"
#import "SMDetailMedol.h"
#import "SMHomeSectionModel.h"
#import "SMHotCell.h"
#import "HomeSectionHeaderView.h"
#import "ServiceSKUFrame.h"
#import "ServiceSKUCell.h"
#import "SMAudioItemFrame.h"
#import "SMAudioItem.h"
#import "SMAudioModel.h"
#import "SMAudioCell.h"
#import "SMDetailHeaderFrame.h"
#import "SMDetailHeaderView.h"
#import "SMHotSectionFooterView.h"
#import "ServiceItemViewController.h"
#import "ServiceSKU.h"
#import "MyOfferLoginViewController.h"
#import "ShareNViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"


#define Limit_Count_NoLogin 2
 
@interface SMDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
@property(nonatomic,strong)SMDetailMedol *detail;
@property(nonatomic,strong)SMDetailHeaderFrame *detail_Frame;
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)SMDetailHeaderView *headerView;
@property(nonatomic,strong)NSArray *groups;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (strong, nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) UIView *bgView;
//返回按钮
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *shareBtn;

@property (nonatomic, assign) BOOL isPlaying_audio;
@property (strong, nonatomic) ZFPlayerView *audioPlayerView;
@property (nonatomic, strong) ZFPlayerModel *audioplayerModel;
@property (strong, nonatomic) UIView *audioPlayerFatherView;
//分享
@property(nonatomic,strong)ShareNViewController *shareVC;
@property(nonatomic,assign)BOOL first_time_loading;


@end

@implementation SMDetailViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self whenViewWillAppearWithPlayer];
    
    [MobClick beginLogPageView:@"page超导详情"];
    
    if (self.detail.main_title) {
        
        NSDictionary *dict = @{@"title" : self.detail.main_title};
        
        [MobClick event:@"Assign_ALL_Playtime" attributes:dict];
        [MobClick event:@"ALL_Playtime"];

    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
  
    [super viewWillDisappear:animated];
   
    [MobClick endLogPageView:@"page超导详情"];

    // push出下一级页面时候暂停
    
    if (self.playerView && !self.playerView.isPauseByUser){
        
        self.isPlaying = YES;
        self.playerView.playerPushedOrPresented = YES;
    }
    
    
    if (self.audioPlayerView && !self.audioPlayerView.isPauseByUser) {
        
           self.isPlaying_audio = YES;
           self.audioPlayerView.playerPushedOrPresented = YES;
    }
    
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeData];
  
}

 

#pragma mark : 网络请求
- (void)makeData{
 
    [self startAPIRequestWithSelector:[NSString stringWithFormat:@"%@%@",kAPISelectorSuperMasterDetail,self.message_id] parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [self updateUIWithResponse:response];

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [self dismiss];
    }];
    
}

- (void)updateUIWithResponse:(id)response{

 
    self.detail = [SMDetailMedol mj_objectWithKeyValues:response];
    
    self.detail.islogin = LOGIN;

    self.detail_Frame = [SMDetailHeaderFrame frameWithDetail:self.detail];
    
    
    //指定某一个超导页面统计总播放次数
    if (self.detail.main_title) {
        
        NSDictionary *dict = @{@"title" : self.detail.main_title};
        
        [MobClick event:@"Assign_ALL_Playtime" attributes:dict];
        [MobClick event:@"ALL_Playtime"];

    }
    
    
    NSMutableArray *group_temp = [NSMutableArray array];

    //1 分段音频
    if (self.detail.audio.fragments.count > 0) {
        
        NSMutableArray *audio_temp = [NSMutableArray array];
        
        for (SMAudioItem *item in self.detail.audio.fragments){
            
            //1 没登录时限制收听个数
            if (!LOGIN && audio_temp.count < Limit_Count_NoLogin){
            
                //大于2个听前两个 小于两个全不可听
                item.isCanPlay = (self.detail.audio.fragments.count > Limit_Count_NoLogin) ? YES : NO;
            }
            
            //2 登录全可听
            if (LOGIN)  item.isCanPlay = YES;
            
            
            SMAudioItemFrame *audioFrame = [SMAudioItemFrame frameWitAudioItem:item];
            
            [audio_temp addObject:audioFrame];
        }
        
        
        //3 展示部分，点击显示全部，再展示全部
        SMHomeSectionModel *one = [SMHomeSectionModel sectionInitWithTitle:@"分段音频" Items:[audio_temp copy] groupType:SMGroupTypeAudios];
        
        one.show_All_data = (one.item_all.count < one.limit_count);
       
        
        if (one.items.count > 0) [group_temp addObject:one];
        

    }
    
    
    //2 推荐服务
    if (self.detail.sku.count > 0) {
        
        NSMutableArray *sku_temp = [NSMutableArray array];
        for (ServiceSKU *sku in self.detail.sku){
            
            ServiceSKUFrame *skuFrame = [ServiceSKUFrame frameWithSKU:sku];
            
            [sku_temp addObject:skuFrame];
        }
        SMHomeSectionModel *second = [SMHomeSectionModel sectionInitWithTitle:@"推荐服务"  Items:[sku_temp copy] groupType:SMGroupTypeSKUs];
        
        if (second.items.count > 0)  [group_temp addObject:second];
        
    }
    
    //3 相关视频
    if (self.detail.related.count > 0) {
        
        NSMutableArray *hots_temp = [NSMutableArray array];
        
        for (SMHotModel *hot in self.detail.related){
            
            [hots_temp addObject:[SMHotFrame frameWithHot:hot]];
        }
        SMHomeSectionModel *third = [SMHomeSectionModel sectionInitWithTitle:@"相关视频"  Items:[hots_temp copy] groupType:SMGroupTypeHot];
        
         if (third.items.count > 0)  [group_temp addObject:third];
        
    }
    
    self.groups = [group_temp copy];
    
    
    self.headerView.header_frame = self.detail_Frame;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView reloadData];

 
    
    NSString *path = @"";
    
    if (self.detail.has_video ) {
        
        path =  LOGIN ? self.detail.video_url :self.detail.trial_video_url;
        
    }else{
    
        path = self.detail.audio.file_url;
    }
    
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.playerView.alpha = 1;
        self.bgView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self.tableView  setContentOffset:CGPointZero animated:NO];
        
        self.playerModel.videoURL    =  [NSURL URLWithString:path];
        
        [self.playerView resetToPlayNewVideo:self.playerModel];
        
        [self.audioPlayerView pause];

        if ([path hasSuffix:@".mp3"])  {
            
            [self.playerView pause];
             self.playerView.userInteractionEnabled = LOGIN ? YES : NO;
            
        }else{
            
            self.playerView.userInteractionEnabled = YES;

        }
        
        
    }];
    
    
 
}



#pragma mark : 添加UI
- (void)makeUI{
    
    [self makeTableView];
   
}

- (SMDetailHeaderView *)headerView{

    if (!_headerView) {
        
        WeakSelf;
        _headerView = [[SMDetailHeaderView alloc] init];
        _headerView.actionBlock = ^(BOOL guest_intro_showAll, UIButton *sender) {
            
            if(sender){
            
                [weakSelf toLoginView];
            
            } else{
            
                [weakSelf showHeaderView];
            }
          
        };
      
    }
    
    return _headerView;
}

- (void)showHeaderView{
    
    self.detail.guest_intr_ShowAll = YES;
    
    [self makeTableViewHeaderWithDetailModel:self.detail];

    [self.tableView reloadData];
    
}

//设置表头
- (void)makeTableViewHeaderWithDetailModel:(SMDetailMedol *)detail{

    self.detail_Frame.detailModel = detail;
    
    self.headerView.header_frame = self.detail_Frame;
    
    self.tableView.tableHeaderView = self.headerView;
    
}



-(void)makeTableView
{
  
    UIView *fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, XSCREEN_WIDTH, AdjustF(200.f))];
    self.playerFatherView = fatherView;
    
    self.bgView.alpha = 0;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, CGRectGetMaxY(self.playerFatherView.frame))];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.playerFatherView];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:_backButton];
    CGFloat top_y = IsiPhoneBigScreen ? 40 : 20;
    CGFloat btn_w = 40;
    CGFloat btn_h = btn_w;
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_w, btn_h));
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(top_y);
    }];
 
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn addTarget:self action:@selector(caseShare) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn  setImage:[UIImage imageNamed:@"Uni_share"] forState:UIControlStateNormal];
    [self.bgView addSubview:_shareBtn];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_w, btn_h));
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(top_y);
    }];
 
    CGFloat tb_y = CGRectGetMaxY(self.bgView.frame);
    CGFloat tb_x = 0;
    CGFloat tb_w = XSCREEN_WIDTH;
    CGFloat tb_h = XSCREEN_HEIGHT - tb_y;
    CGRect tb_frame = CGRectMake(tb_x, tb_y, tb_w, tb_h);
    self.tableView =[[MyOfferTableView alloc] initWithFrame:tb_frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMHomeSectionModel *group = self.groups[indexPath.section];
    
    switch (group.groupType) {
        case SMGroupTypeAudios:
        {
            SMAudioCell *audio_cell = [SMAudioCell cellWithTableView:tableView indexPath:indexPath];
             audio_cell.audioFrame =  group.items[indexPath.row];
             [audio_cell bottomLineWithHiden:(indexPath.row == group.items.count - 1)];
            
            return audio_cell;
        }
            break;
       case SMGroupTypeSKUs:
        {
            ServiceSKUFrame *sku_frame = group.items[indexPath.row];
            
            ServiceSKUCell *sku_cell = [ServiceSKUCell cellWithTableView:tableView indexPath:indexPath SKU_Frame:sku_frame];
            
            return sku_cell;
        }
            break;
            
        default:{
        
            SMHotCell *hot_cell = [SMHotCell cellWithTableView:tableView];
            hot_cell.hotFrame = group.items[indexPath.row];
            return hot_cell;
        }
            break;
    }
   
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:group.title];
    SectionView.backgroundColor = XCOLOR_WHITE;
    
    return SectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    
    if (!group.show_All_data) {
        
        WeakSelf
        SMHotSectionFooterView *footer = [SMHotSectionFooterView footerWithTitle:@"展开所有音频" action:^{
            
            group.show_All_data = YES;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            
        }];
        footer.moreColor = XCOLOR_WHITE;
        footer.moreTitleColor = XCOLOR_LIGHTBLUE;
        
        return footer;
        
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMHomeSectionModel *group = self.groups[indexPath.section];
    
    CGFloat height = 0;
    
    switch (group.groupType) {
        case SMGroupTypeAudios:
        {
            SMAudioItemFrame *audio_Frame =  group.items[indexPath.row];
            height = audio_Frame.cell_height;
        }
            break;
        case SMGroupTypeSKUs:
        {
            ServiceSKUFrame *sku_frame = group.items[indexPath.row];
            height = sku_frame.cell_Height;
            
        }
            break;
        default:{
            
            SMHotFrame *hot_frame  =  group.items[indexPath.row];
            height = hot_frame.cell_height;
   
        }
            break;
    }
 
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  Section_header_Height_nomal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    
    if (!group.show_All_data) return Section_footer_Height_Title;
    
    return Section_footer_Height_nomal;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SMHomeSectionModel *group = self.groups[indexPath.section];
   
    switch (group.groupType) {
        case SMGroupTypeHot:
        {
            SMHotFrame *hot_frame  =  group.items[indexPath.row];
            
            if (hot_frame.hot.messageType == SMMessageTypeOffLine) {
                
                [self safariWithPath:hot_frame.hot.offline_path];
                
                return;
                
            }
            
            self.message_id =  hot_frame.hot.message_id;
            
            [self makeData];
            
            [self.tableView setContentOffset:CGPointZero animated:YES];
      
        }
            break;
            
        case SMGroupTypeSKUs:{
        
            ServiceItemViewController *sku_vc = [[ServiceItemViewController alloc] init];
            
            ServiceSKUFrame *sku_frame = group.items[indexPath.row];
            
            sku_vc.service_id = sku_frame.SKU.service_id;
            
            [self pushWithVC:sku_vc];
        }

            break;
            
        default:{
            
        }
            break;
    }
  
    //非音频不能点击
    if (group.groupType != SMGroupTypeAudios) return;
    
    
        SMAudioItemFrame *audio_frame  =  group.items[indexPath.row];
    
        //不能播放音频
    if (!audio_frame.item.isCanPlay)  {
    
        
        [self loginView];
        
        return;
    }
        

    
        NSInteger temp_index = DEFAULT_NUMBER;
        
        for (NSInteger p_index = 0; p_index < group.items.count; p_index++) {
        
            SMAudioItemFrame *a_frame  =  group.items[p_index];
            
            if (a_frame.item.inPlaying) {
                
                temp_index = p_index;
                
                a_frame.item.inPlaying = NO;
                
                [self.audioPlayerView pause];
                
                break;
            }
        }
    
    
    
    
        if (temp_index == DEFAULT_NUMBER ) {
            
            audio_frame.item.inPlaying = YES;
  
        }else{
            
            audio_frame.item.inPlaying = (temp_index == indexPath.row) ? NO : !audio_frame.item.inPlaying;
      
          
        }
 
     
    
    if ( audio_frame.item.inPlaying) {
        
        self.audioplayerModel.videoURL  =  [NSURL URLWithString:audio_frame.item.file_url];
        
        [self.audioPlayerView resetToPlayNewVideo:self.audioplayerModel];
        
        [self.playerView pause];
        
    }else{
    
        [self.audioPlayerView pause];

    }
    
    
       [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

    
}



#pragma mark : 事件处理
- (void)pushWithVC:(UIViewController *)vc{
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - PLAYER

- (ZFPlayerModel *)audioplayerModel {
    
    if (!_audioplayerModel) {
        _audioplayerModel    = [[ZFPlayerModel alloc] init];
        _audioplayerModel.fatherView  =  self.audioPlayerFatherView;
        
    }
    return _audioplayerModel;
}


- (UIView *)audioPlayerFatherView{

    if (!_audioPlayerFatherView){
        
        _audioPlayerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, XSCREEN_WIDTH, 200)];
    
        [self.view insertSubview:_audioPlayerFatherView belowSubview:self.tableView];

    }
    
    
    return _audioPlayerFatherView;
}

- (ZFPlayerView *)audioPlayerView {
    
    if (!_audioPlayerView) {
        
        _audioPlayerView = [[ZFPlayerView alloc] init];
    
        [_audioPlayerView playerControlView:nil playerModel:self.audioplayerModel];
        // 设置代理
        _audioPlayerView.delegate = self;
         //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        
        // 打开预览图
        
    }
    return _audioPlayerView;
}




- (ZFPlayerModel *)playerModel {
    
    if (!_playerModel) {
        _playerModel      = [[ZFPlayerModel alloc] init];
        //        _playerModel.title   = @"这里设置视频标题";
        _playerModel.videoURL         =  [NSURL URLWithString:self.detail.video_url];
        _playerModel.placeholderImage = [UIImage imageNamed:@"sm_vedio_banner.jpg"];
        _playerModel.fatherView       = self.playerFatherView;
        
    }
    return _playerModel;
}


- (ZFPlayerView *)playerView {
    
    if (!_playerView) {
        
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.alpha = 0;
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
         _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        
        // 打开下载功能（默认没有这个功能）
//        _playerView.hasDownload    = YES;
        
//        [_playerView autoPlayTheVideo];

        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}


#pragma mark :  ZFPlayerDelegate
/** 返回按钮事件 */
- (void)zf_playerBackAction{

    [self.navigationController popViewControllerAnimated:YES];

}

//点击播放事件
- (void)zf_playerDidClickPlay:(ZFPlayerView *)playerView{
    
 
    
    //每点击一个“视频/音频”超导的播放按钮记录1次，播放-暂停-播放为2次
    /*
     ZFPlayerStateFailed,     // 播放失败
     ZFPlayerStateBuffering,  // 缓冲中
     ZFPlayerStatePlaying,    // 播放中
     ZFPlayerStateStopped,    // 停止播放
     ZFPlayerStatePause       // 暂停播放
     
     
     */
    
    if (playerView.state == ZFPlayerStateBuffering && !self.first_time_loading) {
        

        self.first_time_loading = YES;
        
       
    }
 
 
    if (self.playerView.state == ZFPlayerStatePlaying && self.audioPlayerView.state == ZFPlayerStatePlaying) {
        
        [self.audioPlayerView pause];
        
        [self reSetSectionAudio];
    }
    
   
}

- (void)reSetSectionAudio{

    SMHomeSectionModel *group = self.groups[0];
    
    for (NSInteger p_index = 0; p_index < group.items.count; p_index++) {
        
        SMAudioItemFrame *a_frame  =  group.items[p_index];
        
        a_frame.item.inPlaying = NO;
        
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)zf_playerStateEndPlay:(ZFPlayerView *)playerView{

    if (playerView == self.audioPlayerView) {
    
        [self reSetSectionAudio];
    }
}

- (void)zf_playerDownload:(NSString *)url {
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    
    return NO;
}


- (void)backBtnClick:(UIButton *)sender{

    [self dismiss];
}


- (void)safariWithPath:(NSString *)path{
    
    [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:path]];
    
}


- (void)whenViewWillAppearWithPlayer{

    // pop回来时候是否自动播放
    if (self.playerView && self.isPlaying) {
        
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
    
    
    
    if (self.audioPlayerView && self.isPlaying_audio) {
        
        self.isPlaying_audio = NO;
        self.audioPlayerView.playerPushedOrPresented = NO;
        
    }
    
    //1 如果不存在，没有必要下一步操作
    if (!self.detail) return;
  
    
    //2 判断登录状态是否改变
    if (self.detail.islogin != LOGIN) {
        
        self.detail.islogin = LOGIN ? YES : NO;
        
        [self makeTableViewHeaderWithDetailModel:self.detail];
        
        for (NSInteger index = 0; index < self.detail.audio.fragments.count ; index++) {
            
            SMAudioItem *item  = self.detail.audio.fragments[index];
            //1 没登录时限制收听个数
            if (!LOGIN && index < Limit_Count_NoLogin){
                
                //大于2个听前两个 小于两个全不可听
                item.isCanPlay = (self.detail.audio.fragments.count > Limit_Count_NoLogin) ? YES : NO;
            }
            
            //2 登录全可听
            if (LOGIN)  item.isCanPlay = YES;
            
        }
        
        
        [self.tableView reloadData];
        
        if (!LOGIN) return;
        
        if (self.detail.has_video == NO){
        
            self.playerView.userInteractionEnabled = YES;
            
        }else{
        
            //如果 self.audioPlayerView.state 正在播
            
            self.playerModel.videoURL    =  [NSURL URLWithString:self.detail.video_url];
           
            [self.playerView resetToPlayNewVideo:self.playerModel];
            
            if (self.audioPlayerView.state == ZFPlayerStatePlaying)  [self.playerView pause];
            
            
        }
        
    
        
    }
 
    
}

- (void)toLoginView{

   MyOfferLoginViewController *loginVC =[[MyOfferLoginViewController alloc] init];
    loginVC.index = 1;
    MyofferNavigationController *nav =[[MyofferNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:^{}];
}


- (ShareNViewController *)shareVC{
    
    if (!_shareVC) {
        
        NSString *shareURL = [NSString stringWithFormat:@"%@sm/lecture/%@.html",DOMAINURL,self.detail.short_id];
        NSString *shareTitle = self.detail.main_title;
        NSString *shareContent = self.detail.introduction;
        NSString *path = self.detail.ad_post_mc;

        NSMutableDictionary *shareInfor = [NSMutableDictionary dictionary];
        [shareInfor setValue:path forKey:@"icon"];
        [shareInfor setValue:shareURL forKey:@"shareURL"];
        [shareInfor setValue:shareTitle forKey:@"shareTitle"];
        [shareInfor setValue:shareContent forKey:@"shareContent"];
        [shareInfor setValue:@"plat" forKey:@"plat"];
        _shareVC = [ShareNViewController shareView];
        _shareVC.shareInfor = shareInfor;
        
        [self addChildViewController:_shareVC];
        [self.view addSubview:self.shareVC.view];
        
    }
    
    return _shareVC;
}

//分享
- (void)caseShare{
    
    [self.shareVC  show];
    
}
- (void)dealloc{
    
    KDClassLog(@"导师详情 + SMDetailViewController + dealloc");
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
