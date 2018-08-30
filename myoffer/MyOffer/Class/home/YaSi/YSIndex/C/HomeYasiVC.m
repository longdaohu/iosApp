//
//  HomeYasiVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYasiVC.h"
#import "HomeYaSiHeaderView.h"
#import "YaSiHomeModel.h"
#import "YSMyCourseVC.h"
#import "YaSiScheduleVC.h"
#import "FSSegmentTitleView.h"
#import "YasiCatigoryModel.h"
#import "YasiCatigoryItemModel.h"

@interface HomeYasiVC ()<FSSegmentTitleViewDelegate>
@property(nonatomic,strong)YaSiHomeModel *ysModel;
@property(nonatomic,strong)NSArray *height_arr;
@property(nonatomic,assign)NSInteger current_index;
@property(nonatomic,strong)HomeYaSiHeaderView *YSHeader;

@end

@implementation HomeYasiVC



- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.type = UITableViewStylePlain;
    self.ysModel = [[YaSiHomeModel alloc] init];
    [self makeYSHeaderView];
    
    myofferGroupModel *ys_group  = [myofferGroupModel groupWithItems:@[@"test"] header:@"test"];
    self.groups = @[ys_group];
    self.height_arr = @[@2000,@800,@1000,@700];
    
    [self makeCategoryData];
}

- (void)casePush{
    
    YSMyCourseVC *vc = [[YSMyCourseVC alloc] init];
    PushToViewController(vc);
//    [self makeUserSigned];
}

- (void)makeYSHeaderView{
    
    HomeYaSiHeaderView *header = [[HomeYaSiHeaderView alloc] initWithFrame:self.ysModel.header_frame];
    header.ysModel = self.ysModel;
    self.headerView = header;
    self.YSHeader = header;
    header.actionBlock = ^{
        [self casePush];
    };
}

#pragma mark : UITableViewDatasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titles = @[@"嘿客课程介绍",@"嘿客课程大纲",@"报名须知",@"常见问题"];
    FSSegmentTitleView *titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60) titles:titles delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    titleView.title_width_no_equal = YES;
    return titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"YSimages"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSimages"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@" aaaaaaa = %@",self.height_arr[self.current_index]];
    cell.contentView.backgroundColor = XCOLOR_RANDOM;
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  [self.height_arr[self.current_index] floatValue]   ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  XSCREEN_HEIGHT;
}

#pragma mark :
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
 
    self.current_index = endIndex;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
}

#pragma mark : 数据请求
//分类数据
- (void)makeCategoryData{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/categorys",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makeCatigoryWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
              }];
}

- (void)makeCatigoryWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        return;
    }
    NSArray *result = response[@"result"];
    if (result.count == 0) {
        return;
    }
    NSArray *catigorys = [YasiCatigoryModel mj_objectArrayWithKeyValuesArray:result];
    YasiCatigoryModel *cat = catigorys.firstObject;
    YasiCatigoryItemModel *cat_son = cat.servicePackage.firstObject;
    
    [self makeCatigoryItemDataWithID:cat_son._id];
    
}

//分类子项
- (void)makeCatigoryItemDataWithID:(NSString *)item_id{
    
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/products/%@",DOMAINURL_API,item_id];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makeCatigoryItemWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
              }];
}

- (void)makeCatigoryItemWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        return;
    }
    
    NSLog(@"makeCatigoryItemWithResponse >>>>>>> %@",response);
    
}

//签到
- (void)makeUserSigned{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/singin",DOMAINURL_API];
    
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makeUserSignedWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
              }];
}

- (void)makeUserSignedWithResponse:(id)response{
    
    if (!ResponseIsOK) {
          NSString *msg =[NSString stringWithFormat:@"%@",response[@"msg"]];
          [MBProgressHUD showMessage:msg];
          return;
    }
    self.YSHeader.userSigned = YES;
    [MBProgressHUD showMessage:@"签到成功，获得10个U币！"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
