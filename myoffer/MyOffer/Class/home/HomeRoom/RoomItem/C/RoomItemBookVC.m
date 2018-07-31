//
//  RoomItemBookVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemBookVC.h"
#import "RoomItemBookCell.h"
#import "RoomItemBookSV.h"

@interface RoomItemBookVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *items;
@end

@implementation RoomItemBookVC

- (NSArray *)items{
    if (!_items) {
        
        _items = @[
                   @"比如第二个例子中，他形容自己的父母老实巴交",
                   @"",
                   @"比如第二个例子中，他形容自己的父母老实巴交，我是一点都没有看出哪里老实巴交了，要说不明事理还比较准确，这种父母，就是典型的可怜之人必有可恨之处。",
                   @"但罪魁祸首并不是他们",
                   @"而是这个男人估计平时就在父母面前打肿脸充胖子，一副大包大揽的样子，造成了父母的错觉，觉得大儿子特有本事特有钱。",
                   @"而农村父母大多边界感比较差",
                   @"",
                   @"",
                   @"",
                   @"",
                   @"但这里有一个大前提，你得把自己的日子先过好了。",
                   @"",
                   @"而农村父母大多边界感比较差",
                   @"",
                   @"",
                   @"",
                   @"",
                   @"孝顺父母，友爱兄弟，是我们的优良传统，自古以来，我们都是一个人情社会，相互帮助，可以使这个世界多很多温暖，手足之情，更是血浓于水",
                   @"身为他们的老婆孩子，简直就是人生最大的灾难，任何时候，你们都是排最后的，他的父母兄弟姐妹被他养得红光满面，你和孩子往往衣衫褴褛，生活不继。",
                   @"",
                   @"而农村父母大多边界感比较差",
                   ];
    }
    
    return _items;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NavigationBarHidden(YES);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}

- (void)makeUI{
    
    self.title = @"房源详情";
    [self makeTableView];
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    UINib *xib = [UINib nibWithNibName:@"RoomItemBookCell" bundle:nil];
    [self.tableView registerNib:xib forCellReuseIdentifier:@"RoomItemBookCell"];
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XTabBarHeight, 0);
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomItemBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomItemBookCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = self.items[indexPath.row];
    cell.actionBlock = ^{
        
        NSLog(@" cell ---- ");
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    RoomItemBookSV *sv = [RoomItemBookSV new];
    return sv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 58;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    KDClassLog(@" 房源预订 + RoomItemBookVC + dealloc");
}


@end
