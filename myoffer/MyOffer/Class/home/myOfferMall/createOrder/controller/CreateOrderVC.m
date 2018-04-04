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

@interface CreateOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property(nonatomic,strong)NSArray *discount_items;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong) UIButton *protocolBtn;
@property(nonatomic,strong) UIButton *optionBtn;

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

- (void)makeData{
    
    NSString *path  = @"GET svc/marketing/coupons/get";
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
    }];
}

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
    
    self.title  = @"创建订单";
    
    [self makeTableView];
    
}

- (void)makeTableView
{
    self.tableView.backgroundColor = XCOLOR_BG;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 50)];
    self.tableView.tableFooterView = footer;
    
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 200;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    UIButton *optionBtn = [[UIButton alloc] initWithFrame:CGRectMake( 15, 10, 30, 30)];
    [optionBtn setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
    [optionBtn setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateSelected];
    [footer addSubview:optionBtn];
    optionBtn.selected = YES;
    [optionBtn addTarget:self action:@selector(footerClick:) forControlEvents:UIControlEventTouchUpInside];
    self.optionBtn = optionBtn;
    
    UIButton *subBtn = [[UIButton alloc] init];
    self.protocolBtn = subBtn;
    [subBtn setTitle:@"购买条款与协议，买家须知" forState:UIControlStateNormal];
    [subBtn.titleLabel setFont:XFONT(14)];
    [subBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
    [subBtn sizeToFit];
    [footer addSubview:subBtn];
    [subBtn addTarget:self action:@selector(footerClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat sub_y = 0;
    CGFloat sub_h = 50;
    CGFloat sub_x = CGRectGetMaxX(optionBtn.frame) + 5;
    CGFloat sub_w = subBtn.mj_w;
    subBtn.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
    
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:subBtn.currentTitle attributes:attribtDic];
    [subBtn setAttributedTitle:attribtStr  forState:UIControlStateNormal];

}



- (void)setItem:(ServiceItem *)item{
    
    _item = item;
 
    myofferGroupModel *group = [myofferGroupModel groupWithItems:@[item] header:nil];
    group.type = SectionGroupTypeCreateOrderMassage;
    [self.groups addObject:group];
    
    myofferGroupModel *enjoy = [myofferGroupModel groupWithItems:nil header:@"尊享通道"];
    enjoy.type = SectionGroupTypeCreateOrderEnjoy;
    [self.groups addObject:enjoy];
    
    if (item.reduce_flag) {
        
        [self makeData];
        
    }
 
    self.priceLab.text = item.price_str;
    
}

- (NSMutableArray *)groups{
    
    if (!_groups) {
        _groups =  [NSMutableArray array];
    }
    
    return _groups;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_ZERO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group  = self.groups[indexPath.section];
    XWeakSelf
    if (group.type == SectionGroupTypeCreateOrderEnjoy) {
 
        OrderEnjoyVC *vc = [[OrderEnjoyVC alloc] initWithNibName:@"OrderEnjoyVC" bundle:nil];
        vc.enjoyBlock = ^(NSString *price) {
            
            [weakSelf caseEnjoyItem:price group:group];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    if (group.type == SectionGroupTypeCreateOrderActive) {
        
        OrderActionVC *vc =  [[OrderActionVC alloc] initWithNibName:@"OrderActionVC" bundle:nil];
        vc.items = self.discount_items;
        vc.actBlock = ^(DiscountItem *item) {
            [weakSelf caseActionSelectWithItem:item group:group];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)caseEnjoyItem:(NSString *)price group:(myofferGroupModel *) group{

    group.sub = [NSString stringWithFormat:@"尊享优惠了 ￥%@",price];
    [self.tableView reloadData];
 
    self.discountLab.text = [NSString stringWithFormat:@"(已优惠 %@) ",price];
    
}

- (void)caseActionSelectWithItem:(DiscountItem *)it  group:(myofferGroupModel *)group{
 
    NSString *sub = it ? [NSString stringWithFormat:@"活动优惠了 ￥%@",it.rules] : @"";
    group.sub = sub;
    [self.tableView reloadData];
    
    for (DiscountItem *item  in self.discount_items) {
        item.selected = NO;
        if ([it.cId isEqualToString: item.cId]) {
            item.selected = YES;
            break;
        }
    }
    
    if (it) {
        self.discountLab.text = [NSString stringWithFormat:@"(已优惠 %@) ",it.rules];
    }
    
}

- (void)footerClick:(UIButton *)sender{
    
    if (sender.currentTitle) {
        
        NSLog(@"查看协议");
        
    }else{
        
        sender.selected  = !sender.selected;
        
        if (sender.selected) {
            NSLog(@"能提交");
        }else{
            NSLog(@"不能提交");
        }
        
    }
    
}

- (IBAction)caseCommit:(UIButton *)sender {
    
            NSLog(@"看情况能不能提交");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    NSLog(@"生成订单页面 +  CreateOrderVC + dealloc");
}

@end
