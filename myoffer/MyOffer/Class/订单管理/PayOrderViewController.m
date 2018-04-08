//
//  PayOrderViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PayOrderViewController.h"
#import "PayHeaderView.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderItem.h"
#import "OrderDetailViewController.h"

@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)NSString *payStyle;
@property(nonatomic,assign)BOOL payEnd;
@property(nonatomic,strong)UIAlertView *alert;
@end

@implementation PayOrderViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[AppDelegate sharedDelegate] umeng];

    [MobClick endLogPageView:@"page订单支付"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page订单支付"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(payResult:) name:@"alipay" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(payResult:) name:@"wxpay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pay:)
                                                 name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];

}

-(void)payResult:(NSNotification *)notification{

    NSString *BackResult = (NSString *)notification.object;
    BOOL result = ([BackResult isEqualToString:@"0"] ||  [BackResult isEqualToString:@"9000"]);
    self.payEnd = result;
    NSString *title = result ? @"支付成功" : @"支付失败";
    
    [self showAler:title];
  
}


-(void)showAler:(NSString *)title
{
     UIAlertView *alert =[[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
     self.alert = alert;
     [alert show];
    
 }
 
#pragma mark : UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView.title isEqualToString:@"支付成功"]) {
        
         OrderDetailViewController  *detail = [[OrderDetailViewController alloc] init];
         detail.order  =  self.order;
        [self.navigationController pushViewController:detail  animated:YES];
        
    }
    
}

-(NSArray *)items
{
    if (!_items) {
        
        NSDictionary *ali =@{@"name":@"支付宝",@"icon":@"alipay"};
        NSDictionary *weixin =@{@"name":@"微信支付",@"icon":@"weixin"};
        
        _items = @[ ali,weixin];
    }
    return _items;
}


-(void)makeUI{
    
    self.title = @"支付方式";
    [self makeTableView];
    
}


-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self makeTableViewHeader];
    
}

- (void)makeTableViewHeader{
    
   
    PayHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"PayHeaderView" owner:self options:nil].firstObject;
    headerView.order = self.order;
     self.tableView.tableHeaderView =  headerView;
    
}

#pragma mark : UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

static NSString *identify = @"pay";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *item = self.items[indexPath.row];
    cell.imageView.image =  [UIImage imageNamed:item[@"icon"]];
    cell.textLabel.text = item[@"name"];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 30)];
    sectionView.backgroundColor = XCOLOR_WHITE;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"选择支付方式";
    titleLab.font = [UIFont systemFontOfSize:15];
    [titleLab sizeToFit];
    titleLab.mj_x = ITEM_MARGIN;
    titleLab.mj_y = 5;
    [sectionView addSubview:titleLab];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequireLogin
    
    
    NSDictionary *item = self.items[indexPath.row];
    
    if ([item[@"name"] isEqualToString:@"支付宝"]) {
        
           [self sendAliPay];
        
    }else{
            [self payWeixin];
     }


}

//微信支付
-(void)payWeixin
{
    
    if (![WXApi isWXAppInstalled]){
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息"   message:@"您还没有安装微信客户端!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"跳转微信"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
            NSString * URLString = @"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        return;
    }
    
   
    
//    [[AppDelegate sharedDelegate] updateUmeng];
    
 
    NSString *path =[NSString stringWithFormat:kAPISelectorOrderWeixin,self.order.order_id];
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        self.payStyle = @"微信";
         NSDictionary *dict = response[@"paramsObj"];
        
        if(dict != nil){
            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //   调起微信支付
            PayReq  *req           = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           =  stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
           
            //                日志输出
//            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
        }else{
            
//            NSLog(@"服务器返回错误 %@",dict);
        }
        
    }];
    
}


//支付宝支付
-(void)sendAliPay
{
    
        NSString *path =[NSString stringWithFormat:kAPISelectorOrderAlipay,self.order.order_id];
            
        [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
                    
                    self.payStyle = @"支付宝";
                    NSString *appScheme = @"My0ffer767577465";
                    NSString *params = [response valueForKey:@"params"];
                  
                    [[AlipaySDK defaultService] payOrder:params fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        
                        
                        [self pay:nil];
                        
                    }];
                    
                }];
    
}


-(void)pay:(NSNotification *)noti
{
    
    if (self.payEnd) {
        
        return;
    }
    
    NSString *path;
    if ([self.payStyle isEqualToString:@"支付宝"]) {
        path =[NSString stringWithFormat:kAPISelectorOrderAlipay,self.order.order_id];
    }else if([self.payStyle isEqualToString:@"微信"]){
       path =[NSString stringWithFormat:kAPISelectorOrderWeixin,self.order.order_id];
    }
    
    [self startAPIRequestWithSelector:path parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
        
        NSString *endStr =[NSString stringWithFormat:@"%@",response[@"end"]];
        
        if (endStr.boolValue && !self.alert.visible) {
            
            [self showAler:@"支付成功"];
        }
    }];
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     KDClassLog(@"PayOrderViewController  dealloc");
    
}


@end
