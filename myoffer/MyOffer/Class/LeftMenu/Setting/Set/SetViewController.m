//
//  SetViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "SetViewController.h"
#import "ProfileViewController.h"
#import "ApplyViewController.h"
#import "FeedbackViewController.h"
#import "XWGJAboutViewController.h"

@interface SetViewController ()
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)myofferGroupModel *logout_group;
@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    [MobClick beginLogPageView:@"page设置中心"];
    
    [self whenLoginStatusChange];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page设置中心"];
    
}

- (void)whenLoginStatusChange{
    
    if (LOGIN) {
    
        
        if (self.groups.count == 1) {
            
            [self.groups addObject:self.logout_group];
            
            self.datas = [self.groups copy];
            
            [self.tableView reloadData];

        }
        
        
        return;
    }
    

    if (self.groups.count > 1) {
        
        [self.groups removeLastObject];
        
        self.datas = [self.groups copy];

        [self.tableView reloadData];
        
    }
  
    
}


- (myofferGroupModel *)logout_group{

    if (!_logout_group) {
        
        //退出
        
        XWGJAbout *logout  =  [XWGJAbout cellWithLogo:nil title:@"退出登录" action:NSStringFromSelector(@selector(caseLogout)) itemClass:nil];
        
        _logout_group = [myofferGroupModel groupWithItems:@[logout] header:nil];
        _logout_group.section_header_height = Section_header_Height_min;
        
 
    }
    
    return _logout_group;
}



- (NSMutableArray *)groups{

    if (!_groups) {
        
        //个人信息
        XWGJAbout *profile   = [XWGJAbout cellWithLogo:nil title:GDLocalizedString(@"Setting-001") action:NSStringFromSelector(@selector(caseLogin:)) itemClass:NSStringFromClass([ProfileViewController class])];
         //反馈
        
        XWGJAbout *feedBack  = [XWGJAbout cellWithLogo:nil title:GDLocalizedString(@"Setting-003") action:NSStringFromSelector(@selector(caseLogin:)) itemClass:NSStringFromClass([FeedbackViewController class])];
  
        //关于
       XWGJAbout *about  =  [XWGJAbout cellWithLogo:nil title:GDLocalizedString(@"Setting-004") action:NSStringFromSelector(@selector(caseAbout:)) itemClass:NSStringFromClass([XWGJAboutViewController class])];
        
 
       myofferGroupModel *setGroup = [myofferGroupModel groupWithItems:@[profile,feedBack,about] header:nil];
        setGroup.section_header_height = Section_header_Height_min;
  
        
        _groups   =  [NSMutableArray array];
        
        [_groups addObject:setGroup];
        
    }
    
    
    return _groups;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.datas = [self.groups copy];
    
}


#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
static NSString *identify = @"set";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (indexPath.section == 1) {
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }else{
    
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
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


#pragma mark : 事件处理

- (void)caseLogin:(XWGJAbout *)item{

    RequireLogin
    [self.navigationController pushViewController:[[NSClassFromString(item.item_class) alloc] init] animated:YES];

}

- (void)caseAbout:(XWGJAbout *)item{
    
    [self.navigationController pushViewController:[[NSClassFromString(item.item_class) alloc] init] animated:YES];

}

-(void)caseLogout{
    
    [[AppDelegate sharedDelegate] logout];

    [self dismiss];
    
}


- (void)dealloc{
    
    KDClassLog(@"dealloc SetViewController");
}


@end
