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
#import "OrderDetailTableViewCell.h"
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



- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    [self makeDataSourse];
    
    [self makeUI];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)makeDataSourse{
    
    XJHUtilDefineWeakSelfRef

    NSString *path = [NSString stringWithFormat:@"GET api/account/order/%@",self.order.orderId];
    
        [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
    
            
            NSArray *SKUs = response[@"SKUs"];
            NSDictionary *SKU = SKUs[0];
          
            [SKU[@"services"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSDictionary *temp = (NSDictionary *)obj;
            
                OrderServiceItem  *item = [[OrderServiceItem alloc] init];

                item.name = temp[@"name"];

                [temp[@"oversea"] integerValue] == 0 ? [weakSelf.leftItems addObject:item] :  [weakSelf.rightItems addObject:item];
                
                
            }];
         
            
            if (weakSelf.leftItems.count >  weakSelf.rightItems.count){
                
                for (NSInteger index = self.rightItems.count; index < weakSelf.leftItems.count; index ++ ) {
                    
                    OrderServiceItem  *item = [[OrderServiceItem alloc] init];
                    
                    item.name = @"";
                    
                    [weakSelf.rightItems addObject:item];
                }
                
            }else{
                
                for (NSInteger index = self.leftItems.count; index < weakSelf.rightItems.count; index ++ ) {
                    OrderServiceItem  *item = [[OrderServiceItem alloc] init];
                    item.name = @"";
                    [weakSelf.leftItems addObject:item];
                }
                
            }
   
            
            [weakSelf makeTableViewFooterView:response];

            [weakSelf statusWithTag:response[@"status"]];

            [weakSelf.tableView reloadData];
  
        }];
    
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
    
    self.backBtn =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

     self.navigationItem.leftBarButtonItem = self.backBtn;
    
}


-(void)makeTableViewHeaderView{

    XJHUtilDefineWeakSelfRef
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
    
    
    XJHUtilDefineWeakSelfRef
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
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight -64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BACKGROUDCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderServiceItem  *left = self.leftItems[indexPath.row];
    OrderServiceItem  *right = self.rightItems[indexPath.row];
    
    return   left.cellHeight > right.cellHeight ? left.cellHeight : right.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.isTableViewSelected ? 0 : self.leftItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailTableViewCell *cell =[OrderDetailTableViewCell cellWithTableView:tableView];
    UIColor *cellColor =  indexPath.row % 2 ?BACKGROUDCOLOR  :  XCOLOR_WHITE;
    cell.contentView.backgroundColor = cellColor;
    cell.leftItem = self.leftItems[indexPath.row];
    cell.rightItem = self.rightItems[indexPath.row];
    
    return cell;
}



-(void)cancelOrder{
    
 
    NSString *path = [NSString stringWithFormat:@"GET api/account/order/close?order_id=%@",self.order.orderId];
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        if ([response[@"result"] isEqualToString:@"OK"]) {
            
            if (self.actionBlock) {
        
                self.actionBlock(YES);
        
                [self.navigationController popViewControllerAnimated:YES];
             }
        }
    }];
    
}


-(void)back{
   
    if (self.navigationController.childViewControllers.count > 3) {
        
        UIViewController *child = self.navigationController.childViewControllers[1];
        if ([child isKindOfClass:[ServiceMallViewController class]]) {
            
            ServiceMallViewController *mall =(ServiceMallViewController *)child;
            mall.refresh = YES;

        }
       
        if ([child isKindOfClass:[OrderViewController class]]) {
            
            OrderViewController *orderList =(OrderViewController *)child;
            orderList.refresh = YES;
        }
        
         [self.navigationController popToViewController:child animated:YES];

        NSLog(@"-if------------ %ld",self.navigationController.childViewControllers.count);

        
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
        
        NSLog(@"-else------------ %ld",self.navigationController.childViewControllers.count);

    }
    
}

-(void)dealloc{

    NSLog(@"OrderDetailViewController  dealloc");

}


@end
