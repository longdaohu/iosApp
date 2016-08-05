//
//  UpgradeViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/7/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UpgradeViewController.h"
#import "ServiceItemView.h"
#import "UpgradeTipsView.h"
#import "PayOrderViewController.h"
#import "OrderItem.h"
#import "SeviceDetailViewController.h"

typedef enum {
    serviceItemTypeNo,
    serviceItemTypeB,
    serviceItemTypeC
}serviceItemType;   //选择服务类型

typedef enum {
    buttonTypePop,
    buttonTypePay
}buttonType; //底部按钮类型

@interface UpgradeViewController ()
@property(nonatomic,strong)UIImageView *iconView;            //1、成功图片
@property(nonatomic,strong)UILabel *succeseLab;              //2、成功提示
@property(nonatomic,strong)UIView *line;                     //3、间隔线
@property(nonatomic,strong)UILabel *currentServiceLab;       //4、当前已购买服务
@property(nonatomic,strong)ServiceItemView *BServiceView;    //5、B套餐
@property(nonatomic,strong)ServiceItemView *CServiceView;    //6、C套餐
@property(nonatomic,strong)UpgradeTipsView *tipsView;        //7、C套餐服务提示
@property(nonatomic,strong)UIButton *popBtn;                 //8、完成返回按钮
@property(nonatomic,strong)UIButton *payBtn;                 //9、支付按钮
@property(nonatomic,copy)NSString  *payOrderId;              //10、用户已选择服务类型
@end

@implementation UpgradeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"申请信息";
    
    [self makeUI];
    
}


-(void)setServiceResponse:(NSDictionary *)serviceResponse{


    
    _serviceResponse = serviceResponse;
    
    BOOL serviceB = [serviceResponse[@"paid_sku_name"] containsString:@"DIY升级免费服务包"];
    BOOL serviceC =  [serviceResponse[@"paid_sku_name"] containsString:@"VIP尊享增值服务包"];
 
    
    //10、根据用户已购买套餐调整页面元素
    if (serviceB) {

        [self serviceContainB:serviceResponse];
        
    }else if(serviceC){
       
        [self serviceContainC:serviceResponse];
     
    }else{
        
        [self serviceContainA:serviceResponse];
        
    }
 
 
}





-(void)makeUI{


    XJHUtilDefineWeakSelfRef
    BOOL Iphone5 = XScreenHeight <= 568.0 ;
    
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
    self.currentServiceLab.text = @"myOffer将免费为你提供DIY基础免费服务包\n 可选择升级：";
    self.currentServiceLab.numberOfLines = 2;
    CGFloat currentX = 15;
    CGFloat currentY =  CGRectGetMaxY(self.line.frame) + 10;
    CGFloat currentW =   XScreenWidth - 2 * currentX;
    CGFloat currentH =  [self.currentServiceLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:KDUtilSize(14)]].height;
    self.currentServiceLab.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    
    //5、B套餐
    self.BServiceView =[ServiceItemView View];
    [self.view addSubview:self.BServiceView];
    
    //6、C套餐
    self.CServiceView =[ServiceItemView View];
    [self.view addSubview:self.CServiceView];
    
    CGFloat BsvX = 0;
    CGFloat BsvY = CGRectGetMaxY(self.currentServiceLab.frame) + 10;
    CGFloat BsvW = XScreenWidth - 2 * BsvX;
    CGFloat BsvH =  80 * SCREEN_SCALE;
    self.BServiceView.frame = CGRectMake(BsvX, BsvY, BsvW, BsvH);
    self.BServiceView.actionBlock = ^(UIButton *sender,NSString *orderId){
        weakSelf.payOrderId = orderId;
        [weakSelf.CServiceView click];
        weakSelf.payBtn.enabled = sender.selected;
        weakSelf.payBtn.backgroundColor = weakSelf.payBtn.enabled ? XCOLOR_RED : XCOLOR_LIGHTGRAY;
    };
    

    CGFloat CsvX = BsvX;
    CGFloat CsvY = CGRectGetMaxY(self.BServiceView.frame) + 10;
    CGFloat CsvW = BsvW;
    CGFloat CsvH = BsvH;
    self.CServiceView.frame = CGRectMake(CsvX, CsvY, CsvW, CsvH);
    self.CServiceView.actionBlock = ^(UIButton *sender,NSString *orderId){
      
        weakSelf.payOrderId = orderId;
        [weakSelf.BServiceView click];
        weakSelf.payBtn.enabled = sender.selected;
        weakSelf.payBtn.backgroundColor = weakSelf.payBtn.enabled ? XCOLOR_RED : XCOLOR_LIGHTGRAY;
        
    };
    
    
    //7、C套餐服务提示
    CGFloat tipVX = lineX;
    CGFloat tipVY = CGRectGetMaxY(self.CServiceView.frame) + 10;
    CGFloat tipVW = XScreenWidth - 2 * tipVX;
    CGFloat tipVH = 0;
    self.tipsView =[[UpgradeTipsView alloc] initWithFrame:CGRectMake(tipVX, tipVY, tipVW, tipVH)];
    [self.view addSubview:self.tipsView];
    NSString *tipStr =@"Tips：选择VIP尊享服务包，将享有一对一服务，帮你创造亮点，指导选课，帮你冲刺世界名校。全程操办你的文书、签证，学校交涉补材料、考试分数递送、协助邮寄纸质材料等24项超值服务";
    self.tipsView.tipStr = tipStr;
    self.tipsView.height = self.tipsView.contentHeigt;
    self.tipsView.actionBlock = ^{
        [weakSelf more];
    };
    
    
    //8、完成返回按钮
    self.popBtn =[self buttonWithTitle:@"完成" titleColor:XCOLOR_RED tag:buttonTypePop];
    self.popBtn.layer.borderColor  = XCOLOR_RED.CGColor;
    self.popBtn.layer.borderWidth  = 1;
    CGFloat popX = lineX;
    CGFloat popY =  XScreenHeight - 80 - 64;
    CGFloat popW = (XScreenWidth - 2 * lineX - 20) * 0.5 ;
    CGFloat popH = Iphone5 ? 40 : 50;
    self.popBtn.frame = CGRectMake(popX, popY, popW, popH);
    
    //9、支付按钮
    self.payBtn =[self buttonWithTitle:@"去支付" titleColor:XCOLOR_WHITE tag:buttonTypePay];
    self.payBtn.backgroundColor = XCOLOR_LIGHTGRAY;
    CGFloat payX = XScreenWidth - popW - popX;
    self.payBtn.frame = CGRectMake(payX, popY, popW, popH);
    self.payBtn.enabled = NO;
    
 
}



//服务A套餐
-(void)serviceContainA:(NSDictionary *)response{

    BOOL Iphone5 = XScreenHeight <= 568.0 ;

    self.BServiceView.serviceDict = response[@"SKUs"][0];
    self.CServiceView.serviceDict = response[@"SKUs"][1];

    if (Iphone5) {
        
        self.line.hidden  =  YES;
        CGFloat popY      =  XScreenHeight - 50 - 64  ;
        self.popBtn.top   = popY;
        self.payBtn.top   = popY;
        self.currentServiceLab.top = CGRectGetMaxY(self.succeseLab.frame) + 10 ;
        self.BServiceView.top      = CGRectGetMaxY(self.currentServiceLab.frame) + 10;
        self.CServiceView.top      = CGRectGetMaxY(self.BServiceView.frame) + 10;
        self.tipsView.top          = CGRectGetMaxY(self.CServiceView.frame) + 10;
        
    }
}

//服务B套餐
-(void)serviceContainB:(NSDictionary *)response{
    
    self.currentServiceLab.text  =[NSString stringWithFormat:@"你当前的服务类型为%@\n 可选择升级：",response[@"paid_sku_name"]];
    self.BServiceView.hidden     = YES;
    self.CServiceView.top        = CGRectGetMaxY(self.currentServiceLab.frame) + 10;
    self.tipsView.top            = CGRectGetMaxY(self.CServiceView.frame) + 10;
    self.CServiceView.serviceDict = response[@"SKUs"][0];
}


//服务C套餐
-(void)serviceContainC:(NSDictionary *)response{

    self.currentServiceLab.text =[NSString stringWithFormat:@"你当前的服务类型为%@\n 留学再无后顾之忧",response[@"paid_sku_name"]];

    self.payBtn.hidden          = YES;
    self.tipsView.hidden        = YES;
    self.BServiceView.hidden    = YES;
    self.CServiceView.hidden    = YES;
    self.popBtn.width           = XScreenWidth - self.popBtn.left * 2;
    self.popBtn.backgroundColor = XCOLOR_RED;
    [self.popBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];

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
        case buttonTypePop:
            [self back];
            break;
        default:
            [self pay];
            break;
    }
    
}

//返回
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//服务包详情
-(void)more{
    
    SeviceDetailViewController *detail = [[SeviceDetailViewController alloc] init];
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





@end
