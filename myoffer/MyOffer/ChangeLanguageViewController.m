//
//  ChangeLanguageViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "DoneButton.h"


@interface ChangeLanguageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *languageTableView;
@property(nonatomic,strong)NSArray *cellItems;
@property(nonatomic,strong)UIView *footView;
@end

@implementation ChangeLanguageViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"语言设置";
    self.cellItems = @[@"简体中文",@"English"];
    self.footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 80)];
    DoneButton *saveBtn =[[DoneButton alloc] initWithFrame:CGRectMake( 20, 20, APPSIZE.width - 40, 40)];
    
    saveBtn.backgroundColor =[UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
     [self.footView addSubview:saveBtn];
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(14, 0, APPSIZE.width, 1)];
    line.alpha = 0.4;
    line.backgroundColor =[UIColor lightGrayColor];
    [self.footView addSubview:line];
    
    self.languageTableView.tableFooterView = self.footView;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"setCell"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setCell"];
    }
    cell.textLabel.text = self.cellItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
