//
//  RoomItemDetailVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemDetailVC.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "RoomItemModel.h"
#import "HomeSecView.h"
#import "RoomItemFrameModel.h"
#import "RoomTextCell.h"
#import "RootTagsCell.h"
#import "RoomItemTypeCell.h"
#import "RoomTextSpodCell.h"
#import "RoomItemHeaderView.h"
#import "RoomNavigationView.h"
#import "RoomItemBookVC.h"

@interface RoomItemDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)RoomItemFrameModel *itemFrameModel;
@property(nonatomic,strong)RoomNavigationView *nav;

@end

@implementation RoomItemDetailVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NavigationBarHidden(YES);
    [MobClick beginLogPageView:@"page51Room房源详情"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page51Room房源详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self makeUI];
    [self makeData];
}

- (void)makeUI{
    
    self.view.backgroundColor = XCOLOR_BG;
    [self makeTableView];
    
    RoomNavigationView *nav = [RoomNavigationView nav];
    self.nav = nav;
    [self.view addSubview:nav];
    nav.title = @"房源详情";
    WeakSelf
    nav.acitonBlock = ^(BOOL isBackButton) {
        if (isBackButton) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    backBtn.backgroundColor = XCOLOR_RANDOM;
//    [backBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:XImage(@"back_arrow") forState:UIControlStateNormal];
    [backBtn setImage:XImage(@"back_arrow_black") forState:UIControlStateSelected];
    nav.rightView = backBtn;
    
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.sectionHeaderHeight = 50;
    self.tableView.sectionFooterHeight = 10;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.backgroundColor = XCOLOR_CLEAR;
 }

- (NSArray *)groups{
    
    if (!_groups) {
        
        myofferGroupModel *discount = [myofferGroupModel groupWithItems:nil header:@"优惠活动"];
        discount.type = SectionGroupTypeRoomDetailDiscount;
        
        myofferGroupModel *type = [myofferGroupModel groupWithItems:nil header:@"房间类型"];
        type.type = SectionGroupTypeRoomDetailRoomType;
        
        myofferGroupModel *intro = [myofferGroupModel groupWithItems:nil header:@"公寓介绍"];
        intro.type  = SectionGroupTypeRoomDetailTypeIntroduction;
        
        myofferGroupModel *facilities = [myofferGroupModel groupWithItems:nil header:@"公寓设施"];
        facilities.type = SectionGroupTypeRoomDetailTypeFacility;
        
        myofferGroupModel *note = [myofferGroupModel groupWithItems:nil header:@"预订须知"];
        note.type = SectionGroupTypeRoomDetailTypeNote;
      
        _groups = @[discount,type,intro,facilities,note];
    }
    
    return  _groups;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    myofferGroupModel *group = self.groups[section];
 
    return group.items.count;
}

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    myofferGroupModel *group = self.groups[indexPath.section];
    if (group.type == SectionGroupTypeRoomDetailTypeIntroduction || group.type == SectionGroupTypeRoomDetailDiscount) {
        RoomTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomTextCell"];
        if (!cell) {
            cell =[[RoomTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoomTextCell"];
        }
        cell.group = group;
        cell.item = group.items[indexPath.row];
        cell.itemFrameModel = self.itemFrameModel;
        
        return cell;
    }
    
    
    if (group.type == SectionGroupTypeRoomDetailTypeFacility) {
        
        RootTagsCell *cell =[[RootTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.items = group.items[indexPath.row];
        cell.itemFrameModel = self.itemFrameModel;
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeRoomDetailRoomType) {
        
        RoomItemTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomItemTypeCell"];
        if (!cell) {
            cell =[[RoomItemTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoomItemTypeCell"];
        }
        cell.itemFrameModel = group.items[indexPath.row];
 
        return cell;
    }
    
    if (group.type == SectionGroupTypeRoomDetailTypeNote) {
        
        RoomTextSpodCell *cell =[[RoomTextSpodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.item = group.items[indexPath.row];
        cell.itemFrameModel = self.itemFrameModel;
        
        return cell;
    }
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    cell.contentView.backgroundColor = XCOLOR_RANDOM;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.groups[indexPath.section];
    if(group.type == SectionGroupTypeRoomDetailRoomType){
     
        RoomItemBookVC *vc = [[RoomItemBookVC alloc] init];
        vc.itemFrameModel =  group.items[indexPath.row];
        PushToViewController(vc);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomeSecView *header = [[HomeSecView alloc] init];
    header.leftMargin = 20;
    header.group = self.groups[section];
 
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myofferGroupModel *group = self.groups[indexPath.section];
    if (group.cell_height_set > 0 ) {
        return group.cell_height_set;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark : 数据处理
- (void)makeData{
 
    WeakSelf;
    [[HttpsApiClient_API_51ROOM instance] property:238 completionBlock:^(CACommonResponse *response) {
        NSString *status = [NSString stringWithFormat:@"%d",response.statusCode];
        if (![status isEqualToString:@"200"]) {
            NSLog(@" 网络请求错误 ");
            return ;
        }
        id result = [response.body KD_JSONObject];
        [weakSelf updateUIWithResponse:result];
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    
    RoomItemModel *room = [RoomItemModel mj_objectWithKeyValues:response];
    RoomItemFrameModel *roomFrameModel = [[RoomItemFrameModel alloc] init];
    roomFrameModel.item = room;
    self.itemFrameModel = roomFrameModel;
 
    for (myofferGroupModel *group in self.groups) {
        switch (group.type) {
            case SectionGroupTypeRoomDetailTypeIntroduction:
            {
                group.items = @[room.intro];
                group.cell_height_set = roomFrameModel.intro_cell_hight;
            }
                break;
            case SectionGroupTypeRoomDetailDiscount:
            {
                group.items = @[room.process];
                group.cell_height_set = roomFrameModel.process_cell_hight;
            }
                break;
            case SectionGroupTypeRoomDetailTypeNote:
            {
                group.items = @[room.promotion];
                group.cell_height_set = roomFrameModel.promotion_cell_hight;
            }
                break;
            case SectionGroupTypeRoomDetailTypeFacility:
            {
                group.items = @[room.ameniti_arr];
                group.cell_height_set = roomFrameModel.faciliti_cell_hight;
            }
                break;
            case SectionGroupTypeRoomDetailRoomType:
            {
                group.items = roomFrameModel.typeFrames;
                group.cell_height_set = roomFrameModel.type_cell_hight;
            }
                break;
            default:
                break;
        }
    }
    [self.tableView reloadData];
    
    
    RoomItemHeaderView *header = [[RoomItemHeaderView  alloc] initWithFrame:roomFrameModel.header_frame];
    header.itemFrameModel = roomFrameModel;
    self.tableView.tableHeaderView = header;
    WeakSelf
    header.actionBlock = ^{
        [weakSelf caseMap];
    };
    
    self.nav.alpha_height =  roomFrameModel.header_box_frame.origin.y - XNAV_HEIGHT;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.nav scrollViewDidScroll:scrollView];
}

- (void)caseMap{
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
