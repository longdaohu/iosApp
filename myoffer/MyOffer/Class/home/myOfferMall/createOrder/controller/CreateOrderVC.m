//
//  CreateOrderVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreateOrderVC.h"
#import "CreateOrderOneCell.h"
#import "CreateOrderItemCell.h"
#import "myofferGroupModel.h"
#import "OrderEnjoyVC.h"
#import "OrderActionVC.h"
#import "DiscountItem.h"
#import "serviceProtocolVC.h"
#import "PayOrderViewController.h"
#import "OrderItem.h"

@interface CreateOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property(nonatomic,strong)NSArray *discount_items;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong) UIButton *protocolBtn;
@property(nonatomic,strong) UIButton *optionBtn;
@property(nonatomic,strong)serviceProtocolVC *protocalVC;
@property(nonatomic,strong)NSMutableDictionary *parameter;

@end

@implementation CreateOrderVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page创建订单"];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page创建订单"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    
}

- (NSMutableArray *)groups{
    
    if (!_groups) {
        _groups =  [NSMutableArray array];
    }
    
    return _groups;
}

- (NSMutableDictionary *)parameter{
    
    if (!_parameter) {
        _parameter =  [NSMutableDictionary dictionary];
    }
    
    return _parameter;
}


- (void)makeData{
    
    //获取用户优惠券
    NSString *path  = @"GET svc/marketing/coupons/get";
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
    }];
}

//活动通道
- (void)updateWithResponse:(id)response{
    
    NSArray *result  = response[@"result"];
    self.discount_items = [DiscountItem mj_objectArrayWithKeyValuesArray:result];
 
    if (result.count > 0) {
        
        myofferGroupModel *act = [myofferGroupModel groupWithItems:nil header:@"活动通道"];
        act.type = SectionGroupTypeCreateOrderActive;
        [self.groups insertObject:act atIndex:1];
    }
    [self.tableView reloadData];
}


- (void)makeUI{
    
    self.title  = @"订单确认页";
    
    [self makeTableView];
    
    self.priceLab.text = self.itemFrame.item.price_str;
    
    [self.parameter setValue:self.itemFrame.item.service_id  forKey:@"skuId"];

    self.protocalVC.itemFrame = self.itemFrame;

}

- (void)makeTableView
{
    self.tableView.backgroundColor = XCOLOR_BG;
    CGFloat footer_h = 30;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, footer_h)];
    self.tableView.tableFooterView = footer;
    
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 200;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIButton *optionBtn = [[UIButton alloc] initWithFrame:CGRectMake( 15, 0, footer_h, footer_h)];
    [optionBtn setImage:[UIImage imageNamed:@"protocol_nomal"] forState:UIControlStateNormal];
    [optionBtn setImage:[UIImage imageNamed:@"protocol_select"] forState:UIControlStateSelected];
    [footer addSubview:optionBtn];
    optionBtn.selected = YES;
    [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.optionBtn = optionBtn;
    
    UIButton *protocolBtn = [[UIButton alloc] init];
    self.protocolBtn = protocolBtn;
    [protocolBtn setTitle:@"购买条款与协议，买家须知" forState:UIControlStateNormal];
    [protocolBtn.titleLabel setFont:XFONT(14)];
    [protocolBtn sizeToFit];
    [footer addSubview:protocolBtn];
    [protocolBtn addTarget:self action:@selector(protocolClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat sub_y = 0;
    CGFloat sub_h = footer_h;
    CGFloat sub_x = CGRectGetMaxX(optionBtn.frame) + 5;
    CGFloat sub_w = protocolBtn.mj_w;
    protocolBtn.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
    [self protocolAttribute:NO];// 下划线
    
}

- (serviceProtocolVC *)protocalVC{
    
    if (!_protocalVC) {
        
        _protocalVC = [[serviceProtocolVC alloc] init];
        _protocalVC.type = protocolViewTypeHtml;
        _protocalVC.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:_protocalVC.view];
    }
    
    return _protocalVC;
}

- (void)setItemFrame:(ServiceItemFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    myofferGroupModel *group = [myofferGroupModel groupWithItems:@[itemFrame.item] header:nil];
    group.type = SectionGroupTypeCreateOrderMassage;
    [self.groups addObject:group];
   
    //reduce_flag为true优惠
    if (itemFrame.item.reduce_flag) {
      
        myofferGroupModel *enjoy = [myofferGroupModel groupWithItems:nil header:@"尊享通道"];
        enjoy.type = SectionGroupTypeCreateOrderEnjoy;
        [self.groups addObject:enjoy];
        
        [self makeData];
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSourc

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    myofferGroupModel *group = self.groups[indexPath.section];
 
    if (group.type == SectionGroupTypeCreateOrderMassage) {
        
        CreateOrderOneCell  *cell = [[NSBundle mainBundle] loadNibNamed:@"CreateOrderOneCell" owner:self options:nil].lastObject;
        cell.item = group.items[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        CreateOrderItemCell  *cell = [[NSBundle mainBundle] loadNibNamed:@"CreateOrderItemCell" owner:self options:nil].lastObject;
        cell.item = group;

        return cell;
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    myofferGroupModel *group  = self.groups[indexPath.section];
    
    //如果顶部订单信息，不继续执行
    if (SectionGroupTypeCreateOrderMassage  == group.type) {
        return;
    }
  
    myofferGroupModel *enjoy = nil;
    myofferGroupModel *active = nil;
    for (myofferGroupModel *item in self.groups) {
        if (item.type == SectionGroupTypeCreateOrderEnjoy) {
            enjoy = item;
        }
        if (item.type == SectionGroupTypeCreateOrderActive) {
            active = item;
        }
    }
 
    if (group.type == SectionGroupTypeCreateOrderEnjoy) {
 
        if (active.sub.length > 0) {
            [self caseAlertWithGroup:group];
        }else{
            [self casePushEnjoy:group];
        }
     }
    
    
    if (group.type == SectionGroupTypeCreateOrderActive) {
         if (enjoy.sub.length > 0) {
            [self caseAlertWithGroup:group];
        }else{
            [self casePushActive:group];
        }
     }
    
}

//push OrderEnjoyVC
- (void)casePushEnjoy:(myofferGroupModel *)group{
    
    XWeakSelf
    OrderEnjoyVC *vc = [[OrderEnjoyVC alloc] initWithNibName:@"OrderEnjoyVC" bundle:nil];
    vc.enjoyBlock = ^(NSDictionary *result) {
         [weakSelf caseEnjoyItemUpdateWithResult:result group:group];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//Enjoy  数据更新
- (void)caseEnjoyItemUpdateWithResult:(NSDictionary *)result group:(myofferGroupModel *) group{
    
    //清空数据
    for (myofferGroupModel *item in self.groups) {
        item.sub = @"";
    }
    group.sub = [NSString stringWithFormat:@"尊享优惠了 -￥%@",result[@"rules"]];
    
    [self.tableView reloadData];
    
//    NSLog(@"caseEnjoyItemUpdateWithResult  尊享 ==  %@",result[@"rules"]);

    //显示总金额
    [self discountMessage:result[@"rules"]];
    
    //提交订单请求参数
    [self.parameter setValue:result[@"promote_id"]  forKey:@"pId"];
    [self.parameter setValue:@""  forKey:@"cId"];

}


//push OrderActionVC
- (void)casePushActive:(myofferGroupModel *)group{
 
        XWeakSelf
        OrderActionVC *vc =  [[OrderActionVC alloc] initWithNibName:@"OrderActionVC" bundle:nil];
        vc.items = self.discount_items;
        vc.actBlock = ^(DiscountItem *item) {
             [weakSelf caseActionUpdateWithItem:item group:group];
        };

        [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)caseActionUpdateWithItem:(DiscountItem *)item  group:(myofferGroupModel *)group{
    
    //清空数据
    for (myofferGroupModel *it in self.groups) {
        it.sub = @"";
    }
    
    NSString *sub = item ? [NSString stringWithFormat:@"%@ -￥%@",item.name,item.rules] : @"";
    group.sub = sub;
    [self.tableView reloadData];
    
    //设置被选项
    for (DiscountItem *it  in self.discount_items) {
        it.selected = NO;
        if ([item.cId isEqualToString: it.cId]) {
            it.selected = YES;
        }
    }
    
    //更新总金额
    [self discountMessage:item.rules];
 
   //提交订单请求参数
    [self.parameter setValue:@""  forKey:@"pId"];
    [self.parameter setValue:item.cId  forKey:@"cId"];
    
}


//显示 Alert
- (void)caseAlertWithGroup:(myofferGroupModel *)group{
    
        XWeakSelf;
        NSString *message = (group.type == SectionGroupTypeCreateOrderActive) ? @"选择使用优惠券将无法同时使用尊享通道" :  @"选择使用尊享通道将无法同时使用优惠券" ;
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
         }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"依然进入" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             if (group.type == SectionGroupTypeCreateOrderActive ) {
                 [weakSelf casePushActive:group];
            }else{
                [weakSelf casePushEnjoy:group];
            }
        }];
        [alertCtrl addAction:cancelAction];
        [alertCtrl addAction:okAction];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    
}


 //更新总金额
- (void)discountMessage:(NSString *)value{
    
    self.discountLab.hidden = !value;
    self.discountLab.text = [NSString stringWithFormat:@"(已优惠￥%@) ",value];
    CGFloat after_price_fl = self.itemFrame.item.price.floatValue - value.floatValue;
    NSString *price = [self fomatterWithPrice:[NSString stringWithFormat:@"%lf",after_price_fl]];
    self.priceLab.text = price;
}

//查看协议
- (void)protocolClick:(UIButton *)sender{
 
       [self.protocalVC pageWithHiden:NO];
}

//选择按钮
- (void)optionBtnClick:(UIButton *)sender{
    
    sender.selected  = !sender.selected;
 
     if (sender.selected) {
         
         [self protocolAttribute:NO];
     }
 
}

//设置协议字符串颜色
- (void)protocolAttribute:(BOOL)colorful{
    
    
    UIColor *clr  = colorful ? XCOLOR_RED :XCOLOR(188, 188, 188, 1);
    NSDictionary *attribtDic = @{
                                 NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                 NSForegroundColorAttributeName: clr
                                 };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.protocolBtn.currentTitle attributes:attribtDic];
    [self.protocolBtn setAttributedTitle:attribtStr  forState:UIControlStateNormal];
}

//提交订单
- (IBAction)caseCommit:(UIButton *)sender {
    
      if (!self.optionBtn.selected) {
        [self protocolAttribute:YES];
        return;
    }
    
    [self orderCreate];
}


- (NSString *)fomatterWithPrice:(NSString *)price{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSNumber *number = [NSNumber numberWithFloat:price.floatValue];
    NSString *numberString = [numberFormatter stringFromNumber: number];
    
    return  [NSString stringWithFormat:@"￥ %@",numberString];
}

// 下单
- (void)orderCreate{
//NSDictionary *parameter  = @{ @"skuId": self.item.price};
//pId:@"",//推广码Id
//cId:@"",//优惠券码Id   优惠券id和推广码Id只可选传
    XWeakSelf
    [self startAPIRequestWithSelector:@"POST svc/emall/order/create" parameters:self.parameter showHUD:YES errorAlertDismissAction:nil success:^(NSInteger statusCode, id response) {
        
        [weakSelf orderCreateSuccessWithResponse:response];
        
    }];
    
}
//下单成功
- (void)orderCreateSuccessWithResponse:(id)response{
    
    NSDictionary *result = response[@"result"];
    
    OrderItem *order = [[OrderItem alloc] init];
    order.SKU = result[@"name"];
    order.total_fee = result[@"amount"];
    order.order_id = result[@"orderId"];
    
    PayOrderViewController *pay = [[PayOrderViewController alloc] init];
    pay.order = order;
    [self.navigationController pushViewController:pay animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    KDClassLog(@"创建订单页面 +  CreateOrderVC + dealloc");
}

@end
