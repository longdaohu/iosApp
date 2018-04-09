//
//  OrderActionVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/4.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "OrderActionVC.h"
#import "DiscountCell.h"
#import "DiscountItem.h"
#import "OrderActionCell.h"

@interface OrderActionVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)BOOL  cell_top_selected;

@end

@implementation OrderActionVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page优惠"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page优惠"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    
}

- (void)setItems:(NSArray *)items{
    
    _items = items;
    
    self.cell_top_selected = YES;
    
    for (DiscountItem *item in items) {
        
            if (item.selected ) {
                
                self.cell_top_selected = NO;
 
                break;
            }
    }

    [self.tableView reloadData];
    
}


- (void)makeUI{
    self.title = @"我的优惠";
    [self makeTableView];
}

- (void)makeTableView
{
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.tableFooterView =[[UIView alloc] init];
    UINib *xib = [UINib nibWithNibName:@"DiscountCell" bundle:nil];
    [self.tableView registerNib:xib forCellReuseIdentifier:@"DiscountCell"];
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.items.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        OrderActionCell  *cell = [[NSBundle mainBundle] loadNibNamed:@"OrderActionCell" owner:self options:nil].lastObject;
        cell.cell_selected = self.cell_top_selected;
        
        return cell;
    }
    
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscountCell" forIndexPath:indexPath];
    cell.type = OrderDiscountCellTypeNoClickButton;
    cell.item = self.items[indexPath.section - 1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    DiscountItem  *item_select = nil;
    
    if (indexPath.section == 0) {
        OrderActionCell *actionCell = (OrderActionCell *)cell;
        actionCell.cell_selected = YES;
    }else{
        item_select  = self.items[indexPath.section - 1];
    }
    
    [self dismiss];
 
    //如果点击项为已选项，没必要再重复再选择
    if (item_select.selected)  return;
 
    if (self.actBlock) {
        self.actBlock(item_select);
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"优惠 + DiscountVC + dealloc");
}

@end
