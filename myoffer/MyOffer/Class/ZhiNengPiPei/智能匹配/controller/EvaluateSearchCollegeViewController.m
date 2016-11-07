//
//  EvaluateSearchCollegeViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/9/24.
//  Copyright (c) 2015年 UVIC. All rights reserved.
//

#import "EvaluateSearchCollegeViewController.h"

@interface EvaluateSearchCollegeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *schoolList;
@property(nonatomic,strong)NSArray *resultList;
@property(nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

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
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeViewUI];
    
    [self createSearchSource];
}

-(void)makeViewUI
{
    self.title = GDLocalizedString(@"Evaluate-University");//@"毕业院校";  //@"完成"
    
    UIBarButtonItem *rightCommitButton =[[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"Evaluate-Done") style:UIBarButtonItemStylePlain target:self action:@selector(commitInput)];
    self.navigationItem.rightBarButtonItem = rightCommitButton;
    
    
    [self.searchTextField addTarget:self action:@selector(searchCollegeWithKeyValue:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, XScreenWidth, XScreenHeight - (XNav_Height + 44))];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//     self.footView.backgroundColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]; //[UIColor colorWithRed:230/255 green:230/255 blue:238/255 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc] init];
     [self.view addSubview:self.tableView];
    
    
}

-(void)createSearchSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"collegelist" ofType:nil];
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    NSString *pathString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSString *noHeaderPath = [pathString stringByReplacingOccurrencesOfString:@"\[\"" withString:@""];
    NSString *noFooterpath = [noHeaderPath stringByReplacingOccurrencesOfString:@"\"]" withString:@""];
    self.schoolList = [noFooterpath componentsSeparatedByString:@"\",\""];
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
    
    [self universityName:self.resultList[indexPath.row]];
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//正则表达匹配查询结果
-(void)searchCollegeWithKeyValue:(UITextField *)searchTF
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchTF.text];
    self.resultList = [self.schoolList filteredArrayUsingPredicate:pred];
    [self.tableView reloadData];
}

//提交查询
-(void)commitInput
{
    [self universityName:self.searchTextField.text];
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
