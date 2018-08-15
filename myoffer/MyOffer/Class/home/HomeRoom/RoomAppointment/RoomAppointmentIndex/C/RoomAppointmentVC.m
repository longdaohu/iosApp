//
//  RoomAppointmentVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/9.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomAppointmentVC.h"
#import "RoomAppointmentResultVC.h"
#import "RoomAppointmentCell.h"
#import "WYLXGroup.h"
#import "Masonry.h"
#import "MyofferTextHeaderView.h"

@interface RoomAppointmentVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)UIButton *commitBtn;
@property(nonatomic,strong)RoomAppointmentResultVC  *resultVC;

@end

@implementation RoomAppointmentVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeUI];
    [self addNotificationCenter];
}

-(NSArray *)groups{
    
    if (!_groups) {
        
        WYLXGroup *name   =  [WYLXGroup groupWithType:EditTypeCountry title:@"姓名 * （中文" placeHolder:nil content:nil groupKey:@"name" spod:false];
        name.groupType = EditTypeRoomUserName;
        WYLXGroup *email    =  [WYLXGroup groupWithType:EditTypePhone title:@"电子邮箱 *" placeHolder:nil content:nil groupKey:@"email" spod:false];
        email.groupType = EditTypeRoomUserEmail;
        WYLXGroup *wx    =  [WYLXGroup groupWithType:EditTypeGrade title:@"微信*" placeHolder:nil content:nil groupKey:@"wx" spod:false];
        wx.groupType = EditTypeRoomUserWeixin;
        WYLXGroup *time  =  [WYLXGroup groupWithType:EditTypeSuject title:@"入住时间*" placeHolder:nil content:nil groupKey:@"time" spod:false];
        time.groupType = EditTypeRoomUserTime;
        WYLXGroup *qq  =  [WYLXGroup groupWithType:EditTypeSuject title:@"QQ" placeHolder:nil content:nil groupKey:@"qq" spod:false];
        qq.groupType = EditTypeRoomUserQQ;
        _groups = @[name,email,wx,time,qq];
    }
    return _groups;
}

- (RoomAppointmentResultVC *)resultVC{
    
    if (!_resultVC) {
    
        _resultVC = [[RoomAppointmentResultVC alloc] init];
        [self addChildViewController:_resultVC];
        _resultVC.view.alpha = 0;
        _resultVC.view.frame = self.view.bounds;
        _resultVC.view.transform = CGAffineTransformMakeTranslation(XSCREEN_WIDTH,0);
        [self.view insertSubview:_resultVC.view aboveSubview:self.commitBtn];
        WeakSelf
        _resultVC.actionBlock = ^(BOOL isBackToHome) {
            [weakSelf caseSuccesed:isBackToHome];
        };
    }
    
    return _resultVC;
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
    
    if (self.isPresent) {
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [backBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:XImage(@"back_arrow_black") forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
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
    
    NSLog(@"caseCommitClick = %@",sender.currentTitle);
    
    WYLXGroup *item;
    NSString  *alter;
    for(WYLXGroup *group in self.groups){
        
        if ([group.content isEqualToString:@""]) {
            alter = @"不能为空";
            item = group;
            break;
        }
    }
    
    self.resultVC.view.alpha = 1;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.resultVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.navigationItem.leftBarButtonItem = nil;
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

- (void)caseSuccesed:(BOOL)isBackToHome{
    
    
    if (isBackToHome) {
     
         if (self.actionBlock) {
             
             self.actionBlock();
             [self casePop];
         }
        
        return;
    }
    
    if (self.isPresent) {
        [self casePop];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)casePop{
    
    [self.navigationController dismissViewControllerAnimated:true completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
