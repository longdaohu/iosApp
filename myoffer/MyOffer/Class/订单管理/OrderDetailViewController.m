//
//  OrderDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailHeaderView.h"
#import "OrderDetailFooterView.h"
#import "OrderServiceItem.h"
#import "OrderItem.h"
#import "PayOrderViewController.h"
#import "ServiceMallViewController.h"
#import "OrderViewController.h"


@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isTableViewSelected;
@property(nonatomic,strong)NSMutableArray *leftItems;
@property(nonatomic,strong)NSMutableArray *rightItems;
@property(nonatomic,strong)NSDictionary *orderDetailDict;
@property(nonatomic,strong)UILabel *rightLab;
@property(nonatomic,strong)UIBarButtonItem *backBtn;

@end

@implementation OrderDetailViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page订单详情"];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page订单详情"];
    
}

-(NSMutableArray *)rightItems{
    
    if (!_rightItems) {
        
        _rightItems =[NSMutableArray array];
        
    }
    return  _rightItems;
    
}

-(NSMutableArray *)leftItems{
    
    if (!_leftItems) {
        
        _leftItems =[NSMutableArray array];
        
    }
    return  _leftItems;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    [self makeDataSourse];
    
    [self makeUI];
}


-(void)makeDataSourse{
    
    XWeakSelf

    NSString *path = [NSString stringWithFormat:kAPISelectorOrderDetail,self.order.order_id];
    
        [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
    
            [weakSelf makeOrderWithResponse:response];
            [weakSelf makeTableViewFooterView:response];
            [weakSelf statusWithTag:response[@"status"]];
            [weakSelf.tableView reloadData];
  
        }];
    
}


-(void)makeOrderWithResponse:(NSDictionary *)response
{
    NSArray *SKUs = response[@"SKUs"];
    
    NSDictionary *SKU = SKUs[0];

    XWeakSelf
    
    [SKU[@"services"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *temp = (NSDictionary *)obj;
        OrderServiceItem  *item = [[OrderServiceItem alloc] init];
        item.name = temp[@"name"];
        [weakSelf.leftItems addObject:item];
        
    }];
    
  
    if (!self.leftItems.count) {
        
         OrderDetailHeaderView *header = ( OrderDetailHeaderView *)self.tableView.tableHeaderView;
        [header headerSelectButtonHiden];
    }
    
    [self.leftItems removeAllObjects];
    [self.rightItems removeAllObjects];
   

}


-(void)statusWithTag:(NSString *)status
{
    
     NSString *title;
    
    if ([status isEqualToString:@"ORDER_FINISHED"]) {
        
          title  = @"已付款";
        
    }else   if ([status isEqualToString:@"ORDER_PAY_PENDING"]) {
        
         title = @"待付款";
        
    }else  if ( [status isEqualToString:@"ORDER_CLOSED"]) {
        
        title = @"订单关闭";
        
    }else  if ( [status isEqualToString:@"ORDER_REFUNDED"]) {
        
        title = @"已退款";
        
    }

    self.rightLab.text = title;
}


-(void)makeUI{

    self.title  = @"订单详情";
   
    [self makeTableView];
    [self makeTableViewHeaderView];
    
    self.rightLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    self.rightLab.textColor =XCOLOR_WHITE;
    self.rightLab.font =[UIFont systemFontOfSize:16];
    self.rightLab.textAlignment = NSTextAlignmentRight;
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem  alloc] initWithCustomView:self.rightLab];
    
    self.backBtn =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(caseBack)];
     self.navigationItem.leftBarButtonItem = self.backBtn;
    
}


-(void)makeTableViewHeaderView{

    XWeakSelf
    OrderDetailHeaderView *header = [[OrderDetailHeaderView alloc] init];
    header.order = self.order;
    header.frame = CGRectMake(0, 0, XSCREEN_WIDTH, header.headHeight);
    header.actionBlock = ^(UIButton *sender){
          weakSelf.isTableViewSelected = sender.selected;
         [weakSelf.tableView reloadData];
     };
    self.tableView.tableHeaderView = header;
}



-(void)makeTableViewFooterView:(NSDictionary *)respose{
    
    
    XWeakSelf
    OrderDetailFooterView *footer = [[OrderDetailFooterView alloc] init];
    footer.orderDict = respose;
    footer.frame = CGRectMake(0, 0, XSCREEN_WIDTH, footer.headHeight + 20);
    footer.actionBlock = ^(UIButton *sender){
        
        if (10 == sender.tag) {
            
            PayOrderViewController *pay =[[PayOrderViewController alloc] init];
            pay.order = weakSelf.order;
            [weakSelf.navigationController pushViewController:pay animated:YES];
            
        }else{
            [weakSelf cancelOrder];
        }
        
    };
    self.tableView.tableFooterView = footer;
    
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
}


#pragma mark : UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return self.isTableViewSelected ? 15 : HEIGHT_ZERO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}


//取消订单
-(void)cancelOrder{

    XWeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否要取消订单"  message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *path = [NSString stringWithFormat:kAPISelectorOrderClose,self.order.order_id];
        //先删除 已选择专业数组列表  > 再删除分区头
        [weakSelf startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
            if ([response[@"result"] isEqualToString:@"OK"]) {
                
                if (weakSelf.actionBlock) {
                    weakSelf.actionBlock(YES);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
            }
        }];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

//返回
-(void)caseBack{
   
    if (self.navigationController.childViewControllers.count > 3) {
        
        UIViewController *child = self.navigationController.childViewControllers[1];
       
        if ([child isKindOfClass:[ServiceMallViewController class]]) {
            
            ServiceMallViewController *mall =(ServiceMallViewController *)child;
            mall.refresh = YES;
            [self.navigationController popToViewController:mall animated:YES];

        } else if([child isKindOfClass:[OrderViewController class]]){
        
            OrderViewController *orderList =(OrderViewController *)child;
            orderList.refresh = YES;
            [self.navigationController popToViewController:orderList animated:YES];
 
        }else{
        
            [self.navigationController popToRootViewControllerAnimated:YES];
            
         }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
 
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)dealloc{

    KDClassLog(@"订单详情 + OrderDetailViewController + dealloc");

}


@end
