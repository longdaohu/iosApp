//
//  RoomSearchResultVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomSearchResultVC.h"
#import "RoomSearchCell.h"

@interface RoomSearchResultVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation RoomSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self makeUI];
}


- (void)makeUI{
    
    [self makeNavigationView];
    [self makeTableView];
}

- (void)makeNavigationView{
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(caseMeiqia)];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH , 26)];
    searchTF.font = XFONT(10);
    searchTF.backgroundColor = XCOLOR(243, 246, 249, 1);
    searchTF.layer.cornerRadius = 13;
    searchTF.layer.masksToBounds = YES;
    searchTF.placeholder = @"输入关键字搜索城市，大学，公寓";
    self.navigationItem.titleView = searchTF;
    searchTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView setImage:XImage(@"home_application_search_icon")];
    searchTF.leftView = leftView;
    searchTF.leftViewMode =  UITextFieldViewModeAlways;
}

- (void)makeTableView{
    
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 10;
}

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark : 事件处理
- (void)caseMeiqia{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
