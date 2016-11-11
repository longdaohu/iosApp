//
//  UpgradeViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/7/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UpgradeViewController.h"
#import "UpgradeFooterView.h"
#import "PayOrderViewController.h"
#import "OrderItem.h"
#import "SeviceDetailViewController.h"
#import "ApplyStatusViewController.h"
#import "UpdateCell.h"

typedef enum {
    serviceItemTypeNo,
    serviceItemTypeB,
    serviceItemTypeC
}serviceItemType;   //选择服务类型

typedef enum {
    buttonTypeApplyStatus,
    buttonTypePay
}buttonType; //底部按钮类型

@interface UpgradeViewController ()<UITableViewDelegate,UITableViewDataSource>
//1、成功图片
@property(nonatomic,strong)UIImageView *iconView;
//2、成功提示
@property(nonatomic,strong)UILabel *succeseLab;
//3、间隔线
@property(nonatomic,strong)UIView *line;
//4、当前已购买服务
@property(nonatomic,strong)UILabel *currentServiceLab;
//8、完成返回按钮
@property(nonatomic,strong)UIButton *popBtn;
//9、支付按钮
@property(nonatomic,strong)UIButton *payBtn;
//10、用户已选择服务类型
@property(nonatomic,copy)NSString  *payOrderId;
@property(nonatomic,strong)UITableView *tableView;
//最后选择项 IndexPath
@property(nonatomic,strong)NSIndexPath *lastIndexPath;
@end

@implementation UpgradeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"申请信息";
    
    [self makeUI];
    
}

-(void)setServiceResponse:(NSDictionary *)serviceResponse{

     _serviceResponse = serviceResponse;
    
    
    //10、根据用户已购买套餐调整页面元素
    NSString *paid_sku_name =  [serviceResponse[@"paid_sku_name"] length] > 0 ? [NSString stringWithFormat:@"你当前的服务类型为%@\n 可选择升级：",serviceResponse[@"paid_sku_name"]] : @"myOffer将为你提供免费基础留学申请\n 可选择升级：";;
    self.currentServiceLab.text  =  paid_sku_name;
    
    if ([serviceResponse[@"SKUs"] count] == 0) {
 
        [self serviceContainC];
    }
    
    [self.tableView reloadData];
 
}


//服务C套餐
-(void)serviceContainC{
    
    self.tableView.tableFooterView = [UIView new];
    self.payBtn.hidden          = YES;
    self.popBtn.width           = XScreenWidth - self.popBtn.left * 2;
    self.popBtn.backgroundColor = XCOLOR_RED;
    [self.popBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
}


-(void)makeUI{
    
    [self  makeHeader];
    
    [self  makeTableView];
    
    [self  makeBottomView];

}

-(void)makeBottomView{
    
    BOOL Iphone5 = XScreenHeight <= 568.0 ;
    //8、完成返回按钮
    self.popBtn =[self buttonWithTitle:@"查看申请状态" titleColor:XCOLOR_RED tag:buttonTypeApplyStatus];
    self.popBtn.layer.borderColor  = XCOLOR_RED.CGColor;
    self.popBtn.layer.borderWidth  = 1;
    CGFloat popX = 15;
    CGFloat popY =  XScreenHeight - 80 - 64;
    CGFloat popW = (XScreenWidth - 2 * popX - 20) * 0.5 ;
    CGFloat popH = Iphone5 ? 40 : 50;
    self.popBtn.frame = CGRectMake(popX, popY, popW, popH);
    
    //9、支付按钮
    self.payBtn =[self buttonWithTitle:@"去支付" titleColor:XCOLOR_WHITE tag:buttonTypePay];
    self.payBtn.backgroundColor = XCOLOR_LIGHTGRAY;
    CGFloat payX = XScreenWidth - popW - popX;
    self.payBtn.frame = CGRectMake(payX, popY, popW, popH);
    self.payBtn.enabled = NO;
    
    
    if (Iphone5) {
        
        self.line.hidden  =  YES;
        CGFloat popY      =  XScreenHeight - 50 - 64  ;
        self.popBtn.top   =  popY;
        self.payBtn.top   =  popY;
        self.currentServiceLab.top = CGRectGetMaxY(self.succeseLab.frame) + 10 ;
        self.tableView.top =CGRectGetMaxY(self.currentServiceLab.frame) + 10;
        
    }
    
}

-(void)makeHeader{

    //1、成功图片
    CGFloat iconX = 0;
    CGFloat iconY =  10;
    CGFloat iconW = XScreenWidth;
    CGFloat iconH = 60 * SCREEN_SCALE;
    self.iconView =[[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY , iconW,iconH)];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.image =[UIImage imageNamed:@"TJ_success"];
    [self.view addSubview:self.iconView];
    
    //2、成功提示
    self.succeseLab =[UILabel labelWithFontsize:KDUtilSize(18) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
    self.succeseLab.text = @"提交成功";
    [self.view addSubview:self.succeseLab];
    CGFloat scX = 0;
    CGFloat scY = CGRectGetMaxY(self.iconView.frame)  + 10;
    CGFloat scW = XScreenWidth;
    CGFloat scH = 20;
    self.succeseLab.frame = CGRectMake(scX, scY, scW, scH);
    
    //3、间隔线
    CGFloat lineX = 15;
    CGFloat lineY = CGRectGetMaxY(self.succeseLab.frame) + 10;
    CGFloat lineW = XScreenWidth - 2 * lineX;
    CGFloat lineH = 5;
    self.line =[[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
    self.line.backgroundColor = XCOLOR(232, 233, 232);
    [self.view addSubview:self.line];
    
    //4、当前已购买服务
    self.currentServiceLab =[UILabel labelWithFontsize:KDUtilSize(14) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.currentServiceLab];
    //    self.currentServiceLab.text = @"myOffer将免费为你提供免费基础留学申请\n 可选择升级：";
    self.currentServiceLab.numberOfLines = 2;
    CGFloat currentX =  15;
    CGFloat currentY =  CGRectGetMaxY(self.line.frame) + 10;
    CGFloat currentW =  XScreenWidth - 2 * currentX;
    CGFloat currentH =  KDUtilSize(14) * 2 + 10;
    self.currentServiceLab.frame = CGRectMake(currentX, currentY, currentW, currentH);
  
}



//按钮共用方法
-(UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color tag:(buttonType)type{

    UIButton *sender =[[UIButton alloc] init];
    [self.view addSubview:sender];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:color forState:UIControlStateNormal];
    sender.layer.cornerRadius = 4;
    sender.tag                = type;
    [sender addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
  
    return sender;
}



//底部按钮点击
-(void)onclick:(UIButton *)sender{

    switch (sender.tag) {
        case buttonTypeApplyStatus:
            [self ApplyStatus];
            break;
        default:
            [self pay];
            break;
    }
    
}

//返回
-(void)ApplyStatus{
    
    ApplyStatusViewController *ApplyStatus = [[ApplyStatusViewController alloc] init];
    ApplyStatus.isBackRootViewController   = YES;
    [self.navigationController pushViewController:ApplyStatus animated:YES];
    
}


//服务包详情
-(void)more{
    
    SeviceDetailViewController *detail = [[SeviceDetailViewController alloc] init];
    detail.isBackRootViewController    = YES;
    detail.path                        = [NSString stringWithFormat:@"%@service_dtl?=cset",DOMAINURL];
    [self.navigationController pushViewController:detail animated:YES];
    
}

//付款
-(void)pay{
    
    NSString *path =[NSString stringWithFormat:@"GET api/account/order/create?sku_id=%@",self.payOrderId];//
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        PayOrderViewController *pay = [[PayOrderViewController alloc] init];
        pay.order                   = [OrderItem orderWithDictionary:response[@"order"]];
        [self.navigationController pushViewController:pay animated:YES];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.currentServiceLab.frame) + 10, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.scrollEnabled = NO;
    XWeakSelf
    
    UpgradeFooterView *tipsView =[UpgradeFooterView footViewWithContent:@"Tips：选择VIP尊享服务包，将享有一对一服务，帮你创造亮点，指导选课，帮你冲刺世界名校。全程操办你的文书、签证，学校交涉补材料、考试分数递送、协助邮寄纸质材料等24项超值服务"];
    self.tableView.tableFooterView = tipsView;
    tipsView.actionBlock = ^{
        
        [weakSelf more];
    };
    
}



#pragma mark —————— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  80 * SCREEN_SCALE;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.serviceResponse[@"SKUs"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UpdateCell *cell =[UpdateCell cellWithTableView:tableView selectedIndexPaht:indexPath];
    cell.sku = self.serviceResponse[@"SKUs"][indexPath.section];
    
    cell.actionBlock = ^(NSIndexPath *Idp,NSString *orderId){
        
        [self cellDidSelectRowAtIndexPath:Idp orderId:orderId];
        
    };

    
    return cell;
}

- (void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath orderId:(NSString *)orderId
{

    
    self.payOrderId = orderId;
    
    if (self.lastIndexPath != indexPath) {
    
        UpdateCell *cell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
        
        [cell cellClick];
     
    }
 
    self.payBtn.enabled = (self.lastIndexPath != indexPath);
    
    self.payBtn.backgroundColor  =  self.payBtn.enabled ?  XCOLOR_RED:XCOLOR_LIGHTGRAY;
    
    self.lastIndexPath = indexPath;
 
}


-(void)dealloc{

    KDClassLog(@"dealloc  UpgradeViewController");
}

@end
