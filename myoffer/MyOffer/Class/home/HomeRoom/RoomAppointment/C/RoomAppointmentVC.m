//
//  RoomAppointmentVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/9.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomAppointmentVC.h"
#import "RoomAppointmentCell.h"
#import "WYLXGroup.h"
#import "Masonry.h"
#import "MyofferTextHeaderView.h"
#import "RoomAppointSuccesView.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "MeiqiaServiceCall.h"

@interface RoomAppointmentVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)UIButton *commitBtn;
@property(nonatomic,strong)RoomAppointSuccesView  *succesView;

@end

@implementation RoomAppointmentVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeUI];
    [self addNotificationCenter];
}

-(NSArray *)groups{
    
    if (!_groups) {
        
        WYLXGroup *name   =  [WYLXGroup groupWithType:EditTypeRoomUserName title:@"姓名* (中文)" placeHolder:nil content:nil groupKey:@"name" spod:false];
        name.groupType = EditTypeRoomUserName;
        WYLXGroup *email    =  [WYLXGroup groupWithType:EditTypeRoomUserEmail title:@"电子邮箱 *" placeHolder:nil content:nil groupKey:@"email" spod:false];
        email.groupType = EditTypeRoomUserEmail;
        WYLXGroup *wx    =  [WYLXGroup groupWithType:EditTypeRoomUserWeixin title:@"微信 *" placeHolder:nil content:nil groupKey:@"wx" spod:false];
        wx.groupType = EditTypeRoomUserWeixin;
        WYLXGroup *time  =  [WYLXGroup groupWithType:EditTypeRoomUserTime title:@"入住时间 *" placeHolder:nil content:nil groupKey:@"time" spod:false];
        time.groupType = EditTypeRoomUserTime;
//        WYLXGroup *qq  =  [WYLXGroup groupWithType:EditTypeRoomUserQQ title:@"手机号码 *" placeHolder:nil content:nil groupKey:@"qq" spod:false];
//        qq.groupType = EditTypeRoomUserQQ;
        _groups = @[name,email,wx,time];
    }
    return _groups;
}


- (RoomAppointSuccesView *)succesView{
    
    if (!_succesView) {
    
        _succesView = Bundle(@"RoomAppointSuccesView");
        _succesView.frame = self.view.bounds;
        [self.view insertSubview:_succesView aboveSubview:self.commitBtn];
        _succesView.transform = CGAffineTransformMakeTranslation(XSCREEN_WIDTH,0);
        WeakSelf
        _succesView.actionBlock = ^(UIButton *maiqia, UIButton *home, UIButton *keep) {
            
            if (maiqia) [weakSelf caseMeiqia];
            if (home) [weakSelf caseHome];
            if (keep) [weakSelf casePop];
        };
    }
    
    return _succesView;
}

- (void)makeUI{
    
    [self makeTableView];
    
    self.title = @"预约表单";
    
    CGFloat com_x  = 20;
    CGFloat com_w  = XSCREEN_WIDTH - com_x * 2;
    CGFloat com_h  = 45;
    UIButton *commitBtn = [[UIButton alloc] init];
     self.commitBtn = commitBtn;
    [commitBtn setTitle:@"提交预约" forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"button_red_highlight"] forState:UIControlStateHighlighted];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"button_red_nomal"]  forState:UIControlStateNormal];
    [self.view addSubview:commitBtn];
    
    [commitBtn addTarget:self action:@selector(caseCommitClick:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.shadowColor = XCOLOR_RED.CGColor;
    commitBtn.layer.shadowOffset = CGSizeMake(0, 5 );
    commitBtn.layer.shadowRadius = 10;
    commitBtn.layer.shadowOpacity = 0.3;
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(com_w, com_h));
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-30);
        make.left.mas_equalTo(com_x);
        
    }];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    backBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:XImage(@"back_arrow_black") forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}


- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
 
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);

    MyofferTextHeaderView *header = [[MyofferTextHeaderView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
    header.title = @"由于当前房源比较紧张，请您先填写入住信息，我们将为您提前预约当前房源。";
    header.backgroundColor = XCOLOR(244, 247, 250, 1);
    self.tableView.tableHeaderView = header;
 
}
//键盘处理通知
-(void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    RoomAppointmentCell *cell =[RoomAppointmentCell cellWithTableview:tableView];

    cell.items = self.groups;
    cell.item = self.groups[indexPath.row];

    return cell;
}

#pragma mark : 事件处理
- (void)caseCommitClick:(UIButton *)sender{
   
 
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString  *title ;
    for(WYLXGroup *group in self.groups){

        switch (group.groupType) {
            case EditTypeRoomUserName:{
                title = @"姓名";
                NSString *regex = @"[\u4e00-\u9fa5]{2,8}";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if (![pred evaluateWithObject:group.content]) {
                    [MBProgressHUD showMessage:@"请输入正确的中文姓名"];
                    return;
                }else{
                    
                    [parameter setValue:group.content forKey:@"name"];
                }
                
            }
                break;
            case EditTypeRoomUserEmail:{
                title = @"邮箱";
                NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if (![pred evaluateWithObject:group.content]) {
                    [MBProgressHUD showMessage:@"请输入正确的邮箱地址"];
                    return;
                }else{
                    
                    [parameter setValue:group.content forKey:@"email"];
                }
                
            }
                break;
            case EditTypeRoomUserWeixin:{
                title = @"微信";
                NSString *regex = @"^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}+$";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if (![pred evaluateWithObject:group.content]) {
                    [MBProgressHUD showMessage:@"请输入正确的微信号"];
                    return;
                }else{
                    
                    [parameter setValue:group.content forKey:@"wechat"];
                }
                
            }
                break;
            case EditTypeRoomUserTime:{
                title = @"入住时间";
                NSString *regex = @"^[2]{1}[-0-9]{9}$";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if(group.content.length == 0 || !group.content){
                        [MBProgressHUD showMessage:@"入住时间不能为空"];
                        return;
                } else if (![pred evaluateWithObject:group.content]) {
                    [MBProgressHUD showMessage:@"请选择正确的时间"];
                    return;
                }
                else{
                    
                    [parameter setValue:group.content forKey:@"date"];
                }
                
            }
                break;
            default:
                break;
        }
    }
    
    [parameter setValue:self.room_id forKey:@"property_id"];
 
 
//    NSDictionary *parameter = @{
//                                    @"name":@"xxx",
//                                    @"mobile":@"18688958114",
//                                    @"email":@"767577465@qq.com",
//                                    @"wechat":@"wei-laoxu",
//                                    @"date":@"2018-12-09",
//                                    @"property_id":self.room_id
//                                };
    WeakSelf;
    [[HttpsApiClient_API_51ROOM instance] enquiryWithParameter:parameter completion:^(CACommonResponse *response) {
//        id result = [response.body KD_JSONObject];
        if (!response.error) {
            [weakSelf caseSuccess];
        }
    }];
}

- (void)caseSuccess{
    
    self.succesView.alpha = 1;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.succesView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:XImage(@"maiqia_call") style:UIBarButtonItemStyleDone target:self action:@selector(caseMeiqia)];
    }];
}

#pragma mark : 键盘处理

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up {
    
    NSDictionary* userInfo = [aNotification userInfo];
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGFloat upHeight = up ? keyboardEndFrame.size.height : 200;
    UIEdgeInsets inset = self.tableView.contentInset;
    if (up) {
        inset.bottom = upHeight + (self.view.mj_h - self.commitBtn.mj_y) + 20;
    }else{
        inset.bottom = upHeight;
    }
    self.tableView.contentInset =  inset;
    
    [self.view layoutSubviews];
    [UIView commitAnimations];
}


- (void)caseMeiqia{
    
    [MeiqiaServiceCall callWithController:self];
}


- (void)casePop{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)caseHome{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    if (self.actionBlock) {
        self.actionBlock();
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    KDClassLog(@"预约表单 + RoomAppointmentVC + dealloc");
}


@end
