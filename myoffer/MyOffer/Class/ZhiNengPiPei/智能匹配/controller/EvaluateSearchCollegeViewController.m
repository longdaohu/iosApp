//
//  EvaluateSearchCollegeViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/9/24.
//  Copyright (c) 2015年 UVIC. All rights reserved.
//

#import "EvaluateSearchCollegeViewController.h"
#import "TopNavView.h"

@interface EvaluateSearchCollegeViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    
    [self makeDataSource];
    
}

- (void)makeDataSource{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    self.schoolList = [ud valueForKey:@"uni_list"];
    
    if (!self.schoolList.count) {
        
        [self startAPIRequestWithSelector:@"GET docs/zh-cn/chinese-university-names.json" parameters:nil success:^(NSInteger statusCode, id response) {
            
            self.schoolList = [response copy];
            
            [ud setValue:self.schoolList forKey:@"uni_list"];//保存学校数据到本地，多次加载无意义
            
            [ud synchronize];
            
        }];
        
    }

}

//其实封装一下比较好
-(void)makeViewUI
{
    
    TopNavView *navView = [TopNavView topView];
    [self.view addSubview:navView];
    
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 24, XSCREEN_WIDTH - 80, 34)];
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
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(rightX, 24, XSCREEN_WIDTH - rightX, 34)];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [navView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(commitInput) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XNAV_HEIGHT, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT)];
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
    
    if ( 0 ==self.searchTextField.text.length) {
        
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
