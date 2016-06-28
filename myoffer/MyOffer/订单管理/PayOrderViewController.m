//
//  PayOrderViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PayOrderViewController.h"
#import "PaySectionHeaderView.h"
#import "PayHeaderView.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderItem.h"
#import "OrderDetailViewController.h"

@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSDictionary *tempDic;
@end

@implementation PayOrderViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[AppDelegate sharedDelegate] umeng];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self makeUI];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(AliPayResult:) name:@"alipay" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(weixinPayResult:) name:@"wxpay" object:nil];
    
    
}

-(void)weixinPayResult:(NSNotification *)notification
{
    
    NSString *BackResult = (NSString *)notification.object;
     NSString *title = [BackResult isEqualToString:@"0"] ? @"支付成功" : @"支付失败";
    [self showAler:title];
}


-(void)AliPayResult:(NSNotification *)notification
{
    NSString *BackResult = (NSString *)notification.object;
    NSString *title = [BackResult isEqualToString:@"9000"] ? @"支付成功" : @"支付失败";
    [self showAler:title];
}




-(void)showAler:(NSString *)title
{
    UIAlertView *aler =[[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [aler show];
}
#pragma mark —————— UIAlertViewDelegate
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
        
        _items = @[@"支付宝",@"微信支付"];
    }
    return _items;
}

-(void)makeUI{
    
    [self makeTableView];
    
}


-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self makeTableViewHeader];
}

-(void)makeTableViewHeader
{
    PayHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"PayHeaderView" owner:self options:nil].lastObject;
  
    headerView.order = self.order;

     self.tableView.tableHeaderView =  headerView;
}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource
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
    
    cell.imageView.image =[UIImage imageNamed:@"about_weibo"];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    return [[PaySectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, 30)];
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
    indexPath.row == 0 ? [self sendAliPay] :[self payWeixin];
}


-(void)payWeixin
{
    
    [[AppDelegate sharedDelegate] updateUmeng];
    
    NSString *path =[NSString stringWithFormat:@"GET api/account/wechatpayapp?is_ios=1&order_id=%@",self.order.orderId];
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
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
            
            NSLog(@"服务器返回错误");
        }
        
    }];
    
}



-(void)sendAliPay
{
    
     NSString *path =[NSString stringWithFormat:@"GET api/account/alipayapp?order_id=%@",self.order.orderId];
     [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSString *appScheme = @"alipayMy0ffer767577465";
        NSString *params = [response valueForKey:@"params"];
       [[AlipaySDK defaultService] payOrder:params fromScheme:appScheme callback:^(NSDictionary *resultDic) {
 
       }];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    NSLog(@"PayOrderViewController  dealloc");
    
}


@end
