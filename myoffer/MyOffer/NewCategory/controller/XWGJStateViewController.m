//
//  XWGJStateViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "XNewSearchViewController.h"
#import "XWGJStateViewController.h"
//#import "NewSearchRstViewController.h"
#import "XUCountry.h"

@interface XWGJStateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *states;
@end

@implementation XWGJStateViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page国家地区"];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page国家地区"];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeStateTableView];
   
   
    
    self.title = self.countryName;
 
    if([self.countryName isEqualToString:GDLocalizedString(@"CategoryVC-UK")])
    {
        self.states = @[GDLocalizedString(@"SearchResult_All"),GDLocalizedString(@"CategoryVC-ENG001"),GDLocalizedString(@"CategoryVC-ENG002"),GDLocalizedString(@"CategoryVC-ENG003"),GDLocalizedString(@"CategoryVC-ENG004")];
 
    }else{
        self.states =@[GDLocalizedString(@"SearchResult_All"),GDLocalizedString(@"CategoryVC-AUSTR001"),GDLocalizedString(@"CategoryVC-AUSTR002"),GDLocalizedString(@"CategoryVC-AUSTR003"),GDLocalizedString(@"CategoryVC-AUSTR004"),GDLocalizedString(@"CategoryVC-AUSTR005"),GDLocalizedString(@"CategoryVC-AUSTR006"),GDLocalizedString(@"CategoryVC-AUSTR007")];
    }
 
}

//备用数据源
-(void)getStateData
{
    NSString *keyWord  = USER_EN ? @"Country_EN" :@"Country_CN";
    NSArray *values = [[NSUserDefaults standardUserDefaults] valueForKey:keyWord];
    NSMutableArray *temps =[NSMutableArray array];
    for (NSDictionary *countryDic  in values) {
        XUCountry *country = [XUCountry countryInitWithCountryDictionary:countryDic];
       [temps addObject:country];
    }
    NSArray *countries = [temps valueForKeyPath:@"countryName"];
    NSInteger  index  = [countries indexOfObject:self.countryName];
    XUCountry *country = temps[index];
    self.states =  [country.states valueForKeyPath:@"stateName"];
    
}

-(void)makeStateTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = XCOLOR_CLEAR;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view  addSubview:self.tableView];
    
    
    UIImage *countryImage  = [self.countryName isEqualToString:GDLocalizedString(@"CategoryVC-UK")] ? [UIImage imageNamed:GDLocalizedString(@"Category-UK") ] :[UIImage imageNamed:GDLocalizedString(@"Category-AU") ];
      UIImageView *headerView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, Country_Width -20)];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.image = countryImage;
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark —————— UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.states.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"state"];
    
    if (!cell) {
        
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"state"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.states[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key = indexPath.row == 0 ?KEY_COUNTRY: KEY_STATE;
    NSString *searchValue = indexPath.row == 0 ? self.countryName : self.states[indexPath.row];
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:key
                                                                                  value:searchValue
                                                                                orderBy:RANKTI];

    if ( 0 == indexPath.row) {
        
        vc.CoreCountry =  self.countryName;
        
    }else{
    
        vc.CoreState = self.states[indexPath.row];

    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
