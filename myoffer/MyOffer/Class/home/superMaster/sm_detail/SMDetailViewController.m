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

@interface SMDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)SMDetailMedol *detail;
@property(nonatomic,strong)SMDetailHeaderFrame *detail_Frame;
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)SMDetailHeaderView *headerView;
@property(nonatomic,strong)NSArray *groups;

@end

@implementation SMDetailViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    
    //1 如果不存在，没有必要下一步操作
    if (!self.detail) return;
    
    //2 判断登录状态是否改变
    if (self.detail.islogin != LOGIN) {
        
        self.detail.islogin = LOGIN;
        
        self.detail_Frame.detailModel = self.detail;
        
        self.headerView.header_frame = self.detail_Frame;
        
        self.tableView.tableHeaderView = self.headerView;
        
        
        for (NSInteger index = 0; index < self.detail.audio.fragments.count ; index++) {
        
            SMAudioItem *item  = self.detail.audio.fragments[index];
                 //1 没登录时限制收听个数
            if (!LOGIN && index < 2){
            
                //大于2个听前两个 小于两个全不可听
                item.isPlay = (self.detail.audio.fragments.count > 2) ? YES : NO;
            }
            
            //2 登录全可听
            if (LOGIN)  item.isPlay = YES;
            
        }
        
        
        
        [self.tableView reloadData];
        
    }
    
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeData];
  
}


#pragma mark : 网络请求
- (void)makeData{

    NSString *path = [NSString stringWithFormat:@"GET /api/sm/lecture/%@",self.message_id];

    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        [self updateUIWithResponse:response];
        
    }];
    
}

- (void)updateUIWithResponse:(id)response{

 
    self.detail = [SMDetailMedol mj_objectWithKeyValues:response];
    
    self.detail.islogin = LOGIN;
    
    self.detail_Frame = [SMDetailHeaderFrame frameWithDetail:self.detail];
    
    
    NSMutableArray *group_temp = [NSMutableArray array];

    if (self.detail.audio.fragments.count > 0) {

        
        NSMutableArray *audio_temp = [NSMutableArray array];
        
        for (SMAudioItem *item in self.detail.audio.fragments){
            
            //1 没登录时限制收听个数
            if (!LOGIN && audio_temp.count < 2){
            
                //大于2个听前两个 小于两个全不可听
                item.isPlay = (self.detail.audio.fragments.count > 2) ? YES : NO;
            }
            
            //2 登录全可听
            if (LOGIN)  item.isPlay = YES;
            
            
            SMAudioItemFrame *audioFrame = [SMAudioItemFrame frameWitAudioItem:item];
            
            [audio_temp addObject:audioFrame];
        }
        
        //3 展示部分，点击显示全部，再展示全部
        NSArray *audioArr = audio_temp.count > 5 ? [audio_temp subarrayWithRange:NSMakeRange(0, 5)] : audio_temp;

        SMHomeSectionModel *one = [SMHomeSectionModel sectionInitWithTitle:@"分段音频" Items:[audioArr copy] index:0];
        
        one.item_all = audio_temp;
        
        [group_temp addObject:one];
        
    }
    
    
    
    if (self.detail.sku.count > 0) {
        
        NSMutableArray *sku_temp = [NSMutableArray array];
        for (ServiceSKU *sku in self.detail.sku){
            
            ServiceSKUFrame *skuFrame = [ServiceSKUFrame frameWithSKU:sku];
            
            [sku_temp addObject:skuFrame];
        }
        SMHomeSectionModel *second = [SMHomeSectionModel sectionInitWithTitle:@"推荐服务"  Items:[sku_temp copy] index:1];
        
        [group_temp addObject:second];

        
    }
    
    
    if (self.detail.related.count > 0) {
        
        NSMutableArray *hots_temp = [NSMutableArray array];
        
        for (SMHotModel *hot in self.detail.related){
            
            [hots_temp addObject:[SMHotFrame frameWithHot:hot]];
        }
        SMHomeSectionModel *third = [SMHomeSectionModel sectionInitWithTitle:@"相关视频"  Items:[hots_temp copy] index:2];
        
        [group_temp addObject:third];
        
    }
    
    self.groups = [group_temp copy];
    
    self.headerView.header_frame = self.detail_Frame;
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView reloadData];

}


#pragma mark : 添加UI
- (void)makeUI{
    
    [self makeTableView];
  
}

- (SMDetailHeaderView *)headerView{

    if (!_headerView) {
        
        XWeakSelf;
        _headerView = [[SMDetailHeaderView alloc] init];
        
        _headerView.actionBlock = ^{
        
            [weakSelf loginView];
            
        };
    }
    
    return _headerView;
}


-(void)makeTableView
{
    CGFloat tb_y = 200;
    CGFloat tb_x = 0;
    CGFloat tb_w = XSCREEN_WIDTH;
    CGFloat tb_h = XSCREEN_HEIGHT - tb_y;
    CGRect tb_frame = CGRectMake(tb_x, tb_y, tb_w, tb_h);
    self.tableView =[[MyOfferTableView alloc] initWithFrame:tb_frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headerView;

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
    
    if (group.index == 0) {
        
        SMAudioCell *audio_cell = [SMAudioCell cellWithTableView:tableView indexPath:indexPath];
    
        
        audio_cell.audioFrame =  group.items[indexPath.row];
        
        
        [audio_cell bottomLineWithHiden:(indexPath.row == group.items.count - 1)];
        
        return audio_cell;
        
        
    }else if(group.index == 1){
        
        ServiceSKUFrame *sku_frame = group.items[indexPath.row];
        
        ServiceSKUCell *sku_cell = [ServiceSKUCell cellWithTableView:tableView indexPath:indexPath SKU_Frame:sku_frame];
        
        return sku_cell;
        
    }else{
        
        SMHotCell *hot_cell = [SMHotCell cellWithTableView:tableView];
        
        hot_cell.hotFrame = group.items[indexPath.row];
        
        return hot_cell;
        
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
    
    if (group.index == 0 && !group.showMore && group.item_all.count > 5) {
        
        XWeakSelf
        SMHotSectionFooterView *footer = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMHotSectionFooterView class]) owner:self options:nil].firstObject;
        footer.moreColor = XCOLOR_WHITE;
        footer.moreTitleColor = XCOLOR_LIGHTBLUE;
        footer.moreTitle = @"展开所有音频";
        footer.actionBlock = ^{
            
            group.showMore = YES;
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        
        return footer;
        
    }
    
    return nil;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMHomeSectionModel *group = self.groups[indexPath.section];
    
    if (group.index == 0) {
        
      SMAudioItemFrame *audio_Frame =  group.items[indexPath.row];
        
        return audio_Frame.cell_height;
        
    }else if(group.index == 1) {
        
        ServiceSKUFrame *sku_frame = group.items[indexPath.row];

        return sku_frame.cell_Height;
        
    }else{
        
        SMHotFrame *hot_frame  =  group.items[indexPath.row];
        
        return  hot_frame.cell_height;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    
    if (group.index == 0 && !group.showMore && group.item_all.count > 5) {
        
        return 80;
    }
    
    return 10;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SMHomeSectionModel *group = self.groups[indexPath.section];
    
    if (group.index == 2) {
        
        SMHotFrame *hot_frame  =  group.items[indexPath.row];
        
        SMDetailViewController *detail = [[SMDetailViewController alloc] init];
        
        detail.message_id = hot_frame.hot.message_id;
        
        [self pushWithVC:detail];
    }
    
    
    if (group.index == 1) {
        
        
        ServiceItemViewController *sku_vc = [[ServiceItemViewController alloc] init];
        
        ServiceSKUFrame *sku_frame = group.items[indexPath.row];

        sku_vc.service_id = sku_frame.SKU.service_id;

        [self pushWithVC:sku_vc];
    }
    
    
    
    if (group.index == 0) {
        
        
        SMAudioItemFrame *audio_frame  =  group.items[indexPath.row];
        
        //不能播放音频
        if (!audio_frame.item.isPlay)  return;
        
            
            NSInteger temp_index = DEFAULT_NUMBER;
            
            for (NSInteger p_index = 0; p_index < group.items.count; p_index++) {
            
                SMAudioItemFrame *a_frame  =  group.items[p_index];
                
                if (a_frame.item.inPlaying) {
                    
                    temp_index = p_index;
                    
                    a_frame.item.inPlaying = NO;
                    
                    break;
                }
            }
            
            
            NSLog(@">>>>>>>>>>>>> %@",audio_frame.item.file_url);
            
            if (temp_index == DEFAULT_NUMBER ) {
                
                audio_frame.item.inPlaying = YES;

            }else{
                
                if(temp_index == indexPath.row){
                    
                     audio_frame.item.inPlaying = NO;
                
                }else{
                
                     audio_frame.item.inPlaying = !audio_frame.item.inPlaying;
                
                }
              
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

         }
    
}




#pragma mark : 事件处理
- (void)pushWithVC:(UIViewController *)vc{
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
