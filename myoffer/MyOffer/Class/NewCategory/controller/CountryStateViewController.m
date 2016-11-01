//
//  XWGJStateViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "XNewSearchViewController.h"
#import "CountryStateViewController.h"
#import "XUCountry.h"

@interface CountryStateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *states;
@end

@implementation CountryStateViewController
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
    
    [self makeUI];
    
    [self getStateData];
 
}

- (void)makeUI{
    
    self.title = self.countryName;

    [self makeTableView];
    
}

//备用数据源
-(void)getStateData
{
    
    if([self.countryName isEqualToString:GDLocalizedString(@"CategoryVC-UK")])
    {
        self.states = @[GDLocalizedString(@"SearchResult_All"),GDLocalizedString(@"CategoryVC-ENG001"),GDLocalizedString(@"CategoryVC-ENG002"),GDLocalizedString(@"CategoryVC-ENG003"),GDLocalizedString(@"CategoryVC-ENG004")];
        
    }else{
        
        self.states =@[GDLocalizedString(@"SearchResult_All"),GDLocalizedString(@"CategoryVC-AUSTR001"),GDLocalizedString(@"CategoryVC-AUSTR002"),GDLocalizedString(@"CategoryVC-AUSTR003"),GDLocalizedString(@"CategoryVC-AUSTR004"),GDLocalizedString(@"CategoryVC-AUSTR005"),GDLocalizedString(@"CategoryVC-AUSTR006"),GDLocalizedString(@"CategoryVC-AUSTR007")];
    }
    
}

-(void)makeTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view  addSubview:self.tableView];
    
    
    UIImage *countryImage  = [self.countryName isEqualToString:GDLocalizedString(@"CategoryVC-UK")] ? [UIImage imageNamed:GDLocalizedString(@"Category-UK") ] :[UIImage imageNamed:GDLocalizedString(@"Category-AU") ];
    UIImageView *headerView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, (countryImage.size.height  *  XScreenWidth / countryImage.size.width))];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.image = countryImage;
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

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
    
    NSString *key = indexPath.row == 0 ? KEY_COUNTRY : KEY_STATE;
    
    NSString *searchValue = indexPath.row == 0 ? self.countryName : self.states[indexPath.row];
    
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:key
                                                                              value:searchValue
                                                                            orderBy:RANKTI];
    
    if ( 0 == indexPath.row) {
        
        vc.CoreCountry =  self.countryName;
        
    }else{
        
        vc.CoreCountry =  self.countryName;
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
