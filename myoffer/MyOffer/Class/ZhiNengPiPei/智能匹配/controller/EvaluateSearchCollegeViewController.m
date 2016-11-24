//
//  EvaluateSearchCollegeViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/9/24.
//  Copyright (c) 2015年 UVIC. All rights reserved.
//

#import "EvaluateSearchCollegeViewController.h"

@interface EvaluateSearchCollegeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *topNavView;
@property(nonatomic,strong)NSArray *schoolList;
@property(nonatomic,strong)NSArray *resultList;
@property(nonatomic,strong)UITableView *tableView;
@property(strong, nonatomic)UITextField *searchTextField;

@end

@implementation EvaluateSearchCollegeViewController


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page搜索学校"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page搜索学校"];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeViewUI];
    
    [self startAPIRequestWithSelector:@"GET docs/zh-cn/chinese-university-names.json" parameters:nil success:^(NSInteger statusCode, id response) {
        
        self.schoolList = [response copy];
        
    }];
    
}

-(void)makeViewUI
{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XNav_Height)];
    navView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:navView];
    
    UIImageView *navBgVew = [[UIImageView alloc] init];
    navBgVew.contentMode = UIViewContentModeScaleAspectFit;
    [navView addSubview:navBgVew];
    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
    UIImage *bgImage =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    navBgVew.frame = CGRectMake(0, 0, XScreenWidth, bgImage.size.height);
    navView.clipsToBounds = YES;
    navBgVew.image = bgImage;
    
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 24, XScreenWidth - 80, 34)];
    self.searchTextField = searchTextField;
    [navView addSubview:searchTextField];
    searchTextField.placeholder = @"请输入在读或毕业院校";
    searchTextField.leftViewMode =  UITextFieldViewModeAlways;
    UIImageView  *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, searchTextField.bounds.size.height, 50)];
    leftView.image = XImage(@"search-no-result");
    leftView.contentMode = UIViewContentModeCenter;
    searchTextField.leftView = leftView;
    searchTextField.layer.cornerRadius = CORNER_RADIUS;
    searchTextField.backgroundColor = XCOLOR_WHITE;
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.searchTextField addTarget:self action:@selector(searchCollegeWithKeyValue:) forControlEvents:UIControlEventEditingChanged];
    
    
    CGFloat rightX = CGRectGetMaxX(searchTextField.frame);
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(rightX, 24, XScreenWidth - rightX, 34)];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [navView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(commitInput) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XNav_Height, XScreenWidth, XScreenHeight - XNav_Height)];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.resultList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"school"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"school"];
    }
    
    cell.textLabel.text = self.resultList[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *item = self.resultList[indexPath.row];
   
    if ([item containsString:@"输入"])  return;
    
    [self universityName:item];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//正则表达匹配查询结果
-(void)searchCollegeWithKeyValue:(UITextField *)searchTF
{
    
    if ([self.searchTextField.text containsString:@" "]) {
        
        NSRange emptyRange = [searchTF.text rangeOfString:@" "];
        
        searchTF.text = [searchTF.text substringWithRange:NSMakeRange(0, emptyRange.location)];
        
    }
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchTF.text];
    self.resultList = [self.schoolList filteredArrayUsingPredicate:pred];
    
    if (self.resultList.count == 0 && searchTF.text.length > 0) {

        NSString *item = [NSString stringWithFormat:@"输入\" %@\" ",searchTF.text];
        self.resultList = @[item];
    }
    
    [self.tableView reloadData];
}



//提交查询
-(void)commitInput
{
    
    if (self.searchTextField.text.length == 0) {
        
         [self universityName:self.searchTextField.text];
        
    }else{
    
        NSString *regex = @"[\u4e00-\u9fa5]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        if ([pred evaluateWithObject:self.searchTextField.text]) {
            
            [self universityName:self.searchTextField.text];

        }else{
            
            AlerMessage(@"请输入完整的中文院校名称");
        }
        
    }

    
    
}


-(void)universityName:(NSString *)unversity{

    
    if (unversity && self.valueBlock) {
        
        self.valueBlock(unversity);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)dealloc{
    
    KDClassLog(@"智能匹配 学校搜索 dealloc");
}

@end
