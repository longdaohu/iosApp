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
#import "OrderDetailCell.h"
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

    NSString *path = [NSString stringWithFormat:@"GET api/account/order/%@",self.order.orderId];
    
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
        
//        [temp[@"oversea"] integerValue] == 0 ? [self.leftItems addObject:item] :  [self.rightItems addObject:item];
        
    }];
    
    /*
    
    if (self.leftItems.count > self.rightItems.count){
        
        for (NSInteger index = self.rightItems.count; index < self.leftItems.count; index ++ ) {
            
            OrderServiceItem  *item = [[OrderServiceItem alloc] init];
            item.name = @"";
            [self.rightItems addObject:item];
        }
        
    }else{
        
        for (NSInteger index = self.leftItems.count; index < self.rightItems.count; index ++ ) {
            OrderServiceItem  *item = [[OrderServiceItem alloc] init];
            item.name = @"";
            [self.leftItems addObject:item];
        }
    }
    
    */
  
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
        
        title = @"已付款";
        
    }else  if ([status isEqualToString:@"ORDER_PAY_PENDING"]) {
        
        title = @"待付款";
        
    }else  if ([status isEqualToString:@"ORDER_CLOSED"]) {
        
        title = @"未付款";
        
    }else{
        
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
    header.frame = CGRectMake(0, 0, XScreenWidth, header.headHeight);
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
    footer.frame = CGRectMake(0, 0, XScreenWidth, footer.headHeight + 20);
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
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight - XNav_Height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;

    self.tableView.sectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderServiceItem  *left = self.leftItems[indexPath.row];
    OrderServiceItem  *right = self.rightItems[indexPath.row];
    return   left.cellHeight > right.cellHeight ? left.cellHeight : right.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return self.isTableViewSelected ? 15 : HEIGHT_ZERO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.isTableViewSelected ? 0 : self.leftItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailCell *cell =[OrderDetailCell cellWithTableView:tableView indexPath:indexPath];
    cell.leftItem = self.leftItems[indexPath.row];
    cell.rightItem = self.rightItems[indexPath.row];
    
    return cell;
}


//取消订单
-(void)cancelOrder{
    
    XWeakSelf
    NSString *path = [NSString stringWithFormat:@"GET api/account/order/close?order_id=%@",self.order.orderId];
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        if ([response[@"result"] isEqualToString:@"OK"]) {
            
            if (weakSelf.actionBlock) {
        
                weakSelf.actionBlock(YES);
        
                [weakSelf.navigationController popViewControllerAnimated:YES];
             }
        }
    }];
    
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

    KDClassLog(@"Order详情  dealloc");

}


@end
