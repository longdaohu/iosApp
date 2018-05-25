//
//  PersonCenterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "LeftMenuHeaderView.h"
#import "CenterHeaderView.h"
#import "ApplyStutasCenterViewController.h"
#import "PersonCell.h"
#import "FavoriteViewController.h"
#import "CatigoryViewController.h"
#import "NotificationViewController.h"
#import "SetViewController.h"
#import "PipeiEditViewController.h"
#import "OrderViewController.h"
#import "ApplyStutasCenterViewController.h"
#import "PersonServiceStatusHistoryViewController.h"
#import "IntelligentResultViewController.h"
#import "LeftBarButtonItemView.h"
#import "myApplyViewController.h"
#import "ApplyStutasModel.h"
#import "ApplyStatusNewCell.h"
#import "ApplyStatusModelFrame.h"
#import "myOfferPageViewController.h"
#import "DiscountVC.h"
#import "MQChatViewManager.h"
#import "MeiqiaServiceCall.h"
#import "RewardVC.h"
#import "InvitationVC.h"

@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)LeftMenuHeaderView *header_topView;
@property(nonatomic,strong)UIImageView *colorView;
@property(nonatomic,strong)PersonServiceStatusHistoryViewController *serviceHistoryView;
@property(nonatomic,strong)LeftBarButtonItemView *TZView;
@property(nonatomic,assign)BOOL havePeipeiResult;
@property(nonatomic,strong)ApplyStatusModelFrame *statusframeModel;
@property(nonatomic,assign)CurrentClickType currentType;

@end


@implementation PersonCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page个人中心"];
    NavigationBarHidden(YES);
    [self presentViewWillAppear];
    
}


//页面出现时预加载功能
-(void)presentViewWillAppear{
    
    [self didClickCurrent];
    [self caseLogin];
    [self caseWhenUserLogout];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page个人中心"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
    
}

- (PersonServiceStatusHistoryViewController *)serviceHistoryView{

    if (!_serviceHistoryView) {
        
        _serviceHistoryView =  [PersonServiceStatusHistoryViewController new];
        
        [self addChildViewController: _serviceHistoryView];
        
        NSInteger index = self.view.subviews.count;
        
        [self.view insertSubview:_serviceHistoryView.view  atIndex:index];
        
    }
    
    return _serviceHistoryView;
}


- (NSMutableArray *)groups{

    if (!_groups) {
        
        _groups = [NSMutableArray array];
    
        XWGJAbout *wdsq = [XWGJAbout cellWithLogo:@"p_wdsq" title:@"我的申请" sub_title:nil accessory_title:nil accessory_icon:nil] ;
        wdsq.action = NSStringFromSelector(@selector(caseApplyStutasCenter));
        
        XWGJAbout *znpp = [XWGJAbout cellWithLogo:@"p_mbti" title:@"DIY申请" sub_title:nil accessory_title:nil accessory_icon:nil] ;
        znpp.action = NSStringFromSelector(@selector(caseMyApply));
        
        XWGJAbout *mbti = [XWGJAbout cellWithLogo:@"p_rank" title:@"大学排名" sub_title:nil accessory_title:nil accessory_icon:nil] ;
        mbti.action = NSStringFromSelector(@selector(caseRank));

        XWGJAbout *invitation = [XWGJAbout cellWithLogo:@"p_invitation" title:@"邀请有礼"  sub_title:nil accessory_title: @"坐享最高800现金奖励" accessory_icon:nil] ;
        invitation.item_Type = XWGJAboutTypeInvitaion;
        invitation.action = NSStringFromSelector(@selector(caseInvitation));
        
        XWGJAbout *reward = [XWGJAbout cellWithLogo:@"p_reward" title:@"我的奖励"  sub_title:nil accessory_title: nil accessory_icon:nil] ;
        reward.action = NSStringFromSelector(@selector(caseReward));

        XWGJAbout *service = [XWGJAbout cellWithLogo:@"p_qq" title:@"在线客服"  sub_title:nil accessory_title: nil accessory_icon:nil] ;
        service.action = NSStringFromSelector(@selector(caseQQ));
        
        XWGJAbout *call = [XWGJAbout cellWithLogo:@"p_phone" title:@"客服热线"  sub_title:nil accessory_title: @"4000 666 522" accessory_icon:nil] ;
        call.action = NSStringFromSelector(@selector(casePhone));
        
        XWGJAbout *question = [XWGJAbout cellWithLogo:@"p_help" title:@"常见问题"  sub_title:nil accessory_title: nil accessory_icon:nil] ;
        question.action = NSStringFromSelector(@selector(caseHelp));
  
    
        NSMutableArray *z_group = [NSMutableArray arrayWithObjects:wdsq,nil];
        NSMutableArray *a_group = [NSMutableArray arrayWithObjects:znpp, mbti,nil];
        NSMutableArray *b_group = [NSMutableArray arrayWithObjects:invitation,reward,service, call,question,nil];
        
        [_groups addObjectsFromArray:@[z_group,a_group,b_group]];
    }
    
    return _groups;
}

- (void)makeUI{
    
    [self makeTableView];
    
    self.header_topView = [LeftMenuHeaderView headerViewWithTap:^{
        [self caseTapUserHeader];
    }];
    
    self.header_topView.mj_w = XSCREEN_WIDTH;
    CenterHeaderView *header_bottomeView =  [CenterHeaderView centerSectionViewWithResponse:nil actionBlock:^(centerItemType type) {
        
        switch (type) {
            case centerItemTypeMyApply:
                [self caseZNPP];
                break;
            case centerItemTypefavor:
                [self caseFave];
                break;
            case centerItemTypeDiscount:
                [self caseDiscount];
                break;
            default:
                [self caseOrder];
                break;
        }
        
        
    }];
    
    //设置智能匹配、收藏、留学服务子项Frame
    header_bottomeView.headerFrame = [[MeCenterHeaderViewFrame alloc] init];
    header_bottomeView.mj_y = self.header_topView.mj_h;
    
    CGFloat header_h = CGRectGetMaxY(header_bottomeView.frame);
    CGFloat header_w = XSCREEN_WIDTH;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, header_w, header_h)];
     self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView addSubview:self.header_topView];
    [tableHeaderView addSubview:header_bottomeView];
    
    
    
    CGFloat color_Y =  header_h - XSCREEN_HEIGHT;
    CGFloat color_h =  XSCREEN_HEIGHT;
    CGFloat color_w =  XSCREEN_WIDTH;
    UIImageView *colorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, color_Y, color_w, color_h)];
    self.colorView = colorView;
    colorView.contentMode = UIViewContentModeScaleAspectFill;
    colorView.backgroundColor = XCOLOR_LIGHTBLUE;
    [self.view insertSubview:colorView belowSubview:self.tableView];
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
    UIImage *navImage =[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    colorView.image = navImage;
 
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    [setBtn setImage:[UIImage imageNamed:@"p_set"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(caseSetting) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:setBtn];
 
    WeakSelf
    self.TZView  = [LeftBarButtonItemView leftViewWithBlock:^{
         [weakSelf caseTZ];
     }];
    self.TZView.mj_x = XSCREEN_WIDTH - 50;
    self.TZView.icon = @"p_msg";
    [tableHeaderView addSubview:self.TZView];
}


- (void)makeTableView
{
    CGRect table_frame = self.view.bounds;
    CGFloat top_margin = 22;
    table_frame.origin.y = top_margin;
    table_frame.size.height -= top_margin;
    self.tableView =[[UITableView alloc] initWithFrame:table_frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
 
}



#pragma mark : 网络请求
- (void)requestWithPath:(NSString *)path{
    
    WeakSelf
    [self startAPIRequestWithSelector:path parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
        
        //关于智能匹配
        if ([path isEqualToString:kAPISelectorZiZengPipeiGet]) {
            
            [weakSelf PiPeiWithResponse:response];
        
        }
        
        
        if ([path isEqualToString:kAPISelectorCheckNews]) {
            
            [weakSelf resultWithCheckNewsWithResponse:response];
            
        }
        
        
    }];
    
}
//判断是否有智能匹配数据
- (void)PiPeiWithResponse:(id)response{
    
    self.havePeipeiResult = response[@"university"] ? YES : NO;
    
}

//显示是否有新消息显示在导航栏未读通知
- (void)resultWithCheckNewsWithResponse:(id)response{

    self.TZView.countStr = [NSString stringWithFormat:@"%@",response[@"message_count"]];
 
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.groups[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray  *rows = self.groups[indexPath.section];
    XWGJAbout *item = rows[indexPath.row];
    
    if (item.item_Type == XWGJAboutTypeServiceStatus) {
        
        ApplyStatusNewCell *status_cell =[ApplyStatusNewCell cellWithTableView:tableView];
        status_cell.statusFrame = self.statusframeModel;
        
        return status_cell;
 
    }
    PersonCell *cell = [PersonCell cellWithTableView:tableView];
    [cell bottomLineShow:(indexPath.row != (rows.count - 1))];
    if (item.item_Type == XWGJAboutTypeInvitaion) {
        [cell redSpodShow:YES];
    }
    cell.item = item;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray  *rows = self.groups[indexPath.section];
    XWGJAbout *item = rows[indexPath.row];
    
    return  item.cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Section_footer_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray  *rows = self.groups[indexPath.section];
    XWGJAbout *item = rows[indexPath.row];
    
    
    if (item.item_Type == XWGJAboutTypeServiceStatus) {
        [self.serviceHistoryView serviceHishtoryShow:YES];
    }else{
        if (item.action.length > 0) {
            [self performSelector:NSSelectorFromString(item.action) withObject:nil afterDelay:0.0];
        }
    }
 
}

#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset_y = scrollView.contentOffset.y;
    if (offset_y < -XSCREEN_WIDTH  && scrollView.isDragging) {
        scrollView.contentOffset = CGPointMake(0, -XSCREEN_WIDTH);
    }
    
    CGFloat origin_y =  self.tableView.tableHeaderView.mj_h - XSCREEN_HEIGHT;
    if (offset_y > self.header_topView.mj_h) {
         self.colorView.mj_y =  22 - XSCREEN_HEIGHT;
    }else{
        self.colorView.mj_y = origin_y -(scrollView.contentOffset.y);
    }
    
}



//照片选择器 图片上传
#pragma mark : UIImagePickerControlleDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    image = [image KD_imageByCroppedToSquare:600];
    
    self.header_topView.iconImage = image;
    
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSString *path = [NSString stringWithFormat:@"%@m/api/account/portrait",DOMAINURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
    
    [[APIClient defaultClient] startTaskWithRequest:request expectedStatusCodes:nil success:^(NSInteger statusCode, id response) {
    } failure:^(NSInteger statusCode, NSError *error) {
        [self showAPIErrorAlertView:error clickAction:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}




#pragma mark : 事件处理

- (void)caseRank{
    
    [self.tabBarController setSelectedIndex:1];
    UINavigationController *nav  = self.tabBarController.childViewControllers[1];
    CatigoryViewController *catigroy =  (CatigoryViewController *)nav.childViewControllers[0];
    [catigroy jumpToRank];

}

//服务状态-个人申请
- (void)caseApplyStutasCenter{
    
    self.currentType = CurrentClickTypeServiceStatus;
    RequireLogin
    [self pushWithVC:NSStringFromClass([ApplyStutasCenterViewController class])];

}

- (void)caseQQ{
    
    [MeiqiaServiceCall callWithController:self];
}


- (void)casePhone{
   
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4000666522"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
  
}

- (void)caseZNPP{
    
    
    if (!LOGIN){
        self.havePeipeiResult = NO;
        [self pushWithVC:NSStringFromClass([PipeiEditViewController class])];
        return;
    }
    
    if (self.havePeipeiResult) {
        RequireLogin
        [self pushWithVC:NSStringFromClass([IntelligentResultViewController class])];
    }else{
        [self pushWithVC:NSStringFromClass([PipeiEditViewController class])];
    }
    

}
//跳转收藏
- (void)caseFave{
    
    self.currentType = CurrentClickTypeFavor;
    RequireLogin
    [self pushWithVC:NSStringFromClass([FavoriteViewController class])];

}
//我的申请
- (void)caseMyApply{
    
    self.currentType = CurrentClickTypeMyApply;
    RequireLogin
    [self pushWithVC:NSStringFromClass([myApplyViewController class])];
}
//设置
- (void)caseSetting{
    
    [self pushWithVC:NSStringFromClass([SetViewController class])];
}

//帮助
- (void)caseHelp{
    
    [self pushWithVC:NSStringFromClass([myOfferPageViewController class])];
}
//通知
- (void)caseTZ{

    self.currentType = CurrentClickTypeMsg;
    RequireLogin
    [self pushWithVC:NSStringFromClass([NotificationViewController class])];
}
//订单中心
- (void)caseOrder{
    
    self.currentType = CurrentClickTypeOrder;
    RequireLogin
    [self pushWithVC:NSStringFromClass([OrderViewController class])];

}
//折扣
- (void)caseDiscount{
    
    [self pushWithVC:NSStringFromClass([DiscountVC class])];
}
//邀请有礼
- (void)caseInvitation{
 
    [self pushWithVC:NSStringFromClass([InvitationVC class])];

}

//我的奖励
- (void)caseReward{

    RequireLogin
    [self pushWithVC:NSStringFromClass([RewardVC class])];
}

//跳转
- (void)pushWithVC:(NSString *)vcStr{
    
    self.currentType = CurrentClickTypeDefault;
    if (NSClassFromString(vcStr) == [myOfferPageViewController class]) {
        myOfferPageViewController *vc = [[myOfferPageViewController  alloc] init];
        vc.pageType = myOfferPageTypeHelp;
        PushToViewController(vc);
        return;
    }
    PushToViewController([[NSClassFromString(vcStr)  alloc] init]);
 
}



- (void)caseTapUserHeader{
    
    if(!LOGIN){
        RequireLogin
        return;
    }
    KDUtilDefineWeakSelfRef
     KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:@"更换头像"
                                           cancelButtonTitle:@"取消"
                                                cancelAction:nil
                                      destructiveButtonTitle:nil
                                           destructiveAction:nil];
    // @"拍照"  @"从手机相册选择"
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [as addButtonWithTitle:GDLocalizedString(@"Me-009") action:^{
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = weakSelf;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            imagePicker.showsCameraControls = YES;
            [self presentViewController:imagePicker animated:YES completion:^{}];
            
        }];
    }
    
    [as addButtonWithTitle:GDLocalizedString(@"Me-0010") action:^{
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = weakSelf;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:^{}];
        
    }];
    
    [as showInView:[weakSelf view]];
    
    
}

//加载用户信息
- (void)caseMakeDataUserInfor{

    if(LOGIN) { //请求头像信息
        if (self.header_topView.haveIcon) return;
        [self startAPIRequestWithSelector:kAPISelectorAccountInfo  parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
            self.header_topView.haveIcon = YES;
            self.header_topView.user = [MyofferUser mj_objectWithKeyValues:response];
        }];
        return;
    }
    self.header_topView.haveIcon = NO;
    [self.header_topView headerViewWithUserLoginOut];
    
}

//服务状态
- (void)caseMakeDataServiceStatus{

    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorStatusList  parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) { }];
    
}

- (void)updateUIWithResponse:(id)response{

    NSArray *status_Arr = [ApplyStutasModel mj_objectArrayWithKeyValuesArray:response];
    
    if (status_Arr.count == 0) return;
    
    ApplyStutasModel *statusItem = status_Arr.firstObject;
    ApplyStatusModelFrame *statusframeModel = [ApplyStatusModelFrame frameWithStatusModel:statusItem];
    self.statusframeModel = statusframeModel;
    self.serviceHistoryView.status_frame = self.statusframeModel;
    
    XWGJAbout *serviceStatus = [XWGJAbout cellWithLogo:@"about_love" title:[status_Arr.firstObject title] sub_title:nil accessory_title:nil accessory_icon:nil] ;
    serviceStatus.cell_height = statusframeModel.cell_Height;
    serviceStatus.item_Type =  XWGJAboutTypeServiceStatus;
 
    NSMutableArray *items = self.groups.firstObject;
    
    if (2 == [items count]) {
        
        [items replaceObjectAtIndex:1 withObject:serviceStatus];

    }else{
        
        [items addObject:serviceStatus];

    }
    
    XWGJAbout *item  = items.firstObject;
    item.acc_title = @"查看更多";
    item.accessoryType = YES;

    [self.tableView reloadData];
    
}
//网络请求智能匹配数据
- (void)caseMakeDataForPipei{

    [self requestWithPath:kAPISelectorZiZengPipeiGet];
}
//网络请求新消息数据
- (void)caseMakeDataForNewMessage{

    [self requestWithPath:kAPISelectorCheckNews];
}
//未登录情况
- (void)caseWhenUserLogout{
    
    if (LOGIN) return;
 
    for (NSInteger index = 0 ; index < self.groups.count; index++){
      
        NSMutableArray *group = self.groups[index];
        
        if (index == 0) {
        
            XWGJAbout *item = group.firstObject;
            item.acc_title = @"";
            item.accessoryType = NO;
        }
        
        for (XWGJAbout *item in group){
            
            if (item.item_Type == XWGJAboutTypeServiceStatus) {
                
                self.statusframeModel = nil;
                
                [group removeObject:item];
                
                [self.tableView reloadData];
            }
  
        }
    }
 
    
    self.TZView.countStr = @"0";

    [self caseMakeDataUserInfor];
    
}
//登录情况
- (void)caseLogin{
    
    if (!LOGIN) return;
    
    [self caseMakeDataServiceStatus];
    
    [self caseMakeDataUserInfor];
    
    [self caseMakeDataForPipei];
    
    [self caseMakeDataForNewMessage];
    
}
//当前点击项
- (void)didClickCurrent{

    if (self.currentType == CurrentClickTypeDefault) return;
    
    if (!LOGIN) return;
    
    [self performSelector:@selector(clickedWithCurrentType) withObject:nil afterDelay:ANIMATION_DUATION * 2];
 
}

- (void)clickedWithCurrentType{

    switch (self.currentType) {
        case CurrentClickTypeOrder:
            [self caseOrder];
            break;
        case CurrentClickTypeFavor:
            [self caseFave];
            break;
        case CurrentClickTypeMyApply:
            [self caseMyApply];
            break;
        case CurrentClickTypeMsg:
            [self caseTZ];
            break;
        case CurrentClickTypeMBTI:
            [self caseRank];
            break;
        case CurrentClickTypeServiceStatus:
            [self caseApplyStutasCenter];
            break;
        default:
            break;
    }
    
    self.currentType = CurrentClickTypeDefault;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
