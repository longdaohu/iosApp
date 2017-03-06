//
//  HelpViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/25.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "HelpViewController.h"
@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *helpItems;


@end

@implementation HelpViewController

-(NSArray *)helpItems
{
    if (!_helpItems) {
        
        _helpItems = @[@"平台网站",@"如何申请",@"申请条件",@"递交申请",@"Offer管理",@"操作疑问"];
    }
    
    return _helpItems;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    [MobClick beginLogPageView:@"page帮助中心"];
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page帮助中心"];
    
}

- (void)viewDidLoad {
 
    [super viewDidLoad];
    
    [self makeUI];
  
}

-(void)makeUI
{
    self.title  = GDLocalizedString(@"Left-helpCenter");
  
 
}

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.helpItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = self.helpItems[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WebViewController *help = [[WebViewController alloc] init];
    help.path    = [NSString stringWithFormat:@"%@faq#index=%ld",DOMAINURL,(long)indexPath.row];
    [self.navigationController pushViewController:help animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return HEIGHT_ZERO;
}


-(void)dealloc
{
    KDClassLog(@"帮助中心  dealloc");   //可以释放
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
