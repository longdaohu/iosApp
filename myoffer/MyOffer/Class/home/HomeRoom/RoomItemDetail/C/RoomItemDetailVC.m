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
#import "RoomMapVC.h"
#import "HomeRoomIndexFlatFrameObject.h"
#import "Masonry.h"
#import "MeiqiaServiceCall.h"
#import "MyoffferAlertTableView.h"
#import "RoomAppointmentVC.h"

@interface RoomItemDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MyoffferAlertTableView *tableView;
@property(nonatomic,strong)RoomItemFrameModel *itemFrameModel;
@property(nonatomic,strong)RoomNavigationView *nav;
@property(nonatomic,strong)UIButton *bookBtn;

@end

@implementation RoomItemDetailVC
-(void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
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
    
    UIView *footer = [[UIView alloc] init];
    [self.view addSubview:footer];
    footer.backgroundColor = XCOLOR_WHITE;
    footer.layer.shadowColor = [UIColor blackColor].CGColor;
    footer.layer.shadowOffset = CGSizeMake(0,3);
    footer.layer.shadowOpacity =  0.15;
    footer.layer.cornerRadius = 8;
    CGFloat left_margin = 20;
    CGFloat bottom_margin = 30;
    CGFloat footer_width = XSCREEN_WIDTH - left_margin * 2;
    CGFloat footer_height = 45;
    [footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(footer_width, footer_height));
        make.left.mas_equalTo(left_margin);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-bottom_margin);
    }];
 
    UIButton *meiqia = [UIButton new];
    [meiqia setTitle:@"在线咨询" forState:UIControlStateNormal];
    [meiqia setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
    meiqia.titleLabel.font = XFONT(14);
    [footer addSubview:meiqia];
    [meiqia addTarget:self action:@selector(caseMeiqia) forControlEvents:UIControlEventTouchUpInside];
    CGFloat  meiqia_w = 113;
    CGFloat  book_w = footer_width - meiqia_w;
    [meiqia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(meiqia_w);
        make.height.mas_equalTo(footer.mas_height);
        make.left.mas_equalTo(footer.mas_left);
        make.top.mas_equalTo(footer.mas_top);
    }];
    
    UIButton *book = [UIButton new];
    [book setTitle:@"预订房间" forState:UIControlStateNormal];
    [book setBackgroundImage:XImage(@"button_red_right_nomal") forState:UIControlStateNormal];
    [book setBackgroundImage:XImage(@"button_red_right_highlight") forState:UIControlStateHighlighted];
    [book setBackgroundImage:XImage(@"button_light_right_unable") forState:UIControlStateDisabled];
    book.titleLabel.font = XFONT(14);
    [footer addSubview:book];
    self.bookBtn = book;
    [book addTarget:self action:@selector(caseBook) forControlEvents:UIControlEventTouchUpInside];
    [book mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(book_w);
        make.height.mas_equalTo(footer.mas_height);
        make.left.mas_equalTo(meiqia.mas_right);
        make.top.mas_equalTo(footer.mas_top);
    }];
}

-(void)makeTableView
{
    self.tableView =[[MyoffferAlertTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.sectionHeaderHeight = 52;
    self.tableView.sectionFooterHeight = Section_footer_Height_nomal;
    self.tableView.estimatedSectionHeaderHeight= UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    self.tableView.backgroundColor = XCOLOR_WHITE;
    
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.itemFrameModel.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    myofferGroupModel *group =  self.itemFrameModel.groups[section];
 
    return group.items.count;
}

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    myofferGroupModel *group = self.itemFrameModel.groups[indexPath.section];
    if (group.type == SectionGroupTypeRoomDetailTypeIntroduction || group.type == SectionGroupTypeRoomDetailTypeProcess) {
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
    
    if (group.type == SectionGroupTypeRoomDetailPromotion) {
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.itemFrameModel.groups[indexPath.section];
    if(group.type == SectionGroupTypeRoomDetailRoomType){
        RoomTypeItemFrameModel  *itemFrameModel =  group.items[indexPath.row];
        if (itemFrameModel.item.prices.count > 0) {
            RoomItemBookVC *vc = [[RoomItemBookVC alloc] init];
            vc.itemFrameModel =  itemFrameModel;
            PushToViewController(vc);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomeSecView *header = [[HomeSecView alloc] init];
    header.leftMargin = 20;
    header.titleInMiddle = YES;
    header.group = self.itemFrameModel.groups[section];
 
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myofferGroupModel *group = self.itemFrameModel.groups[indexPath.section];
    if (group.cell_height_set > 0 ) {
        return group.cell_height_set;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    footer.backgroundColor = XCOLOR_BG;
    if (section == self.itemFrameModel.groups.count - 1) {
        footer.backgroundColor = XCOLOR_WHITE;
    }
    return footer;
}

#pragma mark : 数据处理
- (void)makeData{
 
    WeakSelf;
    [self propertyWithRoomID:self.room_id.integerValue  additionalSuccessAction:^(id response, int status) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSError *error, int status) {
        [weakSelf.tableView alertWithNetworkFailure];
    }];
 
}

- (void)updateUIWithResponse:(id)response{
    
    [self.tableView alertViewHiden];
    
    RoomItemModel *room = [RoomItemModel mj_objectWithKeyValues:response];
    RoomItemFrameModel *roomFrameModel = [[RoomItemFrameModel alloc] init];
    roomFrameModel.item = room;
    self.itemFrameModel = roomFrameModel;
 
    [self.tableView reloadData];
    
    RoomItemHeaderView *header = [[RoomItemHeaderView  alloc] initWithFrame:roomFrameModel.header_frame];
    header.itemFrameModel = roomFrameModel;
    self.tableView.tableHeaderView = header;
    WeakSelf
    header.actionBlock = ^{
        [weakSelf caseMap];
    };
    
    self.nav.alpha_height =  roomFrameModel.header_box_frame.origin.y - XNAV_HEIGHT;
    self.bookBtn.enabled = !room.mark_sold.boolValue;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.nav scrollViewDidScroll:scrollView];
}

- (void)caseMap{

    if (self.isFromMap) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    RoomMapVC *vc = [[RoomMapVC alloc] init];
    vc.itemFrameModel = self.itemFrameModel;
    PushToViewController(vc);
}

- (void)caseMeiqia{
    
    [MeiqiaServiceCall callWithController:self];
}

- (void)caseBook{
 
    if (!self.itemFrameModel) return;
    
    WeakSelf
    RoomAppointmentVC *vc = [[RoomAppointmentVC alloc] init];
    vc.room_id = self.room_id;
    vc.actionBlock = ^{
        [weakSelf caseHome];
    };
    
    if ([self.navigationController isKindOfClass:[MyofferNavigationController class]]) {
        MyOfferWhiteNV *nav = [[MyOfferWhiteNV alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        PushToViewController(vc);
    }
}

- (void)caseHome{
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    });
}

-(void)dealloc
{
    KDClassLog(@" 房源详情 + RoomItemDetailVC + dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
