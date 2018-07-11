//
//  myApplyViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "myApplyViewController.h"
#import "ApplyViewController.h"
#import "ApplyStatusViewController.h"

@interface myApplyViewController ()
@property(nonatomic,strong)NSMutableArray *groups;

@end

@implementation myApplyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [MobClick beginLogPageView:@"page我的申请"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page我的申请"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"我的申请";
    self.datas = [self.groups copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)groups{
    
    if (!_groups) {
        
        XWGJAbout *apply  =  [XWGJAbout cellWithLogo:nil title:@"申请意向" action:NSStringFromSelector(@selector(caseApply:)) itemClass:NSStringFromClass([ApplyViewController class])];
        XWGJAbout *status  =  [XWGJAbout cellWithLogo:nil title:@"审核状态" action:NSStringFromSelector(@selector(caseApply:)) itemClass:NSStringFromClass([ApplyStatusViewController class])];
        
        myofferGroupModel *group = [myofferGroupModel groupWithItems:@[apply,status] header:nil];
        group.section_header_height = Section_header_Height_min;
        
        _groups   =  [NSMutableArray array];
        
        [_groups addObject:group];
        
    }
    
    
    return _groups;
    
}


#pragma mark: UITableViewDelegate  UITableViewDataSoure

static NSString *identify = @"set";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    myofferGroupModel *group = self.datas[indexPath.section];
    XWGJAbout *item       = group.items[indexPath.row];
    cell.textLabel.text  = item.title;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.datas[indexPath.section];
    XWGJAbout *item       = group.items[indexPath.row];
    
    if (item.action.length > 0) {
        
        [self performSelector:NSSelectorFromString(item.action) withObject:item afterDelay:0];
    }
    
}

- (void)caseApply:(XWGJAbout *)item{

    RequireLogin

    UIViewController *vc = [[NSClassFromString(item.item_class) alloc] init];
    NSString *apply = NSStringFromClass([ApplyViewController class]);
    
    if ([apply isEqualToString:item.item_class]) {
        
        ApplyViewController  *apply_vc =  (ApplyViewController *)vc;
        
        [self.navigationController pushViewController:apply_vc animated:YES];

        return;
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)dealloc{

    KDClassLog(@"dealloc myApplyViewController");
}

@end
