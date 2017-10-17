//
//  XWGJStateViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "CountryStateViewController.h"
#import "MyOfferCountry.h"
#import "MyOfferCountryState.h"
#import "SearchUniversityCenterViewController.h"


@interface CountryStateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *stateTableView;
@property(nonatomic,strong)UITableView *cityTableView;
@property(nonatomic,strong)MyOfferCountry *countryModel;
@property(nonatomic,strong)MyOfferCountryState *currentState;
@property(nonatomic,strong)UIImageView *selectImageView;
@property(nonatomic,strong)UIFont *cell_font;
@property(nonatomic,strong)NSIndexPath *current_Index;

@end

@implementation CountryStateViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page国家地区"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
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
    
    self.cell_font = XFONT(XFONT_SIZE(16));
    
}
// cell选中时背景图片
- (UIImageView *)selectImageView{

    if (!_selectImageView) {
        
        UIImage *image = [UIImage KD_imageWithColor:XCOLOR_WHITE];
        _selectImageView =  [[UIImageView alloc] initWithImage:image];
    }
    
    return _selectImageView;
}


//备用数据源
-(void)getStateData
{
 
    NSString *country = @"英国";
    
    if([self.countryName containsString:@"英国"]){
    
        country = @"英国";
        
    }else if([self.countryName containsString:@"澳"]){
    
        country = @"澳大利亚";
   
    }else{
    
        country = @"美国";
    }
    
    NSArray *countryes = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country_CN"];
    
    for (NSDictionary *countryDic in countryes) {
        
        if ([countryDic[@"name"] isEqualToString:country]) {
            
            self.countryModel = [MyOfferCountry mj_objectWithKeyValues:countryDic];
           
            [self.stateTableView reloadData];

            break;
        }
        
    }
    
    
    if (self.stateTableView) {
    
        if (self.countryModel && self.countryModel.states.count > 0) {
            
            self.current_Index = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.stateTableView selectRowAtIndexPath:self.current_Index animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.currentState = self.countryModel.states.firstObject;
            
        }
        
        
    }
    
    
}

-(void)makeTableView{
    
    CGFloat left_Width = 150;
    CGFloat left_Height = XSCREEN_HEIGHT - XNAV_HEIGHT;
    self.stateTableView = [self tableViewWithFrame: CGRectMake(0, 0, left_Width, left_Height)];
    self.stateTableView.backgroundColor = XCOLOR_BG;
    [self.view  addSubview:self.stateTableView];

    self.cityTableView =  [self tableViewWithFrame: CGRectMake(left_Width, 0, XSCREEN_WIDTH - left_Width, left_Height)];
    self.cityTableView.backgroundColor = XCOLOR_WHITE;
    self.cityTableView.showsVerticalScrollIndicator = NO;
    [self.view  addSubview:self.cityTableView];
    
}

- (UITableView *)tableViewWithFrame:(CGRect)frame{

    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
         tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

 
    return tableView;
}


#pragma mark : UITableViewDelegate  UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    
    if (tableView == self.stateTableView) {
        
        rows = self.countryModel.states.count + 1;
        
    }else{
        
        rows = self.currentState.cities.count + 1;

    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.stateTableView) {
        
        UITableViewCell *stateCell = [tableView dequeueReusableCellWithIdentifier:@"state"];
        
        if (!stateCell) {
            
            stateCell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"state"];
            stateCell.contentView.backgroundColor = XCOLOR_BG;
            stateCell.selectedBackgroundView =  self.selectImageView;
            stateCell.textLabel.highlightedTextColor = XCOLOR_LIGHTBLUE;
            stateCell.textLabel.font =  self.cell_font;
         }
        
        NSString *name;
        
        if (indexPath.row == 0) {
            
            name = @"全部";
            
        }else{
            
            MyOfferCountryState *state =  self.countryModel.states[indexPath.row - 1];
            
            name = state.name;
        }
        
        stateCell.textLabel.text = name;
        
        return stateCell;
        
        
        
    }else{
        
        
        UITableViewCell *city_cell = [tableView dequeueReusableCellWithIdentifier:@"state_city"];
        
        if (!city_cell) {
            
            city_cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"state_city"];
            city_cell.textLabel.font = self.cell_font;
   
        }
        
        NSString *name;
        
        if (indexPath.row == 0) {
            
            name = @"全部";
            
        }else{
            
            NSDictionary *city =  self.currentState.cities[indexPath.row - 1];
            
            name = city[@"name"];
        }
        
        city_cell.textLabel.text = name;
        
        return city_cell;
        
    }
    
  
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString *key = KEY_COUNTRY;
    NSString *searchValue = self.countryModel.name;
    
    //州tableView
    if (tableView == self.stateTableView) {
        
        if (indexPath.row != 0) {
            
            self.currentState =  self.countryModel.states[indexPath.row - 1];
            
            [self.cityTableView reloadData];
            
            self.current_Index = indexPath;
            
            return;
        }
        
        
        SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:key value:searchValue];
       
        [self.navigationController pushViewController:vc animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self.stateTableView selectRowAtIndexPath:self.current_Index animated:NO scrollPosition:UITableViewScrollPositionTop];
 
        
        return;
        
    }
    
    
    if (indexPath.row == 0) {
        
        key = KEY_STATE;
        
        searchValue = self.currentState.name;
        
    }else{
    
        key = KEY_CITY;
        NSDictionary *city =  self.currentState.cities[indexPath.row - 1];
        
        searchValue = city[@"name"];
        
    }
    
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:key value:searchValue country:self.countryModel.name];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
