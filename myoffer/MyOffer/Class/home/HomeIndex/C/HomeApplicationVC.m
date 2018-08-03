//
//  HomeApplicationVC.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/7.
//  Copyright © 2018年 徐金辉. All rights reserved.
//


#import "HomeApplicationVC.h"
#import "HomeRoomTopView.h"
#import "HomeApplicationTopView.h"
#import "IntelligentResultViewController.h"
#import "PipeiEditViewController.h"
#import "WYLXViewController.h"
#import "GuideOverseaViewController.h"
#import "SearchViewController.h"
#import "HomeApplySubjecttCell.h"
#import "HomeApplycationArtCell.h"
#import "HomeApplyUniCell.h"
#import "HomeApplicationDestinationCell.h"
#import "SearchUniversityCenterViewController.h"
#import "MessageDetaillViewController.h"
#import "HomeSecView.h"

@interface HomeApplicationVC ()
@property (assign, nonatomic)NSInteger recommendationsCount;
@property(nonatomic,strong)NSArray *appGroups;

@end

@implementation HomeApplicationVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkZhiNengPiPei];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat menu_w = XSCREEN_WIDTH;
    CGFloat menu_x = 0;
    CGFloat menu_y = 0;
    CGFloat menu_h = 170;
    WeakSelf;
    HomeApplicationTopView *topView = [[HomeApplicationTopView  alloc] initWithFrame:CGRectMake(menu_x, menu_y, menu_w, menu_h)];
    topView.actionBlock = ^(UIButton *sender) {
        [weakSelf topViewClick:sender];
    };
    self.headerView = topView;

    
    self.groups = self.appGroups;
    [self makedData];
}


- (NSArray *)appGroups{
    
    if (!_appGroups) {
        
        myofferGroupModel *uni  = [myofferGroupModel groupWithItems:nil header:@"院校宝典"];
        uni.accesory_title= @"查看更多";
        uni.type = SectionGroupTypeApplyUniversity;
        NSArray *cities = @[
                            @{@"country":@"英国",@"city":@"伦敦",@"name":@"伦敦\nLondon", @"icon":@"city_ld.jpg",},
                            @{@"country":@"英国",@"city":@"曼彻斯特",@"name":@"曼彻斯特\nManchester", @"icon":@"city_mcst.jpg",},
                            @{@"country":@"英国",@"city":@"伯明翰",@"name":@"伯明翰\nBirmingham", @"icon":@"city_bmh.jpg",},
                            @{@"country":@"澳大利亚",@"city":@"悉尼",@"name":@"悉尼\nSydney", @"icon":@"city_xn.jpg",},
                            @{@"country":@"澳大利亚",@"city":@"墨尔本",@"name":@"墨尔本\nMelbourne", @"icon":@"city_mrb.jpg",},
                            @{@"country":@"新西兰",@"city":@"奥克兰",@"name":@"奥克兰\nAuckland", @"icon":@"city_akl.jpg"}
                            ];
        myofferGroupModel *destination  = [myofferGroupModel groupWithItems:@[cities] header:@"目的地"];
        destination.type = SectionGroupTypeApplyDestination;
        destination.accesory_title= @"留学生梦想的6座城";
        destination.section_header_height  = 60;
        
        NSArray *areas = @[@"placeHolder"];
        myofferGroupModel *subject  = [myofferGroupModel groupWithItems:@[areas] header:@"热门专业"];
        subject.type = SectionGroupTypeApplySubject;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *items = [ud valueForKey:@"HotArticle"];
        myofferGroupModel *article  = [myofferGroupModel groupWithItems:items header:@"热门阅读"];
        article.type = SectionGroupTypeArticleColumn;
        article.accesory_title= @"查看更多";
        
        _appGroups = @[uni,destination,subject,article];
    }
    
    return _appGroups;
}


- (void)makedData{
    [self makeHotUni];
}

/*-----------热门学校----------*/
- (void)makeHotUni{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@svc/app/hotUniversity",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makHotUniWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                           }];
}

- (void)makHotUniWithResponse:(id)response{
    if (!ResponseIsOK) return;
    [self reloadWithItems:@[response[@"result"]] type:SectionGroupTypeApplyUniversity];
    
}
/*-----------热门学校----------*/
- (void)reloadWithItems:(NSArray *)items type:(SectionGroupType)type{
    
    NSInteger index = 0;
    for (myofferGroupModel *group in self.groups) {
        if (group.type == type) {
            index = [self.groups indexOfObject:group];
            group.items = items;
            break;
        }
    }
    
    [self reloadSection:index];
}


#pragma mark :

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    WeakSelf
    HomeSecView *header = [[HomeSecView alloc] init];
    header.leftMargin = 20;
    header.group = self.groups[section];
    header.actionBlock = ^(SectionGroupType type) {
        [weakSelf caseHeaderView:type];
    };
    
    return header;
}

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myofferGroupModel *group = self.groups[indexPath.section];
    WeakSelf
    
    if (group.type == SectionGroupTypeArticleColumn) {
        HomeApplycationArtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeApplycationArtCell"];
        if (!cell) {
            cell = Bundle(@"HomeApplycationArtCell");
        }
        cell.item = group.items[indexPath.row];
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeApplySubject) {
        HomeApplySubjecttCell *cell = Bundle(@"HomeApplySubjecttCell");
        cell.actionBlock = ^(NSString *name) {
            [weakSelf caseArea:name];
        };
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeApplyUniversity) {
        HomeApplyUniCell *cell = Bundle(@"HomeApplyUniCell");
        cell.item = group.items[indexPath.row];
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeApplyDestination) {
        HomeApplicationDestinationCell *cell = Bundle(@"HomeApplicationDestinationCell");
        cell.items = group.items[indexPath.row];
        cell.actionBlock = ^(NSDictionary *item) {
            [weakSelf caseApplyDestination:item];
        };
        return cell;
    }
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row = %ld",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.groups[indexPath.section];
    if (group.type == SectionGroupTypeArticleColumn) {
        NSDictionary *item = group.items[indexPath.row];
        [self caseArticleMessage:item[@"id"]];
    }
    
    if (group.type == SectionGroupTypeApplyUniversity) {
        NSDictionary *item = group.items[indexPath.row];
        [self.navigationController pushUniversityViewControllerWithID:item[@"id"] animated:YES];
    }
}



- (void)topViewClick:(UIButton *)sender{
    
    if (!sender) {
        [self caseSearch];
    }
    if ([sender.currentTitle isEqualToString:@"我要留学"]) {
        [self caseWYLX];
    }
    if ([sender.currentTitle isEqualToString:@"留学指南"]) {
        [self caseGuide];
    }
    if ([sender.currentTitle isEqualToString:@"智能匹配"]) {
        [self casePipei];
    }
    if ([sender.currentTitle isEqualToString:@"资讯宝典"]) {
        [self caseMessage];
    }
}
//跳转搜索
- (void)caseSearch{
    
    MyofferNavigationController *nav = [[MyofferNavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}
//跳转我要留学
- (void)caseWYLX{
    [MobClick event:@"WoYaoLiuXue"];
    [self presentViewController:[[WYLXViewController alloc] init]  animated:YES completion:nil];
}
//跳转留学指南
- (void)caseGuide{
    [MobClick event:@"XiaoBai"];
    PushToViewController([[GuideOverseaViewController alloc] init]);
}
//跳转智能匹配
- (void)casePipei{
    [MobClick event:@"PiPei"];
    
    if (!LOGIN)  self.recommendationsCount = 0;
    if (self.recommendationsCount > 0) {
        RequireLogin
        PushToViewController([[IntelligentResultViewController alloc] init] );
        return;
    }
    PushToViewController([[PipeiEditViewController alloc] init] );
}

//判断是否有智能匹配数据或收藏学校
-(void)checkZhiNengPiPei{
    
    if (!LOGIN) return;
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet parameters:nil showHUD:NO errorAlertDismissAction:nil success:^(NSInteger statusCode, id response) {
        weakSelf.recommendationsCount = response[@"university"] ? 1 : 0;
    }];
}

//跳转资讯宝典
- (void)caseMessage{
    [self.tabBarController setSelectedIndex:2];
}

- (void)caseArea:(NSString *)name{
    
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_AREA value:name];
    PushToViewController(vc);
}


//跳转目的地
- (void)caseApplyDestination:(NSDictionary *)item{
    
    NSString *path = item[@"path"];
    if (path.length > 0) {
        WebViewController  *vc =  [[WebViewController alloc] initWithPath:path];
        PushToViewController(vc);
        
        return;
    }
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_CITY value:item[@"city"] country:item[@"country"]];
    PushToViewController(vc);
}

- (void)caseArticleMessage:(NSString *)articel_id{
    
    MessageDetaillViewController *vc = [[MessageDetaillViewController alloc] initWithMessageId:articel_id];
    PushToViewController(vc);
}


- (void)caseHeaderView:(SectionGroupType)type{
    
    switch (type) {
        case SectionGroupTypeArticleColumn:
            [self caseMessage];
            break;
        case SectionGroupTypeApplyUniversity:
        {
            NSString *key = KEY_COUNTRY;
            SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:key value:@"英国"];
            PushToViewController(vc);
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


